<cfoutput>

  <cfif ThisTag.ExecutionMode == "Start">
  
    <cfparam name="Attributes.tagname" type="string" default="xfilterSection"/>
    <cfparam name="Attributes.Id" type="string" default="#application.fn.GetRandomVariable()#"/>
    <cfparam name="Attributes.width" type="string" default="0"/>
    <cfparam name="Attributes.hide" type="boolean" default="false"/>
    
    <cfset request.filtersection.tag = Attributes/>

  <cfelse>

    <style>
      ###Attributes.Id# {
        overflow:auto;
        width:#Attributes.width#;
      }
    </style>
    
    <div class="xlv-app-sidebar" id="#Attributes.Id#" style="height: 800px;">
      <div class="xlv-app-nav-wrap">
          <a href="javascript:void(0)" class="close_xlv-app_sidebar close-xlv-app-sidebar">
            <span class="feather-icon"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-chevron-left"><polyline points="15 18 9 12 15 6"></polyline></svg></span>
          </a>

          <cfset Content = THISTAG.GeneratedContent />
          <cfset THISTAG.GeneratedContent = "" />
      
          #Content#

      </div>
    </div> 

  </cfif>

</cfoutput>