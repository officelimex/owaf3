<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">

    <cfparam name="Attributes.TagName" type="string" default="datepicker"/>
    <cfparam name="Attributes.type" type="string" default="text"/>
    <cfparam name="Attributes.name" type="string"/>
    <cfparam name="Attributes.value" type="string" default=""/>
    <cfparam name="Attributes.required" type="boolean" default="false"/>
    <cfparam name="Attributes.help" type="string" default=""/>
    <cfparam name="Attributes.label" type="string" default="#Attributes.name#"/>
    <cfparam name="Attributes.size" type="string" default="col-sm-6"/>
    <cfparam name="Attributes.id" type="string" default="#application.fn.GetRandomVariable()#"/>
    <cfparam name="Attributes.format" type="string" default="dd-mm-yyyy"/>
    <cfparam name="Attributes.withButton" type="boolean" default="true"/>


 	<cfset ArrayAppend(request.form.datepicker,Attributes)/>

 	<cfset cf_xform = getBaseTagData("cf_xform").Attributes/>

 	<cftry>

 		<cfset cf_row = getBaseTagData("cf_frow").ATTRIBUTES.TagName/>
 		<cfcatch type="any">
			<cfset cf_row = ""/>
 		</cfcatch>

 	</cftry>


<cfelse>


	<cfif cf_row eq "">
		<div class="form-group">
	<cfelse>
		<div class="#Attributes.size# pad-top-10">
	</cfif>

		    <cfif !cf_xform.useplaceholder>
		    	<label for="#Attributes.id#">#Attributes.label# <cfif Attributes.required><sup class="text-danger">●</sup></cfif></label>
		    </cfif>

		    <input type="text" class="form-control datepicker" name="#attributes.name#" value="#dateformat(attributes.value,'Attributes.format')#" data-date-format="#Attributes.format#" id="#Attributes.id#"
		    	<cfif cf_xform.useplaceholder>
		    		placeholder="#Attributes.label#"
		    	</cfif>
		    	<cfif Attributes.required>
		    		required
		    	</cfif>
		    />

		    <cfif Attributes.help neq "">
		        <small class="form-text text-muted">#Attributes.help#</small>
		    </cfif>

	<!---cfif cf_row eq "">
		</div>
	<cfelse>
		</div>
	</cfif--->
	</div>

</cfif>
</cfoutput>