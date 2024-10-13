component output="false" extends="officelimex.owaf.com.Controller"  {

	// save to file table
	remote string function upload(required numeric modelId, required numeric key, required string tag, required numeric userid) returnTypeFormat="json"	{

		var rand_path = randRange(100,999) & '/' & randRange(100,999) & '/'
		var path_to_save = ''
		var _error = ''				// error to report to the client
		var uploaded_file_list = ''// list of uploaded files to return to the client

		transaction	{

			lock timeout='100' name='file-upload' throwOnTimeout='true' type='exclusive'	{

				path_to_save = "#application.site.dir#attachment/" & rand_path

				if(!directoryExists(path_to_save))	{
					directoryCreate(path_to_save)
				}

				try {

					//file action="upload" result="saved_file" destination=path_to_save
					saved_file = fileUpload(path_to_save, "", " ", "makeunique")
					// save file to db
					model(application.model.FILE).saveFile(
						modelId 	: arguments.modelId,
						file_info 	: saved_file,
						file_path 	: rand_path,
						key 		: arguments.key,
						tag 		: arguments.tag,
						userid 		: arguments.userid
					)

				}
				catch(any exception) {
					_error = exception.message & " : " & exception.Detail
				}

			}

		}

		if(_error != '')	{
			return '{"error" : ' & serializeJSON(_error) & '}'
		}
		else 	{
			return '{"file_name": #serializeJSON(rand_path & saved_file.serverFile)#}'
		}

	}

	// also delete from server
	remote void function delete(required string file_name) returnTypeFormat="json"	{

		lock timeout='60' name='file-upload' throwOnTimeout='true' type='exclusive'	{
			// check if file exist

			var file_to_delete = "#application.site.dir#attachment/" & file_name
			if(fileExists(file_to_delete))	{

				fileDelete(file_to_delete)
				model(application.model.FILE).deleteByFileName(file_name)

			}


		}

	}

	remote void function deleteFromServer(required string file_name, required numeric size) returnTypeFormat="json"	{

		lock timeout='60' name='file-delete' throwOnTimeout='true' type='exclusive'	{
			// check if file exist
			var file_to_delete = "#application.site.dir#attachment/" & file_name
			if(fileExists(file_to_delete))	{
				// remove form db
				model(application.model.FILE).deleteByFileAndSize(file_name, size)
				fileDelete(file_to_delete)

			}

		}

	}

}