<cfscript>

	public numeric function getCurrentVersion()	{

		var rt = runQuery('SELECT COUNT(*) C FROM ' & this.table_name & '_history WHERE ' & this._pk_field & '=' & getKeyValue())

		return val(rt.C)
	}

	public query function getVersions()	{

		//var qtemp = runQuery('SELECT * FROM ' & this.table_name & '_history WHERE '
		//		& this.Key & '=' & getKeyValue() & ' ORDER BY Modified')
		// TODO: Find a way to get the model name, just like table-name
		var v = {}
		v.history_doc = model(variables.model_history_path)
		var qtemp = v.history_doc.Findall(
			where : v.history_doc.getTableAlias() &'.'&this._pk_field&'='&getKeyValue(),
			order : v.history_doc.getTableAlias() & '.modified DESC '
		)

		return qtemp
	}

	public query function getLastVersion()	{

		//var qtemp = runQuery('SELECT * FROM ' & this.table_name & '_history WHERE '
		//		& this.Key & '=' & getKeyValue() & ' ORDER BY Modified')
		// TODO: Find a way to get the model name, just like table-name
		var v = {}
		v.history_doc = model(variables.model_history_path)
		var qtemp = v.history_doc.Findall(
			where : v.history_doc.getTableAlias() &'.'&this._pk_field&'='&getKeyValue(),
			order : v.history_doc.getTableAlias() & '.modified DESC ',
			limit : '0,1'
		)

		return qtemp
	}

</cfscript>