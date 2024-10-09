<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">

    <cfparam name="Attributes.TagName" type="string" default="UploadFile"/>
    <cfparam name="Attributes.name" type="string"/>
    <cfparam name="Attributes.value" type="string" default=""/>

    <cfparam name="Attributes.existingFiles" type="query" default="#QueryNew('x')#"/>
    <cfparam name="Attributes.showExistingFiles" type="boolean" default="true"/>
    <cfparam name="Attributes.tag" type="string" default="#Attributes.name#"/>
    <cfparam name="Attributes.display" type="string" default="Click here to upload files"/>

    <!---cfparam name="Attributes.required" type="boolean" default="false"/--->

    <cfparam name="Attributes.label" type="string" default="#Attributes.name#"/>
    <!---cfparam name="Attributes.showPreview" type="boolean" default="true"/--->
    <cfparam name="Attributes.multiple" type="boolean" default="true"/>
    <cfparam name="Attributes.id" type="string" default="#application.fn.GetRandomVariable()#"/>
    <cfparam name="Attributes.modelId" type="numeric"/>
    <cfparam name="Attributes.key" type="numeric"/>
		<cfparam name="uid" default=""/>
		<cfif isdefined("request.user.userid")>
			<cfset uid = request.user.userid/>
		</cfif>
    <cfparam name="Attributes.userid" type="numeric" default="#uid#"/>

    <cfparam name="Attributes.cssStyle" type="string" default=""/>

    <cfparam name="Attributes.onSuccess" type="string" default=""/>

	<cfif Attributes.showExistingFiles>

		<cfif !Attributes.existingFiles.recordcount>

			<cfquery name="Attributes.ExistingFiles">
				SELECT * FROM file
				WHERE `Key` = #Attributes.key# AND modelId = #Attributes.modelId# <cfif Attributes.tag neq "">AND `tag`="#Attributes.tag#"</cfif>
			</cfquery>

		</cfif>

	</cfif>

<cfelse>

	<form id="#Attributes.id#_form" method="post" enctype="multipart/form-data">

		<div>#Attributes.label#</div>
		<div class="dropzone" id="#Attributes.id#" style="#Attributes.cssStyle#"></div>

		<input type="hidden" id="#Attributes.id#q" value="" name="#Attributes.name#">
		<input type="hidden" value="#Attributes.tag#" name="#Attributes.name#_tag">

	</form>

<script>
    $(document).ready(function() {

	    <cfset _dropzone = application.fn.GetRandomVariable()/>

		var #_dropzone# = new Dropzone("###Attributes.id#", {
			url: 'awaf/tags/fileuploader/File.cfc?method=upload&modelId=#Attributes.modelId#&key=#Attributes.key#&userid=#attributes.userid#&tag=#Attributes.tag#',
			addRemoveLinks: true,
			thumbnailWidth:200,
			thumbnailHeight:200,
			dictDefaultMessage: "#Attributes.display#",
			dictRemoveFileConfirmation: "Are you sure you want to delete this file, You will not be able to undo this action"
		});
		#_dropzone#.on("success", function(a,b) {
			var fn = JSON.parse(b).file_name;
			var _hd = $('###Attributes.id#q')[0];
			_hd.value = _hd.value + "|" + fn;

			<!---- run customized script on success --->
			#Attributes.onSuccess#

		});

		#_dropzone#.on("removedfile", function(file) {

			if (typeof file.xhr === 'undefined')	{
				$.ajax({
					url: 'awaf/tags/fileuploader/File.cfc?method=deleteFromServer&file_name='+file.path+'&size='+file.size,
				});
			}
			else 	{
				var fld = JSON.parse(file.xhr.responseText);
				fld = JSON.parse(fld).file_name;

				$.ajax({
					url: 'awaf/tags/fileuploader/File.cfc?method=delete&file_name='+fld,
					success: function( strData ){

						var _hd = $('###Attributes.id#q')[0];
						_hd.value = _hd.value.replace(fld, '');

					}
				});
 			}
		});

	    <!--- create mockfile ---->
	    <cfif Attributes.existingFiles.recordcount>
	    	var mockFile ='';
	    	<cfloop query="Attributes.existingFiles">
				// Create the mock file:
				var mockFile = {path: "#Attributes.existingFiles.file#", name: "#listlast(Attributes.existingFiles.file,'/')#", size: #val(Attributes.existingFiles.size)# };
				#_dropzone#.emit("addedfile", mockFile);
				<cfif isImageExtension(Attributes.existingFiles.file)>
					#_dropzone#.emit("thumbnail", mockFile, "attachment/#Attributes.existingFiles.file#");
				</cfif>
				#_dropzone#.emit("complete", mockFile);
			</cfloop>
	    </cfif>



    });
</script>
<cfscript>
	private string function quotedList(required string lst)	{

		var nlst = '';
		loop list=arguments.lst item='_lt'	{
			nlst = listAppend(nlst, "'" & _lt & "'");
		}

		return nlst;
	}

	private boolean function isImageExtension(required string img)	{

		var x = false;
		switch (listlast(arguments.img,'.'))	{
			case 'jpg': case 'png': case 'gif' : case 'ico':

				x = true;

			break;
		}

		return x;
	}
</cfscript>


</cfif>

</cfoutput>