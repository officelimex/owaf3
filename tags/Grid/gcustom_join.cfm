<cfif ThisTag.ExecutionMode EQ "Start">

    <cfparam name="Attributes.TagName" type="string" default="CustomJoin"/>
    <cfparam name="Attributes.join" type="string" />
    <cfparam name="Attributes.select" type="string"/>

    <cfassociate basetag="cf_Grid"/>

 	<cfset ArrayAppend(request.grid.cutomjoin,Attributes)/>

</cfif>