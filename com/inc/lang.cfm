<cfscript>
	cfparam(name="request.lang", default="en")
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
  
</cfscript>