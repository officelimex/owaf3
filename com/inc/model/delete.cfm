<cfscript>

	public void function Trash()	{

		transaction action='begin'	{

			var qInsert = buildInsertQuery('deleted_' & this.table_name)
			//abort serializejson(this[this.key])
			var rt = qInsert.execute()
			var q ='';
			var child_item = '';

			// move child items {has many}
			if(this._relationship.hasmany.len())	{
				loop array=this._relationship.hasmany item='sub_item'	{
					child_item = model(sub_item);
					q = child_item.findAll(where=this._pk_field & '=' & this.getKeyValue())
					loop query=q	{
						model(sub_item).findByKey(q[child_item._pk_field]).Trash()
					}
				}
			}

			// delete from database
			this.delete()

		}

	}

	public void function delete(string id=this.getKeyValue())	{
		
		var oparam = ""
		if(this.TenantId != 0)	{
			oparam = " AND TenantId = #this.TenantId#"
		}
		try {
			query 	{
				echo('DELETE FROM `#this.table_name#` WHERE `#this._pk_field#` = "#arguments.id#" #oparam#')
			}
			clearCache()
		}
		catch(Any e) {
			abort 'You can not delete this record because it is associated with other records. You have to delete those records first in order to delete this record'
		}

	}

	public void function deleteAll(required string where)	{

		var oparam = ""
		if(this.TenantId != 0)	{
			oparam = " AND TenantId = #this.TenantId#"
		}
		//TODO: secure where clause
		query 	{
			echo('DELETE FROM `#this.table_name#` WHERE #arguments.where# #oparam#')
		}

		clearCache()
	}

	public void function deleteAllInKey(required string keys)	{
		
		var oparam = ""
		if(this.TenantId != 0)	{
			oparam = " AND TenantId = #this.TenantId#"
		}
		if(trim(arguments.keys) != "")	{

			query 	{
				echo('DELETE FROM `#this.table_name#` WHERE #this._pk_field# IN (#arguments.keys#) #oparam#')
			}
			clearCache()
		}
	}

	private any function buildInsertQuery(string table_name = this.table_name)	{

		var qInsert = new Query();

		var sql_ = "INSERT INTO " & arguments.table_name & " SET "
		// move item to tash table
		loop list=variables.columns item='col'	{
			sql_ = listAppend(sql_, col & " = :" & col, ", ");
			if(this.fields[col].default is 'NULL' and this.fields[col].type is 'cf_sql_int' and (this[col] is "" or this[col] is 0))	{
				qInsert.addParam(name = col, null='yes');
			}
			else 	{
				qInsert.addParam(name = col, value = this[col], cfsqltype = this.fields[col].type);
			}
		}
		sql_ = replace(sql_,"SET ,","SET ");

		qInsert.setSql(sql_);

		return qInsert;
	}

</cfscript>