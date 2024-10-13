component output="false" extends="officelimex.owaf.com.Controller"  {

  remote string function upload() returntypeformat="json"	{

		var path_to_save = '';
		var file_path = '';			// dynamic file path to place the file
		var error = '';				// error to report to the client
		var uploaded_file_list = '';// list of uploaded files to return to the client

		lock timeout='60' name='file-upload' throwontimeout='true' type='exclusive'	{

			file_path = "#randRange(100,999)#/"
			path_to_save = "#application.site.dir#attachment/temp/" & file_path

			if(!directoryExists(path_to_save))	{
				directory action="create" directory=path_to_save;
			}

			try {
				file action="upload" destination=path_to_save;
			}
			catch(any exception) {
				error = exception.message;
			}

		}
		if(error neq '')	{
			return '{"error" : ' & serializeJSON(error) & '}';
		}
		else 	{
			return '{"file_name": #serializeJSON(file_path & cffile.serverfile)#}';
		}
	}

	remote void function deleteTemp(required string file_name) returntypeformat="json"	{

		lock timeout='60' name='file-upload' throwontimeout='true' type='exclusive'	{
			// check if file exist
			var file_to_delete = "#application.site.dir#attachment/temp/#file_name#"
			if(fileExists(file_to_delete))	{
				file action="delete" file="#file_to_delete#";
      }
      // delete from db
			getFile().deleteByFileName(file_to_delete)
		}

	}

	remote void function deleteFromServer(required string file_name, required string path, required numeric size) returnTypeFormat="json"	{

		lock timeout='60' name='file-delete' throwOntimeout='true' type='exclusive'	{
			// check if file exist
			var file_to_delete = arguments.path & file_name
			if(fileExists(file_to_delete))	{
				file action="delete" file="#file_to_delete#";
			}
			// remove form db
			var ofl = getFile()
			var fl = ofl.findAll(
				where : [
					'file.File LIKE :file AND file.Size LIKE :size', {
						file: "%#arguments.file_name#%",
						size: "%#arguments.size#%",
					}
				],
				limit : '0,1'
			)
			if(fl.recordcount)	{
				if(ListLen(fl.File) > 1)	{
					var pos = listFindNoCase(fl.File, arguments.file_name, '|')
					var fn = listDeleteAt(fl.File, pos, '|')
					var sz = listDeleteAt(fl.Size, pos, '|')
					ofl.new({
						FileId 	: fl.FileId,
						File 		: fn,
						Size 		: sz
					}).save()
				}
				else {
					ofl.delete(fl.FileId)
				}
			}

		}

  }
  
	/**
	 * save into file db and also upload to s3
	 *
	 * @urlparam 
	 */
  remote void function SaveData(required struct fr) {

    getFile().saves3Files(arguments.fr)
  }

}