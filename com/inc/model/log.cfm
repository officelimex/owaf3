<cfscript>

	public void function $log(numeric key = 0, numeric tenantid, numeric userid, required string event, string info, string ref = "")	{

	 	_id = getKeyValue()
		
		/*if(local._id == 0)	{
			local._id = arguments.key
		}*/
		if(arguments.key != 0)	{
			_id = arguments.key
		}
	
		_modelId = _tenantId = 0
		if(IsDefined("this.MODEL_ID"))	{
			_modelId = this.MODEL_ID
		}
		if(isDefined("request.user.tenant.id"))	{
			_tenantId = request.user.tenant.id
		}
		else {
			_tenantId = arguments.tenantId
		}
		if(isDefined("request.user.userid"))	{
			arguments.userid = request.user.userid
		}

		model(application.model.LOG).new({
			TenantId : _tenantId,
			IP       : cgi.REMOTE_ADDR,
			URL      : listLast(cgi.REQUEST_URL,'?'),
			Browser  : cgi.HTTP_USER_AGENT,
			ModelId  : _modelId,
			Event    : arguments.event,
			Info     : arguments.info,
			Key      : _id,
			UserId   : arguments.userid,
			Ref      : arguments.ref
		}).save()

	}

</cfscript>