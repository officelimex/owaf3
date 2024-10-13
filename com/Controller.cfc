component	{

	public Controller function init()	{

		return this
	}

	// use this function to get the model name, table name and alias


	// use this function to get the model name, table name and alias
	private struct function getModelDefaultParam(required string model_desc)	{

		var mod_desc = structNew();
		switch(listLen(arguments.model_desc," "))	{
			case 1: // model name only
				mod_desc.model_name  = arguments.model_desc;
				mod_desc.table_name = '';
			break;
			case 2: // model and table
				mod_desc.model_name = mod_desc.table_name = listFirst(arguments.model_desc," ");
				mod_desc.table_name = mod_desc.table_name & " " & listLast(arguments.model_desc," ");
			break;
			case 3: // model and table and table alias
				mod_desc.model_name = listFirst(arguments.model_desc," ");
				mod_desc.table_name = listGetAt(arguments.model_desc,2, " ") & " " & listLast(arguments.model_desc," ");
			break;
		}
		mod_desc.table_name = listlast(mod_desc.table_name,'.');
		return mod_desc;
	}

	// param 	@fieldname -> form.fieldnames
	public number function maxEditTableItems(required string field_names, required string field_name)	{

		var l = 0;

		loop list=arguments.field_names item='form_item'	{
			if(findNoCase(arguments.field_name, form_item))	{
				l = listAppend(l,val(listlast(form_item,'_')));
			}
		}
		var a = listtoarray(l);

		return a.max();
	}

	// param 	@fieldname -> form.fieldnames
	public number function countEditTableItemInForm(required string fieldnames)	{

		var l = 0;

		loop list=arguments.fieldnames item='form_item'	{
			l = listAppend(l,val(listlast(form_item,'_')));
		}
		var a = listtoarray(l);

		return a.max();
	}

	// param 	@fieldname -> form.fieldnames -
	public number function maxValueOfSubItemInForm(required string fieldnames)	{

		var l = 0;

		loop list=arguments.fieldnames item='form_item'	{
			l = listAppend(l,val(listlast(form_item,'_')));
		}
		var a = listtoarray(l);

		return a.max();
	}


	// item that has dropdown list, using `
	/**
	 * [saveModelItemWithList description]
	 * @param  {[type]} required string          model_desc    [description]
	 * @param  {[type]} required string          form_field    [description]
	 * @param  {String} string   fixed_field     [description]
	 * @param  {[type]} required struct          form          [description]
	 * @param  {[type]} struct   versionData     [description]
	 * @param  {String} string   form_group_name [if you have more than one edittable in a form]
	 * @return {[type]}          [description]
	 */
	public any function saveModelItemWithList(required string model_desc, required string form_field, string fixed_field='', required struct form, struct versionData = structnew(), string form_group_name='')	{

		var item_data = structnew();
		var item_model = model(arguments.model_desc);
		var action = action_ = '';
		var pkey=0;
		var fgroup = '';
		if(arguments.form_group_name neq "")	{
			fgroup = arguments.form_group_name & "_";
		}

		transaction {

			loop from=1 to=maxValueOfSubItemInForm(arguments.form.fieldnames) index='i'	{

				action_ = fgroup & 'action_' & i;

				if(structKeyExists(arguments.form, action_))	{

					action = arguments.form[action_];
					if(structKeyExists(arguments.form,fgroup & item_model.key & '_' & i))	{
						pkey = arguments.form[fgroup & item_model.key & '_' & i];
					}
					//abort pkey;
					if(action is 'D')	{

						item_model.find(pkey).delete();

					}
					else 	{

						loop list=arguments.form_field item='field_item'	{
							_field_item = field_item;
							if(fgroup neq '')	{
								_field_item = replacenocase(field_item, fgroup, '');
							}
							item_data[_field_item] = listfirst(arguments.form[fgroup & field_item & '_' & i],'`');
						}

						// for fixed field
						loop list=arguments.fixed_field item='fixed_item'	{
							item_data[fixed_item] = arguments.form[fixed_item];
						}
						item_data[item_model.key] = pkey;

						item_model.new(item_data).save(arguments.versionData);
					}

				}
			}


		}


		return item_model;

	}

	public boolean function isClient() hint="check if the user currencly logged in is a client"	{

		var bool = false;
		if(request.user.userType is 'Client')	{
			bool = true;
		}

		return bool;
	}

	public void function VerifyUser()	{
		lock type="read-only" scope="session" timeout="5"	{
			s = session
		}
		cfparam(name="s.user.islogin", default="false", type="boolean")
		if(!s.user.islogin)	{
			abort "Not authorized, You have to login first"
		}
	}

	include 'inc/controller/email.cfm';
	// model/controller functions
	include 'inc/function.cfm';
	include 'inc/model/helper.cfm';

}