<cfoutput>

	<cfif thisTag.ExecutionMode eq 'start'>

		<cfparam name="Attributes.TagName" type="string" default="yAxis"/>
		<cfparam name="Attributes.name" type="string"/>
		<cfparam name="Attributes.datasource" type="any"/>
		<cfparam name="Attributes.yAxis" type="string" default=""/>
		<cfparam name="Attributes.hideSymbol" type="boolean" default="false"/>

		<!--- line --->
		<cfparam name="Attributes.smooth" type="boolean" default="false"/>

		<!--- area --->
		<cfparam name="Attributes.area" type="boolean" default="false"/>
		<cfset cf_series = getBaseTagData("cf_series").Attributes/>

		{
			name: '#Attributes.name#',
			<cfif attributes.yAxis != "">
				yAxisIndex: #attributes.yAxis#,
			</cfif>
			type: 'line',
			<cfif attributes.hideSymbol>
				showSymbol: false,
			</cfif>
			smooth: #Attributes.smooth#,
			<cfif attributes.area>
				areaStyle: {normal: {}},
			</cfif>
			data:[

				<cfif isquery(Attributes.datasource)>
					<cfparam name="Attributes.ColumnName" type="string"/>
					<cfloop query="#Attributes.datasource#">
						'#evaluate(Attributes.columnName)#'<cfif recordcount != currentrow>,</cfif>
					</cfloop>
				<cfelseif IsArray(Attributes.datasource)>
					<cfloop array="#Attributes.datasource#" item="x">
						{value:#x.value#, name:'#x.name#'},
					</cfloop>
				<cfelse>
					'#replace(Attributes.datasource,",","','","all")#'
				</cfif>

			]
		},

	</cfif>

</cfoutput>