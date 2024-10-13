<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">
  
    <cfparam name="Attributes.TagName" type="string" default="Columns"/> 
 	   
 	<cfassociate basetag="cf_TableEdit" />
 	<cfset request.TableEdit.totalcolumn = 0/>
	<cfset request.TableEdit.columns = ArrayNew(1)/>     
<!--- close tag --->   
<cfelse>
 
</cfif> 
</cfoutput>