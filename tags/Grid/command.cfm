<cfoutput>
<cfif ThisTag.ExecutionMode == "Start">

    <cfparam name="Attributes.TagName" type="string" default="Command"/>
    <cfparam name="Attributes.icon" type="string" default=""/>
    <cfparam name="Attributes.iconType" type="string" default="fal fa-"/>
    <cfparam name="Attributes.title" type="string" default=""/>
    <cfparam name="Attributes.type" type="string" default="load"/><!--- load|ajax, execute, modal, print, blank --->
    <cfparam name="Attributes.buttonType" type="string" default="link"/>
    <cfparam name="Attributes.style" type="string" default="#Attributes.buttonType#"/>
    <cfparam name="Attributes.url" type="string"/>

    <cfparam name="Attributes.keyboard" type="boolean" default="false"/> 
    <cfparam name="Attributes.backdrop" type="string" default="static"/> 
    <cfparam name="Attributes.modalurl" type="string" default=""/>
    <cfparam name="Attributes.modalPosition" type="string" default="center"/> <!--- the to place the modal --->

    <cfparam name="Attributes.urlparam" type="string" default=""/> <!--- other url parameters to send along with the url--->
    <cfparam name="Attributes.jsURLparam" type="string" default=""/> <!--- other url parameters to send along with the url using column data--->
    <cfparam name="Attributes.renderTo" type="string" default=""/>
    <cfparam name="Attributes.changeURL" type="boolean" default="true"/>
    <cfparam name="Attributes.forcePageReload" type="boolean" default="true"/>
    <cfparam name="Attributes.samePage" type="boolean" default="false"/>
    <cfparam name="Attributes.condition" type="string" default="0==0"/>
    <cfparam name="Attributes.redirectURL" type="string" default=""/>
    <cfparam name="Attributes.confirm" type="string" default="Are you sure?"/><!---- js confirm that user wants to go ahead with the click command. used with when type = execute --->
    <cfparam name="Attributes.class" type="string" default=""/>
    <cfparam name="Attributes.help" type="string" default="#Attributes.title#"/>
    <cfparam name="Attributes.key" type="string" default="row[0]"/><!--- the id, key --->
    <cfparam name="Attributes.documentNumber" type="string" default="#Attributes.key#"/><!---document number of the row or column to display :: DO NOT USE--->
    <cfparam name="Attributes.pageColumn" type="string" default="#Attributes.documentNumber#"/><!--- the column to show on the modal title --->
    <cfparam name="Attributes.pageTitle" type="string" default="#Attributes.help#"/> <!--- this is used in the breadcrumb/history bar --->

    <cfset Attributes.pageColumn = replacenocase(Attributes.pageColumn, " ", "&nbsp;", 'all')/>
    <cfset Attributes.pageTitle = replacenocase(Attributes.pageTitle, " ", "&nbsp;", 'all')/>

    <cfif Attributes.renderTo neq "">
			<cfset Attributes.changeURL = false/>
			<cfset Attributes.forcePageReload = true/>
    </cfif>

    <cfset nurl = Attributes.url/>

    <!----- onver Attributes.url - CFC url to normal url --->
     <cfif Attributes.type == "execute">

			<cfset method =  listlast(listfirst(listlast(Attributes.url,'?'),'&'),'=')/>
			<cfset control = replace(listFirst(Attributes.url,'.'),'/','.')/>

			<cfset nurl = control & '.' & method/>

    </cfif>

    <cfif listFindNoCase(request.user.pageURLs, nurl)>

	   <cfassociate basetag="cf_Commands"/>

	   <cfset cmd = GetBaseTagData('cf_Commands').ATTRIBUTES/>

	   <!--cfset Attributes.icon = cmd.iconprefix & Attributes.icon/---->
	   <cfset Attributes.icon = Attributes.iconType & Attributes.icon/>
	   <cfset Attributes.style = cmd.buttonTypeprefix & Attributes.style & " " & Attributes.class/>

	   <cfset ArrayAppend(request.grid.Commands,Attributes)/>

	</cfif>

</cfif>
</cfoutput>