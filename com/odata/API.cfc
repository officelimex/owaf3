component {
  
  public string function getFilter(string filter, string id, struct field_map) {

    var _filter = ""

		if(arguments.filter != "")	{

			// replace field in filter
			for(x in field_map)	{
				arguments.filter = replaceNocase(arguments.filter, x, field_map[x], 'all')
			}

			// replace code in filter
			arguments.filter = replaceNocase(arguments.filter, ' lt ', ' < ', 'all')
			arguments.filter = replaceNocase(arguments.filter, ' gt ', ' > ', 'all')
			arguments.filter = replaceNocase(arguments.filter, ' eq ', ' = ', 'all')
			arguments.filter = replaceNocase(arguments.filter, ' ne ', ' <> ', 'all')

			var _filter = "WHERE #arguments.filter#"
		}

		if(arguments.id != 0)	{
			_filter = "WHERE i.itemId = #arguments.id#"
    }
    
    return _filter
  }

  public string function getOrderBy(string order = "") {

    var _order_by = ""
		if(arguments.order != "")	{
			_order_by = "ORDER BY #arguments.order#"
    }
    
    return _order_by
  }

  public string function getLimit(numeric skip = 0, numeric top = 0) {

		var limit = "LIMIT 0,100"
		if(arguments.top != 0)	{
			var limit = "LIMIT #arguments.skip#, #arguments.top#"
		}
    
    return limit
  }

}