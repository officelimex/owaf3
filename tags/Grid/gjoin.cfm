<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">
  
    <cfparam name="Attributes.TagName" type="string" default="Join"/> 
    <cfparam name="Attributes.Model" type="string" /><!--- model description --->
    <cfparam name="Attributes.type" type="string" default="join"/> <!--- type of join {join, ljoin} --->
    <cfparam name="Attributes.fkey" type="string" default=""/>
    <cfparam name="Attributes.alias" type="string" default=""/> 
    <cfparam name="Attributes.deep" type="boolean" default="false"/><!---- deep relationship --->

    <cfif Attributes.alias neq "">

 	    <cfset Attributes.Model = Attributes.Model & " " & Attributes.alias/>
 		
 	</cfif>

    <cfassociate basetag="cf_Grid"/>
    
 	<cfset ArrayAppend(request.grid.join,Attributes)/>
     
</cfif> 
</cfoutput>