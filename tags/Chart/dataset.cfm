<cfoutput>

	<cfif ThisTag.ExecutionMode == "Start">

	    <cfparam name="Attributes.TagName" type="string" default="datasets"/>
	    <cfparam name="Attributes.label" type="string"/>
	    <cfparam name="Attributes.data" type="any"/>
	    <cfparam name="Attributes.backgroundColor" type="string" default=""/>
	    <cfparam name="Attributes.borderColor" type="string" default=""/>
	    <cfparam name="Attributes.type" type="string" default=""/>
	    <cfparam name="Attributes.yAxisID" type="string" default=""/>
	    <cfparam name="Attributes.fill" type="string" default="0"/> <!--- 0, 'start', 'end', 'origin' --->
	    <cfparam name="Attributes.borderWidth" type="string" default="3"/>
	    <cfparam name="Attributes.pointRadius" type="string" default="3"/>
	    <cfparam name="Attributes.pointBackgroundColor" type="string" default="#Attributes.borderColor#"/>
	    <cfparam name="Attributes.lineTension" type="string" default=""/>
			
		<cfif Attributes.yAxisID != "">
			<cfset request.chart.dataset.yAxisID[Attributes.yAxisID] = "x"/>
		</cfif>

	<cfelse>

		<cfset Content = THISTAG.GeneratedContent />
		<cfset THISTAG.GeneratedContent = "" />

			{
				<cfif Attributes.lineTension != "">lineTension: #Attributes.lineTension#,</cfif>
				pointBackgroundColor: "#Attributes.pointBackgroundColor#",
				pointRadius:#Attributes.pointRadius#,
				borderWidth:#Attributes.borderWidth#,
				<cfif Attributes.borderColor != "">borderColor: '#Attributes.borderColor#',</cfif>
				fill: '#Attributes.fill#',
				<cfif Attributes.type != "">
					type: "#Attributes.type#",
				</cfif>
				label: "#Attributes.label#",
				<cfif Attributes.yAxisID != "">
					yAxisID: '#Attributes.yAxisID#',
				</cfif>
				data: [
					<cfif isQuery(Attributes.data)>
	    			<cfparam name="Attributes.ColumnName" type="string"/>
						<cfloop query="#Attributes.data#">
							#Attributes.data[Attributes.ColumnName]#,
						</cfloop>
					<cfelse>
						<cfloop list="#Attributes.data#" item="x">
							#x#,
						</cfloop>
					</cfif>
				],
				<cfif Attributes.backgroundColor != "">
					<cfset bg_count = listLen(Attributes.backgroundColor,'|')>
					<cfif bg_count gt 1>
						backgroundColor : [
							<cfloop list="#Attributes.backgroundColor#" item="x" delimiters="|">
								#x#,
							</cfloop>
						]
					<cfelse>
						backgroundColor : #Attributes.backgroundColor#
					</cfif>,
				</cfif>
			},

	</cfif>

</cfoutput>