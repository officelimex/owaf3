<cfscript>
	//
	cfparam(name="request.user.company.name", default="")

	public void function sendMail(
		required string subject,
		required string to,
		required string body,
		string bcc,
		string cc,
		string replyto = application.owaf.mail.from,
		array attachments = [],
		array inline_attachments = [],
		string from = application.owaf.mail.from,
		string username = application.owaf.mail.smtp.username,
		string server = application.owaf.mail.server,
		string password = application.owaf.mail.password,
		string port = application.owaf.mail.port,
		string company = request.user.company.name,
		struct notification = {})	{

			
		var _email = cc_email = bcc_email = ""

		transaction {
			
			if(!structIsEmpty(arguments.notification))	{
				arguments.notification.to = arguments.to
				cfparam(name="arguments.notification.title", default="#arguments.subject#")
				cfparam(name="arguments.notification.message", default="")
				cfparam(name="request.user.userId", default="")
				cfparam(name="arguments.notification.from", default="#request.user.userId#")
				getNotification().saveData(arguments.notification)
			}
			
			loop list="#arguments.to#" item="em" delimiters="," {
				if(isValid("email", em))	{
					if(!IsBlacklisted(em))	{
						_email = listAppend(_email, em)
					}
				}
			}

			loop list="#arguments.cc#" item="em" delimiters="," {
				if(isValid("email", em))	{
					if(!IsBlacklisted(em))	{
						cc_email = listAppend(cc_email, em)
					}
				}
			}


			loop list="#arguments.bcc#" item="em" delimiters="," {
				if(isValid("email", em))	{
					if(!IsBlacklisted(em))	{
						bcc_email = listAppend(bcc_email, em)
					}
				}
			}

			cfparam(name="request.user.company.SenderEmail", default="")
			if(request.user.company.SenderEmail != "")	{
				arguments.from = arguments.replyto = "#arguments.company# <#request.user.company.SenderEmail#>"
			}
			//arguments.from = replaceNocase(arguments.from, "Officelime ", request.user.company.name)
			//abort arguments.from
			
			if(_email != "")	{
				
				// Create an instance of the mail object
				var _mail = new mail()
				
				// Set it's properties
				_mail.setTo(_email)
						.setSubject(arguments.subject)
						.setReplyTo(arguments.replyto)
						.setFrom("#arguments.from#")
						.setUsername(arguments.username)
						.setPassword(arguments.password)
						.setServer(arguments.server)
						.setPort(arguments.port)
						.setuseTLS(true)
				
				if(len(cc_email))	{
					_mail.setCC(cc_email)
				}
				if(len(bcc_email))	{
					_mail.setBCC(bcc_email)
				}

				//.setType('html')
				//.setBody(arguments.body)
				
				//  Add an attachment
				loop array=arguments.attachments item="att" index="i"	{

					var fl = GetTempDirectory() & "#arguments.subject#_#i#.#att.extension#"
					fileWrite(fl, att.body)
					_mail.addParam(
						file : fl,
						type : att.type
					)

				}

				loop array=arguments.inline_attachments item="att" index="i"	{
					_mail.addPart(type:att.type, body: att.body)
				}

				_mail.addPart(type:"html", body: arguments.body)
				/*if(inline_attachments.InlineAttachmentType1 != "")	{
					_mail.addPart(
						body : inline_attachments.InlineAttachmentBody1,
						type : inline_attachments.InlineAttachmentType1
					)
				}*/
				
				//_mail.send()
			}

		}
	}

	private boolean function isBlacklisted(required string e)	{

		query name="qr" {
			echo("SELECT * FROM blocked_email WHERE Email = ")
        queryparam value=arguments.e cfsqltype="cf_sql_varchar";
		}

		var rt = false
		if(qr.recordcount)	{
			rt = true
		}

		return rt
	}

</cfscript>