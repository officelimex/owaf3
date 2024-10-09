<cfscript>

	public void function sendMail(
		required string subject,
		required string to,
		required string body,
		string bcc,
		string cc,
		string replyto = application.awaf.mail.from,
		array attachments = arraynew(),
		array inline_attachments = arraynew(),
		string from = application.awaf.mail.from,
		string username = application.awaf.mail.from,
		string password = application.awaf.mail.password,
		string port = application.awaf.mail.port)	{
					
		if(arguments.from == arguments.username)	{
			if(Isdefined("application.awaf.mail.username"))	{
				arguments.username = application.awaf.mail.username
			}
		}
		
		arguments.body = "
			<html>
				<head>
					<style>

					</style>
				</head>
				<body>
					#arguments.body#..
				</body>
			</html>
		"

		var msg = new Query();
		var col_param = ":Subject,:_To_,:Body,:BCC,:CC,:ReplyTo,:_From_,:Password,:Server,:Port,:Username";
		if(arguments.inline_attachments.len())	{
			col_param = col_param & ',:InlineAttachmentBody1,:InlineAttachmentType1';
		}
		if(arguments.attachments.len())	{
			col_param = col_param & ',:Attachments';
		}
		//abort serialize(arguments);
		var col = replace(col_param,':','','all');
		var col = replace(col,'_','`','all');
		msg.setDatasource('officelime')
			.setSql("INSERT INTO email_broker (#col#) VALUES (#col_param#)")
			.addParam(name:'Subject', 	value: arguments.subject, 							cfsqltype: 'cf_sql_varchar')
			.addParam(name:'_To_', 			value: arguments.to, 										cfsqltype: 'cf_sql_varchar')
			.addParam(name:'Body', 			value: arguments.body, 									cfsqltype: 'cf_sql_varchar')
			.addParam(name:'BCC', 			value: "#arguments.bcc# ", 							cfsqltype: 'cf_sql_varchar')
			.addParam(name:'CC', 				value: "#arguments.cc# ", 							cfsqltype: 'cf_sql_varchar')
			.addParam(name:'ReplyTo', 	value: "#arguments.replyto# ", 					cfsqltype: 'cf_sql_varchar')
			.addParam(name:'_From_', 		value: arguments.from,				 					cfsqltype: 'cf_sql_varchar')
			.addParam(name:'Password', 	value: application.awaf.mail.password, 	cfsqltype: 'cf_sql_varchar')
			.addParam(name:'Server', 		value: application.awaf.mail.server, 		cfsqltype: 'cf_sql_varchar')
			.addParam(name:'Port', 			value: arguments.port, 									cfsqltype: 'cf_sql_integer')
			.addParam(name:'Username', 	value: arguments.username, 							cfsqltype: 'cf_sql_varchar');

		// add attachments
		if(arguments.attachments.len())	{

			var _att = "";
			for(att in arguments.attachments) {
				_att = ListAppend(_att, att, '|');
			}
			msg.addParam(name: "Attachments", 	value: _att);

		}

		// add inline attachments
		if(arguments.inline_attachments.len())	{
			for(att in arguments.inline_attachments) {

				msg.addParam(name: "InlineAttachmentBody1", 	value: att.body);
				msg.addParam(name: "InlineAttachmentType1", 	value: att.type);

			}
		}

		msg.execute()

	}

	public struct function CalendarEventBuilder(
			required string from_name,
			required string from_email,
			required string to_name,
			required string to_email,
			required string loc,
			required date date,
			required string subject,
			required string desc)	{

		var rt = ev = {}

		ev.location = arguments.loc
		ev.organizerName = arguments.from_name
		ev.organizerEmail = arguments.from_email
		ev.attenderEmail = arguments.to_email
		ev.attenderName = arguments.to_name
		ev.startTime = ParseDateTime(dateformat(arguments.date,'mm/dd/yyyy') & " " & timeformat(arguments.date,'h:mm tt'))
		ev.subject = arguments.subject
		ev.description = arguments.desc

		rt = {
			event 		: ev,
			attachment 	: [{
				body 	: iCalUS(ev),
				type 	: "text/calendar"
			}]
		}

		return rt
	}

	public function iCalUS(stEvent) {
		var vCal = "";
		var CRLF=chr(13)&chr(10);
		var date_now = Now();

		if (NOT IsDefined("stEvent.organizerName"))
			stEvent.organizerName = "Organizer Name";

		if (NOT IsDefined("stEvent.organizerEmail"))
			stEvent.organizerEmail = "#application.awaf.mail.from#";

		if (NOT IsDefined("stEvent.subject"))
			stEvent.subject = "";

		if (NOT IsDefined("stEvent.location"))
			stEvent.location = "";

		if (NOT IsDefined("stEvent.description"))
			stEvent.description = "";

		if (NOT IsDefined("stEvent.startTime"))  // This value must be in West Africa Time!!!
			stEvent.startTime = ParseDateTime("3/21/2008 14:30");  // Example start time is 21-March-2008 2:30 PM Eastern

		if (NOT IsDefined("stEvent.endTime"))
			hh = timeFormat(stEvent.startTime,  'h')+2;
			/*if(hh gt 12)	{

			}*/
			stEvent.endTime = ParseDateTime(dateformat(stEvent.startTime,'mm/dd/yyyy') & " " &  timeFormat(stEvent.startTime, hh & ':mm'));  // Example end time is 21-March-2008 3:30 PM Eastern

		if (NOT IsDefined("stEvent.priority"))
			stEvent.priority = "1";

		vCal = "BEGIN:VCALENDAR" & CRLF;
		vCal = vCal & "PRODID: -//CFLIB.ORG//iCalUS()//EN" & CRLF;
		vCal = vCal & "VERSION:2.0" & CRLF;
		vCal = vCal & "METHOD:REQUEST" & CRLF;
		vCal = vCal & "BEGIN:VTIMEZONE" & CRLF;
		vCal = vCal & "TZID:GMT Standard Time" & CRLF;
		vCal = vCal & "BEGIN:STANDARD" & CRLF;
		vCal = vCal & "DTSTART:20081026T020000" & CRLF;
		vCal = vCal & "RRULE:FREQ=YEARLY;BYDAY=-1SU;BYMONTH=10" & CRLF;
		vCal = vCal & "TZOFFSETFROM:+0100" & CRLF;
		vCal = vCal & "TZOFFSETTO:+0000" & CRLF;
		vCal = vCal & "TZNAME:Standard Time" & CRLF;
		vCal = vCal & "END:STANDARD" & CRLF;
		vCal = vCal & "BEGIN:DAYLIGHT" & CRLF;
		vCal = vCal & "DTSTART:20080330T010000" & CRLF;
		vCal = vCal & "RRULE:FREQ=YEARLY;BYDAY=-1SU;BYMONTH=3" & CRLF;
		vCal = vCal & "TZOFFSETFROM:+0000" & CRLF;
		vCal = vCal & "TZOFFSETTO:+0100" & CRLF;
		vCal = vCal & "END:DAYLIGHT" & CRLF;
		vCal = vCal & "END:VTIMEZONE" & CRLF;
		vCal = vCal & "BEGIN:VEVENT" & CRLF;
		vCal = vCal & "UID:#date_now.getTime()#.CFLIB.ORG" & CRLF;  // creates a unique identifier
		vCal = vCal & "ORGANIZER;CN=#stEvent.organizerName#:MAILTO:#stEvent.organizerEmail#" & CRLF;
		vCal = vCal & "DTSTAMP:" &
				DateFormat(date_now,"yyyymmdd") & "T" &
				TimeFormat(date_now, "HHmmss") & CRLF;
		vCal = vCal & "DTSTART;TZID=GMT Standard Time:" &
				DateFormat(stEvent.startTime,"yyyymmdd") & "T" &
				TimeFormat(stEvent.startTime, "HHmmss") & CRLF;
		vCal = vCal & "DTEND;TZID=GMT Standard Time:" &
				DateFormat(stEvent.endTime,"yyyymmdd") & "T" &
				TimeFormat(stEvent.endTime, "HHmmss") & CRLF;
		vCal = vCal & "SUMMARY:#stEvent.subject#" & CRLF;
		vCal = vCal & "LOCATION:#stEvent.location#" & CRLF;
		vCal = vCal & "DESCRIPTION:#stEvent.description#" & CRLF;
		vCal = vCal & "ATTENDEE;CUTYPE=INDIVIDUAL;CN=#stEvent.attenderName#;ROLE=REQ-PARTICIPANT;PARTSTAT
 =NEEDS-ACTION;RSVP=TRUE:MAILTO:#stEvent.attenderEmail#" & CRLF;
		vCal = vCal & "PRIORITY:#stEvent.priority#" & CRLF;
		vCal = vCal & "TRANSP:OPAQUE" & CRLF;
		vCal = vCal & "CLASS:PUBLIC" & CRLF;
		vCal = vCal & "BEGIN:VALARM" & CRLF;
		vCal = vCal & "TRIGGER:-PT30M" & CRLF;  // alert user 30 minutes before meeting begins
		vCal = vCal & "ACTION:DISPLAY" & CRLF;
		vCal = vCal & "DESCRIPTION:Reminder" & CRLF;
		vCal = vCal & "END:VALARM" & CRLF;
		vCal = vCal & "END:VEVENT" & CRLF;
		vCal = vCal & "END:VCALENDAR";
		return Trim(vCal);
	}

</cfscript>