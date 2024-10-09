<cflock scope="Session" timeout="10" type="readonly">
	<cfset grid_opts = session.tags.grid[url.grid_name]/>
</cflock>

<cfset _totalColumns = arrayLen(grid_opts.COLUMNS)/>

<!--cfparam name="url.join" default=""/>
<cfparam name="url.gb" default=""/>  group by --->
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
<cfset timespn = createtimespan(0,6,0,0)/>
<!--- Indexed column --->
<cfparam name="url.indexkey" default="#mObject.key#"/>

<cfif url.indexkey eq "">
	<cfset url.indexkey = grid_opts.COLUMNS[1].field/>
</cfif>

<!--- work on filter --->
<cfset grid_opts.filter = replace(grid_opts.filter,':','=','all')/>         <!--- equal sign --->
<cfset grid_opts.filter = replace(grid_opts.filter,'!:','<>','all')/>         <!--- not equal sign --->
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
	<cfif _value neq "">
		<cfset grid_base_filter = true/>
		<!---cfset _value = replace(_value,'{{EMPTY}}','')/--->
		<!---- replace , with quoted list --->
		<cfset _nvalue = ""/>
		<cfloop list="#_value#" item="_x">
			<cfset _nvalue = listAppend(_nvalue, '"#_x#"')/>
		</cfloop>
		<cfset grid_base_filter_clause = listAppend(grid_base_filter_clause, listGetAt(grid_opts.fCOLUMNS,x) & ' IN (' & _nvalue & ')','`')/>
	</cfif>
</cfloop>
<cfset grid_base_filter_clause = replaceNoCase(grid_base_filter_clause, "`", " AND ", 'all')/>
<cfset grid_base_filter_clause = replaceNoCase(grid_base_filter_clause, "|", ",", 'all')/>
<cfset grid_base_filter_clause = replaceNoCase(grid_base_filter_clause, "{{EMPTY}}", "", 'all')/>

<!---cfscript>

	abort grid_base_filter_clause;
</cfscript---->

<!--- Data set after filtering --->
<cfquery name="qFiltered" cachedwithin="#timespn#" datasource="#mObject.datasource#">

	#mObject.buildSelectClause(select=grid_opts.sel_stm, base_sql = grid_opts.base_sql)#
	<!--- custom join --->
	#grid_opts.join_stm#

	<cfinclude template="inc_search.cfm"/>

	<cfif _totalColumns gt 0>

		ORDER BY
		<cfset order_col = listGetAt(grid_opts.fCOLUMNS,form['order[0][column]']+1)/>
		<cfif listlen(order_col,'.') eq 1>
			`#order_col#`
		<cfelse>
			#order_col#
		</cfif>

		#form['order[0][dir]']#

	</cfif>

	LIMIT #val(form.start)#, #val(form.length)#
</cfquery>

<!--- Total data set length --->
<cfquery name="qCount" cachedwithin="#timespn#" datasource="#mObject.datasource#">
	SELECT
		#mObject.table_name#.#url.indexkey#
	FROM `#mObject.table_name#`

	#mObject.sql_join#
	#grid_opts.join_stm#

	<cfinclude template="inc_search.cfm"/>
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
	"data": [
		<cfoutput query="qFiltered">
			[
				<cfloop array="#grid_opts.Columns#" index="thisColumn">
					<cfif thisColumn.Name != grid_opts.Columns[1].Name>,</cfif>
					<cfset itm = qFiltered[trim(thisColumn.Name)][qFiltered.currentRow]/>
					<cfif isDate(itm)>
						<cfset date_format = dateformat(itm,thisColumn.dateformat)/>
						<!--- check for datetime --->
						<cfset itm_tt = timeformat(itm, "hhTT")/>

						<cfif left(itm_tt,'5') == "12AM">
							<cfset itm = date_format/>
						<cfelse>
							<cfset itm = "#date_format# <small>#timeformat(itm, "h:mm tt")#</small>"/>
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