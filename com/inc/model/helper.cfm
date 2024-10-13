<cffunction name="clearCache" retrun="void" access="private">
	<cfargument name="filter" default="#this.table_name#" type="string"/>

	<cfif arguments.filter is "">

		<cfobjectcache action="clear"/>

	<cfelse>

		<cfobjectcache action="clear" filter="*#arguments.filter#*"/>

	</cfif>

</cffunction>

<cffunction name="clearAllCache" retrun="void" access="private">

		<cfobjectcache action="clear"/>

</cffunction>

<cffunction name="dumpdata" retrun="void" access="private">
	<cfargument name="data" type="any"/>

	<cfquery>
		INSERT INTO `dump` set
			`DATA` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#serializejson(arguments.data)#"/>
	</cfquery>

</cffunction>

<cfscript>

	private string function pulralize(required string word)	{

		var last_letter = right(arguments.word, 1);
		var pl = '';

		switch(last_letter)	{
			case 'mdd':
				code;
			break;

			default:
				pl = 's';
			break;
		}

		return arguments.word & pl;
	}

	private string function singularize(required string word)	{

		var nword = arguments.word;
		if(reFindNoCase('s$', arguments.word))	{

			nword = reReplaceNoCase(arguments.word, 's$', '');
		}

		return nword;
	}

	public function isEmail(str) {

	   return (REFindNoCase("^['_a-z0-9-\+]+(\.['_a-z0-9-\+]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.(([a-z]{2,3})|(aero|asia|biz|cat|coop|info|museum|name|jobs|post|pro|tel|travel|mobi))$",
	arguments.str) AND len(listGetAt(arguments.str, 1, "@")) LTE 64 AND
	len(listGetAt(arguments.str, 2, "@")) LTE 255) IS 1;
	}

	public any function saveModelItem(required string model_desc, required string form_field, string fixed_field='', required struct form, struct versionData = structnew())	{

		var item_data = {}
		var item_model = model(arguments.model_desc)
		var action = action_ = '';
		var pkey=0;

		transaction {

			loop from=1 to=maxValueOfSubItemInForm(arguments.form.fieldnames) index='i'	{

				action_ = 'action_' & i;

				if(structKeyExists(arguments.form, action_))	{

					action = arguments.form[action_];
					if(structKeyExists(arguments.form,item_model.key & '_' & i))	{
						pkey = arguments.form[item_model.key & '_' & i];

					}
					//abort pkey;
					if(action is 'D')	{

						item_model.find(pkey).delete();

					}
					else 	{

						loop list=arguments.form_field item='field_item'	{
							item_data[field_item] = arguments.form[field_item & '_' & i];
						}

						// for fixed field
						loop list=arguments.fixed_field item='fixed_item'	{
							item_data[fixed_item] = arguments.form[fixed_item];
						}
						//if(structKeyExists(arguments.form,item_model.key & '_' & i))	{
						item_data[item_model.key] = pkey;
						//}
						//model(arguments.model_desc).new(item_data).save();
						//dumpdata(item_data);
						//abort 's';
						//abort serialize(arguments.form.dnid);
						item_model.new(item_data).save(arguments.versionData);
						//item_data = {}
					}

				}
			}


		}

		return item_model

	}

	public struct function updateFormParamOn(required string fr_value, struct struct_value)	{

		arguments.struct_value['fieldnames'] = listAppend(arguments.struct_value['fieldnames'], arguments.fr_value)

		loop list="#arguments.fr_value#" item="itm"	{
			_itm = trim(itm)
			cfparam(name="arguments.struct_value.#_itm#", default="No")
			
			if(arguments.struct_value[_itm] == "On")	{
				arguments.struct_value[_itm] = "Yes"
			}
			
		}

		return arguments.struct_value
	}

	public string function getWebsiteIcon(required string website)	{

		var rt = ""

		if(len(arguments.Website))	{
			cfhttp(method="GET", charset="utf-8", url="https://i.olsh.me/allicons.json?url=#arguments.Website#", result="result") { }			
			var r = deserializeJSON(result.filecontent)
			if(isdefined("r.icons"))	{
				if(r.icons.len())	{
					rt = r.icons[1].url
				}
			}
		}
		
		return rt
	}

	public string function saveImageToS3andGetContent(required string c)	{
		
		var cont = arguments.c
		// find all images in content 
		var imgs = reMatch('src\s*=\s*"(.+?)"', cont)
		for(img in imgs)	{
			

			img = replaceNoCase(img, 'src="', "")
			img = replaceNoCase(img, '="', "=")

			if(right(img,1) == '"')	{
				img = left(img, len(img)-1)
			}
			
			if(!findNoCase("https://", img))	{
				// upload to s3 
				ext = listLast(listFirst(img, ";"), "/")
				objimg = imageReadBase64(img)
				dir = "#application.s3.bucket#pub/#request.user.tenant.id#/editor/"
				file_name = randRange(0,9) & createUniqueId() & ".#ext#"
				full_file_name = dir & file_name
				if(!directoryExists(dir))	{
					directoryCreate(dir)
				}
				
				cfimage(source="#objimg#" destination="#full_file_name#" action="write")
				// find the item in the content
				cont = replaceNoCase(cont, img, '#application.s3.url#pub/#request.user.tenant.id#/editor/#file_name#"')
			}
		}
		//abort cont
		return cont
	}
	
</cfscript>