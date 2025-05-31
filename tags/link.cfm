<cfoutput>
<cfif ThisTag.ExecutionMode == "Start">

    <cfparam name="Attributes.TagName" type="string" default="Link"/>
    <cfparam name="Attributes.url" type="string"/>
    <cfparam name="Attributes.changeURL" type="boolean" default="true"/>
    <cfparam name="Attributes.renderTo" type="string" default=""/>
    <cfparam name="Attributes.urlparam" type="string" default=""/>
    <cfparam name="Attributes.redirectURLparam" type="string" default=""/>
    <cfparam name="Attributes.type" type="string" default="load"/> <!--- load || ajax, execute, modal, print, blank, todo:callback --->
    <cfparam name="Attributes.icon" type="string" default=""/>
    <cfparam name="Attributes.iconType" type="string" default="fal fa-"/>
    <cfparam name="Attributes.iconCss" type="string" default=""/>
    <cfparam name="Attributes.showIfNoAccess" type="boolean" default="false"/>
    <cfparam name="Attributes.title" type="string" default=""/>
    <cfparam name="Attributes.help" type="string" default="#Attributes.title#"/>
    <cfparam name="Attributes.modalTitle" type="string" default="#Attributes.help#"/>
    <cfparam name="Attributes.class" type="string" default=""/>
    <cfparam name="Attributes.cssStyle" type="string" default=""/> <!--- css style --->
    <cfparam name="Attributes.force" type="boolean" default="false"/>
    <cfparam name="Attributes.closeModal" type="boolean" default="false"/>
    <cfparam name="Attributes.scrollTo" type="string" default=""/>
    <cfparam name="Attributes.flashMessage" type="string" default="Done"/>
    <cfparam name="Attributes.modalPosition" type="string" default=""/>
		<cfparam name="Attributes.backdrop" type="string" default="static"/>
    <cfparam name="Attributes.keyboard" type="boolean" default="false"/> 
		
		<cfset Attributes.modalTitle = application.fn.excapeJsStr(Attributes.modalTitle)/>

		<cfif Attributes.renderTo == "">
			<cfparam name="Attributes.samePage" type="boolean" default="false"/>
		<cfelse>
			<cfparam name="Attributes.samePage" type="boolean" default="true"/>
		</cfif>

	<!--- close tag --->
	<!--- Testing git gui now --->
	<cfset nurl = Attributes.url/>

	<cfif Attributes.type == "execute" || Attributes.type == "ajax">
		
		<cfparam name="Attributes.confirm" type="string" default="Are you sure"/>
		<cfparam name="Attributes.redirectURL" type="string" default=""/>
		<cfparam name="Attributes.redirectType" type="string" default=""/> <!--- "" or "modal" --->

		<cfset method =  listlast(listFirst(listlast(Attributes.url,'?'),'&'),'=')/>
		<cfset control = replace(listFirst(Attributes.url,'.'),'/','.','all')/>

		<cfset nurl = control & '.' & method/>
		
	</cfif>

<cfelse>

	<cfinclude  template="../com/inc/lang.cfm">
	<!--- lang --->
	<cfset Attributes.modalTitle = tr(Attributes.modalTitle)/>
	<!---//lang --->

	<cfset Content = THISTAG.GeneratedContent/>
	<cfset THISTAG.GeneratedContent = "" />
	
	<cfset deChar = "~"/>
	<cfif listFindNoCase(nurl, "@")>
		<cfset deChar = "@"/>
	</cfif>

	<cfif listFindNoCase(request.user.pageURLs, listfirst(nurl, deChar))>

		<cfswitch expression="#Attributes.type#">
			<cfcase value="print">
				<cfif Attributes.icon == "">
					<cfset Attributes.icon = "print"/>
				</cfif>
				<cfset printurl = replace(Attributes.url,'.','/','all')/>
				<cfset printurl = replace(printurl,deChar,'&key=')/>
				<a title="#Attributes.help#" class="#attributes.class#" style="#Attributes.cssStyle#" href="views/inc/print/print.cfm?page=#printurl#&#Attributes.urlparam#" target="_blank" ><cfif Attributes.icon != ""><i class="#Attributes.icontype##Attributes.icon# #Attributes.iconCss#"></i><cfif len(trim(Content))>&nbsp;</cfif></cfif>#Content#</a>
			</cfcase>
			<cfcase value="modal">
				<a title="#Attributes.help#" class="#attributes.class#" style="#Attributes.cssStyle#" href="javascript:;"
					onclick="showModal('#Attributes.url#', {'backdrop':'#Attributes.backdrop#','keyboard':#Attributes.keyboard#,'param':'#Attributes.urlparam#','title':'#Attributes.modalTitle#' <cfif Attributes.modalPosition != "">,'position':'#Attributes.modalPosition#'</cfif>})" >
					<cfif Attributes.icon != ""><i class="#Attributes.icontype##Attributes.icon# #Attributes.iconCss#"></i>
					</cfif>#Content#
				</a>
			</cfcase>
			<cfcase value="execute,ajax" delimiters=",">
				<cfset conf_ = replaceNoCase(Attributes.confirm,"'","\'","all")/>
				<cfif listLen(conf_,"|") gt 1>
					<cfset conf_ = "title:'#listFirst(conf_,'|')#',text:'#listLast(conf_,'|')#'"/>
				<cfelse>
					<cfset conf_ = "title:'#conf_#'"/>
				</cfif>
				<cfif Attributes.confirm == "">
					<cfset conf_ = ""/>
				</cfif>
				<a title="#Attributes.help#"
					class="#attributes.class#"
					style="#Attributes.cssStyle#" href="javascript:;"
					onclick="
					<cfif conf_ != "">

						Swal.fire({
							icon: 'question',
							#conf_#,
							confirmButtonText: 'Yes',
							showCancelButton: true
						}).then((result) => {
							if (result.isConfirmed) {

					</cfif>
						ajaxCall('#Attributes.url#&#Attributes.urlparam#', function(d)	{
							<cfif Attributes.redirectURL != "">
								<cfif Attributes.redirectType == "modal">
									showModal('#Attributes.redirectURL#', {'backdrop':'#Attributes.backdrop#','keyboard':#Attributes.keyboard#,'param':'#Attributes.redirectURLparam#','title':'#Attributes.modalTitle#' <cfif Attributes.modalPosition != "">,'position':'#Attributes.modalPosition#'</cfif>});
								<cfelse>
									loadPage('#Attributes.redirectURL#',{<cfif Attributes.scrollTo!="">'scrollTo':'#Attributes.scrollTo#',</cfif>'forcePageReload':true,'changeURL':#attributes.changeURL#,'param':'#Attributes.redirectURLparam#'<cfif attributes.renderTo != "">,'renderTo':'#attributes.renderTo#'</cfif>});
								</cfif>
							</cfif>
							<cfif Attributes.FlashMessage != "">
								<cfif FindNoCase("{{", Attributes.FlashMessage)>
									var d = $.parseJSON(d);
									<cfset Attributes.FlashMessage = replaceNoCase(Attributes.FlashMessage, "{{", "' + d.")/>
									<cfset Attributes.FlashMessage = replaceNoCase(Attributes.FlashMessage, "}}", "+'")/>
								</cfif>
								itemCreatedNotice('#Attributes.FlashMessage#');
							</cfif>
							<cfif Attributes.closeModal>$('##__app_modal').modal('hide');</cfif>
						});
					<cfif conf_ != "">
						}
					});
				</cfif>
					" >
					<cfif Attributes.icon != ""><i class="#Attributes.icontype##Attributes.icon# #Attributes.iconCss#"><cfif len(trim(Content))>&nbsp;</cfif></i></cfif>
					#Content#
				</a>
			</cfcase>
			<cfcase value="blank">
				<cfset _nurl = replace(Attributes.url,'.','/','all')/>
				<cfset _nurl = replace(_nurl,deChar,'.cfm?id=')/>
				<a title="#Attributes.help#"
					class="#attributes.class#"
					style="#Attributes.cssStyle#"
					href="views/#_nurl#"
					target="_blank">
					<cfif Attributes.icon != ""><i class="#Attributes.icontype##Attributes.icon# #Attributes.iconCss#"><cfif len(trim(Content))>&nbsp;</cfif></i></cfif>
					#Content#
				</a>
			</cfcase>
			<cfdefaultcase>
				<a title="#Attributes.help#"
				class="#attributes.class#"
				style="#Attributes.cssStyle#" href="javascript:;"
				onclick="
					loadPage('#Attributes.url#', {<cfif Attributes.scrollTo!="">'scrollTo':'#Attributes.scrollTo#',</cfif>'param':'#Attributes.urlparam#','samePage':#Attributes.samePage#,'title':'#Attributes.title#','forcePageReload':#Attributes.force#,'changeURL':#attributes.changeURL#<cfif attributes.renderTo != "">,'renderTo':'#attributes.renderTo#'</cfif>});
					<cfif Attributes.closeModal>$('##__app_modal').modal('hide');</cfif>
				" >
				<cfif Attributes.icon != ""><i class="#Attributes.icontype##Attributes.icon# #Attributes.iconCss#"><cfif len(trim(Content))>&nbsp;</cfif></i></cfif>#Content#</a>
			</cfdefaultcase>
      	</cfswitch>
	<cfelse>
		<cfif Attributes.showIfNoAccess>
			#Content#
		</cfif>
	</cfif><!---&nbsp;--->

</cfif>
</cfoutput>