<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">

    <cfparam name="Attributes.TagName" type="string" default="ToolBar"/>

    <cfassociate basetag="cf_Grid"/>

	<cfset request.grid.toolbar = ArrayNew(1)/>

		<div class="card-header">
			<div class="row align-items-center">


			<!---cfif request.grid.hasSearch>
				<div class="row">
			</cfif--->

<!--- close tag --->
<cfelse>
			<!---cfif request.grid.hasSearch>
				</div>
			</cfif--->

			</div>
		</div>

</cfif>
</cfoutput>