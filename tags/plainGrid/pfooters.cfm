<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">
  
    <cfparam name="Attributes.TagName" type="string" default="pFooters"/>
    <cfparam name="Attributes.class" type="string" default=""/>
 	   
 	<cfassociate basetag="cf_pGrid" />
 	<cfset Attributes.footer = arrayNew(1)/>
	<cfset ArrayAppend(request.PlainGrid.footers,Attributes)/>    
<!--- close tag --->   
<cfelse>
 
</cfif> 
</cfoutput>