<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">

    <cfparam name="Attributes.TagName" type="string" default="File"/>
    <cfparam name="Attributes.name" type="string"/>
    <cfparam name="Attributes.value" type="string" default=""/>
    <cfparam name="Attributes.temporaryLocation" type="boolean" default="true"/>
    <cfparam name="Attributes.existingFiles" type="query" default="#QueryNew('x')#"/>
    <cfparam name="Attributes.existingFilePath" type="string" default=""/>
    
		<cfparam name="Attributes.tag" type="string" default="#Attributes.name#"/>
    <cfparam name="Attributes.class" type="string" default=""/>

    <cfparam name="Attributes.required" type="boolean" default="false"/>

    <cfparam name="Attributes.label" type="string" default="Drag & drop files here to upload"/>
    <!---cfparam name="Attributes.showPreview" type="boolean" default="true"/--->
    <cfparam name="Attributes.multiple" type="boolean" default="true"/>
    <cfparam name="Attributes.id" type="string" default="#application.fn.GetRandomVariable()#"/>

	<cfset ArrayAppend(request.form.file, Attributes)/>

	<cfset cf_xform = getBaseTagData("cf_xform").Attributes/>

<cfelse>

	<div class="pad-top-10">

		<div class="dropzone #Attributes.class#" id="#Attributes.id#">

		</div>

		<input type="hidden" id="#Attributes.id#q" <cfif Attributes.required>required</cfif> value="" name="#Attributes.name#" >
		<input type="hidden" value="#Attributes.tag#" name="#Attributes.name#_tag" >

	</div>
<!---- script --->
<script>
    $(document).ready(function() {

		<cfset _dropzone = application.fn.GetRandomVariable()/>

		var #_dropzone# = new Dropzone("###Attributes.id#", {
			url: 'owaf/tags/form/File.cfc?method=upload&save_to_temp_first=#attributes.temporaryLocation#',
			addRemoveLinks: true,
			thumbnailWidth:200,
			thumbnailHeight:200,
			dictDefaultMessage: "#Attributes.label#"
		});
		#_dropzone#.on("success", function(a,b) {
			//console.log(b);
			var fn = JSON.parse(b).file_name;
			var _hd = $('###Attributes.id#q')[0];
			_hd.value = _hd.value + "|" + fn;
		});

		#_dropzone#.on("removedfile", function(file) {

			if (typeof file.xhr === 'undefined')	{
				// remove file already on the server
				if(confirm('Are you sure you want to delete ' + file.name + '? You will not be able to undo this action'))	{
					$.ajax({
						url: 'owaf/tags/form/File.cfc?method=deleteFromServer&file_name='+file.path+'&size='+file.size,
					});
				}
				else 	{
					return false;
				}
			}
			else 	{
				var fld = JSON.parse(file.xhr.responseText) ;
				fld = JSON.parse(fld).file_name;

				$.ajax({
					url: 'owaf/tags/form/File.cfc?method=delete&file_name='+fld,
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
					#_dropzone#.emit("thumbnail", mockFile, "#Attributes.existingFilePath#/#Attributes.existingFiles.file#");
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