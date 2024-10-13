<cfscript>


	public void function onCfcRequest(required string cfc, required string method, required struct args) output=true{

		lock timeout="60" scope="session" type="exclusive" 	{
			request.user = session.user
		}
		if(request.user.isLogin)	{

			mtd = ListFirst(cgi.request_url,'?')

			mtd = replacenocase(mtd, request.user.tenant.url & "controllers/",'')
			mtd = replacenocase(mtd, request.user.tenant.url & "owaf/tags/",'')			
			mtd = replacenocase(mtd, "https://officelime.app/" & "controllers/",'')
			mtd = replacenocase(mtd, "https://officelime.app/" & "owaf/tags/",'')

		
			mtd_n = listFirst(ListLast(cgi.request_url,'?'),'&')
			mtd = mtd & replacenocase(mtd_n, 'method=','')
			mtd = replacenocase(mtd, '.cfc','.')
			mtd = replacenocase(mtd, '/','.','all')

			mtd = replacenocase(mtd, "https:..ccmvessel.net.",'')
			mtd = replacenocase(mtd, "https:..fuelstation.officelime.app.",'')
			mtd = replacenocase(mtd, "https:..enyo.officelime.app.",'')
			mtd = replacenocase(mtd, "http:..ccmvessel.net.",'')
			mtd = replacenocase(mtd, "controllers.",'')
			mtd = replacenocase(mtd, "https:..officelime.app.",'')
			mtd = replacenocase(mtd, "http:..officelime.app.",'')
			mtd = replacenocase(mtd, "http:..localhost.officelimex.",'')
			
			if(listFindNoCase(request.user.PageURLs, mtd))	{

				var o = createObject(arguments.cfc)
				var metadata = getMetadata(o[method])

				if(structKeyExists(metadata, "access") && metadata.access == "remote")	{

					lock type="read-only" scope="session" timeout="5"	{
						s = session
					}
					cfparam(name="s.user.islogin", default="false", type="boolean")
					if(!s.user.islogin)	{
						abort "Not authorized, You have to login first"
					}

					cfparam(name="metadata.returnFormat", default="wddx");

					switch(metadata.returnFormat)	{
						case "json":
							local.responseMimeType = "text/json"
						break;
						case "plain":
							local.responseMimeType = "text/plain"
						break;
						default:
							local.responseMimeType = "text/xml"
						break;
					}
					local.result = invoke(o, method, args)
					if(isdefined("local.result"))	{
						cfcontent(type="#local.responseMimeType#", reset="true")
						writeoutput(local.result)
					}

				}
				else{
					throw(type="InvalidMethodException", message="Invalid method called", detail="The method #method# does not exists or is inaccessible remotely")
				}
			}
			else{
				abort "No Permission to perform Task #mtd#"
			}
		}
		else { // for login

			mtd = ListFirst(cgi.request_url,'?')

			mtd = replacenocase(mtd, "https://officelime.app/" & "controllers/",'')
			mtd = replacenocase(mtd, "https://officelime.app/" & "owaf/tags/",'')

		
			mtd_n = listFirst(ListLast(cgi.request_url,'?'),'&')
			mtd = mtd & replacenocase(mtd_n, 'method=','')
			mtd = replacenocase(mtd, '.cfc','.')
			mtd = replacenocase(mtd, '/','.','all')

			mtd = replacenocase(mtd, "https:..ccmvessel.net.",'')
			mtd = replacenocase(mtd, "http:..ccmvessel.net.",'')
			mtd = replacenocase(mtd, "https:..fuelstation.officelime.app.",'')
			mtd = replacenocase(mtd, "https:..enyo.officelime.app.",'')
			mtd = replacenocase(mtd, "controllers.",'')
			mtd = replacenocase(mtd, "https:..officelime.app.",'')
			mtd = replacenocase(mtd, "http:..officelime.app.",'')
			mtd = replacenocase(mtd, "http:..localhost.officelimex.",'')

			switch(mtd)	{
				case "Employee.checkEmail":

					var o = createObject(arguments.cfc)
					var metadata = getMetadata(o[method])
					
					cfparam(name="metadata.returnFormat", default="wddx");

					switch(metadata.returnFormat)	{
						case "json":
							local.responseMimeType = "text/json"
						break;
						case "plain":
							local.responseMimeType = "text/plain"
						break;
						default:
							local.responseMimeType = "text/xml"
						break;
					}
					local.result = invoke(o, method, args)
					if(isdefined("local.result"))	{
						cfcontent(type="#local.responseMimeType#", reset="true")
						writeoutput(local.result)
					}
				break;
			}
		}
	}

</cfscript>