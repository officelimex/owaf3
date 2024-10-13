component   {
 
	this.sessionType = "jee";
  this.name = "project1"
	this.applicationTimeout = createTimeSpan(0,10,0,0)
	this.setClientCookies = true
	this.setDomainCookies = true
	this.sessionManagement = true
	this.sessionTimeout = createTimeSpan(0,5,0,0)
	this.scriptProtect = 'all'
	this.sessionCookie.sameSite = "strict"
	this.sessionCookie.secure = true
	this.compression = false
	this.suppressRemoteComponentContent = false
	this.bufferOutput = false

	local_path = getDirectoryFromPath(getCurrentTemplatePath()) & "../"
	this.customTagPaths = [
		"#local_path#owaf3/tags/", 
		"#local_path#owaf3/tags/Chart/", 
		"#local_path#owaf3/tags/Chartjs/", 
		"#local_path#owaf3/tags/eCharts/", 
		"#local_path#owaf3/tags/Grid/",
		"#local_path#owaf3/tags/plainGrid/",
		"#local_path#owaf3/tags/Tab/",
		"#local_path#owaf3/tags/Form/",
		"#local_path#owaf3/tags/Accordion/",
		"#local_path#owaf3/tags/Editable/",
		"#local_path#owaf3/tags/TableEdit/",
		"#local_path#owaf3/tags/Buttob/",
		"#local_path#owaf3/tags/FileUploader/",
		"#local_path#owaf3/tags/OrgChart/",
		"#local_path#owaf3/tags/PlainGrid/",
		"#local_path#owaf3/tags/Button/",
		"#local_path#owaf3/tags/ListView/"
	]

	this.mappings = {
		'/owaf3' 			: local_path & "owaf3",
		'/project1' 	: local_path & "project1",
		'/owaf' 			: local_path & "project1/owaf/com"
	}

	this.s3.accesskeyid = 'YOUR_OWN_ID'
	this.s3.secretkey = 'YOUR_OWN_SECRET_KEY'
	this.s3.defaultLocation = 'your_region'

  this.datasource = "project1"
	this.datasources["project1"] = {
		class: 'com.mysql.cj.jdbc.Driver',
		username: 'root',
		password:''
		, bundleName: 'com.mysql.cj'
		, bundleVersion: '8.0.11'
		, connectionString: 'jdbc:mysql://localhost:3308/project1?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Africa/Lagos&useLegacyDatetimeCode=true&useSSL=false&requireSSL=false'
		, connectionLimit:100 // default:-1
		, timezone:'Africa/Lagos'
		, alwaysSetTimeout:true // default: false
	}

  public void function onApplicationStart()   {

		cfinclude(template="settings.cfm")

		structAppend(application.fn, createObject("component", "project1.owaf.GlobalFunction")) 

    cfinclude(template="app_variables.cfm")

		application.datasource.main = this.datasource

  }

	cfinclude(template="owaf/on_cfc_request.cfm")

	public boolean function onRequest(required string targetPage)	{

		if(application.owaf.mode == 1)	{
			cfinclude(template="clear.cfm")
		}
		
		cfinclude(template="owaf/on_request.cfm")

		if (request.include_page == 'views/secure_page.cfm') 	{

			if(
				(findnocase('login.cfm', arguments.targetPage)) 				||
				(findnocase('signup.cfm', arguments.targetPage)) 				||
				(findnocase('index.cfm', arguments.targetPage)) 				||
				(findnocase('forget.cfm', arguments.targetPage))				||
				(findnocase('logout.cfm', arguments.targetPage))				||
				(findnocase('clear.cfm', arguments.targetPage))					||
				(findnocase('ajax.cfm', arguments.targetPage))
			){

				cfinclude(template="#lcase(arguments.targetPage)#")
			}
			else 	{

				cfinclude(template="views/secure_page.cfm")
			}
		}
		else 	{

			try {
				cfinclude(template="#lcase(arguments.targetPage)#")
			} catch (missinginclude e) {
				cfinclude(template="index.cfm")
			}

		}

		return true
	}

	public void function onError(required any exception, required string eventname)	{

		cfheader(statusCode = "503",statusText = "Server error")

		request.err = arguments.exception 

		include "views/error.cfm"; 
		
	} 

}