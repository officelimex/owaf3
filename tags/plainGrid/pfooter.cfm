<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">

    <cfparam name="Attributes.span" type="numeric" default="0"/>
    <cfparam name="Attributes.tagName" type="string" default="Footer"/>
    <cfparam name="Attributes.align" type="string" default="right"/>
    <cfparam name="Attributes.clearborder" type="boolean" default="false"/>
    <cfparam name="Attributes.nowrap" type="boolean" default="false"/>
    <cfparam name="Attributes.class" type="string" default=""/>
    <cfparam name="Attributes.style" type="string" default=""/>
    <cfparam name="Attributes.format" type="string" default="string"/>
    <cfparam name="Attributes.sumColumn" type="string" default=""/> <!--- column to sum --->

    <cfif Attributes.sumColumn != "">
        <cfset Attributes.format = "money"/>
    </cfif>

    <cfassociate basetag="cf_pFooters"/>

 <cfelse>

    <cfset Attributes.Content = thisTag.GeneratedContent />
    <cfset thisTag.GeneratedContent = "" />
    <cfset ArrayAppend(request.PlainGrid.footers[request.PlainGrid.footers.len()].footer,Attributes)/>

</cfif>
</cfoutput>