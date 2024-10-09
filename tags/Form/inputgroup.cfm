<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">

    <cfparam name="Attributes.TagName" type="string" default="InputGroup"/>
    <cfparam name="Attributes.type" type="string" default="text"/>
    <cfparam name="Attributes.name" type="string"/>
    <cfparam name="Attributes.value" type="string" default=""/>
    <cfparam name="Attributes.required" type="boolean" default="false"/>
    <cfparam name="Attributes.help" type="string" default=""/>
    <cfparam name="Attributes.label" type="string" default="#Attributes.name#"/>
    <cfparam name="Attributes.size" type="string" default="col-sm-6"/>

    <cfparam name="Attributes.addonprepend" type="string" default=""/>
    <cfparam name="Attributes.addonprependicon" type="string" default=""/>

    <cfparam name="Attributes.click" type="string" default=""/>
    <cfparam name="Attributes.id" type="string" default="#application.fn.GetRandomVariable()#"/>


 	<cfset ArrayAppend(request.form.input,Attributes)/>

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

		    <div class="input-group">
		    	<cfif Attributes.addonprependicon is not "">
		    		<span class="input-group-addon">
		    			<i class="#Attributes.addonprependicon#"></i>
		    		</span>
		    	</cfif>
			    <input type="#Attributes.type#" value="#attributes.value#" class="form-control addon" name="#Attributes.name#" id="#Attributes.id#"
			    	<cfif cf_xform.useplaceholder>
			    		placeholder="#Attributes.label#"
			    	</cfif>
			    	<cfif Attributes.required>
			    		required
			    	</cfif>
			    />

		    </div>

	</div>

</cfif>
</cfoutput>