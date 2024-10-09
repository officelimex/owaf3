<cfoutput>

  <cfif ThisTag.ExecutionMode == "Start">
  
    <cfparam name="Attributes.TagName" type="string" default="CustomField"/>
    <cfparam name="Attributes.total" type="numeric" default="9"/>

    <cfparam name="Attributes.readonly" type="boolean" default="false"/>

    <cfparam name="Attributes.id" type="string" default="#application.fn.GetRandomVariable()#"/>

    <cfparam name="Attributes.key" type="string" default="0"/>
    <cfparam name="Attributes.modelId" type="numeric"/>
    <cfparam name="Attributes.tenantId" type="numeric"/>

    <cfparam name="Attributes.fieldName" default="custom_field"/>

    <cfset ArrayAppend(request.form.cfield, Attributes)/>
  
    <cfset cf_xform = getBaseTagData("cf_xform").Attributes/>
  
  <cfelse>
<!---     
    <cfquery name="qC">
      SELECT 
        fd.*,
        fn.*
      FROM custom_field_name fn
      LEFT JOIN custom_field_data fd ON fd.CustomFieldNameId = fn.CustomFieldNameId
      WHERE fn.TenantId = #attributes.tenantid# 
        AND fn.ModelId = #attributes.modelId#
        AND fd.Key1 = "#Attributes.key#"
    </cfquery>
 --->
    <cfquery name="qC">
      SELECT 
        fn.*
      FROM custom_field_name fn
      WHERE fn.TenantId = #attributes.tenantid# 
        AND fn.ModelId = #attributes.modelId#
    </cfquery>

    <div class="row">
      <cfset i=0/>
      <cfloop query="qC">
        <cfquery name="qCD">
          SELECT 
            fd.*
          FROM custom_field_data fd
          WHERE fd.Key1 = "#Attributes.key#" 
            AND fd.CustomFieldNameId = #qC.CustomFieldNameId# 
          LIMIT 0,1        
        </cfquery>
        <cfset i++/>
        <div class="col-sm-6 col-md-4">
          <div class="form-group ">
            <label for="_xf#CustomFieldNameId#">#qC.Name#</label> 
            <div class="#Attributes.id##i#">
              <input type="text" id="_xf#CustomFieldNameId#"
                <cfif Attributes.readonly>readonly</cfif>
                value="#qCD.value#" 
                class="form-control" 
                name="#Attributes.fieldName#_value_#i#"/>
            </div>
          </div>
          <input type="hidden" value="#qCD.CustomFieldDataId#" name="#Attributes.fieldName#_pk_#i#"/>
          <input type="hidden" value="#qC.CustomFieldNameId#" name="#Attributes.fieldName#_fk_#i#"/>
        </div>
      </cfloop>
    </div>
  </cfif>
</cfoutput>