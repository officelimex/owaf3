<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">
  
    <cfparam name="Attributes.TagName" type="string" default="Columns"/> 
 	   
 	<cfassociate basetag="cf_pGrid" />
	<cfset request.PlainGrid.columns = ArrayNew(1)/>     
<!--- close tag --->   
<cfelse>
 
</cfif> 
</cfoutput>