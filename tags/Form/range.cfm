<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">

    <cfparam name="Attributes.TagName" type="string" default="Range"/>
    <cfparam name="Attributes.type" type="string" default="text"/>
    <cfparam name="Attributes.name" type="string"/>
    <cfparam name="Attributes.value" type="string" default=""/>
    <cfparam name="Attributes.required" type="boolean" default="false"/>
    <cfparam name="Attributes.help" type="string" default=""/>
    <cfparam name="Attributes.label" type="string" default="#Attributes.name#"/>
    <cfparam name="Attributes.min" type="numeric"/>
    <cfparam name="Attributes.max" type="numeric"/>
    <cfparam name="Attributes.step" type="numeric" default="1"/>
    <cfparam name="Attributes.prefix" type="string" default="%"/>
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

			<output id="#Attributes.id#_s_o">#attributes.value##Attributes.prefix#</output>
			<input type = "range" min="#attributes.min#" step="#Attributes.step#" max="#attributes.max#" value="#attributes.value#" onchange="#Attributes.id#_s_o.value=value+'#Attributes.prefix#'" name="#Attributes.name#" id="#Attributes.id#" list="#Attributes.id#country"/>

<datalist id="#Attributes.id#country">
<option>0</option>
<option>10</option>
<option>20</option>
</datalist>
		    <!---input type="#Attributes.type#" value="#attributes.value#" class="form-control" name="#Attributes.name#" id="#Attributes.id#"
		    	<cfif cf_xform.useplaceholder>
		    		placeholder="#Attributes.label#"
		    	</cfif>
		    	<cfif Attributes.required>
		    		required
		    	</cfif>
		    /--->
		    <cfif Attributes.help neq "">
		        <small class="form-text text-muted">#Attributes.help#</small>
		    </cfif>
		    <br/>
	<!---cfif cf_row eq "">
		</div>
	<cfelse>
		</div>
	</cfif--->
	</div>

</cfif>
</cfoutput>