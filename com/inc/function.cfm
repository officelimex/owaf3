<cfscript>
	/*private struct function getModelDefaultParam(required string model_desc)	{

		var mod_desc = structNew();
		switch(listLen(arguments.model_desc," "))	{
			case 1: // model name only
				mod_desc.model_name = mod_desc.table_name = arguments.model_desc ;
				//mod_desc.table_name = '';
			break;
			case 2: // table alias
				mod_desc.model_name = mod_desc.table_name = listFirst(arguments.model_desc," ");
				mod_desc.table_name = mod_desc.table_name & " " & listLast(arguments.model_desc," ");
			break;
			case 3: // model and table and table alias
				mod_desc.model_name = listFirst(arguments.model_desc," ");
				mod_desc.table_name = listGetAt(arguments.model_desc,2, " ") & " " & listLast(arguments.model_desc," ");
			break;
		}

		return mod_desc;
	}*/

	public query function QoQ(required string select, required query dbquery, boolean group)	{

		local.group_by = ""
		if(arguments.group == true)	{
			local.gf = ""
			local.gv = replace(arguments.select, ", ", ",", "all")
			// todo: remove alias
			loop list="#local.gv#" item="fld"	{
				local.gf = listAppend(local.gf, listFirst(fld, " "))
			}

			local.group_by = "GROUP BY " & local.gf
		}
		query name="local.query" dbtype="query"	{
			echo(
				"SELECT
					#arguments.select#
				FROM arguments.dbquery
				#local.group_by#"
			)
		}

		return local.query
	}

	public string function AEncrypt(required string phrase)	{

		return encrypt(arguments.phrase, application.owaf.secretkey, 'AES/CBC/PKCS5Padding', 'HEX')
	}

	public string function ADecrypt(required string enc_phrase)	{

		return decrypt(arguments.enc_phrase, application.owaf.secretkey, 'AES/CBC/PKCS5Padding', 'HEX')
	}

	// param 	@fieldname -> form.fieldnames -
	public number function maxValueOfSubItemInForm(required string fieldnames)	{

		var l = 0;

		loop list=arguments.fieldnames item='form_item'	{
			l = listAppend(l,val(listlast(form_item,'_')));
		}
		var a = listtoarray(l);

		return a.max()
	}

	public string function bracketValueList(required string value, string delimiters=",")	{

		return "[" & replaceNoCase(arguments.value, arguments.delimiters,'],[','all') & "]";
	}

	/**
	 * Returns a randomly generated string using the specified character sets and length(s)
	 * @strLen Either a number of a list of numbers representing the range in size of the returned string. (Required)
	 * @charset A string describing the type of random string. Can contain: alpha, numeric, and upper. (Required)
	 */
	public string function randStr(string strLen=7, string charSet='alphauppernumeric') {
		var usableChars = ""
		var charSets = arrayNew(1)
		var tmpStr = ""
		var newStr = ""
		var i = 0
		var thisCharPos = 0
		var thisChar = ""

		charSets[1] = '48,57'    // 0-9
		charSets[2] = '65,90'    // A-Z
		charSets[3] = '97,122'    // a-z

		if (findnocase('alpha', charSet)) { usableChars = listappend(usableChars, 3); }

		if (findnocase('numeric', charSet)) { usableChars = listappend(usableChars, 1); }

		if (findnocase('upper', charSet)) { usableChars = listappend(usableChars, 2); }

		if (len(usableChars) is 0) { usableChars = '1,2,3'; }

		if(listlen(strLen) gt 1 and listfirst(strLen) lt listlast(strLen)) { strLen = randrange(listfirst(strLen), listlast(strLen)); }
		else if (val(strLen) is 0) { strLen = 8; }


		while (len(tmpStr) LE strLen-1)
		{
				thisSet = listFirst(usableChars);
				usableChars = listdeleteat(usableChars, 1);
				usableChars = listappend(usableChars, thisSet);

				tmpStr = tmpStr & chr(randrange(listfirst(charSets[thisSet]), listlast(charSets[thisSet])));
		}

		for (i=1; i lte strLen; i=i+1)
		{
				thisCharPos = randrange(1, len(tmpStr));
				thisChar = mid(tmpStr, thisCharPos, 1);
				tmpStr = removeChars(tmPStr, thisCharPos, 1);
				newstr = newstr & thisChar;
		}

		return newStr
	}

	public boolean function hasLicense(required numeric lid)	{

		var rt = false
		if(listFind(request.user.Tenant.LicenseIds, arguments.lid))	{
			rt = true
		}

		return rt
	}

	include "controller/email.cfm"
	include "../inc/lang.cfm"

</cfscript>