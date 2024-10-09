<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">

    <cfparam name="Attributes.TagName" type="string" default="tItem"/>
    <cfparam name="Attributes.title" type="string"/>
    <cfparam name="Attributes.icon" type="string" default=""/>
    <cfparam name="Attributes.iconType" type="string" default="fal fa-"/>
    <cfparam name="Attributes.isActive" type="boolean" default="false"/>
    <cfparam name="Attributes.url" type="string" default=""/>
    <cfparam name="Attributes.urlparam" type="string" default=""/>
    <cfparam name="Attributes.id" type="string" default="#application.fn.GetRandomVariable()#"/>
    <cfparam name="Attributes.help" type="string" default=""/>
    <cfparam name="Attributes.class" type="string" default=""/>

    <cfassociate basetag="cf_ttab"/>

    <cfset base_tag = GetBaseTagData('cf_ttab').ATTRIBUTES/>
    <!---cfset Attributes.icon = Attributes.iconType & Attributes.icon/--->

 <!--- close tag --->
<cfelse>
	<cfset Attributes.Content = THISTAG.GeneratedContent />
	<cfset THISTAG.GeneratedContent = "" />
   <cfif Attributes.url is "">
      <cfset ArrayAppend(request.tab_item[base_tag.Id], Attributes)/>
   <cfelse>
      <cfif listFindNoCase(request.user.pageURLs, listfirst(Attributes.url,'@'))>
         <cfset ArrayAppend(request.tab_item[base_tag.Id], Attributes)/>
      </cfif>
   </cfif>

</cfif>
</cfoutput>
