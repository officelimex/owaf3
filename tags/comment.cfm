<cfoutput>

	<cfinclude  template="tag_func.cfm">

	<cfif ThisTag.ExecutionMode == "Start">

		<cfparam name="Attributes.TagName" type="string" default="comment"/>
		<cfparam name="Attributes.modelid" type="numeric"/>
		<cfparam name="Attributes.order" type="string" default="asc"/><!--- asc, desc ---->
		<cfparam name="Attributes.tenantid" type="numeric" default="0"/>
		<cfparam name="Attributes.key" type="numeric"/>
		<cfparam name="Attributes.title" type="string" default="Comments"/>
		<cfparam name="Attributes.redirectURL" type="string" default="#url.current_page_url#"/>
		<cfparam name="Attributes.notificationURL" type="string" default="#Attributes.redirectURL#"/>
		
		<cfparam name="Attributes.redirectToModal" type="boolean" default="false"/>
		<cfparam name="Attributes.modalPosition" type="string" default=""/>
		<cfparam name="Attributes.modalTitle" type="string" default=""/>

		<cfif isDefined("request.user.tenantid")>
			<cfif request.user.tenantid == 12>
				<cfparam name="Attributes.duration" default="60"/>
			<cfelse>
				<cfparam name="Attributes.duration"  default="3"/>
			</cfif>
		</cfif>
		
		<cfparam name="Attributes.copy" type="string" default=""/>
		<cfparam name="Attributes.showCopy" type="boolean" default="false"/>
		<cfparam name="Attributes.showReply" type="boolean" default="true"/>
		<cfparam name="Attributes.commentRequired" type="boolean" default="true"/>
		<cfparam name="Attributes.subject" type="string"/>
		<cfparam name="Attributes.avatarImageSize" type="string" default="40px"/>
		<cfparam name="Attributes.avatarClass" type="string" default=""/>
		<cfparam name="Attributes.postURL" type="string" default="plugin/comment.cfc?method=Post"/>
		<cfparam name="Attributes.buttonSize" type="string" default=""/>
		<cfparam name="Attributes.closed" type="boolean" default="false"/>
		<cfparam name="Attributes.AllowAttachment" type="boolean" default="true"/> <!--- allow attachment --->
		<cfparam name="Attributes.ContentSuffix" type="string" default=""/> <!--- this content will show at the end of the mail --->
		
		<cfparam name="Attributes.anonymous" type="boolean" default="false"/>

		<cfparam name="Attributes.editable" type="boolean" default="true"/>
		<cfparam name="Attributes.canCommentRoleIds" type="string" default=""/> <!--- who should be able to make comment --->

		<cfparam name="Attributes.project" type="string"/><!--- this use to know where the modal is in your project where u are making use of the modal --->
		<!--- subject of the mater --- e.g. Quote 1231 --->
		<!--- TODO - escape special character --->

		<cfset Attributes.modalTitle = application.fn.excapeJsStr(Attributes.modalTitle)/>

		<cfset UseS3 = false/>
		<cfif isDefined("application.s3.url")>
			<cfset UseS3 = true/>
		</cfif>

		<cfparam name="Attributes.sendMail" type="boolean" default="true"/>
		<cfif Attributes.sendMail>
			<cfparam name="Attributes.to" type="string" default/><!--- who to send the comment to --->
		</cfif>

		<cfset objCmt = createObject('component','#Attributes.project#.models.plugin.Comment').init()/><!---.buildRelationships()/>--->
		<!---cfset comments = objCmt.findParentComment(Attributes.key, Attributes.modelId, Attributes.order)/--->

		<cfif Attributes.title != "">
			<h3 class="mb-4"><i class="fal fa-comments"></i> #Attributes.title#</h3>
		</cfif>

		<cfparam name="Attributes.pageid" type="string" default="#application.fn.GetRandomVariable()#"/>

		<cfset comments = objCmt.findAllComment(Attributes.key, Attributes.modelid, Attributes.order, request.user.tenant.id)/>
		<div id="#Attributes.pageid#">
			<cfinclude template="comment/inc_view.cfm">
		</div>

			<!--- post your comment --->
			<cfset submit_btn = application.fn.GetRandomVariable()/>
			<cfset submit_button = application.fn.GetRandomVariable()/>
			<cfif Attributes.CanCommentRoleIds != "">
				<cfset _comment_closed = true/>
				<cfloop list="#Attributes.CanCommentRoleIds#" item="rid">
					<cfif listFindNoCase(request.user.RoleIds, rid)>
						<cfset _comment_closed = false/>
					</cfif>
				</cfloop>
				
				<cfset  attributes.closed = _comment_closed/>
			</cfif>
			<cfif !attributes.closed>
				<div class="row align-items-start">
					<div class="col-auto">
						<div class="avatar #Attributes.avatarClass#">
							<cfif attributes.anonymous>
								<img src="assets/img/profile.png" alt="..." class="avatar-img rounded-circle">
							<cfelse>
								<img src="#application.s3.url#pub/#request.user.tenantid#/passport/#request.user.Picture#" alt="..." class="avatar-img rounded-circle">
							</cfif>
						</div>
					</div>
					<div class="col ml--2">
						<cfset form_id = application.fn.getRandomVariable()/>
						<!---<form id="#form_id#"  action="controllers/#attributes.postURL#" enctype="multipart/form-data" method="post">--->
						<form id="#form_id#" enctype="multipart/form-data" method="post">
							<input type="hidden" name="Key" value="#Attributes.Key#"/>
							<input type="hidden" name="redirectURL" value="#Attributes.redirectURL#"/>
							<input type="hidden" name="notificationURL" value="#Attributes.notificationURL#"/>
							<input type="hidden" name="ModelId" value="#Attributes.ModelId#"/>
							<input type="hidden" name="PostedByUserId" value="#request.user.userid#"/>
							<input type="hidden" name="Subject" value="#attributes.subject#"/>
							<input type="hidden" name="TenantId" value="#request.user.tenantid#"/>
							<input type="hidden" name="ContentSuffix" value="#Attributes.ContentSuffix#"/>

							<cfif Attributes.sendMail>
								<input type="hidden" name="to" value="#attributes.to#"/>
								<input type="hidden" name="Copy" value="#attributes.copy#" default=""/>
							</cfif>
							<cfif Attributes.showcopy>
								<input type="hidden" name="cc" class="form-control" style="margin-top:5px;" value="#Attributes.copy#"/>
							</cfif>

							<cfif attributes.AllowAttachment>
								<label class="sr-only">Leave a comment...</label>
								<textarea style="border-bottom-right-radius: 0;border-bottom-left-radius: 0;" class="form-control tag-comment" placeholder="Leave a comment" <cfif attributes.commentrequired> required </cfif> name="comment" rows="2"></textarea>
								<div class="input-group">
									<div class="custom-file">
										<input type="file" class="custom-file-input" multiple name="docs" id="#form_id#1">
										<label class="custom-file-label" for="#form_id#1">Choose file</label>
									</div>
									<div class="input-group-append">
										<button class="btn btn-info btn-sm" style="border-top-right-radius: 0;" type="submit" id="#submit_btn#"><i class="fal fa-comment"></i> Post</button>
									</div>
								</div>
								<input type="hidden" name="comment_file_path" value="#application.owaf.attachmentpath#comment/"/>
							<cfelse>
								<label class="sr-only">Leave a comment...</label>
								<textarea class="form-control tag-comment" placeholder="Leave a comment" required name="comment" rows="2"></textarea>
								<div class="text-right mt-2">
									<button class="btn btn-outline-secondary btn-sm" type="submit" id="#submit_btn#"><i class="fal fa-comment"></i> Post Comment</button>
								</div>
							</cfif>
							<cfif !Attributes.closed>
								<div class="small text-muted text-center " style="color:purple !important;">Click [Post] to save your comment</div>
							</cfif>
						</form>
					</div>
				</div>

				<!--- // get user email // --->
				<cfscript>
					public string function getActiveStaffEmail()	{

						local.rt = createobject('component','#Attributes.project#.models.' & application.model.EMPLOYEE).init().getActiveStaffEmail()

						return local.rt
					}
				</cfscript>

				<script type="text/javascript">

					$(document).ready(function() {

						// Add the following code if you want the name of the file appear on select
						$(".custom-file-input").on("change", function() {
							var fileName = $(this).val().split("\\").pop();
							$(this).siblings(".custom-file-label").addClass("selected").html(fileName);
						});

						<cfset formid = "$('###form_id#')"/>

						<cfset cmt = "$('###form_id# textarea[name=comment]')"/>

						<cfif attributes.showcopy>
							<cfset cc = "$('###form_id# input[name=cc]')"/>
							#cc#.select2({
								tags:[
									#getActiveStaffEmail()#
								],
								placeholder: "CC: (email addresses)",
								allowClear: true
							});
						</cfif>


						#formid#.validate({

							submitHandler: function(e) {
								var #submit_button# = $('###submit_btn#');
								#submit_button#.addClass('disabled loading');
								#submit_button#.prop('disabled', true);

								var fileSelect = $('###form_id# input[name=docs]')[0];
								var data_ = new FormData(#formid#[0]);

								if(fileSelect != null)	{
									var files = fileSelect.files;
									
									// Loop through each of the selected files.
									for (var i = 0; i < files.length; i++) {
										var file = files[i];

										// Add the file to the request.
										data_.append('docs', file);
									}
									
								}

								var xhr = new XMLHttpRequest();

								xhr.open('POST', 'controllers/#attributes.PostURL#', true);

								// Set up a handler for when the request finishes.
								xhr.onload = function () {
									#submit_button#.addClass('disabled loading');
									#submit_button#.prop('disabled', true);

									if (xhr.status === 200) {
										var v = JSON.parse(xhr.response);	
										if(#attributes.redirectToModal#)	{
											showModal('#Attributes.redirectURL#', {title : '#attributes.modalTitle#', position : '#attributes.modalPosition#'});
										}
										else {
											//loadPage('#Attributes.redirectURL#', {'forcePageReload':true, 'scrollTo': v.CommentId});
											loadPage('plugin.comment.view', {
												'param' 					: 'pageid=#Attributes.pageid#&key=#Attributes.key#&modelid=#Attributes.modelid#&order=#Attributes.order#&anonymous=#attributes.anonymous#&editable=#attributes.editable#&redirectURL=#attributes.redirectURL#',
												'samePage'				: true,
												'changeURL'				: false,
												'forcePageReload'	: true,
												'scrollTo'				: v.CommentId,
												'renderTo'				: '#Attributes.pageid#'
											});
											#submit_button#.removeClass('disabled loading');
											#submit_button#.prop('disabled', false);
											document.getElementById("#form_id#").reset();
										}
									}
									else {
										showError(xhr);
										#submit_button#.removeClass('disabled loading');
										#submit_button#.prop('disabled', false);
									}
								};

								xhr.send(data_);

		          }
						});
					});
				</script>
				</form>
			</cfif>

		<style>.tag-comment{width: 100%}</style>
		<script type="text/javascript">
		$(document).ready(function(){
		    autosize($('.tag-comment'));
		});
		</script>
	</cfif>


</cfoutput>
