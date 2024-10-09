<cfoutput>
<cfif ThisTag.ExecutionMode == "Start">

	<cfparam name="Attributes.TagName" type="string" default="Submit"/>
	<cfparam name="Attributes.url" type="string"/>
	<cfparam name="Attributes.style" type="string" default="success"/>
	<cfparam name="Attributes.class" type="string" default=""/>
	<cfparam name="Attributes.classPrefix" type="string" default="btn btn-"/>
	<cfparam name="Attributes.id" type="string" default="#application.fn.GetRandomVariable()#"/>
	<cfparam name="Attributes.clearForm" type="boolean" default="false"/>

	<cfparam name="Attributes.redirectURL" type="string" default=""/>
	<cfparam name="Attributes.redirect" type="string" default="#Attributes.redirectURL#"/>
	<cfparam name="Attributes.redirectType" type="string" default=""/> <!---- type of redirect after form is sumitted {modal},{external} ---->
	<cfparam name="Attributes.modalPosition" type="string" default="center"/> <!---- left, right, center ---->
	<cfparam name="Attributes.modalTitle" type="string" default=""/>
	<cfparam name="Attributes.redirectParam" type="string" default=""/> <!--- redirect url param --->
	<cfparam name="Attributes.targetRedirectElement" type="string" default=""/> <!--- DO NOT USE  --->
	<cfparam name="Attributes.renderTo" type="string" default="#Attributes.targetRedirectElement#"/> <!--- which element on the page to redirect too --->

	<cfparam name="Attributes.flashMessage" type="string" default="Data was saved successfully"/>
	<cfparam name="Attributes.icon" type="string" default="save"/>
	<cfparam name="Attributes.confirm" type="string" default=""/>

	<cfparam name="Attributes.type" type="string" default=""/> <!--- default="", link,external -> send the form to another page --->

	<!--- rewrite submit url --->
	<cfset nurl = listFirst(Attributes.url,'cfc')/>
	<cfset nurl_2 = replace(nurl,'.','/','all')/>
	<cfset Attributes.url = replaceNoCase(Attributes.url, nurl, nurl_2)/>
	<cfset Attributes.url = replaceNoCase(Attributes.url, '/cfc', '.cfc')/>

	<!---- if this is a modal ---->
	<cfparam name="Attributes.closeModalAfterSave" default="true"/>
	<cfif Attributes.redirectType == "modal">
		<cfset Attributes.closeModalAfterSave = false/>
	</cfif>
	<cfset ArrayAppend(request.form.submit, Attributes)/>

	<cfparam name="Attributes.value" type="string" default="Submit #arrayLen(request.form.submit)#"/>

<cfelse>

	<button
		class="#Attributes.classPrefix##Attributes.style# #Attributes.class#"
		id="#Attributes.id#"
		type="submit"
		clear-form="#Attributes.clearForm#"
		confirm="#Attributes.confirm#"
		redirect-url = "#Attributes.redirect#"
		flash-msg="#Attributes.flashMessage#"
		redirect-target="#Attributes.renderTo#"
		redirect-type="#Attributes.redirectType#"
		<cfif Attributes.redirectType == "modal">
			modal-position="#Attributes.modalPosition#"
			modal-title="#Attributes.modalTitle#"
		</cfif>
		redirect-param="#Attributes.redirectParam#"
		close-modal-after-save="#Attributes.closeModalAfterSave#">

		<cfif attributes.icon is not "">
			<i class="fal fa-#attributes.icon#"></i>
		</cfif>

		#Attributes.value#

	</button>

</cfif>
</cfoutput>