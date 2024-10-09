<cfoutput>

	<cfif thisTag.ExecutionMode eq 'start'>

		<cfparam name="Attributes.TagName" type="string" default="gauge"/>
		<cfparam name="Attributes.name" type="string"/>
		<cfparam name="Attributes.datasource" type="any"/>

		<cfparam name="Attributes.center" type="string" default=""/>
		<cfparam name="Attributes.radius" type="string" default=""/>
		<cfparam name="Attributes.min" type="numeric" default="0"/>
		<cfparam name="Attributes.max" type="numeric" default="0"/>

		<cfparam name="Attributes.endAngle" type="numeric" default="-40"/>
		<cfparam name="Attributes.startAngle" type="numeric" default="220"/>

		<cfparam name="Attributes.pointerWidth" type="numeric" default="4"/>

		<cfparam name="Attributes.splitNumber" type="numeric" default="1"/>

		<cfparam name="Attributes.detailFontSize" type="string" default="15px"/>

		<cfset cf_series = getBaseTagData("cf_series").Attributes/>

		<cfparam name="Attributes.font" type="string" default="#cf_series.font#"/>

		{
			<cfif attributes.font != ''>textStyle:{fontFamily:'#attributes.font#'},</cfif>
			name:'#Attributes.name#',
			<cfif Attributes.center neq "">center: #Attributes.center#,</cfif>
			<cfif Attributes.radius neq "">radius: #Attributes.radius#,</cfif>
			<cfif Attributes.min>
				min: #Attributes.min#,
			</cfif>
			<cfif Attributes.max>
				max: #Attributes.max#,
			</cfif>
			<cfif Attributes.pointerWidth>
				pointer: {
					width:#Attributes.pointerWidth#
				},
			</cfif>
			endAngle : #Attributes.endAngle#,
			startAngle : #Attributes.startAngle#,
            detail : {
                textStyle: {
                    fontSize: '#Attributes.detailFontSize#',
                    fontWeight: 'bolder'
                }
            },
            splitNumber: #Attributes.splitNumber#,
            axisLine: {
                lineStyle: {
                    width: 5
                }
            },
            axisTick: {
                length: 10,
                lineStyle: {
                    color: 'auto'
                }
            },
		    axisLabel: {
                show: false
            },
            splitLine: {
                length: 10,
                lineStyle: {
                    color: 'auto'
                }
            },
			type: 'gauge',
			data:[

				<cfif isquery(Attributes.datasource)>

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