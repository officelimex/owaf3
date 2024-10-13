component extends="owaf3.com.Controller"  {

	public struct function getGenderExpression(required string g)	{

		var rt = {
			f1 : "their",
			f2 : "their"
		}

		switch(arguments.g)	{
			case "Male":
				rt = {
					f1 : "he",
					f2 : "him"
				}
			break;
			case "Female":
				rt = {
					f1 : "she",
					f2 : "her"
				}
			break; 
		}

		return rt
	}
	public boolean function hasPermission(required string page)	{

		var rt = false;

		if(findNoCase(arguments.page, request.user.pageurls))	{

			rt = true;
		}

		return rt

	}

	public struct function getTenantInfo()	{

		var site_url = cgi.server_name
		
		if(site_url == "officelime.app" || site_url == "localhost" || site_url == "www.officelime.app")	{

			rt = {
				tenantId : 0,
				LogoURL 	: "",
				URL 			: "https://officelime.app/",
				MSCode 		: "ca27811c-0cf9-49bf-9e2a-ae75ac831006",
				MSSecret 	: "TBm6F8-8@8iM=-o4Q]G6lB3@15jU@e37",
				GSCode 		: "398296178059-8dqvj8nn63tl483i4dgnfhbahoiake0u.apps.googleusercontent.com",
				GSecret 	: "0lvxlohzt8_N--RcyPNoyylU",
				SS 				: "m,g"
			}

		}
		else {

			q = queryExecute(
				"
				SELECT
					tenant.*,
					company.logoURL 
				FROM tenant 
				INNER JOIN company ON company.TenantId = tenant.TenantId
					WHERE URL LIKE :url 
				", 
				{url: "%#site_url#%"},
				{cachedwithin: createtimespan(1,0,0,0)}
			)
			rt = {
				tenantId 	: q.TenantId,
				LogoURL 	: q.LogoURL,
				MSCode 		: q.MSCode,
				MSSecret 	: q.MSSecret,
				URL 			: q.URL,
				GSCode 		: "",
				GSecret 	: "",
				SS 				: q.SS
			}
			
		}

		return rt

	}

	public boolean function hasRole(required numeric id)	{

		var rt = false

		if(listFind(request.user.roleids, arguments.id))	{

			rt = true
		}

		return rt

	}

	public boolean function isHost()	{
		
		var rt = false
		
		if(listFind(request.user.roleids, application.role.HOST))	{
			rt = true
		}

		return rt
	}
	
	public boolean function isHR()	{
		
		var rt = false
		
		if(listFind(request.user.roleids, application.role.HR_ADMIN) || listFind(request.user.roleids, application.role.HR_OFFICER))	{
			rt = true
		}

		return rt
	}

	public boolean function isMD()	{
		
		var rt = false
		
		if(listFind(request.user.roleids, application.role.MD))	{
			rt = true
		}

		return rt
	}

	public boolean function isTimesheetMgr()	{
		
		var rt = false
		
		if(listFind(request.user.roleids, application.role.TIMESHEET_MANAGER))	{
			rt = true
		}

		return rt
	}

	public boolean function isTimesheetHOD()	{
		
		var rt = false
		
		if(listFind(request.user.roleids, application.role.TIMESHEET_HOD))	{
			rt = true
		}

		return rt
	}

	public boolean function isLocationMgr()	{
		
		var rt = false
		
		if(listFind(request.user.roleids, application.role.LOCATION_MANAGER))	{
			rt = true
		}

		return rt
	}

	public boolean function isLineManager()	{
		
		var rt = false
		
		if(listFind(request.user.roleids, application.role.LINE_MANAGER))	{
			rt = true
		}

		return rt
	}

	// do a reverse translation on a text value
	public string function rtrs(required string value)	{

		//var eng_lang = application.eng_lang;

		return ""
	}

	public string function tr(required string words, struct variables = {}, string lang = request.lang)	{

		rt = arguments.words 

		if(arguments.lang == "")	{

		}
		else {
			
			if(isDefined("application.lang[arguments.words][arguments.lang]"))	{
				rt = application.lang[arguments.words][arguments.lang]
				for(x in arguments.variables)	{
					rt = replace(rt, '[[#x#]]', arguments.variables[x], 'all')
				}
			}
			else {
				rt = arguments.words & "."
			}
		}

		return rt
	}

	this.v = this.getRandomVariable

	public string function getRandomVariable()	{

		return '_' & replaceNocase(createuniqueid(),'-','_','all')
	}

	public string function getRandomNumber(numeric len = 6)	{

		var f = 1
		var t = 9
		cfloop(from="1" to="#arguments.len-1#" index="i")	{
			f = listappend(f, "0")
			t = listappend(t, "9")
		}

		f = val(replace(f,',','','all'))
		t = val(replace(t,',','','all'))

		return randRange(f, t)
	}

/* 	public string function replaceCarriageReturn(required string txt)	{

		return replace(arguments.txt,Chr(10),'<br/>','all');
	} */

	public string function replaceCarriageReturn(required string txt)	{

		var rt = arguments.txt
		rt = replace(rt, ">", "&gt;", 'all')
		rt = replace(rt, "<", "&lt;", 'all')

		var rt = replace(rt,Chr(10),'<br/>','all')

		return rt
	}

	public boolean function canSeeSubsidiaries()	{

		var rt = false;

		if(findNoCase("secure.SeeSubsidiaries", request.user.pageurls))	{

			rt = true;
		}

		return rt

	}

	public string function naturalDateFormat(required any d)	{

		var rt = ''
		if(isdate(arguments.d))	{
			rt = '<sup>th</sup>'
			switch(right(day(arguments.d),1))	{
				case 1:
					rt = '<sup>st</sup>'
				break;
				case 2:
					rt = '<sup>n*</sup>'
				break;
				case 3:
					rt = '<sup>r*</sup>'
				break;
			}
			if(listFind('11,12,13,14,15,16,17,18,19,20', day(arguments.d)))	{
				rt = '<sup>th</sup>'
			}
			rt = LSDateFormat(arguments.d, 'd#rt# mmm yyyy');
			rt = replace(rt,'*','d');
		}
		return rt
	}

	public string function naturalNumEnd(required numeric d)	{

		var rt = ''
		if(arguments.d)	{
			rt = '<sup>th</sup>'
			switch(right(arguments.d,1))	{
				case 1:
					rt = '<sup>st</sup>'
				break;
				case 2:
					rt = '<sup>n*</sup>'
				break;
				case 3:
					rt = '<sup>r*</sup>'
				break;
			}
			if(listFind('11,12,13,14,15,16,17,18,19,20', arguments.d))	{
				rt = '<sup>th</sup>'
			}
			rt = '#arguments.d# #rt#'
			rt = replace(rt,'*','d');
		}

		return rt
	}

	public string function naturalDateFormat2(required any d)	{

		var rt = ''
		if(isdate(arguments.d))	{
			rt = '<sup>th</sup>'
			switch(right(day(arguments.d),1))	{
				case 1:
					rt = '<sup>st</sup>'
				break;
				case 2:
					rt = '<sup>n*</sup>'
				break;
				case 3:
					rt = '<sup>r*</sup>'
				break;
			}
			if(listFind('11,12,13,14,15,16,17,18,19,20', day(arguments.d)))	{
				rt = '<sup>th</sup>'
			}
			rt = LSDateFormat(arguments.d, 'd#rt# mmm');
			rt = replace(rt,'*','d');
		}
		return rt
	}

	public string function DateFormat1(required any date)	{

		return LSDateFormat(arguments.date,'mmm d, yyyy') & " " & LSTimeFormat(arguments.date, 'h:mm tt');
	}

	public string function DateFormat2(required any date)	{

		return LSDateFormat(arguments.date,'mmm d, yyyy');
	}

	public string function moneyFormat(required any d )	{
		var rt = ''
		if(isNumeric(arguments.d))	{
			//rt = decimalFormat(arguments.d);
			//rt = NumberFormat(arguments.d, "9,999.99")
			if(listLen("#arguments.d#", ".") == 2)	{
				l = listLast("#arguments.d#",".")
				if(len(l) > 2)	{
					_3val = left(l, 3)
					if(right(_3val,1) > 4)	{
						//systemoutput("====" & arguments.d & "====" & _3val & "=======",  true)
						arguments.d = arguments.d + 0.01
						arguments.d = listfirst("#arguments.d#",".") & "." & left(listLast("#arguments.d#","."),2)
						//systemoutput("====now=" & arguments.d,  true)
					}
				}
			}

			rt = decimalFormat(arguments.d)
		}

		return rt
	}


	/*
		leading zeros in fromt of a number e.g 004, 005 | 010, 011, 012
	*/
	public string function zeroFill(required numeric num, numeric totalLen = 2)	{

		return prependZeros(arguments.num,arguments.totalLen)
	}
	/*
		leading zeros in fromt of a number e.g 004, 005 | 010, 011, 012
	*/
	public string function PrependZeros(required numeric num, numeric totalLen = 2)	{

		var number_len = len(arguments.num);
		var number_len_rem =  arguments.totalLen - number_len;

		switch(number_len_rem)	{
			case 1:
				rt = "0" & arguments.num
			break;
			case 2:
				rt = "00" & arguments.num
			break;
			case 3:
				rt = "000" & arguments.num
			break;
			case 4:
				rt = "0000" & arguments.num
			break;
			default:
				rt = arguments.num
			break;
		}
		return rt
	}

	public string function numberToWords(required numeric amount, required string currency_name, required string currency_unit)	{

		return createObject("component","owaf3.com.Util.Finance.NumberToWords").init(NumberFormat(arguments.Amount,'999.99'), arguments.currency_name, arguments.currency_unit).Convert();
	}

	public numeric function LoanRepayment(required numeric rate, required numeric duration, required numeric princ)	{

		return createObject("component","owaf3.com.Util.Finance.Loan").PMT(arguments.rate, arguments.duration, -arguments.princ);
	}

	public string function timeAfter(required date dateThen, date rightNow = now()) 	{


		return timeAgo(dateThen, rightNow, "after");
	}

	public string function shortHandNumber(required number number)	{

		arguments.number = listFirst(arguments.number,'.');

		switch(arguments.number.len()){
			case 4:
				num = left(arguments.number,1) & "K"
			break;
			case 5:
				num = left(arguments.number,2) & "K"
			break;
			case 6:
				num = left(arguments.number,3) & "K"
			break;
			case 7:
				num = left(arguments.number,1) & "." & mid(arguments.number,7,2 )& "M"
			break;
			case 8:
				num = left(arguments.number,2) & "M"
			break;
			case 9:
				num = left(arguments.number,3) & "M"
			break;
			case 10:
				num = left(arguments.number,1) & "B"
			break;
			default:
				num = arguments.number
			break;
		}
		
		return num

	}

	public string function timeAgo(required date dateThen, date rightNow = now(), string time_frame = "ago") 	{
		var result = ""
		var i = ""
		//var arguments.rightNow = Now();
		Do 	{
			i = dateDiff('yyyy',arguments.dateThen,arguments.rightNow)
			if(i GTE 2)	{
				result = "#i# years #arguments.time_frame#"
				break;
			}
			else if (i EQ 1)	{
				result = "#i# year #arguments.time_frame#"
				break;
			}
			i = dateDiff('m',arguments.dateThen,arguments.rightNow)
			if(i GTE 2)	{
				result = "#i# months #arguments.time_frame#"
				break;
			}
			else if (i EQ 1)	{
				result = "#i# month #arguments.time_frame#"
				break;
			}

			i = dateDiff('d',arguments.dateThen,arguments.rightNow)
			if(i GTE 2){
				result = "#i# days #arguments.time_frame#"
				break;
			}
			else if (i EQ 1)	{
				result = "#i# day #arguments.time_frame#"
				break;
			}

			i = dateDiff('h',arguments.dateThen,arguments.rightNow)
			if(i GTE 2)	{
				result = "#i# hours #arguments.time_frame#"
				break;
			}
			else if (i EQ 1)	{
				result = "#i# hour #arguments.time_frame#"
				break;
			}

			i = dateDiff('n',arguments.dateThen,arguments.rightNow)
			if(i GTE 2)	{
				result = "#i# minutes #arguments.time_frame#"
				break;
			}
			else if (i EQ 1)	{
				result = "#i# minute #arguments.time_frame#"
				break;
			}

			i = dateDiff('s',arguments.dateThen,arguments.rightNow)
			if(i GTE 2)	{
				result = "#i# seconds #arguments.time_frame#"
				break;
			}
			else if (i EQ 1)	{
				result = "#i# second #arguments.time_frame#"
				break;}
			else 	{
				result = "less than 1 second #arguments.time_frame#"
				break;
			}
		}
		While (0 eq 0);

		return result
	}

	//@return x years y months
	public string function TimeIn(required numeric m)	{

		temp = ""

		if(arguments.m neq 0)	{

			y = arguments.m \ 12
			mon = abs((y * 12) - arguments.m)

			if (y gt 0)	{
				if(y eq 1) 	{
					temp = "#y# Year"
				}
				else {
					temp = "#y# Years"
				}
			}

			if (mon eq 1) 	{
				temp = temp & " #mon# Month"
			}
			else if(mon gt 1) 	{
				temp = temp & " #mon# Months"
			}
		}

		return trim(temp)
	}


	this.modalSize = this.resizeModal = this.modalResize

	public string function modalResize(numeric size)	{

		return '
			<style type="text/css">
				@media (min-width: 768px)	{.modal-dialog {max-width: #arguments.size#px !important}}
				@media (min-width: 992px)	{.modal-dialog {max-width: #arguments.size#px !important}}
			</style>
		'
	}

	//public Model function Model(required string model_desc)	{

	//	var arg = getModelDefaultParam(arguments.model_desc)

	//	return createObject("component","officelimex.models." & arguments.model_desc).init()
	//}
	public any function model(required string modl)	{

		return createObject("component","officelimex.models." & ListFirst(arguments.modl, ' ')).init()
	}

	public any function callpageController(required string url, string param)	{

		var c = replace(arguments.url,'/','.','all')
		var _fun = listlast(c,'.')
		c = replacenocase(c, '.'&_fun, '')
		_fun = replace(_fun, '_', '','all')
		c = createObject("component", "officelimex.controllers." & c).init()
		p = {}
		loop list="#arguments.param#" delimiters="|" item="it"	{
			p[listFirst(it,':')] = listLast(it, ':')
		}
		return invoke(c, _fun, {urlparam:p})
	}

	// @ controller description
	public Controller function _controller(required string cntr)	{

		arguments.cntr = replace(arguments.cntr,'_','','all');

		return createObject("component", "officelimex.controllers." & arguments.cntr).init()
	}

	public string function Nth(required string d)	{

		var rt = ''
		arguments.d = val(arguments.d)
		rt = '<sup>th</sup>'
		switch(right(arguments.d,1))	{
			case 1:
				rt = '<sup>st</sup>'
			break;
			case 2:
				rt = '<sup>nd</sup>'
			break;
			case 3:
				rt = '<sup>rd</sup>'
			break;
		}
		if(listFind('11,12,13,14,15,16,17,18,19,20', arguments.d))	{
			rt = '<sup>th</sup>'
		}
		rt = arguments.d & rt

		return rt
	}

	public string function excapeJsStr(required string s)	{
		
		var rt = replaceNoCase(arguments.s, "'", "\'", "All")

		return rt
	}

	public numeric function getParentStoreId(required numeric store_id)	{

		var id = val(arguments.store_id)
		return model(application.model.STORE).getParentStoreId(id)
	}

  public string function getDurationInWords(required numeric i) {

    h = m = ""
    if(i < 60) {
      m = i&"m"
    }
    if(i >= 60)   {
      h = i/60
    }
    
    if(listlen(h,".") == 2)     {
			m = left(listLast(h,".") * 60,2) & "m"
			h = int(h) & "h"
		}
		if(isNumeric(h))	{
			h = h & "h"
		}

    rt = h & " " & m

    return rt
	}
	
	public string function encryptString(required string str)	{

		return encrypt(arguments.str, application.owaf.secretKey,'AES/CBC/PKCS5Padding','Hex');
	}

	public string function decryptString(required string str)	{

		return decrypt(arguments.str, application.owaf.secretKey, 'AES/CBC/PKCS5Padding', 'Hex');
	}
	
}