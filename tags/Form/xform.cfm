<cfoutput>
	<cfif thisTag.ExecutionMode == 'start'>

		<cfparam name="Attributes.TagName" type="string" default="Form"/>
		<cfparam name="Attributes.current_url" type="string" default="#url.current_page_url#"/>
		<cfparam name="Attributes.action" type="string" default=""/>
		<cfparam name="Attributes.useplaceholder" type="boolean" default="false"/>
		<cfparam name="Attributes.id" type="string" default="#application.fn.GetRandomVariable()#"/>
		<cfparam name="Attributes.alertPages" type="string" default=""/><!--- use this to display alert when data has changes --->
		<cfparam name="Attributes.containnerid" type="string" default="app_content"/>
		<cfparam name="Attributes.class" type="string" default=""/>

		<cfparam name="Attributes.target" type="string" default="_blank"/>

		<cfset request.form.input = ArrayNew(1)/>
		<cfset request.form.cfield = ArrayNew(1)/>
		<cfset request.form.textarea = ArrayNew(1)/>
		<cfset request.form.button = ArrayNew(1)/>
		<cfset request.form.submit = ArrayNew(1)/>
		<cfset request.form.radio = ArrayNew(1)/>
		<cfset request.form.check = ArrayNew(1)/>
		<cfset request.form.select = ArrayNew(1)/>
		<cfset request.form.select2 = ArrayNew(1)/>
		<cfset request.form.tag = ArrayNew(1)/>
		<cfset request.form.datePicker = ArrayNew(1)/>
		<cfset request.form.time = ArrayNew(1)/>
		<cfset request.form.file = ArrayNew(1)/>
		<cfset request.form.s3file = ArrayNew(1)/>

		<form target="#attributes.target#" id="#Attributes.id#" method="post" enctype="multipart/form-data" action="#Attributes.action#" class="#Attributes.class#">

	<cfelse>

		</form>

		<script type="text/javascript">
			$(document).ready(function() {

				// form id
				<cfset formId = application.fn.GetRandomVariable()/>
				#formId# = $('###Attributes.id#');
				<cfif arraylen(request.form.radio) || arraylen(request.form.check)>
					$('###Attributes.id# input.icheck').iCheck({checkboxClass: 'icheckbox_square', radioClass: 'iradio_square'});
				</cfif>
				
				<cfset isrange = false/>
				<cfloop array="#request.form.input#" item="mn">

					<!--- for mask --->
					<cfif isDefined("mn.type") && mn.type == "mask">
						$("###mn.id#").mask("#mn.format#", {placeholder: "#mn.placeholder#"});
					</cfif>
					<cfif isDefined("mn.type") && mn.type == "money">
						<cfset isrange = true/> <!--- TODO: fix issue with range --->
						$("###Attributes.id# input.tag-xmoney").on({
							keyup: function() {
								this.value = numberWithCommas($(this).val());
							}
						});
						<!---<cfbreak>--->
					</cfif>
					<cfif isDefined("mn.type") && left(mn.Type,5) == "range">						
						<!---<cfset isRange = true/>--->
						$("###mn.Id#.js-range-slider").ionRangeSlider({
							<cfswitch expression="#mn.range#">
								<cfcase value="minutes">
									values: ["10m","20m","30m","40m","50m","1h","1h 10m","1h 20m", "1h 30m"]	
								</cfcase>
							</cfswitch>
						});
					</cfif>
				</cfloop>
				
				<!---
				<cfif isrange>
					$(".js-range-slider").ionRangeSlider({
						values: ["10m","20m","30m","40m","50m","1h","1h 10m","1h 20m", "1h 30m"]	
					}					
					);
				</cfif>
				--->

				<cfset date_picker_len = request.form.datePicker.len()/>

				// confirmation


				// start validation
				#formId#.validate({
					onsubmit: true,
					debug: true,
					rules: {
						<cfset i = 0/>
						<cfloop array="#request.form.datePicker#" item="attr">
							<cfset i++/>
							'#attr.name#': {
								required: #attr.required#,
								date: true
							} <cfif i is not date_picker_len>,</cfif>
						</cfloop>
					},
					errorPlacement: function(error, element)  {
						//console.log(error);
						if (element.is("input.addon"))    {
							error.appendTo(element.parent().parent());
						}
						else if(element.is(".icheck"))   {
							error.appendTo(element.parent().parent().parent());
						}
						else    {
							error.appendTo(element.parent());
						}

					},

					submitHandler: function(e) {

						<cfset thisForm = application.fn.GetRandomVariable()/>
						<cfset sel_button = application.fn.GetRandomVariable()/>
						<cfset clearform = application.fn.GetRandomVariable()/>
						<cfset flashmsg = application.fn.GetRandomVariable()/>
						<cfset rdi = application.fn.GetRandomVariable()/>
						<cfset rdi_type = application.fn.GetRandomVariable()/>
						<cfset rdi_param = application.fn.GetRandomVariable()/>
						<cfset confirm = application.fn.GetRandomVariable()/>
						<cfset rdi_target = application.fn.GetRandomVariable()/>
						<cfset submit_buttons = application.fn.GetRandomVariable()/>
						<cfset cls_modal_as = application.fn.GetRandomVariable()/>

						var #thisForm# = $(e);
						var #sel_button# = $('###Attributes.id# ##'+#thisForm#.attr('button-submitted'));
						var #clearform# = #sel_button#.attr('clear-form');
						var #flashmsg# = #sel_button#.attr('flash-msg');
						var #rdi# = #sel_button#.attr('redirect-url');
						var #rdi_param# = #sel_button#.attr('redirect-param');
						var #confirm# = #sel_button#.attr('confirm');
						var #cls_modal_as# = #sel_button#.attr('close-modal-after-save');
						var #rdi_target# = #sel_button#.attr('redirect-target');
						var #rdi_type# = #sel_button#.attr('redirect-type');
						if (#rdi_type# == 'modal') {
							<cfset modal_pos = application.fn.GetRandomVariable()/>
							<cfset modal_title = application.fn.GetRandomVariable()/>
							var #modal_title# = #sel_button#.attr('modal-title');
							var #modal_pos# = #sel_button#.attr('modal-position');
						}

						// get all buttons on the form
						#submit_buttons# = $('###Attributes.id# button[type="submit"]');

						<cfset cur_funct = application.fn.GetRandomVariable()/>
						var #cur_funct# = function() {
							$.ajax({
								cache: false,
								beforeSend:function()   {

									#submit_buttons#.prop("disabled", true);
									#submit_buttons#.addClass('disabled');
									#sel_button#.addClass('is-loading');

								},
								url: #formId#.attr('action'),
								type: 'POST',
								data: #formId#.serialize()
							}).done(function(data)  {

								try{
									data = $.parseJSON(data);
								} catch (exception) {
									if (typeof data.KEY === 'undefined') {
										data.KEY = 'ID';
										data.ID = 0;
									}
								}
								if(#flashmsg# != '')    {
									<!---if(#flashmsg#.search("{{") > 0)	{
										#flashmsg# = #flashmsg#.replaceAll("{{", '')
										#flashmsg# = #flashmsg#.replaceAll("}}", "")
									}--->
									///console.log(#flashmsg#)
									itemCreatedNotice(#flashmsg#);// + '. ID: ' + data[data.KEY]);
								}
								<!---cfif Attributes.FlashMessage != "">
									<cfif FindNocase("{{", Attributes.FlashMessage)>
										var d = $.parseJSON(d);
										<cfset Attributes.FlashMessage = replaceNocase(Attributes.FlashMessage, "{{", "' + d.")/>
										<cfset Attributes.FlashMessage = replaceNocase(Attributes.FlashMessage, "}}", "+'")/>
									</cfif>
									itemCreatedNotice('#Attributes.FlashMessage#');
								</cfif--->
								//console.log(data[data['KEY']]);
								// determine what to do from the button clicked
								if(#clearform#=='true')   {
									#thisForm#[0].reset();
									<cfloop array="#request.form.select2#" item="x" index="i">
										$("###Attributes.id# ###x.id#").select2("val", "");
									</cfloop>
								}
								//alert(#rdi#);
								if(#rdi#!='')   {
									<cfset curl = replace(Attributes.current_url,'.','_','all')/>
									<cfset curl = replace(curl,'@','_')/>

									if (data != undefined) {
										<!----:TODO fix bug herer ---->
										#rdi# = #rdi#.replace('@key','@'+data['KEY']);
									}
									if(#rdi_target#!="") 	{
										
										<!--- implement target page ---->
										if($('##' + #rdi_target#).length>0)	{
											loadPage(#rdi#, {'forcePageReload':true, 'changeURL': false, 'renderTo': #rdi_target#, 'param': #rdi_param#+'&target='+#rdi_target#});
										}
										else 	{
											console.log('Warning: target element id #rdi_target# does not exist');
										}
									}
									else 	{
										if(#rdi_type# == 'modal')	{
											showModal(#rdi#, {'position': #modal_pos#, 'title': #modal_title#, 'param': #rdi_param#})
										}
										else if(#rdi_type# == 'external')	{
											window.location.replace(#rdi#);  
										}
										else {
											loadPage(#rdi#, {'forcePageReload':true, 'param':'target='+#rdi_target#});
										}
									}
									//$('###curl#').remove();
								// find all open app_page using this data and display a notice message
								}
								<!--- cfset id_ = ''/>
								<cfloop list="#attributes.alertPages#" item="id">
									<cfset id_ = listAppend(id_,"[id*='#id#']")/>
								</cfloop>
								//$('###attributes.containnerid#').find("#id_#").prepend("hi");--->
								if (typeof #cls_modal_as# !== 'undefined') {
									if(#cls_modal_as# == 'true')    {
										$('##__app_modal').modal('hide');
									}
								}

							}).fail(function(xhr)  {

								showError(xhr);

							}).always(function(data) {

								#submit_buttons#.prop("disabled", false);
								#submit_buttons#.removeClass('disabled is-loading');

							});

						}


						if(#confirm# == '')	{
							#cur_funct#();
						}
						else {
							if(confirm(#confirm#))	{
								#cur_funct#();
							}
						}

					}

				});

				<cfloop array="#request.form.submit#" item="x" index="i">
					$('###x.id#').click(function()    {
						#formId#.attr('action','controllers/#x.url#');
						// add something to the form to know the button that was clicked
						#formId#.attr('button-submitted','#x.id#');
						// redirect
						#formId#.attr('redirect-url','#x.redirectURL#');
					});
				</cfloop>

				<cfloop array="#request.form.tag#" item="x" index="i">
					$("###Attributes.id# ###x.id#").select2({
						<cfset _c = replace(x.value,',','","','all')/>
						tags:["#_c#"],
						tokenSeparators: [","]
						<cfif x.maximumSelectionSize>
							,maximumSelectionSize: #x.maximumSelectionSize#
						</cfif>
					});
				</cfloop>

				<cfloop array="#request.form.select2#" item="x" index="i">
					$("###Attributes.id# ###x.id#").select2({
						placeholder: '#x.placeholder#',
						<cfif !x.URL.isempty()>
							initSelection : function (element, callback) {
								var vl = element.val().split(":");
								var data = {id: vl[0], text: vl[1]}; 
						/* 		if(vl.length > 2)	{
									var vl = element.val().split("#x.delimiters#");
									var data = []
									for (var _i = 0; _i < vl.length; _i++) {
										var _vl = vl[_i].split(":");
										data.push({id: _vl[0], text: _vl[1]});
									}
								} */
								/* var _ids = vl[0].split("#x.delimiters#");
								if (typeof vl[1] === 'undefined')	{
									vl[1] = vl[0];
								} */
								/* var _texts = vl[1].split("#x.delimiters#"); */

								//console.log(data);
								//var data = {id: vl[0], text: vl[1]}; 
								callback(data);
							},
							<cfif x.multiple>
								multiple:true,
							</cfif>
							<cfif x.Tagging>
								tokenSeparators: [","," "],
								createSearchChoice: function(term, data) {
									if ($(data).filter(function() {return this.text.localeCompare(term) === 0;}).length === 0) { return {id: term,text: term};}
								},
							</cfif>
							minimumInputLength: 1,
							ajax: {dataType: "json",
								url: "controllers/#x.URL#",
								data: function (term, page) {  return {q: term, page_limit: 10,page: page};},
								results: function (data) {return {results: data};}
							}
						</cfif>
					});
				</cfloop>

				<cfif date_picker_len>
					<!---$('###Attributes.id# .datePicker').datePicker();--->
					<!---$("###Attributes.id# .datePicker").flatpickr();--->
				</cfif>

			});
		</script>

	</cfif>

</cfoutput>