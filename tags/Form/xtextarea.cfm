<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">

    <cfparam name="Attributes.tagName" type="string" default="Textarea"/>
    <cfparam name="Attributes.required" type="boolean" default="false"/>
    <cfparam name="Attributes.name" type="string"/>
    <cfparam name="Attributes.value" type="string" default=""/>
    <cfparam name="Attributes.help" type="string" default=""/>
    <cfparam name="Attributes.label" type="string" default="#Attributes.name#"/>
		<cfparam name="Attributes.size" type="string" default="col-sm-6"/>

    <cfparam name="Attributes.labelCol" type="string" default=""/>
		<cfparam name="Attributes.valueCol" type="string" default=""/>

    <cfparam name="Attributes.id" type="string" default="#application.fn.GetRandomVariable()#"/>
    <cfparam name="Attributes.rows" type="numeric" default="3"/>
    <cfparam name="Attributes.style" type="string" default=""/>
    <cfparam name="Attributes.readonly" type="boolean" default="false"/>
    <cfparam name="Attributes.editor" type="string" default="suneditor"/> <!--- suneditor,tinymce,ckeditor --->
    <cfparam name="Attributes.html" type="boolean" default="false"/>
    <cfparam name="Attributes.placeholder" type="string" default=""/>
    <cfparam name="Attributes.hideLabel" type="boolean" default="false"/>
    <cfparam name="Attributes.length" type="numeric" default="0"/>
    <cfparam name="Attributes.stripTags" type="array" default='#["p","ul","li","ol","div","blockquote","u","i","strong","img","em","a","table","tr","td","th","tbody","thead"]#'/>

    <cfparam name="Attributes.format" type="string" default="full"/>

		<cfif Attributes.html>
			<cfset Attributes.value = trim(Attributes.value)/>
			<cfset Attributes.value = replaceNoCase(Attributes.value, chr(10), '','all')/>
			<cfset Attributes.value = replaceNoCase(Attributes.value, chr(13), '','all')/>
			<cfset Attributes.value = replaceNoCase(Attributes.value, chr(9), '','all')/>
		</cfif>

	<cfset ArrayAppend(request.form.textarea,Attributes)/>

	<cfset cf_xform = getBaseTagData("cf_xform").Attributes/>

	<cftry>

		<cfset cf_row = getBaseTagData("cf_frow").ATTRIBUTES.TagName/>
		<cfcatch type="any">
			<cfset cf_row = ""/>
		</cfcatch>

	</cftry>


<cfelse>

	<cfif cf_row eq "">
		<div class="form-group <cfif attributes.labelCol != ''>row align-items-top</cfif>">
	<cfelse>
		<div class="#Attributes.size# pad-top-10">
	</cfif>

		<cfif !Attributes.hideLabel>
			<cfif !cf_xform.useplaceholder>
				<label class="#attributes.labelCol#" for="#Attributes.id#">#Attributes.label#<cfif Attributes.required> <sup class="text-danger">●</sup></cfif> </label>
			</cfif>
		</cfif>

		<cfif attributes.editor == "quill">
			<input type="hidden" name="#Attributes.name#" id="#Attributes.id#_holder"/>
		</cfif>
		<div class="#Attributes.id# #attributes.valueCol#" <cfif attributes.editor == "quill">id="#Attributes.id#"</cfif>>
			<cfif attributes.editor == "quill">
				#attributes.value#
			<cfelse>
				<textarea
					<cfif val(Attributes.length)>maxlength="#Attributes.length#"</cfif>
					<cfif cf_xform.useplaceholder>
						placeholder="#Attributes.label#"
					<cfelse>
						<cfif Attributes.placeholder != "">
							placeholder="#Attributes.placeholder#"
						</cfif>
					</cfif>
					<cfif Attributes.style neq "">style="#Attributes.style#"</cfif>
					class="form-control" rows="#Attributes.rows#" name="#Attributes.name#" id="#Attributes.id#"
					<cfif Attributes.required> required </cfif>
				>#attributes.value#</textarea>
			</cfif>
		</div>

			<cfif Attributes.help != "">
				<cfif attributes.labelCol == "">
					<small class="form-text text-muted">#Attributes.help#</small>
				<cfelse>
					<div class="#attributes.labelCol#"></div>
					<div class="#attributes.valueCol#"><small class="form-text text-muted">#Attributes.help#</small></div>
				</cfif>
			</cfif>

	<cfif cf_row eq "">
		</div>
	<cfelse>
		</div>
	</cfif>

	<cfif Attributes.html>
		<cfswitch expression="#Attributes.editor#">
			
			<cfcase value="suneditor">
				<cfset allowed_tags = serialize(Attributes.stripTags)/>
				
				<script>
					$(function() {
						const { stripHtml } = stringStripHtml;
						editor_#Attributes.id# = SUNEDITOR.create((document.getElementById('#Attributes.id#') || '#Attributes.id#'),{
							width : '100%',
							resizingBar : true,
							stickyToolbar:'50px',
							
							<cfif attributes.length>
								maxCharCount : #attributes.length#,
								charCounter : true,
							</cfif>

							height: '#Attributes.rows*15#px',
							<cfif attributes.format == "full">
								buttonList: [
									['formatBlock',  'blockquote','bold', 'underline', 'italic','removeFormat','outdent', 'indent','align', 'list','table', 'link', 'image', 'codeView', 'preview']
								]	
							<cfelseif attributes.format == "basic">
								buttonList: [
									['bold', 'underline', 'italic','removeFormat','outdent', 'indent','align', 'list','link','codeView']
								]						
							</cfif>

						});
<!---
						editor_#Attributes.id#.onChange = (c, core) => {
							<cfif Attributes.stripTags.len()>
								//var _data = removeTags(c, [#allowed_tags#])
								var _data = stripHtml(c, {ignoreTags: #allowed_tags#}).result;
								editor_#Attributes.id#.setContents(_data);
								//document.getElementById('#Attributes.id#').value = _data; 
							<cfelse>
								//document.getElementById('#Attributes.id#').value = c; 
								editor_#Attributes.id#.setContents(_data);
							</cfif>
						}
						---->
<!---
						editor_#Attributes.id#.onBlur = (c, core) => {
							<cfif Attributes.stripTags.len()>
								var _data = stripHtml(editor_#Attributes.id#.getContents(), {ignoreTags: #allowed_tags#}).result;
								editor_#Attributes.id#.setContents(_data);
							<cfelse>
								editor_#Attributes.id#.setContents(editor_#Attributes.id#.getContents());
							</cfif>
							document.getElementById('#Attributes.id#').value = editor_#Attributes.id#.getContents();
						}
						--->
						$(window).click(function() {
						const { stripHtml } = stringStripHtml;

							if (document.body.contains(document.getElementById("#Attributes.id#")))	{
								<cfif Attributes.stripTags.len()>
									document.getElementById('#Attributes.id#').value = stripHtml(editor_#Attributes.id#.getContents(), {ignoreTags: #allowed_tags#}).result;
								<cfelse>
									document.getElementById('#Attributes.id#').value = editor_#Attributes.id#.getContents();
								</cfif>
							}
						});
					});
				</script>	
			</cfcase> 
		</cfswitch>

	</cfif>
</cfif>
</cfoutput>