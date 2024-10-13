<cfscript>

	/*
		@model_desc: the description of a mode "model_name table_name table_alias"
		@parent_model_desc: the description of a mode "model_name table_name table_alias"
		@must_include: include another table inside the query
		@multiple_field: 1 - forgin key with 1 value, 2 - for forign key with more thank one fields
	*/
	public void function belongsTo(required string model_desc)	{

		var mObj = Model(arguments.model_desc);
		var t1 = structNew();

		t1.columns = mObj.getSQLColumns();
		t1.table_name = mObj.table_name;
		t1.sql = "SELECT " & t1.columns & " FROM " & t1.table_name & " " & mObj.getTableAlias();

		this._relationship.belongsTo[t1.table_name] = t1;
	}

	public void function hasMany(required string model_name)	{

		this._relationship.hasmany.append(singularize(arguments.model_name));
		this['get' & listlast(arguments.model_name,'.')] = this.$get;

	}

	/*
		@foreign_key: the key on the main table
		@may_include: use this to link another table to this one [LEFT JOIN]
		@must_include: use this to link another table to this one [INNER JOIN]
	*/
	public void function mayHaveOne(required string model_desc, string foreign_key='', boolean deep_rel=false)	{

		var table = buildRelationshipVariables(arguments.model_desc, arguments.foreign_key, 'LEFT', deep_rel);

		appendTableToRelationship(table);

	}

	private void function appendTableToRelationship(required struct tbl)	{

		if(!this._relationship.hasone.find(arguments.tbl))	{
			this._relationship.hasone.append(arguments.tbl)
		};

	}
	/*
		@foreign_key: the key on the main table
	*/
	public void function mustHaveOne(required string model_desc, string foreign_key='', boolean deep_rel=false)	{

		var table = buildRelationshipVariables(arguments.model_desc, arguments.foreign_key, 'INNER', arguments.deep_rel)

		appendTableToRelationship(table);

	}

	private struct function buildRelationshipVariables(required string model_desc,string foreign_key='', required string join_type, boolean deep_rel)	{

		var arg = getModelDefaultParam(arguments.model_desc);
		var objModel = Model(arguments.model_desc);

		var table = {}

		table.model_name = arg.model_name;
		table.table_name = objModel.table_name;
		table.table_alias = objModel.getTableAlias();
		table.model_desc = arguments.model_desc;
		table.key = objModel.Key;
		table.fkey = arguments.foreign_key;
		if(arguments.foreign_key is '')	{
			table.fkey = objModel.Key;
		}

		table.sql_columns = '';
		loop list=objModel.getSQLColumns() item='local.field'	{
			table.sql_columns = listAppend(table.sql_columns, local.field & " AS " & replace(local.field,'.','_'));
		}

		table.join_type = arguments.join_type;

		if(arguments.deep_rel)	{
			table.include = arrayNew(1);
			objModel.buildrelationships(true)
			if(IsDefined("objModel._relationship"))	{
				loop array=objModel._relationship['hasOne'] item='local.include'	{

					if(isstruct(local.include))	{

						table.include.append(buildJoinProperties(include.model_desc, local.include.fkey, local.include.join_type ));

					}
				}
			}
		}

		return table;
	}

	private struct function buildJoinProperties(required string model_desc, string foreign_key='', string join_type ='LEFT')	{
		var arg = getModelDefaultParam(arguments.model_desc);
		var objModel = Model(arguments.model_desc);
		var table = structnew();

		table.model_name = arg.model_name;
		table.table_name = objModel.table_name;
		table.table_alias = objModel.getTableAlias();
		table.model_desc = arguments.model_desc;
		table.key = objModel.Key;
		table.join_type = arguments.join_type;
		table.fkey = arguments.foreign_key;
		if(arguments.foreign_key is '')	{
			table.fkey = objModel.Key;
		}

		table.sql_columns = '';
		loop list=objModel.getSQLColumns() item='local.field'	{
			table.sql_columns = listAppend(table.sql_columns,local.field & " AS " & replace(local.field,'.','_'));
		}

		return table
	}

	public any function join(required string model_desc, string foreign_keys = '', boolean deep_rel = false)	{

		fk_len = listlen(arguments.foreign_keys);
		loop list=arguments.model_desc item='local.modl' index='local.x'	{
			local.fk = ''
			if(fk_len gte local.x)	{
				local.fk = listgetat(arguments.foreign_keys, local.x)
			}
			mustHaveOne(local.modl, local.fk, arguments.deep_rel)
		}

		return this
	}

	public any function ljoin(required string model_desc, string foreign_keys = '', boolean deep_rel = false)	{

		var fk_len = listlen(arguments.foreign_keys);
		loop list=arguments.model_desc item='local.modl' index='local.x'	{
			local.fk='';
			if(fk_len gte local.x)	{
				local.fk = listgetat(arguments.foreign_keys, local.x)
			}
			mayHaveOne(local.modl, local.fk, arguments.deep_rel)
		}

		return this
	}

</cfscript>