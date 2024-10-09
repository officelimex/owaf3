<cfoutput>

	<cfif ThisTag.ExecutionMode EQ "Start">

	    <cfparam name="Attributes.TagName" type="string" default="FilterGroup"/>
	    <cfparam name="Attributes.title" type="string"/>

        <cfassociate basetag="cf_filters"/>
        <cfset basetag = getBaseTagData("cf_filters")/>

	    <cfparam name="Attributes.column" type="numeric" default="#val(basetag.Attributes.column)#"/>
	    <cfparam name="Attributes.fieldName" type="string" default=""/> <!--- this is for aggregate functions --->
	    <!---cfif val(Attributes.column) == 0 || Attributes.fieldName == "">
	    	<cfabort showerror="Column or field name is required"/>
	    </cfif---->

		<cfset ArrayAppend(request.grid.filter_group, Attributes)/>

        <optgroup label="#Attributes.title#">

	<cfelse>

		</optgroup>

	</cfif>

</cfoutput>