<cfoutput>
	<!---- check if search keyword contains date --->
	<cfset searchMode = false/>
	<cfset date_kw = []/>
	<cfloop list="#search_keyword#" item="kw" delimiters=" ">
		<cfif isDate(kw)>
			<cfset date_kw.Append(dateFormat(kw,"yy/m/d"))/>
		</cfif>
	</cfloop>
	<cfset date_kw_len = date_kw.Len()/>
	<cfif date_kw_len>

		WHERE (
			<cfswitch expression="#date_kw_len#">
				<cfcase value="1">
					<cfloop array="#grid_opts.Columns#" index="thisColumn">
						<cfif thisColumn.searchable && (thisColumn.type == "date" || thisColumn.type == "datetime")>
							<cfif !IsDefined("first_date")>
								<cfset first_date = thisColumn.field/>
							</cfif>
							<cfif (thisColumn.field != first_date)> OR </cfif>
							`#replace(thisColumn.field,'.','`.`')#` = "#date_kw[1]#"
						</cfif>
					</cfloop>
				</cfcase>
				<cfcase value="2">
					<cfloop array="#grid_opts.Columns#" index="thisColumn">
						<cfif thisColumn.searchable && (thisColumn.type == "date" || thisColumn.type == "datetime")>
							<cfif !IsDefined("first_date")>
								<cfset first_date = thisColumn.field/>
							</cfif>
							<cfif (thisColumn.field != first_date)> OR </cfif>
							`#replace(thisColumn.field,'.','`.`')#` BETWEEN "#date_kw[1]#" AND "#date_kw[2]#"
						</cfif>
					</cfloop>
				</cfcase>
				<!--- TODO: implement for 3 and above dates--->
				<cfdefaultcase></cfdefaultcase>
			</cfswitch>
		)

	<cfelse>

		<cfif len(search_keyword)>
			<cfset searchMode = true/>
			WHERE
				(
				<cfloop array="#grid_opts.Columns#" index="thisColumn">
					<cfif thisColumn.searchable>
						<cfif (thisColumn.field neq grid_opts.Columns[1].field)> OR </cfif>
						`#replace(thisColumn.field,'.','`.`')#` LIKE
						<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="%#trim(search_keyword)#%" />
					</cfif>
				</cfloop>
			)

			<cfif grid_base_filter>
				AND #grid_base_filter_clause#
			</cfif>

		</cfif>
		<!--- tenant id ---->
		<!---cfif mObject.TenantId>
			<cfif searchMode>
				AND
			<cfelse>
				WHERE
			</cfif>
			#mObject.table_name#.TenantId = #request.user.TenantId#
		</cfif--->

	</cfif>

	<cfif searchmode>

		<cfif grid_opts.filter is not ''>
			AND (#grid_opts.filter#)
		</cfif>
		<cfif grid_base_filter>
			AND #grid_base_filter_clause#
		</cfif>
		<!--- tenant id ---->
		<cfif mObject.TenantId>
			AND #mObject.table_name#.TenantId = #request.user.TenantId#
		</cfif>

	<cfelse>

		<cfif grid_opts.filter is not ''>
			WHERE #grid_opts.filter#
			<cfif grid_base_filter>
				AND #grid_base_filter_clause#
			</cfif>
			<!--- tenant id ---->
			<cfif mObject.TenantId>
				AND #mObject.table_name#.TenantId = #request.user.TenantId#
			</cfif>
		<cfelse>
			<cfif grid_base_filter>
				WHERE #grid_base_filter_clause#
				<!--- tenant id ---->
				<cfif mObject.TenantId>
					AND #mObject.table_name#.TenantId = #request.user.TenantId#
				</cfif>
			<cfelse>
				<!--- tenant id ---->
				<cfif mObject.TenantId>
					WHERE #mObject.table_name#.TenantId = #request.user.TenantId#
				</cfif>
			</cfif>
		</cfif>

	</cfif>

</cfoutput>