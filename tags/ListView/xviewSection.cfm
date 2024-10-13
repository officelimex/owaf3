<cfoutput>

  <cfif ThisTag.ExecutionMode == "Start">
  
    <cfparam name="Attributes.tagname" type="string" default="xviewSection"/>
    <cfparam name="Attributes.Id" type="string" default="#application.fn.GetRandomVariable()#"/>
  
  <cfelse>

    <style>
      ###Attributes.Id# .xlv--body{
        overflow:auto;
      }
      ###Attributes.Id# {
        -ms-flex: 0 0 #100-request.listsection.tag.width#%;
        flex: 0 0 #100-request.listsection.tag.width#%;
        max-width: #100-request.listsection.tag.width#%;
      }     
      @media (max-width: 1024px)  {
        .xlv-app-wrap.xlv-app-slide .xlv--box ###Attributes.Id# {
          right: 0;
        }
        ###Attributes.Id# {
          width: 100% !important;          
          max-width: 100% !important;          
        }
      }
    </style>

    <cfset Content = THISTAG.GeneratedContent />
    <cfset THISTAG.GeneratedContent = "" />

    <div class="xlv-app-right" id="#Attributes.Id#">

      #Content# 

    </div>
      
  </cfif>

</cfoutput>