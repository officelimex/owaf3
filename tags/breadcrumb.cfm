<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">

    <cfparam name="Attributes.TagName" type="string" default="Breadcrumb"/>
    <cfparam name="Attributes.pageHistory" type="query"/>
    <cfparam name="Attributes.title" type="string" default=""/>


<cfelse>

	<!---cfdump var="#Attributes.pageHistory#"/--->

	<!--- remove the recent entry --->
	<cfquery name="qMax" dbtype="query">
		SELECT MAX(Id) Id FROM Attributes.pageHistory
	</cfquery>

	<cfquery name="qPageHistory" dbtype="query">
		SELECT * FROM Attributes.pageHistory
		WHERE Id <> #val(qMax.Id)#
		ORDER BY Id DESC
	</cfquery>

	<cfset _title = _key = _url = ""/>

 	<cfloop query="qPageHistory" endrow="11">
 		<cfset _url = listPrepend(_url, qPageHistory.url)/>
 		<cfset _title = listPrepend(_title, qPageHistory.title)/>
 		<cfset _key = listPrepend(_key, qPageHistory.key)/>
 	</cfloop>

	<cfquery name="qCurrentPage" dbtype="query">
		SELECT * FROM Attributes.pageHistory
		WHERE Id = #qMax.Id#
	</cfquery>

<div class="app_title">
	<h1>
		<cfif Attributes.title neq "">
			#Attributes.title#
		<cfelse>
			#qCurrentPage.Title#
		</cfif>
		<small class="hidden-xs">
			<cfset i =0/>
			<cfloop list="#_url#" item="_u">
				<cfset i++/>
				<cfset _t = listGetAt(_title, i)/>
				<cfset _k = listGetAt(_key, i)/>

					<cfif _k eq 0>
						<a onclick="loadPage('#_u#',{'title':'#_t#'})">
							#_t#
						</a>
					<cfelse>
						<a onclick="loadPage('#_u#@#_k#',{'title':'#_t#'})">
							#_t#
						</a>
					</cfif>

			</cfloop>
		</small>
	</h1>
</div>

</cfif>
</cfoutput>
