<cfoutput>
	<cfset searchmode = false/>
	<cfif len(trim(form['search[value]']))>
		<cfset searchmode = true/>
		WHERE
				(
		<cfloop array="#grid_opts.Columns#" index="thisColumn">
			<cfif thisColumn.searchable>
				<cfif (thisColumn.field neq grid_opts.Columns[1].field)> OR </cfif>
				`#replace(thisColumn.field,'.','`.`')#` LIKE
				<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="%#trim(form['search[value]'])#%" />
			</cfif>
		</cfloop>
		)

		<cfif grid_base_filter>
			AND #grid_base_filter_clause#
		</cfif>

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
</cfoutput>