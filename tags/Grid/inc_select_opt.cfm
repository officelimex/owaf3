<cfoutput>
    var filter_value = $('###Attributes.id# .grid_filter select').val();
    if(filter_value == null)    {
        filter_value = [];
    }
    <cfset fgroup = request.grid.filter_group/>
    <cfset fg_len = fgroup.len()/>

    <cfif fg_len == 0>
        <cfset fgroup = request.grid.filters/>
    </cfif>

    var processed_result = [
        // Create default result;
        <cfloop array="#fgroup#" index="_x">
            {index:#val(_x.column)#,value:[]},
        </cfloop>
    ];
    for (i = 0; i < filter_value.length; i++) {
        _noshow = true;
        _fdata = filter_value[i].split('`');
        // search for the item existence in rt;
        for (k = 0; k < processed_result.length; k++) {
            if(processed_result[k].index == _fdata[0]){
            // update the value;
            processed_result[k].value.push(_fdata[1]);
            _noshow = false;
            }
        }
        if(_noshow){
            processed_result.push({'index':_fdata[0],'value':[_fdata[1]]});
        }

    }
    // loop through the objects
    for (i = 0; i < processed_result.length; i++) {
        #oTable#.columns(processed_result[i].index).search(processed_result[i].value).draw();
    }
    //TODO: filter not still working well for multiple filter
    if(processed_result.length==0)  {

        //#oTable#.columns().search("").draw();

    };
</cfoutput>