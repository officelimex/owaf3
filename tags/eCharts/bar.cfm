<cfoutput>

	<cfif thisTag.ExecutionMode eq 'start'>

		<cfparam name="Attributes.TagName" type="string" default="Bar"/>
		<cfparam name="Attributes.name" type="string"/>
		<cfparam name="Attributes.datasource" type="any"/>

		<cfparam name="Attributes.barGap" type="string" default="0%"/>
		<cfparam name="Attributes.lablePosition" type="string" default=""/>

		<!--- Name of stack. On the same category axis, the series with the same stack name would be put on top of each other.--->
		<cfparam name="Attributes.stack" type="string" default=""/>


		<cfset cf_series = getBaseTagData("cf_series").Attributes/>

		{
			name:'#Attributes.name#',
			<cfif Attributes.lablePosition != "">
				label: {
					normal: {
						<cfif cf_series.font != "">fontFamily : '#cf_series.font#',</cfif>
						show: true,
						position: 'inside',
						textBorderColor : '##000',
						textBorderWidth : 1
					}
				},
			</cfif>
			type:'bar',
			<cfif Attributes.stack != "">
				stack:'#Attributes.stack#',
			</cfif>
			barGap:'#Attributes.barGap#',
			data:[

				<cfif IsQuery(Attributes.datasource)>
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