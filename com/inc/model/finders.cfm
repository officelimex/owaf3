<cfscript>

	/*
		query = object.Where([
			field : "object.Status"
			operator : "="
			value : "Open"
			type : "varchar",
			and : {
				field :
			}
			or : {

			}
		]).findAll()
		x = y or j = b
		query = object.Where({f:"Object", a:"=", v:"sds"}).Or().And().Between()Join()

	*/
	public any function where(required struct clause)	{

		//cfparam(name="arguments.clause.f", default="")
		cfparam(name="arguments.clause.o", default="=") // =, >, <, IN, LIKE etc
		//cfparam(name="arguments.clause.v", default="")
		cfparam(name="arguments.clause.t", default="varchar")

		this.where_clause.Append(arguments.clause)
 
		return this
	}

	/* get list of ids and names in a table */
	public struct function getList(string name="Name", string pk = this._pk_field, any where = '', string delimiters = '`', string order = '', string limit = '', string group = '', select = '', string joins = '')	{

		var rt = {
			ids 	: "",
			names 	: ""
		}

		var q = this.findAll(joins : arguments.joins, where: arguments.where, limit: arguments.limit, order: arguments.order, group : arguments.group, select : arguments.select)

		for(x in q)	{
			v = ""
			loop list="#arguments.name#" item="nm"	{
				v = listAppend(v, x[trim(nm)], " ")
			}
			if(trim(v) == "")	{
				v = "-"
			}

			rt.ids = listAppend(rt.ids, x[arguments.pk], arguments.delimiters)
			rt.names = listAppend(rt.names, v, arguments.delimiters)
		}

		return rt
	}

	public struct function getActiveList(string name="Name", string pk = this._pk_field, any where = '', string delimiters = '`', string order = '', string limit = '', string group = '', select = '', string joins = '')	{

		arguments.where = ['#this.getTableAlias()#.IsActive = "Yes"',{}]

		return getList(where: arguments.where)
	}

	public query function SelectQuery(string select_clause, string where='', string group = '', string order='')	{

		return runQuery('
			#buildSelectClause(arguments.select_clause)#
			#buildWhereClause(arguments.where)#
			#buildGroupClause(arguments.group)#
			#buildOrderClause(arguments.order)#
		')

	}

	/* find by key and return query  */
	public query function findQ(required string key, string select="")	{

		var nwc = ""
		if (IsDefined("this.TenantId"))	{
			if (this.TenantId)	{
				arguments.TenantId = this.TenantId
				nwc = " AND #this.getTableAlias()#.TenantId = :TenantId"
			}
		}
		if(arguments.select == "")	{
			var _sql = buildSelectClause()
		}
		else {
			var _sql = buildOnlySelectClause(arguments.select)
		}
		var qtemp = runSecureQuery(
			sql 		: _sql,
			where 	: ["#this.getTableAlias()#.#this._pk_field# = :key #nwc#", arguments]
		)

		return qtemp
	}

	// get the lst record in the table
	public query function $findLast(string key='', string where, string limit = '0,1')	{

		if(arguments.key == '')	{
			arguments.key = this._pk_field
		}

		var qtemp = runQuery(
			buildSelectClause() & " " & buildWhereClause(arguments.where) &
			" ORDER BY " & arguments.key & " DESC
			LIMIT #arguments.limit#"
		);

		return qtemp
	}

	/*
		todo --
		implement :
		findall(
			where: 'field_name=:variable_name', || ['field = ?','result']
			param: {type: varchar, value: variable_name, name : 'variable_name'}
		)
	*/
	public query function findAll(any where = '', string joins = '', string select='', string order='', string group='', string limit='', string having = '', string distinct='')	{

		if(arguments.order is '')	{
			arguments.order = variables.order;
		}

		if(arguments.select == "")	{
			var _stm = buildSelectClause(arguments.select, arguments.distinct)
		}
		else 	{
			var _stm = buildOnlySelectClause(arguments.select)
		}

		if(IsArray(arguments.where) || IsEmpty(arguments.where))	{

			var qtemp = runSecureQuery(
				sql 		: _stm & " " & arguments.joins,
				where 	: arguments.where,
				group 	: buildGroupClause(arguments.group),
				having  : buildHavingClause(arguments.having),
				order 	: buildOrderclause(arguments.order),
				limit 	: buildLimitClause(arguments.limit)
			)

		}
		else {

			var qtemp = runQuery(
				_stm & " " & arguments.joins & " " & 
				buildWhereClause(arguments.where) &
				buildGroupClause(arguments.group) &
				buildHavingClause(arguments.having) &
				buildOrderclause(arguments.order) &
				buildLimitClause(arguments.limit)
			)

		}

		return qtemp
	}

	public query function findAllActive(any where = ['#this.getTableAlias()#.IsActive = "Yes"',{}])	{

		return this.findAll(
			where : arguments.where
		)

	}

	public array function getAllIn(required string ids, string field = "Name")	{
		
		
		return this.findAll(where: ['#this._pk_field# IN (:id)', {
			id: {
				list	: true,
				value : arguments.ids
			}
		}]).columnData(arguments.field)
	}
	
	public query function findByKeyIn(required string keys,  string where ='',string select='', string order='', string group='')	{

		if(arguments.order is '')	{
			arguments.order = variables.order;
		}
 		// fix list;
		arguments.keys = listremoveduplicates(arguments.keys);
		arguments.keys = ArrayToList(ListToArray(arguments.keys));

		if (arguments.keys is "")	{
			arguments.keys = 0;
		}
		var where_clause = this._pk_field & ' IN (' &  arguments.keys &')';
		if(arguments.where is not '')	{
			where_clause = where_clause & ' AND ' & arguments.where;
		}

		var qtemp = runQuery(
			buildSelectClause(arguments.select) & buildWhereClause(where_clause) & buildOrderclause(arguments.order)
			& buildGroupClause(arguments.group)
		);

		return qtemp
	}

	/* find one */
	public Model function findOne(any where='')	{

		if(IsArray(arguments.where))	{

			var qtemp = runSecureQuery(
				sql 		: buildSelectClause(),
				where 	: arguments.where,
				limit 	: '0,1'
			)

		}
		else 	{

			var qtemp = runQuery(buildSelectClause() & buildWhereClause(arguments.where) & ' LIMIT 0,1')

		}
		variables.finder_result = qtemp
		setColumns(qtemp)
		setJoinedColumns()
		return duplicate(this)
	}

	/* find record by primary key */
	public any function findByKey(required string value, string key = '')	{

		//writeDump(this.relationship);

		if(arguments.key eq '')	{
			//set the default key
			arguments.key = this._pk_field;
		}

		//query name="qtemp"	{
		var qtemp = runQuery(
				buildSelectClause() & '
				WHERE ' & arguments.key & ' = ' & val(arguments.value) & '
				LIMIT 0,1
			');
		//}
		//this.finder_result = qtemp;
		variables.finder_result = qtemp
		//abort serializeJSON(qtemp)
		setColumns(query=qtemp)
		setJoinedColumns()

		//return duplicate(this)
		return this
	}

	/* build sql select clause */
	public string function buildOnlySelectClause(required string select)	{

		var sql_join = ""
		var sql_stm = arguments.select

		loop array=this._relationship.hasone item="local.relation_ship"	{
			// set foreign key
			if(local.relation_ship.fkey=='')	{
				local.relation_ship.fkey = local.relation_ship.key
			}
			// build join
			//sql_join = sql_join & " " & local.relation_ship.join_type & " JOIN " & local.relation_ship.table_name & " AS `" & local.relation_ship.table_alias & "` ON " & local.relation_ship.table_alias & "." &  local.relation_ship.key & " = " & variables.table_alias & "." & local.relation_ship.fkey
			if(listLen(local.relation_ship.table_name,' ') eq 2)	{
				sql_join = sql_join & " " & local.relation_ship.join_type & " JOIN " & local.relation_ship.table_name & " ON " & local.relation_ship.table_alias & "." &  local.relation_ship.key & " = " & variables.table_alias & "." & local.relation_ship.fkey
			}
			else 	{
				sql_join = sql_join & " " & local.relation_ship.join_type & " JOIN `" & local.relation_ship.table_name & "` AS `" & local.relation_ship.table_alias & "` ON " & local.relation_ship.table_alias & "." &  local.relation_ship.key & " = " & variables.table_alias & "." & local.relation_ship.fkey
			}

			// check for include and add
			if(isDefined("local.relation_ship.include"))	{
				loop array=local.relation_ship.include item="local.inc"	{
					// build join
					sql_join = sql_join & " " & local.inc.join_type & " JOIN `" & local.inc.table_name & "` AS `" & local.inc.table_alias & "` ON " & local.relation_ship.table_alias & "." &  local.inc.fkey & " = " & local.inc.table_alias & "." & local.inc.key

				}
			}

		}

		this.sql_join = sql_join

		return "SELECT " & arguments.select & " FROM `" & this.TABLE_NAME & "` AS `" & variables.table_alias & "` " & sql_join
	}

	/* build sql select clause */
	// base_sql : use this to clear the default sql the system will build
	public string function buildSelectClause(string select='', string distinct='', string base_sql = '-')	{

		var sql_join = '';
		var _sel = arguments.select
		if(_sel is '')	{
			_sel = variables.sql_select;
		}
		else 	{
			_sel = variables.sql_select & "," & _sel;
		}

		if(arguments.base_sql != '-')	{
			if(_sel == '')	{
				_sel = arguments.base_sql
			}
			else {
				_sel = arguments.select & "," & arguments.base_sql
			}

		}

		// add custom select from model
		if(variables.custome_select_clause is not '')	{
			_sel = _sel & ',' & variables.custome_select_clause;
		}

		if(arguments.distinct != '')	{
			_sel = 'DISTINCT ' & arguments.distinct & ',' & _sel;
		}

		// check the relationship and add it to the columns
		loop array=this._relationship.hasone item="relation_ship"	{
			_sel = listAppend(_sel, relation_ship.sql_columns);
			// set foreign key
			if(relation_ship.fkey=='')	{
				relation_ship.fkey = relation_ship.key;
			}
			// build join
			//sql_join = sql_join & " " & relation_ship.join_type & " JOIN " & relation_ship.table_name & " AS `" & relation_ship.table_alias & "` ON " & relation_ship.table_alias & "." &  relation_ship.key & " = " & variables.table_alias & "." & relation_ship.fkey;
			if(listLen(relation_ship.table_name,' ') eq 2)	{
				sql_join = sql_join & " " & relation_ship.join_type & " JOIN " & relation_ship.table_name & " ON " & relation_ship.table_alias & "." &  relation_ship.key & " = " & variables.table_alias & "." & relation_ship.fkey;
			}
			else 	{
				sql_join = sql_join & " " & relation_ship.join_type & " JOIN `" & relation_ship.table_name & "` AS `" & relation_ship.table_alias & "` ON " & relation_ship.table_alias & "." &  relation_ship.key & " = " & variables.table_alias & "." & relation_ship.fkey;
			}

			// check for include and add
			if(isDefined("relation_ship.include"))	{
				loop array=relation_ship.include item="inc"	{
					_sel = listAppend(_sel, inc.sql_columns);
					// build join
					sql_join = sql_join & " " & inc.join_type & " JOIN `" & inc.table_name & "` AS `" & inc.table_alias & "` ON " & relation_ship.table_alias & "." &  inc.fkey & " = " & inc.table_alias & "." & inc.key;

				}
			}

		}

		this.sql_join = sql_join;

		return "SELECT " & _sel & " FROM `" & this.TABLE_NAME & "` AS `" & variables.table_alias & "` " & sql_join;
	}

	/* get belongsto and hasmany items here */
	public query function get(required string relationship, required string table_name)	{

		//query name="qt"	{
			switch(arguments.relationship){
				case 'many':
					var rel = this._relationship.hasMany[arguments.table_name]
					if(rel.multiple_field)	{
						qt = runQuery(
							rel.sql &
							" WHERE " & rel.table_alias & "." & this._pk_field & "=" & getKeyValue()
						);
							//" WHERE " & rel.table_name & "." & this._pk_field & "=" & getKeyValue()
					}
					else 	{
						//writeDump(rel);
						qt = runQuery(
							rel.sql &
							" WHERE " & rel.table_name & "." & this._pk_field & "=" & getKeyValue()
						);
					}

				break;
				case 'belongsto':
					qt = runQuery(
						this._relationship.belongsTo[arguments.table_name].sql &
						" WHERE " &  this._pk_field & "=" & getKeyValue()
					);
				break;
			}
		//}

		return qt
	}

	/* get belongsto and hasmany items here */
	public query function $get(string select='')	{

 		var func_name = getFunctionCalledName();
 		var model_name = mid(func_name, 4, len(func_name)-3);
 		var s_model_name = singularize(model_name);
 		loop array=this._relationship.hasMany item="x"	{
 			if(listlast(x,'.') is s_model_name)	{
 				s_model_name = x;
 			}
 		}

		var qt = model(s_model_name).buildRelationships();
		var qt2 = qt.findAll(select=arguments.select, where= qt.table_name & '.' & this._pk_field & "=" & val(getKeyValue()));

		return qt2;
	}

	private string function buildWhereClause(string where="")	{

		var where_clause = '';

		// replace $this with the table name
		arguments.where = replaceNoCase(arguments.where, '$this', this.getTableAlias())
		
		if(arguments.where != '')	{
			where_clause = ' WHERE (#arguments.where#)';
		}

		if(this.TenantId != 0)	{

			if(where_clause == '')	{
				where_clause = 'WHERE #this.getTableAlias()#.TenantId=#this.TenantId#'
			}
			else {
				where_clause = where_clause & ' AND (#this.getTableAlias()#.TenantId=#this.TenantId#)'
			}
		}

		return where_clause
	}

	private string function buildOrderclause(string order='')	{

		var order_clause = ''
		if(arguments.order != '')	{
			if(findNoCase("ORDER BY", arguments.order))	{
				order_clause = arguments.order
			}
			else 	{
				order_clause = ' ORDER BY ' & arguments.order
			}
		}

		return order_clause
	}

	private string function buildGroupClause(string group='')	{

		var group_clause = ''
		if(trim(arguments.group) != '')	{
			group_clause = ' GROUP BY ' & arguments.group
		}

		return group_clause
	}

	private string function buildHavingClause(string h='')	{

		var h_clause = ''
		if(trim(arguments.h) != '')	{
			h_clause = ' HAVING ' & arguments.h
		}

		return h_clause
	}

	private string function buildLimitClause(string limit='')	{

		var ltm='';
		if(trim(arguments.limit) neq '')	{
			ltm = ' LIMIT ' & arguments.limit
		}

		return ltm;
	}

</cfscript>