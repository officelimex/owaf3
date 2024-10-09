<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">
  
    <cfparam name="Attributes.TagName" type="string" default="Group"/>
 	<cfparam name="Attributes.title" type="string"/>

    <fieldset>
    	<legend>#Attributes.title#</legend>
 
<cfelse>
	
	</fieldset>

</cfif> 
</cfoutput>