<cfoutput>
<cfif ThisTag.ExecutionMode == "Start">

    <cfparam name="Attributes.TagName" type="string" default="Filters"/>
    <cfparam name="Attributes.name" type="string" default="filter"/>
    <cfparam name="Attributes.column" type="string" default=""/>
    <cfparam name="Attributes.group" type="boolean" default="false"/>

    <cfassociate basetag="cf_gbuttons"/>

    <cfset request.grid.filter_group = request.grid.filter_item = ArrayNew(1)/>

    <cfset request.grid.hasFilter = true/>

    <cfset ArrayAppend(request.grid.filters, Attributes)/>
    <div class="grid_filter">
    <select class="form-control" style="display:none;" multiple>

<cfelse>

    </select>
    </div>

</cfif>
</cfoutput>
