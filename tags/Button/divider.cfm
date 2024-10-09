<cfif ThisTag.ExecutionMode == "Start">

    <cfparam name="Attributes.TagName" type="string" default="Divider"/>

    <cfset ArrayAppend(request.buttons, Attributes)/>

</cfif>