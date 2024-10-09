<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">

    <cfparam name="Attributes.TagName" type="string" default="Buttons"/>
    <cfparam name="Attributes.iconprefix" type="string" default="fal fa-"/>
    <cfparam name="Attributes.buttonprefix" type="string" default="btn-"/>
    <cfparam name="Attributes.align" type="string" default="right"/>
    <cfparam name="Attributes.size" type="string" default="btn-group-sm"/> <!--- btn-group-xs --->
    <cfparam name="Attributes.group" type="boolean" default="false"/>
    <cfparam name="Attributes.class" type="string" default=""/>

	<cfset request.buttons = ArrayNew(1)/>

<cfelse>

	<!---- === build for large display ===---->
	<div class="">
		<div class=" text-#Attributes.align# <cfif Attributes.group>btn-group</cfif> #Attributes.size# #Attributes.class#">
			<cfloop array="#request.buttons#" item="attr">
				<cfif attr.isDivider>
					<a class="btn" style="padding:5px;"></a>
				<cfelse>
					<button type="button" class="#attr.id# btn #Attributes.buttonprefix##attr.style# #attr.size# #attr.class#" title="#attr.help#" style="#attr.cssStyle#">
						<cfif attr.icon neq "">
							<cfset it = Attributes.iconprefix/>
							<cfif attr.icontype != "">
								<cfset it = attr.icontype/>
							</cfif>
							<i class="#it##attr.icon#"></i>
						</cfif> #attr.title#
					</button>
					<!---a class="#attr.id# btn #Attributes.buttonprefix##attr.style# #attr.size# #attr.class#" style="#attr.cssStyle#" title="#attr.help#">
						<cfif attr.icon neq ""><i class="#Attributes.iconprefix##attr.icon#"></i></cfif>
						#attr.title#
					</a--->
				</cfif>
			</cfloop>
		</div>
	</div>

	<!---- === build for mobile ===---->
	<!---div class="visible-xs">
		<div class="btn-group #Attributes.size# text-left">
			<button type="button" class="btn btn-info dropdown-toggle" data-toggle="dropdown">
			Action <span class="caret"></span>
			</button>
			<ul class="dropdown-menu" role="menu">
				<cfloop array="#request.buttons#" item="attr">
					<cfif attr.isDivider>
						<li class="divider"></li>
					<cfelse>
						<li>
							<a class="#attr.id# #attr.class#" title="#attr.help#">
								<cfif attr.icon neq "">
									<i class="#Attributes.iconprefix##attr.icon#"></i>
								</cfif>
								<cfif attr.title eq "">
									#attr.help#
								<cfelse>
									#attr.title#
								</cfif>
							</a>
						</li>
					</cfif>
				</cfloop>
			</ul>
		</div>
	</div--->
	<!--- script --->
	<script>
		$(document).ready(function() {
			<cfloop array=#request.buttons# item="x">
				<cfif !x.isDivider>

					<cfset _btn = application.fn.GetRandomVariable()/>
					<cfset _change_url = ",'changeURL':#x.changeURL#"/>
					<cfset _render_to = ""/>
					<cfset _param = ",'param':'#x.urlparam#'"/>
					<cfif x.renderTo neq ''>
						<cfset _render_to = ",'renderTo':'#x.renderTo#'"/>
					</cfif>

					var #_btn# = $('.#x.id#');
									<cfset conf_ = replaceNoCase(x.confirm,"'","\'","all")/>
									<cfif listLen(conf_,"|") gt 1>
										<cfset conf_ = "title:'#listFirst(conf_,'|')#',text:'#listLast(conf_,'|')#'"/>
									<cfelse>
										<cfset conf_ = "title:'#conf_#'"/>
									</cfif>
									<cfif x.confirm == "">
										<cfset conf_ = ""/>
									</cfif>
									<cfset ntitle = replacenocase(x.title,"'","\'","all")/>
	                #_btn#.click(function()    {
	                    <cfif x.url != "">// url

	                    	<cfif conf_ != "">
													
													Swal.fire({
														icon:'question',
														#conf_#,
														confirmButtonText: 'Yes',
														showCancelButton: true
													}).then((result) => {
														if (result.isConfirmed) {

	                    		<!---if(confirm('#nconfirm#'))	{--->
	                    			loadPage('#x.url#',{'forcePageReload':#x.force#,'title':'#ntitle#'#_render_to# #_change_url# #_param#});
	                    		<!---}--->
														}
													});
	                    	<cfelse>
	                    		loadPage('#x.url#',{'forcePageReload':#x.force#,'title':'#ntitle#'#_render_to# #_change_url# #_param#});
	                    	</cfif>

						</cfif>

	                    <cfif x.action != "">// action
	                    	<cfif conf_ != "">
													
													Swal.fire({
														icon:'question',
														#conf_#,
														confirmButtonText: 'Yes',
														showCancelButton: true
													}).then((result) => {
														if (result.isConfirmed) {
														

												</cfif>
		                        $.ajax({
		                            cache: false,
		                            beforeSend:function()   {
		                              #_btn#.addClass('loading disabled');
		                            },
		                            url: 'controllers/#x.action#'
		                        }).done(function(data)  {

		                        	<cfif x.redirectURL != ''>
		                        		<cfset ntitle = replacenocase(x.title,"'","\'","all")/>
		                        		loadPage('#x.redirectURL#',{'forcePageReload':true,'title': '#ntitle#' #_render_to# #_change_url# #_param#});
		                        	</cfif>

		                        	<cfif x.flashMessage != ''>
										<cfset x.flashMessage = replace(x.flashMessage,"'","\'",'all')/>
		                        		<cfset msg_str = application.fn.GetRandomVariable()/>
		                        		#msg_str#="#x.flashMessage#";
		                        		#msg_str# = #msg_str#.replaceAll('[[MSG]]',data);
		                        		itemSaveNotice(#msg_str#);
		                        	</cfif>

		                        }).fail(function(xhr)  {
		                            showError(xhr);
		                            //console.log(xhr);
		                        }).always(function(data) {
		                            #_btn#.removeClass('loading disabled');
		                        });
								<cfif x.closeModal>
									$('##__app_modal').modal('hide');
								</cfif>
	                    	<cfif conf_ != "">
												}
											});
							</cfif>
	                    </cfif>
	                    <cfif x.printurl neq "">
	                    	<cfparam name="application.awaf.staff_client" default="false" type="boolean">
	                    	<cfif application.awaf.staff_client>
	                    		window.open('#application.site.url#views/inc/print/print.cfm?page=#lcase(request.user.usertype)#/#x.printurl#&&#x.urlparam#');
	                    	<cfelse>
	                    		window.open('views/inc/print/print.cfm?page=#x.printurl#&#x.urlparam#');
	                    	</cfif>
	                    	return false;
	                    </cfif>
	                    <cfif x.blankpageurl neq "">
	                    	window.open('views/#x.blankpageurl#.cfm');
	                    	return false;
	                    </cfif>
	                    <cfif x.modalurl neq "">// model url
												<cfset ntitle = replacenocase(x.modaltitle,"'","\'","all")/>
												
	                    	showModal('#x.modalurl#',{'title':'#ntitle#' #_param# #_render_to# <cfif x.modalPosition != "">,'position':'#x.modalPosition#'</cfif>});
	                    </cfif>
	                });
				</cfif>
			</cfloop>
		});
	</script>

</cfif>
</cfoutput>