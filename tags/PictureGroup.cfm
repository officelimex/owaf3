<cfoutput>

	<cfif ThisTag.ExecutionMode=="Start">

		<cfparam name="Attributes.TagName" type="string" default="PictureGroup" />
		<cfparam name="Attributes.picture" type="string" />
		<cfparam name="Attributes.alias" type="string" />
		<cfparam name="Attributes.name" type="string"/>
		<cfparam name="Attributes.bgcolor" type="string" default=""/>
		<cfparam name="Attributes.max" type="numeric" default="10" />
		<cfparam name="Attributes.size" type="string" default="sm" />
		<cfparam name="Attributes.id" type="string" default="#application.fn.GetRandomVariable()#" />
		
		<cfset Attributes.picture = ListRemoveDuplicates(Attributes.picture, "|")/>
		<cfset Attributes.name = ListRemoveDuplicates(Attributes.name, "|")/>
		<cfset Attributes.bgcolor = ListRemoveDuplicates(Attributes.bgcolor, "|")/>
		<cfset Attributes.alias = ListRemoveDuplicates(Attributes.alias, "|")/>
	
		<div class="avatar-group">
			<cfloop list="#Attributes.picture#" delimiters="|" item="p" index="i">
				<cfset al = listGetAt(Attributes.alias, i, "|")/>
				<cfset n = listGetAt(Attributes.name, i, "|")/>
				<div class="avatar avatar-#attributes.size#">
					<cfif p != "../../profile.png">
						<img title="#n#" src="#application.s3.url#pub/#request.user.tenantid#/passport/#p#" class="avatar-img rounded-circle"/>
					<cfelse>
						<cfset bg = ""/>
						<cfif Attributes.bgcolor neq "">
							<cfset c = listGetAt(Attributes.bgcolor, i, "|")/>
							<cfset bg = "background-color:###c#"/>
						</cfif>
						<span title="#n#" style="#bg#" class="avatar-title rounded-circle">#left(al,1)#.#right(al,1)#</span> 
					</cfif>
				</div>
				<cfif i eq Attributes.max>
					<cfset llen = listLen(Attributes.picture, '|')/>
					<cfset rem = llen - Attributes.max/>
					<cfif rem>
						<div class="avatar avatar-#attributes.size#"> 
							<span class="avatar-title more rounded-circle">+#llen-Attributes.max#</span> 
						</div>
					</cfif>
					<cfbreak>
				</cfif>
			</cfloop>

		</div>

	</cfif>
</cfoutput>