component output="false" displayname=""  {

  this.datasource = "owaf_doc"
	this.datasources["owaf_doc"] = {
		class: 'com.mysql.cj.jdbc.Driver',
		username: 'root',
		password:''
		, bundleName: 'com.mysql.cj'
		, connectionString: 'jdbc:mysql://localhost:3308/owaf_doc?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Africa/Lagos&useLegacyDatetimeCode=true&useSSL=false&requireSSL=false'
		, connectionLimit:100 // default:-1
		, timezone:'Africa/Lagos'
		, alwaysSetTimeout:true // default: false
	}
	
}