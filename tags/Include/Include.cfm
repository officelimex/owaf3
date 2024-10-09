<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">
  
    <cfparam name="Attributes.TagName" type="string" default="Include"/> 
    <cfparam name="Attributes.url" type="string" />
    <cfparam name="Attributes.include_variable" type="any"  />

    
    <cfif listFindNoCase(request.user.pageURLs, Attributes.url)>
        <cfset view = Attributes.include_variable/>
        <cfinclude template="../../../views/#lcase(request.user.usertype)#/#replace(Attributes.url,'.','/')#.cfm" />

    </cfif>

<cfelse>

</cfif> 
</cfoutput>