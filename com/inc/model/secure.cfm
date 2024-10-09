<cfscript>
	public string function hashPassword(required string secret, required string salt)	{
		
		var rt = createGUID()
		if(arguments.salt != "")	{
			rt = hmac(arguments.secret & application.awaf.secretkey, arguments.salt, 'HMACSHA256')
		}
		return rt
	}

	public struct function generateKeyAndSalt(required string secret)	{

		var rt = {}

		rt.Salt = generateSecretKey("AES", 256)
		rt.Key = hashPassword(arguments.secret, rt.Salt)

		return rt
	}
</cfscript>