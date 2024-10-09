<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">

    <cfparam name="Attributes.TagName" type="string" default="Search"/>
    <cfparam name="Attributes.id" type="string" default="_#createUniqueId()#" />
    <cfparam name="Attributes.on" type="string" default="Enter" /> <!--- on key up/press --->
    <cfparam name="Attributes.size" type="string" default="col-sm-4 col-xs-6" />

    <cfassociate basetag="cf_ToolBar" />

    <cfset request.grid.hasSearch = true/>

	<!---div class="#Attributes.size#">

		<div class="search">
			<input type="text" class="form-control #Attributes.id# search_text" placeholder="Search..."/>
		</div>

	</div--->

	<div class="col">

		<div class="row align-items-center">
			<div class="col-auto pr-0">
				<span class="fe fe-search text-muted"></span>
			</div>
			<div class="col">
				<input type="search" class="form-control form-control-flush search #Attributes.id#" placeholder="Search..."/>
			</div>
		</div>

	</div>

 	<cfset ArrayAppend(request.grid.toolbar,Attributes)/>


</cfif>
</cfoutput>