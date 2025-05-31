<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">

    <cfparam name="Attributes.TagName" type="string" default="Buttons"/>
    <cfparam name="Attributes.iconprefix" type="string" default="fal fa-"/><!--- deprectiated : use button icon type--->
    <cfparam name="Attributes.buttonprefix" type="string" default="btn-"/>
    <cfparam name="Attributes.size" type="string" default="col-sm-8 col-xs-6"/>
    <cfparam name="Attributes.group" type="boolean" default="false"/>

    <cfassociate basetag="cf_ToolBar"/>

    <cfset request.grid.filters = ArrayNew(1)/>
    <cfset request.grid.buttons = ArrayNew(1)/>

	<cfif request.grid.hasSearch>

		<div class="col-auto">

	</cfif>


	<div class="btn-group">
		<cfif Attributes.group>
			<a href="javascript:;" class="dropdown-ellipses dropdown-toggle" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
				<i class="fe fe-more-vertical"></i>
			</a>
			<div class="dropdown-menu">
		</cfif>
<!--- close tag --->
<cfelse>
	<cfset bf_e = request.grid.buttons.len()+1/>
	<cfloop list="#request.grid.tag.export#" item="_export_type">

		<cfif _export_type eq "html">
			<cfset _icon = "file-code"/>
		<cfelse>
			<cfset _icon = "file-#_export_type#"/>
		</cfif>
		<cfset ArrayAppend(request.grid.buttons, {
			title 			: "",
			help 			: "Export to #ucase(_export_type)#",
			url 			: "owaf/tags/grid/export.cfm?type=#_export_type#&grid_name=#request.grid.tag.name#",
			ignoreRoleCheck : true,
			icon 			: _icon,
			type 			: "external",
			changeURL		: false
		})/>

    </cfloop>

	<cfloop array="#request.grid.buttons#" item="button" index="ii">
		<cfset buildLink = false/>
		<cfset _url = button.url/>
		<!--- make room for type:execute --->
		<cfif button.type == "execute">
			<cfset method =  listlast(listfirst(listlast(button.url,'?'),'&'),'=')/>
			<cfset control = replace(listFirst(button.url,'.'),'/','.')/>
			<cfset _url = control & '.' & method/>
		</cfif>
		<!----TODO: turn the above to a global function --->
		<cfset deChar = "~"/>
    <cfif listFindNoCase(_url, "@")>
        <cfset deChar = "@"/>
    </cfif>
		<cfif listFindNoCase(request.user.pageURLs, listfirst(_url,deChar))>
			<cfset buildLink = true/>
		</cfif>

		<cfif button.ignoreRoleCheck>
			<cfset buildLink = true/>
		</cfif>

		<cfif buildLink>

			<cfif !isdefined('button.showOnhistoryPane')>
				<cfset button.showOnhistoryPane = "false"/>
			</cfif>
			<cfif !isdefined('button.iconCss')>
				<cfset button.iconCss = ""/>
			</cfif>
			<cfif !isdefined('button.force')>
				<cfset button.force = "false"/>
			</cfif>
			<cfif !isdefined('button.icon')>
				<cfset button.icon = ""/>
			</cfif>
			<cfif !isdefined('button.style')>
				<cfset button.style = "link"/>
			</cfif>
			<cfif !isdefined('button.type')>
				<cfset button.type = "external"/>
			</cfif>
			<cfif !isdefined('button.icontype')>
				<cfset button.icontype = "fal fa-"/>
			</cfif>
			<cfif bf_e == ii>
				<div class="dropdown-divider"></div>
			</cfif>
			<cfswitch expression="#button.type#">

				<cfcase value="external">

					<a class="<cfif Attributes.group>dropdown-item<cfelse>btn btn-sm</cfif> #Attributes.buttonprefix##button.style#" title="#button.help#" target="_blank" href="#button.url#">
						<cfif button.icon != "">
							<i class="#button.icontype##button.icon# #button.iconCss#"></i>
						</cfif>
						#button.title#
					</a> 

				</cfcase>
				<cfcase value="external2">

					<!--- <a class="<cfif Attributes.group>dropdown-item<cfelse>btn btn-sm</cfif> #Attributes.buttonprefix##button.style#" title="#button.help#" target="_blank" href="#button.url#">
						<cfif button.icon != "">
							<i class="#button.icontype##button.icon# #button.iconCss#"></i>
						</cfif>
						#button.title#
					</a> --->
					<cfset _nurl = replace(button.url,'.','/','all')/>
					<cfset _nurl = replace(_nurl,'~','.cfm?id=')/>
					<a class="<cfif Attributes.group>dropdown-item<cfelse>btn btn-sm</cfif> #Attributes.buttonprefix##button.style#"
						title="#button.help#"
						href="views/#_nurl#"
						target="_blank">
						<cfif button.icon != "">
							<i class="#button.icontype##button.icon# #button.iconCss#"></i>
						</cfif>
						#button.title#
					</a>

				</cfcase>
				<cfcase value="modal">
					<cfset button_opt = ""/>
					<cfif button.backdrop != "static">
						<cfset button_opt = "'backdrop':#button.backdrop#"/>
					</cfif>
					<cfif button.keyboard == true>
						<cfset button_opt = listPrepend(button_opt, "'keyboard':true")/>
					</cfif> 
					<a href="javascript:;" class="<cfif Attributes.group>dropdown-item<cfelse>btn btn-sm</cfif> #Attributes.buttonprefix##button.style#" title="#button.help#"
						onclick="showModal('#button.url#',{'title':'#button.modaltitle#', 'param':'#button.urlparam#','position':'#button.modalPosition#',#button_opt# });">
						<cfif button.icon != "">
							<i class="#button.icontype##button.icon# #button.iconCss#"></i>
						</cfif>
						#button.title#
					</a>

				</cfcase>
				<cfcase value="execute">
					<!---- redirect url --->
					<cfset donefn = "function(){}"/>
					<cfif button.redirectURL != "">
						<cfset _render = ""/>
						<cfif button.renderTo != "">
							<cfset _render = ",'renderTo':'#button.renderTo#'"/>
						</cfif>
						<cfset donefn = "loadPage('#button.redirectURL#',{'param':'#button.redirectURLParam#','forcePageReload':true,'samePage':#button.samePageRedirect#,'changeURL':false#_render#})"/>
					</cfif>

					<cfif trim(button.confirm) == "">

						<a href="javascript:;" id="#button.id#" class="<cfif Attributes.group>dropdown-item<cfelse>btn btn-sm</cfif> #Attributes.buttonprefix##button.style#" title="#button.help#"
						<cfif !button.disabled>
							onclick="ajaxRequest('#button.url#',{'button':this,'param':'#button.urlparam#', donefn:#donefn#});"
						</cfif>>

					<cfelse>

						<a href="javascript:;" id="#button.id#" class="<cfif Attributes.group>dropdown-item<cfelse>btn btn-sm</cfif> #Attributes.buttonprefix##button.style#" title="#button.help#"
						<cfif !button.disabled>
							onclick="if(confirm('#button.confirm#')){ajaxRequest('#button.url#',{'button':this,'param':'#button.urlparam#', donefn:#donefn#});}"
						</cfif>>

					</cfif>

					<cfif button.icon != "">
						<i class="#button.icontype##button.icon# #button.iconCss#"></i>
					</cfif>
					#button.title#

					</a>
				</cfcase>
				<cfcase value="print">
					<cfset _printurl = replace(button.url,'.','/','all')/>
					<cfset _printurl = replace(_printurl,'~','&id=')/>
					<a class="<cfif Attributes.group>dropdown-item<cfelse>btn btn-sm</cfif> #Attributes.buttonprefix##button.style#" href="views/inc/print/print.cfm?page=#_printurl#" title="#button.help#" target="_blank">
						<cfif button.icon != "">
							<i class="#button.icontype##button.icon#"></i>
						</cfif>
						#button.title#
					</a>
				</cfcase>
				<cfcase value="blank">
					<cfset _printurl = replace(button.url,'.','/','all')/>
					<cfset _printurl = replace(_printurl,'~','.cfm?id=')/>
					<a class="<cfif Attributes.group>dropdown-item<cfelse>btn btn-sm</cfif> #Attributes.buttonprefix##button.style#" href="views/#_printurl#" title="#button.help#" target="_blank">
						<cfif button.icon != "">
							<i class="#button.icontype##button.icon#"></i>
						</cfif>
						#button.title#
					</a>
				</cfcase>
				<cfdefaultcase>
					
					<a href="javascript:;" 
						class="<cfif Attributes.group>dropdown-item<cfelse>btn btn-sm</cfif> #Attributes.buttonprefix##button.style#" 
						title="#button.help#" 
						onclick="loadPage('#button.url#',{<cfif button.samePage>'samePage':true,</cfif><cfif !button.changeURL>'changeURL':false,</cfif>'forcePageReload':#button.force#, 'param':'#button.urlparam#' <cfif button.showOnhistoryPane>,'title':'#button.title#'</cfif><cfif button.renderTo != "">,'renderTo':'#button.renderTo#'</cfif>})">
						<cfif button.icon != "">
							<i class="#button.icontype##button.icon#"></i>
						</cfif>
						#button.title#
					</a>

				</cfdefaultcase>

			</cfswitch>

		</cfif>

	</cfloop>

	<cfif Attributes.group>
		</div>
	</cfif>
	</div>

</cfif>
</cfoutput>