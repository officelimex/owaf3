<cflock scope="Session" timeout="10" type="readonly">
	<cfset grid_opts = session.tags.grid[url.grid_name]/>
</cflock>
<cfset _totalColumns = arrayLen(grid_opts.COLUMNS)/>

<cfparam name="url.gb" default=""/>
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
	<cfset url.indexkey = listFirst(url.Columns)/>
</cfif>

<!--- work on filter --->
<cfset grid_opts.filter = replace(grid_opts.filter,':','=','all')/>         <!--- equal sign --->
<cfset grid_opts.filter = replace(grid_opts.filter,'^',' LIKE ','all')/>    <!--- like sign --->
<cfset grid_opts.filter = replace(grid_opts.filter,'[[','"%','all')/>       <!--- open quote with like sign --->
<cfset grid_opts.filter = replace(grid_opts.filter,']]','%"','all')/>       <!--- close quote with like sign --->
<cfset grid_opts.filter = replace(grid_opts.filter,'[','"','all')/>         <!--- open quote sign --->
<cfset grid_opts.filter = replace(grid_opts.filter,']','"','all')/>         <!--- close quote sign ---->

<!---cfparam name="grid_opts.cmd" default="false" type="boolean" /--->

<!--- check if grid filter is selected --->
<cfset grid_base_filter = false/>
<cfset grid_base_filter_clause = grid_opts.gridfilter/>
<cfif len(grid_base_filter_clause) gt 3>
	<cfset grid_base_filter = true/>
</cfif>


<!--- Data set after filtering --->
<cfquery name="qFiltered" cachedwithin="#timespn#">

	#mObject.buildSelectClause(grid_opts.sel_stm)#
	<!--- custom join --->
	#grid_opts.join_stm#

<cfset searchmode = false>
<cfif len(trim(grid_opts.Search))>
	<cfset searchmode = true>
	WHERE
		(<cfloop array="#grid_opts.Columns#" index="thisColumn">
			<cfif thisColumn.searchable>
				<cfif (thisColumn.field neq grid_opts.Columns[1].field)> OR </cfif>
				`#replace(thisColumn.field,'.','`.`')#` LIKE
				<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="%#trim(grid_opts.Search)#%" />
			</cfif>
			<!----cfif thisColumn neq listFirst(grid_opts.fColumns)> OR </cfif>
				`#replace(thisColumn,'.','`.`')#` LIKE
				<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="%#trim(grid_opts.Search)#%" /---->
		</cfloop>)
</cfif>

<cfif searchmode>

	<cfif grid_opts.filter is not ''>
	 AND (#grid_opts.filter#)
	</cfif>
	<cfif grid_base_filter>
		AND #grid_base_filter_clause#
	</cfif>

<cfelse>

	<cfif grid_opts.filter is not ''>
		WHERE #grid_opts.filter#
		<cfif grid_base_filter>
				AND #grid_base_filter_clause#
		</cfif>
	<cfelse>
		<cfif grid_base_filter>
				WHERE #grid_base_filter_clause#
		</cfif>
	</cfif>


</cfif>


	<cfif grid_opts.gb neq "">
		 GROUP BY #grid_opts.gb#
	</cfif>

<!---cfif _totalColumns gt 0>
	ORDER BY

	#listGetAt(grid_opts.fCOLUMNS,form['order[0][column]']+1)# #form['order[0][dir]']#

</cfif--->

</cfquery>

<cfoutput>

<cfswitch expression="#url.type#">
	<cfcase value="html,htm" delimiters=",">
		<cfheader name="Content-Disposition" value="inline; filename=#url.grid_name#_#dateformat(now(),'dd_mm_yy')#_#timeformat(now(),'h_m_ss')#.htm">
		<cfcontent type="text/html" reset="true">
	</cfcase>
	<cfdefaultcase>
		<cfheader name="Content-Disposition" value="inline; filename=#url.grid_name#_#dateformat(now(),'dd_mm_yy')#_#timeformat(now(),'h_m_ss')#.xls">
		<cfcontent type="application/vnd.ms-excel" reset="true">
	</cfdefaultcase>
</cfswitch>

<style>
	tr th {background-color:orange;}
	td.date {white-space: nowrap;}
	tbody tr td {border-bottom:solid 1px gray;}
	 .text {mso-number-format: "\@";}
</style>

<table>
	<thead>
		<tr>
			<cfloop array="#grid_opts.Columns#" item="cap">
				<cfif cap.exportable>
					<th>#cap.ecaption#</th>
				</cfif>
			</cfloop>
		</tr>
	</thead>
	<tbody>
		<cfloop query="qFiltered">
			<tr>
				<cfloop array="#grid_opts.Columns#" item="col">
					<cfif col.exportable>
						<cfset is_date = false/>
								<cfset is_ex_string = false/>
								<cfset _value = qFiltered[col.name]/>
								<cfset txt_value = listfirst(_value,'.')/>
								<cfif left(txt_value,1) eq 0 and len(txt_value) gt 1>
									<cfset is_ex_string = true/>
								</cfif>
						<cfif isdate(_value)>
							<cfset is_date = true/>
						</cfif>
						<td <cfif is_date>class="date"</cfif> <cfif is_ex_string>class="text"</cfif> >
							<cfif is_date>
								#dateformat(_value,col.dateformat)#
							<cfelse>
								#_value#
							</cfif>
						</td>
					</cfif>
				</cfloop>
			</tr>
		</cfloop>
	</tbody>
</table>

</cfoutput>