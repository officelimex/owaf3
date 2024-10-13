<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">

    <cfparam name="Attributes.span" type="numeric" default="0"/>
    <cfparam name="Attributes.tagName" type="string" default="Caption"/>
    <cfparam name="Attributes.align" type="string" default="left"/>
    <cfparam name="Attributes.class" type="string" default=""/>

    <cfassociate basetag="cf_pgrid"/>

 <cfelse>

    <cfset Attributes.Content = thisTag.GeneratedContent />
    <cfset thisTag.GeneratedContent = "" />
    <cfset request.PlainGrid.caption = Attributes/>

</cfif>
</cfoutput>