<cfif ThisTag.ExecutionMode EQ "Start">

    <cfparam name="Attributes.TagName" type="string" default="Aggregate"/>
    <cfparam name="Attributes.group" type="string" default=""/>
    <cfparam name="Attributes.select" type="string"/>

    <cfassociate basetag="cf_Grid"/>

 	<cfset ArrayAppend(request.grid.aggregate,Attributes)/>

</cfif>