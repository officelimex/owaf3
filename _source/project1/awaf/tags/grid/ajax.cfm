<cflock scope="Session" timeout="10" type="readonly">
	<cfset grid_opts = session.tags.grid[url.grid_name]/>
</cflock>

<cfset _totalColumns = arrayLen(grid_opts.COLUMNS)/>

<cfset mObject = model(grid_opts.model)/>

<cfloop list="#grid_opts.join#" delimiters="$" item="j">
	<cfset jarg = listlen(j,',',true)/>
	<cfset fkey=""/>
	<cfset deep=""/>
	<cfset jtype = listfirst(j)/>
	<cfset m_desc = listgetat(j,2,',',true)/>
	<cfif jarg gt 2>
		<cfset fkey = listgetat(j,3,',',true)/>
	</cfif>
	<cfif jarg gt 3>
		<cfset deep = listgetat(j,4,',',true)/>
	</cfif>
	<cfset mObject = mObject[jtype](m_desc, fkey, deep)/>
</cfloop>
<cfif grid_opts.model == application.model.STOCK>
	<cfset timespn = createtimespan(0,0,0,0)/>
<cfelse>
	<cfset timespn = createtimespan(0,6,0,0)/>
</cfif>
<!--- Indexed column --->
<cfparam name="url.indexkey" default="#mObject.key#"/>

<cfif url.indexkey eq "">
	<cfset url.indexkey = grid_opts.COLUMNS[1].field/>
</cfif>

<!--- work on filter --->
<cfset grid_opts.filter = replace(grid_opts.filter,'!:','<>','all')/>       <!--- not equal sign --->
<cfset grid_opts.filter = replace(grid_opts.filter,':','=','all')/>         <!--- equal sign --->
<cfset grid_opts.filter = replace(grid_opts.filter,'^',' LIKE ','all')/>    <!--- like sign --->
<cfset grid_opts.filter = replace(grid_opts.filter,'[[','"%','all')/>       <!--- open quote with like sign --->
<cfset grid_opts.filter = replace(grid_opts.filter,']]','%"','all')/>       <!--- close quote with like sign --->
<cfset grid_opts.filter = replace(grid_opts.filter,'[','"','all')/>         <!--- open quote sign --->
<cfset grid_opts.filter = replace(grid_opts.filter,']','"','all')/>         <!--- close quote sign ---->

<cfset grid_opts.filter = replace(grid_opts.filter,' *G ',' > ','all')/>   <!--- greater than ---->
<cfset grid_opts.filter = replace(grid_opts.filter,' *GE ',' >= ','all')/>  <!--- greater than ---->
<cfset grid_opts.filter = replace(grid_opts.filter,' *L ',' < ','all')/>   <!--- less than ---->
<cfset grid_opts.filter = replace(grid_opts.filter,' *LE ',' <= ','all')/>  <!--- less than ---->

<!---cfparam name="grid_opts.cmd" default="false" type="boolean" /--->

<!--- check if grid filter is selected --->
<cfset grid_base_filter = false/>
<cfset grid_base_filter_clause = ""/>
<cfset j=-1/>
<cfloop from="1" to="#_totalColumns#" index="x">
	<cfset j++/>
	<cfset _value = form['columns[#j#][search][value]']/>
	<cfif _value != "">
		<cfset grid_base_filter = true/>
		<!---- replace , with quoted list --->
		<cfset _nvalue = ""/>
		<cfloop list="#_value#" item="_x">
			<cfif left(trim(_x),6) == "SELECT">
				<cfset _nvalue = listAppend(_nvalue, _x)/>
			<cfelse>
				<cfset _nvalue = listAppend(_nvalue, '"#_x#"')/>
			</cfif>
		</cfloop>
		<cfset grid_base_filter_clause = listAppend(grid_base_filter_clause, grid_opts.COLUMNS[x].field & ' IN (' & _nvalue & ')','`')/>
	</cfif>
</cfloop>
<cfset grid_base_filter_clause = replaceNoCase(grid_base_filter_clause, "`", " AND ", 'all')/>
<cfset grid_base_filter_clause = replaceNoCase(grid_base_filter_clause, "|", ",", 'all')/>
<cfset grid_base_filter_clause = replaceNoCase(grid_base_filter_clause, "{{EMPTY}}", "", 'all')/>

<cfset search_keyword = trim(form['search[value]'])/>

<!--- Data set after filtering --->
<cfquery name="qFiltered" cachedwithin="#timespn#" datasource="#mObject.datasource#">

	<cfif grid_opts.sel_clause == "">
		#mObject.buildSelectClause(select:grid_opts.sel_stm)#
	<cfelse>
		#mObject.buildSelectClause(select:grid_opts.sel_stm, base_sql: grid_opts.sel_clause)#
	</cfif>
	<!--- custom join --->
	#grid_opts.join_stm#

	<cfinclude template="inc_search.cfm"/>
	<cfif grid_opts.gb neq "">
		GROUP BY #grid_opts.gb#
	</cfif>
	<cfif grid_opts.having neq "">
		HAVING #grid_opts.having#
	</cfif>
	<cfif _totalColumns gt 0>

		ORDER BY
		<cfset order_col = listGetAt(grid_opts.fCOLUMNS,val(form['order[0][column]'])+1)/>
		<cfif listlen(order_col,'.') eq 1>
			`#order_col#`
		<cfelse>
			#order_col#
		</cfif>

		#form['order[0][dir]']#

	</cfif>

	LIMIT #val(form.start)#, #val(form.length)#
</cfquery>

<!--- aggregate --->
<cflock scope="Session" timeout="10" type="readonly">
	<cfset agg = session.tags.grid[url.grid_name].Aggregate/>
</cflock>
<cfif agg.len()>
	<cfquery name="qAgg" cachedwithin="#timespn#" datasource="#mObject.datasource#">
		SELECT
			#agg[1].Select#
		FROM `#mObject.table_name#`
		#mObject.sql_join#
		#grid_opts.join_stm#

		<cfinclude template="inc_search.cfm"/>

		<cfif agg[1].group != "">
			GROUP BY #agg[1].group#
		</cfif>		
	</cfquery>
</cfif>
<!--- Total data set length --->
<cfquery name="qCount" cachedwithin="#timespn#" datasource="#mObject.datasource#">
	SELECT

	<cfif grid_opts.sel_clause == "">
		#mObject.table_name#.#url.indexkey#
	<cfelse>
		<!---#mObject.buildSelectClause(select:grid_opts.sel_stm, base_sql: grid_opts.sel_clause)#
		#mObject.buildSelectClause(select:grid_opts.sel_stm, base_sql: grid_opts.sel_clause)#--->
		1
	</cfif>


	FROM `#mObject.table_name#`

	#mObject.sql_join#
	#grid_opts.join_stm#

	<cfinclude template="inc_search.cfm"/>

	<cfif grid_opts.gb neq "">
		GROUP BY #grid_opts.gb#
	</cfif> 
</cfquery>

<!--- save query report into session for export --->
<!--- the remaining part of the grid here --->
<cflock scope="Session" timeout="10" type="exclusive">
	<cfset session.tags.grid[url.grid_name].search = form['search[value]']/>
	<cfset session.tags.grid[url.grid_name].gridFilter = grid_base_filter_clause/>
</cflock>
<!--- // ------------------------------------------>

<cfcontent reset="Yes" type="application/json" />
{
	"draw": <cfoutput>#val(form.draw)#</cfoutput>,
	"recordsFiltered": <cfoutput>#val(qCount.recordCount)#</cfoutput>,
	"recordsTotal": <cfoutput>#val(qFiltered.recordCount)#</cfoutput>,
	<cfif IsDefined("qAgg")>
		<cfset d = trim(serialize(qAgg))/>
		<cfset d = replacenocase(d,'query(','')/>
		<cfset d = left(d, len(d)-1)/>
		"aggregate": {<cfoutput>#d#</cfoutput>},
	</cfif>
	"data": [
		<cfoutput query="qFiltered">
			[
				<cfloop array="#grid_opts.Columns#" index="thisColumn">
					<cfif thisColumn.Name != grid_opts.Columns[1].Name>,</cfif>
					<cfset itm = qFiltered[thisColumn.Name][qFiltered.currentRow]/>
					<cfparam name="thisColumn.type" default="string"/>
					<cfif listFindNocase('date,datetime',thisColumn.type)>
						<cfif isDate(itm)>
							<cfif !isdefined("thisColumn.dateFormat")>
								<cfset thisColumn.dateFormat = "dd mmm yyyy"/>
							</cfif>
							<cfset date_format = LSDateFormat(itm,thisColumn.dateFormat)/>
							<!--- check for datetime --->
							<cfset itm_tt = LSTimeFormat(itm, "hhTT")/>

							<cfif left(itm_tt,'5') == "12AM">
								<cfset itm = date_format/>
							<cfelse>
								<cfset itm = "#date_format# <small class=text-muted>#timeformat(itm, "h:mm tt")#</small>"/>
							</cfif>
						</cfif>
					</cfif>
					#serializeJSON(itm)#
				</cfloop>
				<cfif grid_opts.cmd>
					,""
				</cfif>
			] <cfif currentRow neq recordcount>,</cfif>
		</cfoutput>
	]
}