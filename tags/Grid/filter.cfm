<cfoutput>

	<cfif ThisTag.ExecutionMode EQ "Start">

	    <cfparam name="Attributes.TagName" type="string" default="Filter"/>
	    <cfparam name="Attributes.title" type="string" default=""/>
	    <cfparam name="Attributes.value" type="string" default="#Attributes.title#"/>
	    <cfparam name="Attributes.selected" type="boolean" default="false"/>
	    <cfparam name="Attributes.operator" type="string" default="IN"/>
	    <cfparam name="Attributes.type" type="string" default="value"/> <!--- value|sql --->
	    <!---cfparam name="Attributes.use" type="string" default="WHERE" hint="HAVING|WHERE"/---> <!--- use eilther having or where clause --->

	    <cftry>
    		<cfassociate basetag="cf_filtergroup"/>
	    	<cfset basetag = getBaseTagData("cf_filtergroup")/>

    		<cfcatch type="any">

    			<cfassociate basetag="cf_filters"/>
	    		<cfset basetag = getBaseTagData("cf_filters")/>

    		</cfcatch>
	    </cftry>

		<!---cfset ArrayAppend(request.grid.filter_item, Attributes)/--->

		<option value="#basetag.Attributes.column#`#Attributes.value#" <cfif Attributes.selected>selected</cfif>>#Attributes.title#</option>

	</cfif>

</cfoutput>