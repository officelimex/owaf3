component 	{

	private void function _connect(required string ds)	{
		cfdbinfo(
			name="application.#arguments.ds#.#this.table_name#",
			dbname = this.datasource,
			table = this.table_name,
			type = "columns"
			datasource = this.datasource
		)
	}
	/*
		@model_path: this is used in the versioning
	*/
	public Model function init(
		required string table_name = '',
				string order = '',
				string custome_select_clause = '',
				string model_path = '',
				string datasource = application.datasource.main,
				numeric tenantid = 0)	{

		this.table_name = lcase(arguments.table_name)
		this.datasource = arguments.datasource

		this.Tenantid = arguments.tenantid

		this.where_clause = []
		this.sql_join = ""
		// reolve the table name and get table alias
		variables.table_alias = listLast(this.table_name, " ")
		variables.custome_select_clause = trim(arguments.custome_select_clause)
		this.table_name = listFirst(this.table_name, " ")

		//get all columns in the model
		// dbname = this.datasource,

		if(application.owaf.mode == 1)	{
			_connect(arguments.datasource)
		}
		else {
			if(!IsDefined("application.#this.datasource#.#this.table_name#") ) 	{
				_connect(arguments.datasource)
			}
		}

		local.table_structure = application[this.datasource][this.table_name]

		variables.columns = valueList(local.table_structure.COLUMN_NAME)
		variables.cacheTimeSpan = createTimeSpan(0, 6, 0, 0)

		// build sql select
		variables.sql_select = ""

		loop list="#variables.columns#" item="local.col"	{
			variables.sql_select = listAppend(variables.sql_select, variables.table_alias & "." & local.col)
		}

		var qp = local.table_structure.filter(function(row, rowNumber, qryData){
			return arguments.qryData.IS_PRIMARYKEY == 'YES'
		})

		this._pk_field = qP.COLUMN_NAME
		this.KEY = this._pk_field

		// use this to store related info not in the DB

		// relationship variables
		this._relationship.hasOne = arrayNew(1)
		this._relationship.hasMany = arrayNew(1)

		// return all queries from finders here
		variables.finder_result = ""

		//settings
		variables.versioning_is_enabled = false
		variables.order = arguments.order
		//variables.model_history_name = arguments.model_history_name
		if(arguments.model_path is not '')	{
			variables.model_path = arguments.model_path & '.'
		}
		else 	{
			variables.model_path = ''
		}

		// functions
		this.log = this.$log;
		this.Avg = this.$avg
		this.Max = this.$max
		this.Min = this.$min
		this.Sum = this.$sum
		this.Count = this.$count
		this.Find = this.findByKey
		this.$find = this.findByKey
		this.FindIn = this.findByKeyIn
		this.IsEmpty = this.$isEmpty
		this.keyExists = this.fieldExists
		this.PrimaryKey = this._pk_field
		this.findLast = this.$findlast

		return this
	}

	/* check if primary key value exist */
	public boolean function $isEmpty()	{

		var rt =false
		if(this.getKeyValue() is 0)	{
			rt = true
		}

		return rt
	}

	public any function getModelInfo()	{

		return this
	}

	/* check if the field exist */
	public boolean function fieldExists(required string filed_name)	{

		var rt = false
		if(listFindNocase(variables.columns, filed_name))	{
			rt = true
		}

		return rt
	}

	public void function EnableVersioning(string model_name = "")	{

		variables.versioning_is_enabled = true
		variables.model_history_name = arguments.model_name
		variables.model_history_path = variables.model_path & this.table_name & 'history'

		if(arguments.model_name != "")	{
			variables.model_history_path = variables.model_path & variables.model_history_name
		}

	}

	/* set the fields of the object using a query or struct */
	private void function setColumns(query query, struct struct = {})	{

		if(arguments.struct.isEmpty())	{
			// use query to build the column value
			loop list=variables.columns item="col"	{

				if(isDefined("arguments.query[col]"))	{
					this[col] = trim(arguments.query[col])
					setfield(col)
				}

			}
		}
		else {
			// use struct to build the column value : this is from the method in the controller
			loop list=variables.columns item="col"	{

				// check if field exist in struct

				if(arguments.struct.keyExists(col))	{
					this[col] = trim(arguments.struct[col])

					setfield(col)
				}
				else 	{//set field that does not exist in the struct
					//this[col] = ''
				}

				//setfield(col)

			}

		}
	}

	private void function setfield(required string col)	{
		// set other details about the field
		this.fields[arguments.col] = getFieldInfo(arguments.col)
		// make fields easily accesible
		switch(this.fields[arguments.col].type) 	{
			case "cf_sql_int": case "cf_sql_decimal":
				if(this[arguments.col] is '') {
					this[arguments.col]=val(this.fields[arguments.col].default);
				}
				else if(this[arguments.col] is 'NULL')	{
					this[arguments.col]=0;
				}
				else {
					this[arguments.col] = replace(this[arguments.col],',','','all');
				}
			break;
			case "cf_sql_date":
				this[arguments.col] = dateFormat(this[arguments.col],'yyyy-mm-dd');
			break;
			case "cf_sql_datetime":
				this[arguments.col] = dateFormat(this[arguments.col],'yyyy-mm-dd') & " " & timeFormat(this[arguments.col],'hh:mm tt');
			break;
			case "cf_sql_varchar":
				this[arguments.col] = this[arguments.col] is '' ? this.fields[arguments.col].default : this[arguments.col];
				if(this[arguments.col] is 'NULL') {this[arguments.col] = '';}
			break;
		}
	}

	/* set columns from other tables join with this one */
	private void function setJoinedColumns()	{

		var fld_name = ''

		loop array=this._relationship.hasone item="relation_ship"	{
			loop list=relation_ship.sql_columns item="col"	{

				fld_name = replace( listlast(col,' '),'.','_','all' )
				this[relation_ship.table_alias][listlast(fld_name,'_')] = variables.finder_result[fld_name]

			}
			// add included table
			if(isDefined("relation_ship.include"))	{
				loop array=relation_ship.include item="inc"	{
					loop list=inc.sql_columns item="col"	{

						fld_name = replace( listlast(col,' '),'.','_','all' )
						this[relation_ship.table_alias][listlast(inc.model_name,'.')][listlast(fld_name,'_')] = variables.finder_result[fld_name]

					}
				}
			}
		}

	}

	private struct function getFieldInfo(required string column)	{

		var q = application[this.datasource][this.table_name].filter(function(row, rowNumber, qryData){
			return arguments.qryData.COLUMN_NAME == '#column#'
		})
		var val_ = {}
		val_.default = q.NULLABLE is 0 ? q.COLUMN_DEFAULT_VALUE : "NULL";
		val_.type = getColdfusionDataType(q.TYPE_NAME);
		val_.validate = q.REMARKS;
		if(!q.IS_NULLABLE)	{
			val_.validate = listAppend(val_.validate,"required",";")
		}

		return val_;
	}

	private string function getColdfusionDataType(required string type)	{
		var rt = "";

		switch(arguments.type){
			case "INT": case "MEDIUMINT": case "BIGINT": case "SMALLINT": case "TINYINT":
				rt = "int";
			break;
			case "INT UNSIGNED": case "MEDIUMINT UNSIGNED": case "BIGINT UNSIGNED": case "SMALLINT UNSIGNED": case "TINYINT UNSIGNED":
				rt = "int";
			break;
			case "FLOAT": case "DECIMAL": case "REAL": case "DOUBLE":
				rt = "decimal";
			break;
			case "FLOAT UNSIGNED": case "DECIMAL UNSIGNED": case "REAL UNSIGNED": case "DOUBLE UNSIGNED":
				rt = "decimal";
			break;
			case "DATE":
				rt = "date"
			break;
			case 'TIMESTAMP': case 'DATETIME':
				rt = 'timestamp';
			break;
			case "TIME":
				rt = "time";
			break;
			default:
				rt="varchar";
			break;
		}
		return "cf_sql_" & rt;
	}


	private boolean function modelDataExists()	{

		// check if model have a pk field ;
		var rt = false
		if(this._pk_field == "")	{
			rt = false
		}
		else 	{
			query name="mE" cachedwithin=variables.cacheTimeSpan datasource=this.datasource	{
				echo("
					SELECT * FROM `#this.TABLE_NAME#` WHERE #this._pk_field# = #getKeyValue()#"
				)
			}
			if(mE.recordcount)	{
				rt = true
			}
		}

		return rt
	}

	include "inc/model/log.cfm"

	include "inc/model/relationship.cfm"

	include "inc/model/finders.cfm"

	include "inc/model/update.cfm"

	include "inc/model/delete.cfm"

	include "inc/model/statistics.cfm"

	include "inc/model/history.cfm"

	include "inc/model/secure.cfm"

	include "inc/model/helper.cfm"

	include "inc/function.cfm"

	/* return the value of the primary key */
	private numeric function getKeyValue()	{

		var rt = 0
		if (isDefined('this[this._pk_field]'))	{
			rt = this[this._pk_field]
		}
		return val(rt)
	}

	public string function getColumns()	{

		return variables.columns
	}

	public string function getTableAlias()	{

		return variables.table_alias
	}

	public string function getSQLColumns()	{

		return variables.sql_select
	}

	private any function runQuery(required string sql)	{

		local.rt = ''
		//abort CreateTimeSpan(0, 6, 0, 0)
		switch(left(trim(arguments.sql),4))	{
			case 'SELE':
			case 'WITH':
				query name='local.rt' cachedwithin=variables.cacheTimeSpan datasource=this.datasource	{
					echo(arguments.sql)
				}
			break;
		}

		return local.rt
	}

	public any function runSecureQuery(required string sql, string joins = '', any where = [], string group='', string order='', string having='', string limit='')	{

		local.rt = ''
		if(arguments.limit != '')	{
			arguments.limit = "#arguments.limit#"
		}
		//abort variables.cacheTimeSpan
		switch(left(trim(arguments.sql),6))	{
			case 'SELECT':
				if(len(arguments.where) > 1)	{
					if(arguments.where[1].len())	{
						if(this.TenantId)	{
							arguments.where[1] = " WHERE (" & arguments.where[1] & ") AND #this.table_name#.TenantId = #this.TenantId#"
						}
						else {
							arguments.where[1] = " WHERE " & arguments.where[1]
						}
					}

					local.rt = queryExecute(
						arguments.sql & arguments.joins  & arguments.where[1] & arguments.group & arguments.having & buildOrderClause(arguments.order) & arguments.limit,
						arguments.where[2],
						{datasource = this.datasource, cachedwithin = variables.cacheTimeSpan}
					)
				}
				else { // no where clause
					if(this.TenantId)	{
						arguments.where = " WHERE #this.table_name#.TenantId = #this.TenantId#"
					}

					local.rt = queryExecute(
						arguments.sql & arguments.joins & arguments.where & arguments.group & arguments.having & arguments.order & arguments.limit,
						{datasource = this.datasource, cachedwithin = variables.cacheTimeSpan}
					)
				}
			break;
		}

		return local.rt

		this.where_clause = []
	}

	private string function buildSecureWhereClause(array wc)	{

		local.rt = ''

		if(arguments.wc.Len())	{
			local.rt = ' WHERE '
			loop array=arguments.wc item="x" index="i"	{
				local.rt  = local.rt & x.f & x.o & ":" & listLast(x.f,'.') & i
			}
		}

		return local.rt
	}

	// use this function to get the model name, table name and alias
	private struct function getModelDefaultParam(required string model_desc)	{

		var mod_desc = structNew()
		switch(listLen(arguments.model_desc," "))	{
			case 1: // model name only
				mod_desc.model_name = arguments.model_desc
				mod_desc.table_name =  arguments.model_desc
			break;
			case 2: // model and table
				mod_desc.model_name = mod_desc.table_name = listFirst(arguments.model_desc," ")
				mod_desc.table_name = mod_desc.table_name & " " & listLast(arguments.model_desc," ")
			break;
			case 3: // model and table and table alias
				mod_desc.model_name = listFirst(arguments.model_desc," ")
				mod_desc.table_name = listGetAt(arguments.model_desc,2, " ") & " " & listLast(arguments.model_desc," ")
			break;
		}
		if(mod_desc.model_name eq mod_desc.table_name)	{
			mod_desc.table_name = ''
		}
		mod_desc.table_name = listlast(mod_desc.table_name,'.')

		return mod_desc;
	}

	public any function buildRelationships(boolean deep_rel=false)	{

		return this
	}

	public string function toString()	{

		var _rt = {}
		//TODO :: Protect some columns from the public
		loop list=variables.columns item='x'	{

			//if((trim(this[x]) != "") or (val(this[x]) == 0))	{
			if(IsDefined("this[x]"))	{
				_rt[x] = this[x]
			}
			//}

		}

		_rt["KEY"] = this.getKeyValue()

		return serializeJSON(_rt)
	}

}