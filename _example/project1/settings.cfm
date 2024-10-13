<cfscript>

	application.owaf.version = "0.1"
	// 0=Production, 1=Developer, 2=Debug
	application.owaf.mode = 1

	application.owaf.secretkey = 'K4Id6B8L40uW-HsPV!jnYC' // do not change
	if(!isdefined("local_path"))	{
		local_path = getDirectoryFromPath(getCurrentTemplatePath()) & "../"
	}
	application.owaf.attachmentpath = local_path & "officelimex/attachment/"   
	application.owaf.temppath = application.owaf.attachmentpath & "temp/" 

	application.owaf.staff_client = false

	application.s3.bucket = "s3:///your_bucket/"
	application.s3.url = "https://your_aws_url/"
	application.owaf.mail.smtp.username =  'YOUR AWS SMTP USERNAME'
	application.owaf.mail.password = 'AWS SMTP PASSWORD'
	application.owaf.mail.server = 'AWS SMTP SERVER'

	application.owaf.mail.from = 'YOUR SENDER EMAIL'
	application.owaf.mail.port = '587'
	application.fn = {} 
	application.site.name = ""
	application.site.logo = ""
	application.site.url = "http://localhost/project1/"
	application.site.dir = getDirectoryFromPath(getCurrentTemplatePath())
	application.site.career.url = ""

</cfscript>