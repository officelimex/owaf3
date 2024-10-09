<cfscript>

	public any function saveData(required struct fr)	{

		return this.new(arguments.fr).save()
	}

	public void function updateAll(required struct data, required string where, string joins)	{

		var qInts = new Query()
		qInts.setDatasource(this.datasource)
		var sql='UPDATE `' & this.table_name & '` #arguments.joins# SET '
		var fld  = ''
		loop collection=arguments.data index='a' item='b'	{
			if(ListLen(a,'.') > 1)	{
				a = ListFirst(a, '.') & "." & ListLast(a, '.')
			}
			else {
				a = "`#a#`"
			}
			fld = listAppend(fld, '#a#="#b#"')
		}

		if(IsDefined("this.TenantId") && this.TenantId != 0)	{

			arguments.where = '#arguments.where# AND (#this.getTableAlias()#.TenantId=#this.TenantId#)'

		}

		qInts.setSql('#sql# #fld# WHERE #arguments.where#').execute()

		clearCache()
	}

	/*Save directly to the database
	public any function saveDirect(required string field, required any value)	{
		query 	{
			echo('UPDATE ' & this.table_name & ' SET ' & arguments.field & '=' & arguments.value & ' WHERE ' & this.key & '=' & getKeyValue() )
		}

		clearCache()
	}*/

	public void function saveDirect(required struct data_)	{

		var qInts = new Query(datasource=this.datasource)

		var sql='UPDATE `' & this.table_name & '` SET '
		var fld  = ''
		loop collection=arguments.data_ index='a' item='b'	{
			fld = listAppend(fld, '`' & a &'`=' & b)
		}
		//abort getKeyValue()
		qInts.setSql(sql & fld & ' WHERE ' & this._pk_field & '=' & getKeyValue()).execute()

		clearCache()
	}



	/* @modifiedbyuserid */
	public any function save(struct versionData={}, boolean ignore_duplicate = false)	{
		// check if the model is already in the db
		var local = {}
		// save the modifiedbyuserid to this struct
		variables.VersionData = arguments.versionData

		if(modelDataExists())	{
			local.this = update()
		}
		else 	{
			local.this = create(arguments.ignore_duplicate)
		}

		clearCache()

		//do versioning here
		if(variables.versioning_is_enabled)	{

			insertHistoryData(local.this)

		}

		return duplicate(local.this)
	}

	public any function saveWithOutHistory()	{

		var local = {}

		if(modelDataExists())	{
			local.this = update()
		}
		else 	{
			local.this = create()
		}

		return duplicate(local.this)
	}

	/*
		insert the data into the database
	*/
	private any function create(boolean ignore_duplicate = false)	{

		var local = {}

		if(arguments.ignore_duplicate)	{
			local.rt = updateInsertQuery("INSERT IGNORE")
		}
		else 	{
			local.rt = updateInsertQuery("INSERT")
		}

		// BUGTOFIX: for table that don't have generated_key
		try {
			return this.findByKey(local.rt.getPrefix().GeneratedKey)
		} catch (any e) {
			//abort serializeJSON(local.rt.getPrefix())
			return this
		}

		//return local.mdl
	}

	private any function insertHistoryData(required any model_insert_from)	{

		var local = {}

		//local.history = model(variables.model_path & this.table_name & 'History')
		if(variables.model_history_name == "")	{
			local.history = model(variables.model_path & this.table_name & 'History')
		}
		else {
			local.history = model(variables.model_path & variables.model_history_name)
		}
		local.qInts = new Query(datasource=this.datasource)

		local.item_to_update = ''
		loop list=local.history.getcolumns() item="col"	{

			if(structKeyExists(arguments.model_insert_from,col))	{
				local.item_to_update = listAppend(local.item_to_update, "`" & col & "` = :" & col, ", ")
				if((arguments.model_insert_from.fields[col].type == 'cf_sql_int') && (arguments.model_insert_from[col] == "" || arguments.model_insert_from[col] == 0))	{
					local.qInts.addParam(name = col, null='yes')
				}
				else 	{
					local.qInts.addParam(name = col, value = arguments.model_insert_from[col], cfsqltype = arguments.model_insert_from.fields[col].type)
				}
			}

		}

		// insert special version data here

		loop collection=variables.VersionData item="_value" index="_fld"	{

			local.item_to_update = listAppend(local.item_to_update, "`" & _fld & "` = :" & _fld, ", ")
			if(isNumeric(_value))	{
				local.qInts.addParam(name = _fld, value = _value, cfsqltype = 'cf_sql_int')
			}
			else 	{
				local.qInts.addParam(name = _fld, value = _value, cfsqltype = 'cf_sql_varchar')
			}

		}

		local.sql_ = 'INSERT INTO ' & this.table_name & '_history SET ' & local.item_to_update
		//bort local.sql_
		local.qInts.setSql(local.sql_).execute()
	}

	/* update the data in the database */
	private any function update()	{

		updateInsertQuery("UPDATE")
		var local.mdl = findByKey(getKeyValue())

		return local.mdl
	}

	/* set the param of the sql insert/update query */
	private any function updateInsertQuery(required string update_type) {

		var tbl_ = ' `' & this.table_name & '`'
		var sql_ = " " & tbl_ & " SET "
		var item_to_update = ''
		var qInts = new Query(datasource=this.datasource)
		var sql_where_c = ""
		if(findNoCase("INSERT", arguments.update_type))	{
			sql_ = arguments.update_type & " INTO " & sql_
		}
		else 	{
			sql_where_c = " WHERE " & this._pk_field & " = " & getKeyValue()
			sql_ = arguments.update_type & sql_
		}

		loop list=variables.columns item="col"	{
			// dont add primary key in the list
			if(col != this._pk_field)	{
				// loop true key that exist on the form itself
				if(structKeyExists(this, col))	{

					// check if the col is in field also
					if(structKeyExists(this.fields, col))	{
						item_to_update = listAppend(item_to_update, "`" & col & "` = :" & col, ", ")

						if((this.fields[col].default == "NULL" || this.fields[col].default == "") && this.fields[col].type == 'cf_sql_int' && val(this[col]) == 0)	{
							qInts.addParam(name = col, null='yes')
						}
						else 	{
							qInts.addParam(name = col, value = this[col], cfsqltype = this.fields[col].type)
						}
						// validate field {server side}
						// check for required field
						if(listFindNoCase(this.fields[col].validate,'required',''))	{
							if(len(this[col]) == 0)	{
								abort showerror = col & " field is required"
							}
						}
					}
				}
			}
		}

		// remove excess "," after SET
		sql_ = sql_ & item_to_update & sql_where_c

		if(trim(item_to_update) != "")	{
			qInts.setSql(sql_)
			var rt = qInts.execute()
			clearCache()
		}
		else 	{
			var rt = ""
		}

		return rt
	}

	/* create a new instance of the model an populate it with its data */
	public any function new(frm)	{

		if(this.TenantId != 0) 	{arguments.frm.TenantId = this.TenantId}

		if(isQuery(frm))	{
			setColumns(query=arguments.frm)
		}
		else {
			for (var x in arguments.frm)	{
				
				if(left(x, 4) == '___$')	{
					var col = decrypt(replace(x,'___$',''), application.awaf.secretKey, 'AES/CBC/PKCS5Padding', 'Hex')
					arguments.frm[col] = decrypt(frm[x], application.awaf.secretKey, 'AES/CBC/PKCS5Padding', 'Hex')
				}
			}
			setColumns(struct=arguments.frm)
		}

		return duplicate(this)
	}

	/* @fields: the fields to toggle */
	public void function toggle(required string fields)	{

		var sql_ = "UPDATE " & this.table_name & " SET "
		var opp = ""
		loop list=arguments.fields item="fld"	{
			opp = this[fld] is "yes" ? "no" : "yes"
			sql_ = listAppend(sql_,fld & "=" & "'#opp#'")
		}
		sql_ = sql_ & " WHERE #this.key# = #getKeyValue()#"
		sql_ = replace(sql_,'SET ,','SET ')
		query 	{
			echo(sql_)
		}
		// set fields update in this
		loop list=arguments.fields item="fld"	{
			this[fld] = this[fld] is "yes" ? "no" : "yes"
		}

		clearCache()

	}

	public void function $replace(required string fieldName, required string Value, required string where)	{

		var sql_ = "UPDATE " & this.table_name & " SET "

		sql_ = sql_ & arguments.fieldName & " = " & arguments.Value
		sql_ = sql_ & " WHERE " & arguments.where

		query 	{
			echo(sql_)
		}

	}

</cfscript>