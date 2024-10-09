<cfoutput>

  <cfif ThisTag.ExecutionMode == "Start">
  
    <cfparam name="Attributes.TagName" type="string" default="ListCustomField"/>
    <cfparam name="Attributes.key" type="string" default="0"/>
    <cfparam name="Attributes.modelId" type="numeric"/>

    <cfquery name="qC">
      SELECT * FROM custom_field_data 
      WHERE TenantId = #request.user.tenantid# 
        AND ModelId = #attributes.modelId#
        AND Key1 = "#Attributes.key#"
    </cfquery>

    <div class="row">
      <cfloop query="qC">
        <div class="col-sm-6 col-md-4">
					<cf_blockitem label="#qC.Name#" value="#qC.Value#" />
        </div>
      </cfloop>
    </div>

  <cfelse>
  </cfif>
</cfoutput>