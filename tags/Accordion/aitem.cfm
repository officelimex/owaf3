<cfoutput>

<cfif ThisTag.ExecutionMode == "Start">

	<cfparam name="Attributes.TagName" type="string" default="aItem"/>
	<cfparam name="Attributes.title" type="string"/>
	<cfparam name="Attributes.icon" type="string" default=""/>
	<cfparam name="Attributes.isActive" type="boolean" default="false"/>
	<cfparam name="Attributes.url" type="string" default=""/>
	<cfparam name="Attributes.urlparam" type="string" default=""/>
	<cfparam name="Attributes.id" type="string" default="#application.fn.GetRandomVariable()#"/>
	<cfparam name="Attributes.style" type="string" default=""/>
	<cfparam name="attributes.contentClass" type="string" default=""/>
	
	<cfassociate basetag="cf_accordion"/>

	<cfset base_tag = GetBaseTagData('cf_accordion').ATTRIBUTES/>
	<!---cfset Attributes.icon = base_tag.iconprefix & Attributes.icon/--->
	<cfif Attributes.style == "">
		<cfset Attributes.style = base_tag.style/>
	</cfif>

<!--- close tag --->

<cfelse>
	<cfset deChar = "~"/>

	<cfset Attributes.Content = THISTAG.GeneratedContent />
	<cfset THISTAG.GeneratedContent = "" />

    <cfif Attributes.url is "">

			<cfset ArrayAppend(request.accordion.item,Attributes)/>

    <cfelse>

			<cfif listFindNoCase(request.user.pageURLs, listfirst(Attributes.url,deChar))>

				<cfset ArrayAppend(request.accordion.item,Attributes)/>

			</cfif>

    </cfif>

</cfif>

</cfoutput>