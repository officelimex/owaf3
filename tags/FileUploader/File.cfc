component output="false" extends="assetgear.awaf.com.Controller"  {

	remote string function upload(boolean save_to_temp_first=true) returntypeformat="json"	{
		
		var path_to_save = '';
		var file_path = '';			// dynamic file path to place the file
		var error = '';				// error to report to the client
		var uploaded_file_list = '';// list of uploaded files to return to the client

		lock timeout='60' name='file-upload' throwontimeout='true' type='exclusive'	{

			file_path = createUUID() & "/";

			if (arguments.save_to_temp_first)	{
				path_to_save = expandPath("../../../attachment/temp/" & file_path);
			} 
			else 	{
				path_to_save = expandPath("../../../attachment/" & file_path);
			}

			if(!directoryExists(path_to_save))	{
				directory action="create" directory=path_to_save;
			}

			try {

				file action="upload"  destination=path_to_save;
			
			}
			catch(any exception) {
				//if (arguments.save_to_temp_first)	{
				error = exception.message;
				//}
			}
			
		}
		if(error neq '')	{
			return '{"error" : ' & serializeJSON(error) & '}';
		}
		else 	{
			return '{"file_name": #serializeJSON(file_path & cffile.serverfile)#}';
		} 
	}

	remote void function delete(required string file_name) returntypeformat="json"	{

		lock timeout='60' name='file-upload' throwontimeout='true' type='exclusive'	{
			// check if file exist
			var file_to_delete = expandPath("../../../attachment/temp/" & file_name);
			if(fileExists(file_to_delete))	{
				file action="delete" file="#file_to_delete#";
				//abort file_to_delete;
			}
			else 	{
				file_to_delete = expandPath("../../../attachment/" & file_name);
				file action="delete" file=file_to_delete;

				// remove form db
			}
			
		}
 
	}

	remote void function deleteFromServer(required string file_name, required numeric size) returntypeformat="json"	{

		lock timeout='60' name='file-delete' throwontimeout='true' type='exclusive'	{
			// check if file exist
			var file_to_delete = expandPath("../../../attachment/" & file_name);
			if(fileExists(file_to_delete))	{
				// remove form db
				model(application.model.FILE).deleteByFileAndSize(file_name, size);
				file action="delete" file="#file_to_delete#"; 


			}
			
		}
 
	}

}