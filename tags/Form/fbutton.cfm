<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">

    <cfparam name="Attributes.TagName" type="string" default="Button"/>
    <cfparam name="Attributes.icon" type="string" default=""/>
    <cfparam name="Attributes.url" type="string"/>
    <cfparam name="Attributes.type" type="string" default="success"/>
    <cfparam name="Attributes.id" type="string" default="#application.fn.GetRandomVariable()#"/>
    <cfparam name="Attributes.flashmessage" type="string" default="Data was saved succesfuly"/>
    <cfparam name="Attributes.size" type="string" default="col-sm-6"/>
    <cfparam name="Attributes.pullleft" type="boolean" default="true"/>

 	<cfset ArrayAppend(request.form.button,Attributes)/>

 	<cfparam name="Attributes.value" type="string" default="button #arraylen(request.form.button)#"/>

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

	<div class="<cfif Attributes.pullleft>pull-left<cfelse>pull-right</cfif> pad-left-10">
		<button class="btn btn-#Attributes.type#" id="#Attributes.id#" type="button" flash-msg="#Attributes.flashmessage#">
			<cfif attributes.icon neq "">
				<i class="#attributes.icon#"></i>
			</cfif>
			#Attributes.value#
		</button>
	</div>

	<!---cfif cf_row eq "">
		</div>
	<cfelse>
		</div>
	</cfif--->
	</div>

</cfif>
</cfoutput>
