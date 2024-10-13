component   {

  this.name = "owaf_x"

  this.datasource = "owaf_doc"
	this.datasources["owaf_doc"] = {
		class: 'com.mysql.cj.jdbc.Driver',
		username: 'root',
		bundleName: 'com.mysql.cj',
		connectionString: 'jdbc:mysql://localhost:3308/owaf_doc?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Africa/Lagos&useLegacyDatetimeCode=true&useSSL=false&requireSSL=false', 
		alwaysSetTimeout: true 
	}
	
}