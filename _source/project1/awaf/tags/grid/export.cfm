<cflock scope="Session" timeout="10" type="readonly">
	<cfset grid_opts = session.tags.grid[url.grid_name]/>
</cflock>
<cfset _totalColumns = arrayLen(grid_opts.COLUMNS)/>
<cfparam name="url.gb" default=""/>
<cfparam name="url.having" default=""/>
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
<cfset grid_opts.filter = replace(grid_opts.filter,'!:','<>','all')/>       <!--- not equal sign --->
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
<!---cfdump var="#grid_base_filter_clause#"/--->
<cfset grid_base_filter_clause = replacenocase(grid_base_filter_clause,"'",'"','all')/>
<!---cfdump var="#grid_base_filter_clause#"/--->

<cfif len(grid_base_filter_clause) gt 3>
	<cfset grid_base_filter = true/>
</cfif>


<!--- Data set after filtering --->
<cfquery name="qFiltered" cachedwithin="#timespn#">

	<cfif grid_opts.sel_clause == "">
		#mObject.buildSelectClause(grid_opts.sel_stm)#
	<cfelse>
		#mObject.buildSelectClause(select:grid_opts.sel_stm, base_sql: grid_opts.sel_clause)#
	</cfif>
	<!--- #mObject.buildSelectClause(grid_opts.sel_stm)# --->
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

		<cfif grid_opts.filter == ''>
			AND (#grid_opts.filter#)
		</cfif>
		<cfif grid_base_filter>
			AND #grid_base_filter_clause#
		</cfif>
		<cfif mObject.TenantId>
			AND #mObject.table_name#.TenantId = #request.user.TenantId#
		</cfif>

	<cfelse>
		
		<cfif grid_opts.filter == ''>
			WHERE 1=1 
			<cfif grid_base_filter>
				AND #grid_base_filter_clause#
			</cfif>
			<cfif mObject.TenantId>
				AND #mObject.table_name#.TenantId = #request.user.TenantId#
			</cfif>
		<cfelse>
			WHERE 1=1 
			<cfif grid_base_filter>
				AND (#grid_base_filter_clause#)
				<cfif mObject.TenantId>
					AND (#mObject.table_name#.TenantId = #request.user.TenantId#)
				</cfif>
			<cfelse>
				<cfif mObject.TenantId>
					AND (#mObject.table_name#.TenantId = #request.user.TenantId#) 
				</cfif>
			</cfif>
			<cfif grid_opts.filter != ''>
				AND (#grid_opts.filter#)
			</cfif>
		</cfif>

	</cfif>

	<cfif grid_opts.gb neq "">
		GROUP BY #grid_opts.gb#
	</cfif>

	<cfif grid_opts.having neq "">
		HAVING #grid_opts.having#
	</cfif>

	ORDER BY
	#listGetAt(grid_opts.fCOLUMNS,grid_opts.sortby+1)# #grid_opts.sortdir#

</cfquery>

<!--- // ------------------------------------------>

<!---cfdump var="#grid_opts#"/--->
<cfoutput>

<cfswitch expression="#url.type#">
	<cfcase value="html,htm" delimiters=",">
		<cfheader name="Content-Disposition" value="inline; filename=#grid_opts.filename#.html">
		<cfcontent type="text/html" reset="true">
	</cfcase>
	<cfdefaultcase>
		<cfheader name="Content-Disposition" value="inline; filename=#grid_opts.filename#.xls">
		<cfcontent type="application/vnd.ms-excel" reset="true">
	</cfdefaultcase>
</cfswitch>
<style>
	th {background-color:orange;}
	.table tr td.date {white-space: nowrap;}
	<cfset f=['','danger','warning','info','success']/>
	<cfset c=['','background-color:##f2dede;','background-color:##fcf8e3;', 'background-color:##d9edf7;','background-color:##dff0d8;']/>
	.bd-top {border-bottom:thin solid black;border-right:thin solid black;}
	.text-right{text-align:right;}
	<cfloop array="#f#" item="clr" index="i">
		.hd-top#clr# {border-top:thin solid black;border-right:thin solid black;border-bottom:thin solid black;#c[i]#}
		.hd-first#clr# {border-left:thin solid black;border-right:thin solid black;border-top:thin solid black;border-bottom:thin solid black;#c[i]#}
		.hd-last#clr# {border-top:thin solid black;border-right:thin solid black;border-bottom:thin solid black;#c[i]#}

		.bd-top#clr# {border-bottom:thin solid black;border-right:thin solid black;#c[i]#}
		.bd-first#clr# {border-left:thin solid black;border-right:thin solid black;border-bottom:thin solid black;#c[i]#}
		.bd-last#clr# {border-bottom:thin solid black;border-right:thin solid black;#c[i]#}
	</cfloop>
	.text {mso-number-format: "\@";}
</style>
<h2>#grid_opts.title#</h2>
<!--- total exportable column --->
<cfset c = ce = 0/>
<cfloop array="#grid_opts.Columns#" item="cap">
	<cfif cap.exportable>
		<cfset ce++/>
	</cfif>
</cfloop>
<cfset defClass["text-center"] = "text-align:center;"/>
<cfset defClass["text-right"] = "text-align:right;"/>
<cfset defClass["bg-soft-info"] = "background-color:##d9edf7;"/>
<cfset defClass["bg-soft-danger"] = "background-color:##f2dede;"/>
<cfset defClass["bg-soft-warning"] = "background-color:##fcf8e3;"/>
<cfset defClass["bg-soft-success"] = "background-color:##dff0d8;"/>

<table>
	<thead>
		<tr>
			<cfloop array="#grid_opts.Columns#" item="cap">
				<cfif cap.exportable>
					<cfset c++/>
					<cfset sty = "hd-top"/>
					<cfif c == 1>
						<cfset sty = "hd-first"/>
					</cfif>
					<cfif c == ce>
						<cfset sty = "hd-last"/>
					</cfif>
					<cfset x = "#sty#"/>
					<cfset x = trim(x)/>
					<cfset _st = ""/>
					<cfloop list="#cap.class#" delimiters=" " item="_c" index="i">
						<cfif isDefined("defClass[_c]")>
							<cfset _st = listAppend(defClass[_c], _st,' ')/>
						</cfif>
					</cfloop>
					<th class="#x#" style="#_st#">#cap.ecaption#</th>
				</cfif>
			</cfloop>
		</tr>
	</thead>
	<tbody>
		<cfloop query="qFiltered">
			<tr>
				<cfset c=0/>
				<cfloop array="#grid_opts.Columns#" item="col">

					<cfset c++/>
					<cfset sty = "bd-top"/>
					<cfif c == 1>
						<cfset sty = "bd-first"/>
					</cfif>
					<cfif c == ce>
						<cfset sty = "bd-last"/>
					</cfif>
					<cfif col.exportable>
						<cfset is_date = false/>
						<cfset is_ex_string = false/>
						<cfset _value = qFiltered[col.name]/>
						<cfset txt_value = listfirst(_value,'.')/>
						<cfif left(txt_value,1) eq 0 and len(txt_value) gt 1>
							<cfset is_ex_string = true/>
						</cfif>
						<cfif findNoCase("text-right",col.class)>
							<cfset col.class = trim(replaceNocase(col.class, "text-right",""))/>
							<cfset is_ex_string = true/>
						</cfif>
						<cfset _st = ""/>
						<cfloop list="#col.class#" delimiters=" " item="_c" index="i">
							<cfif isDefined("defClass[_c]")>
								<cfset _st = listAppend(defClass[_c], _st,' ')/>
							</cfif>
						</cfloop>
						<cfif isdate(_value)>
							<cfset is_date = true/>
						</cfif>
						<td <cfif is_date>class="#sty#" style="white-space: nowrap;#_st#"<cfelseif is_ex_string>align="right" class="#sty#" style='mso-number-format: "\@";#_st#' <cfelse>class="#sty#" style="#_st#"</cfif> >
							<cfif is_date>
								#dateFormat(_value,col.dateformat)#
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