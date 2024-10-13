<cfscript>

	public query function $count(string field_to_count, string fields, string where='', string group = '', order='')	{

		if(arguments.fields neq '')	{
			arguments.fields = ',' & arguments.fields
		}
		arguments.field_to_count = this._pk_field

		return runQuery('
			SELECT COUNT(#arguments.field_to_count#) AS `result` #arguments.fields# FROM #this.table_name#
			#this.SQL_JOIN#
			#buildWhereClause(arguments.where)#
			#buildGroupClause(arguments.group)#
			#buildOrderClause(arguments.order)#
		')
	}

	public query function $avg(required string field, string fields, string where='', string group = '', order='')	{

		if(arguments.fields neq '')	{
			arguments.fields = ',' & arguments.fields
		}

		buildSelectClause()

		return runQuery('
			SELECT AVG(#arguments.field#) AS `result` #arguments.fields# FROM #this.table_name#
			#this.SQL_JOIN#
			#buildWhereClause(arguments.where)#
			#buildGroupClause(arguments.group)#
			#buildOrderClause(arguments.order)#
		')
	}

	public numeric function $sum(required string field, any where='', string group = '')	{

		if(IsArray(arguments.where))	{
			var q = runSecureQuery(
				sql 	: buildOnlySelectClause('SUM(' & arguments.field & ')AS s'),
				where 	: arguments.where,
				group 	: buildGroupClause(arguments.group)
			)
		}
		else	{
			var q = runQuery(
				buildOnlySelectClause('SUM(' & arguments.field & ')AS s') &
				buildWhereClause(arguments.where) & ' ' &
				buildGroupClause(arguments.group)
			)
		}

		return val(q.s)
	}

	public string function $max(required string field, string where='', boolean cast = false)	{

		if(arguments.cast)	{
			var fld_name = "MAX(CAST(#arguments.field# as UNSIGNED)) m "
		}
		else {
			var fld_name = "MAX(#arguments.field#) m "
		}
		var q = runQuery('SELECT #fld_name# FROM `#this.table_name#` #buildWhereClause(arguments.where)#')

		return q.m
	}

	public string function $min(required string field, string where='')	{

		var q = runQuery('SELECT MIN(' & arguments.field & ') AS m FROM `' & this.table_name & '` ' & buildWhereClause(arguments.where))

		return q.m
	}

</cfscript>