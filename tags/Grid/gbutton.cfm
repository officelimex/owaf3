<cfoutput>

	<cfif ThisTag.ExecutionMode EQ "Start">

		<cfparam name="Attributes.TagName" type="string" default="Button"/>
		<cfparam name="Attributes.title" type="string" default=""/>

		<cfparam name="Attributes.modaltitle" type="string" default="#Attributes.title#"/>
		<cfparam name="Attributes.modalPosition" type="string" default="center"/> <!--- the to place the modal --->
		<cfparam name="Attributes.keyboard" type="boolean" default="false"/> 
		<cfparam name="Attributes.backdrop" type="string" default="static"/> 
		
		<cfparam name="Attributes.help" type="string" default="#Attributes.modaltitle#"/>
		<cfparam name="Attributes.id" type="string" default="#application.fn.GetRandomVariable()#"/>
		<cfparam name="Attributes.url" type="string"/>
		<cfparam name="Attributes.urlparam" type="string" default=""/>
		<cfparam name="Attributes.icon" type="string" default=""/>
		<cfparam name="Attributes.iconType" type="string" default="fal fa-"/>
		<cfparam name="Attributes.iconCss" type="string" default=""/>
		<cfparam name="Attributes.style" type="string" default=""/> <!--- bootstrap button style --->
		<cfparam name="Attributes.type" type="string" default="ajax"/> <!--- ajax:link,external,modal,print,execute {use controller/page}--->
		<cfparam name="Attributes.forcePageReload" type="boolean" default="false"/> <!--- depreciate --->
		<cfparam name="Attributes.changeURL" type="boolean" default="true"/> <!---- allow url to change on load --->
		<cfparam name="Attributes.renderTo" type="string" default=""/> <!--- where to render the content to --->
		<cfparam name="Attributes.samePage" type="boolean" default="false"/> <!--- render to same page --->
		<cfparam name="Attributes.showOnHistoryPane" type="boolean" default="true"/> <!--- determin if to show link on history pane or mot --->
		<cfparam name="Attributes.ignoreRoleCheck" type="boolean" default="false"/><!--- determine if to secure the url attribute of this tag --->
		<cfparam name="Attributes.confirm" type="string" default="Are you sure"/> <!--- needed if type = execute --->
		<cfparam name="Attributes.samePageRedirect" type="boolean" default="false"/>
		<cfparam name="Attributes.redirectURL" type="string" default=""/> <!--- needed if type = execute --->
    <cfparam name="Attributes.redirectURLparam" type="string" default=""/>
		<cfparam name="Attributes.force" type="boolean" default="#Attributes.forcePageReload#"/>
		<cfparam name="Attributes.disabled" type="boolean" default="false"/>
    <cfparam name="Attributes.flashMessage" type="string" default="Done"/> <!--- show flash message after executing a link --->

		<cfif Attributes.renderTo neq "">
			<cfset Attributes.showOnHistoryPane = false/>
			<cfset Attributes.force = true/>
			<cfset Attributes.changeURL = false/>
		</cfif>

		<cfset ArrayAppend(request.grid.buttons, Attributes)/>

	</cfif>

</cfoutput>
