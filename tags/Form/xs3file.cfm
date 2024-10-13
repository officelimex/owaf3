<cfoutput>

  <cfif ThisTag.ExecutionMode EQ "Start">
  
    <cfparam name="Attributes.TagName" type="string" default="s3File"/>
    <cfparam name="Attributes.name" type="string"/>
    <cfparam name="Attributes.value" type="string" default=""/>
    <cfparam name="Attributes.temporaryLocation" type="boolean" default="true"/>
    <cfparam name="Attributes.existingFiles" type="query" default="#QueryNew('x')#"/>
    <cfparam name="Attributes.tag" type="string" default="#Attributes.name#"/>
    <cfparam name="Attributes.class" type="string" default=""/>
    <cfparam name="Attributes.path" type="string" default=""/>

    <cfif Attributes.tag != "">
      <cfif isQuery(Attributes.existingFiles) && Attributes.existingFiles.recordcount>
        <cfquery name="Attributes.existingFiles" dbtype="query">
          SELECT 
            * 
          FROM Attributes.existingFiles 
          WHERE Tag = <cfqueryparam value="#Attributes.tag#" cfsqltype="cf_sql_varchar"/>
        </cfquery>
      </cfif>
    </cfif>

    <cfparam name="Attributes.required" type="boolean" default="false"/>

    <cfparam name="Attributes.label" type="string" default="Drag & drop files here to upload"/>
    <cfparam name="Attributes.multiple" type="boolean" default="true"/>
    <cfparam name="Attributes.id" type="string" default="#application.fn.GetRandomVariable()#"/>
  
    <cfset ArrayAppend(request.form.s3file, Attributes)/>

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
      url: 'owaf/tags/form/s3File.cfc?method=upload&save_to_temp_first=#attributes.temporaryLocation#',
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
        //console.log(file);
        if(confirm('Are you sure you want to delete ' + file.name + '? You will not be able to undo this action'))	{
          $.ajax({
            url: 'owaf/tags/form/s3File.cfc?method=deleteFromServer&file_name='+file.path+'&path=#Attributes.path#&size='+file.size,
          });
        }
        else 	{
          return false;
        }
      }
      else 	{
        var fld = JSON.parse(file.xhr.responseText);
        fld = JSON.parse(fld).file_name;

        $.ajax({
          url: 'owaf/tags/form/s3File.cfc?method=deleteTemp&file_name='+fld,
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
				<cfloop list="#Attributes.existingFiles.file#" index="i" item="fl" delimiters="|">
					var mockFile = {path: "#fl#", name: "#listlast(fl,'/')#", size: #val(listGetAt(Attributes.existingFiles.size,i,'|'))# };
					#_dropzone#.emit("addedfile", mockFile);
					<cfif isImageExtension(fl)>
						#_dropzone#.emit("thumbnail", mockFile, "attachment/#fl#");
					</cfif>
					#_dropzone#.emit("complete", mockFile);
				</cfloop>
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