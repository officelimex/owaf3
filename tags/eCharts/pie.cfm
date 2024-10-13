<cfoutput>

	<cfif thisTag.ExecutionMode eq 'start'>

		<cfparam name="Attributes.TagName" type="string" default="Pie"/>
		<cfparam name="Attributes.name" type="string"/>
		<cfparam name="Attributes.datasource" type="any"/>

		<!--- pie --->
		<cfparam name="Attributes.center" type="string" default=""/>
		<cfparam name="Attributes.radius" type="string" default=""/>
		<cfparam name="Attributes.roseType" type="string" default=""/><!---- area, radius --->
		<cfparam name="Attributes.labelPosition" type="string" default=""/>
		<cfparam name="Attributes.showlabel" type="boolean" default="true"/>
		<cfparam name="Attributes.showlabelLine" type="boolean" default="true"/>
		<cfparam name="Attributes.labelformat" type="string" default=""/>
		<cfparam name="Attributes.left" type="string" default=""/>
		<cfparam name="Attributes.top" type="string" default=""/>

		<cfset cf_series = getBaseTagData("cf_series").Attributes/>

		{
			name:'#Attributes.name#',
			tooltip : {
				trigger: 'item',
				formatter: function(params)	{
					return params.seriesName + '<br/>' + params.name + ' : ' + moneyFormat(params.value) + ' (' + params.percent + '%)';
				}
			},
			<cfif Attributes.center != "">center: [#Attributes.center#],</cfif>
			<cfif Attributes.radius != "">radius: [#Attributes.radius#],</cfif>
            label: {
              normal: {
							<cfif cf_series.font != "">fontFamily : '#cf_series.font#',</cfif>
							<cfif attributes.labelformat != "">
								formatter:'#attributes.labelformat#',
							</cfif>
							show: #Attributes.showlabel#,
							<cfif Attributes.labelPosition != "">
								position: '#Attributes.labelPosition#'
							</cfif>
            },
						emphasis: {
							show: true,
							textStyle: {
								fontWeight: 'bold'
							}
						}
          },
					labelLine: {
						normal: {
								show: #Attributes.showlabelLine#
						}
					},
			type: 'pie',
			<cfif Attributes.left != "">
				left: "#Attributes.left#",
			</cfif>
			<cfif Attributes.top != "">
				top: "#Attributes.top#",
			</cfif>
			selectedMode:'single',
			<cfif Attributes.roseType != "">roseType:'#Attributes.roseType#',</cfif>
			data:[

				<cfif isquery(Attributes.datasource)>
					<cfparam name="Attributes.ColumnName" type="string"/>
					<cfparam name="Attributes.ColumnValue" type="string"/>
					<cfloop query="#Attributes.datasource#">
						{value:#evaluate(Attributes.columnValue)#, name:'#evaluate(Attributes.columnName)#'},
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