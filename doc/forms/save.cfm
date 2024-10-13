<cfoutput>
	<cfswitch expression="#url.object#">
		<cfcase value="component">
			<cfquery>
				<cfif val(url.key) eq 0>
					INSERT INTO component SET
				<cfelse>
					UPDATE component SET
				</cfif>

					Title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Title#"/>,
					Type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Type#"/>,
					Description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Description#"/>

				<cfif url.key Neq 0>
					WHERE ComponentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.key#"/>
				</cfif>
			</cfquery>
		</cfcase>

		<cfcase value="tag">
			<cfquery>
				<cfif val(url.key) eq 0>
					INSERT INTO tag SET
				<cfelse>
					UPDATE tag SET
				</cfif>

					ComponentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ComponentId#"/>,
					Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Name#"/>,
					Description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Description#"/>,
					TagExample = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TagExample#"/>,
					ScriptExample = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ScriptExample#"/>

				<cfif url.key Neq 0>
					WHERE TagId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.key#"/>
				</cfif>
			</cfquery>
		</cfcase>

		<cfcase value="tag_argument,method_argument" delimiters=",">
			<cfquery>
				<cfif val(url.key) eq 0>
					INSERT INTO parameter SET
				<cfelse>
					UPDATE parameter SET
				</cfif>
					<cfif isdefined('form.tagid')>
						TagId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.TagId#"/>,
					</cfif>
					<cfif isdefined('form.methodid')>
						MethodId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MethodId#"/>,
					</cfif>
					Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Name#"/>,
					Description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Description#"/>,
					`Required` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Required#"/>,
					`Type` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Type#"/>,
					`Default` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Default#"/>

				<cfif url.key Neq 0>
					WHERE ParameterId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.key#"/>
				</cfif>
			</cfquery>
		</cfcase>
	</cfswitch>
</cfoutput>