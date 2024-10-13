<cfoutput>

  <cfif ThisTag.ExecutionMode == "Start">
  
    <cfparam name="Attributes.tagname" type="string" default="listview"/>
    <cfparam name="Attributes.Id" type="string" default="#application.fn.GetRandomVariable()#"/>
  
    <cfset request.listview.tag = Attributes/>
    
  <cfelse>

    <div id="#Attributes.Id#">
      
      <div class="xlv-app-wrap <cfif request.filtersection.tag.hide>xlv-app-sidebar-toggle</cfif>">

        <cfset Content = THISTAG.GeneratedContent />
        <cfset THISTAG.GeneratedContent = "" />

        #Content#
      
      </div>
    </div>

<script>

  $(document).ready(function(){
  
    var  lv_width = 0;
    var xlvAppTarget = $('###Attributes.Id# .xlv-app-wrap');

    if(lv_width>1024) 
      xlvAppTarget.removeClass('xlv-app-slide');
    $(document).on("click","###Attributes.Id# .xlv-app-wrap .xlv-app-xlv-s-list a.media",function (e) {
      if(lv_width<=1024) {
        xlvAppTarget.addClass('xlv-app-slide');
      }
      return;
    });
    $(document).on("click","###Attributes.Id# .back_xlv-_list",function (e) {
      if(lv_width<=1024) {
        xlvAppTarget.removeClass('xlv-app-slide');
      }	
      return false;
    });
    $(document).on("click","###Attributes.Id# .xlv-app_sidebar_move",function (e) {
      xlvAppTarget.toggleClass('xlv-app-sidebar-toggle');
      return false;
    });
    $(document).on("click","###Attributes.Id# .close_xlv-app_sidebar",function (e) {
      if(lv_width<=1400) {
        xlvAppTarget.removeClass('xlv-app-sidebar-toggle');
      }	
      return false;
    });

  });

  $(window).on("resize", function () {
    setHeightWidth('#Attributes.Id#'); 
  });
  $(window).trigger("resize");

</script>
  </cfif>
  
</cfoutput>