<cfoutput>

  <cfif ThisTag.ExecutionMode == "Start">
  
    <cfparam name="Attributes.TagName" type="string" default="toggle"/>
    <cfparam name="Attributes.Id" type="string" default="#application.fn.getRandomVariable()#"/>
    <cfparam name="Attributes.Name" type="string"/>
    <cfparam name="Attributes.value" type="string" default="No"/>
    <cfparam name="Attributes.label" type="string" default=""/>
    <cfparam name="Attributes.help" type="string" default=""/>
    <cfparam name="Attributes.default" type="string" default=""/>
    <cfparam name="Attributes.onYes" type="string" default=""/>
    <cfparam name="Attributes.onNo" type="string" default=""/>
    
    <div class="form-group">
      
      <label>#attributes.label# </label>
      <div class="custom-control custom-checkbox-toggle" style="margin-top: 15px;">
        <cfif Attributes.value == "">
          <cfset Attributes.value = Attributes.default>
        </cfif>
        <input type="checkbox" class="custom-control-input" name="#Attributes.Name#" <cfif Attributes.value == "Yes">value="Yes" checked</cfif> id="#Attributes.Id#">
        <label class="custom-control-label" for="#Attributes.Id#" id="btn_#Attributes.Id#" <cfif Attributes.value == "Yes">data-value="Yes"<cfelse>data-value="No"</cfif>></label>
      </div>

			<cfif Attributes.help != "">
        <small class="form-text text-muted">#Attributes.help#</small>
      </cfif>

    </div>

  <cfelse>

    <cfif attributes.onYes != "" || attributes.onNo != "">
      <script>
        <!--- on first load do something ---->
        $(function() { 
          <cfif Attributes.value == "Yes">
            #Attributes.onYes#; 
          </cfif>
          <cfif Attributes.value == "No" || Attributes.value == "">
            #Attributes.onNo#; 
          </cfif>
        });
        $("##btn_#Attributes.Id#").click(function(e)  {
          var vl = e.target.attributes['data-value'].value;
          if(vl == "Yes") {
            #Attributes.onNo#
            vl = "No";
          }
          else {
            #Attributes.onYes#
            vl = "Yes";
          }
          e.target.attributes['data-value'].value = vl;
        });

      </script>

    </cfif>

  </cfif>

</cfoutput>