<cfoutput>

	<cfif thisTag.ExecutionMode == 'start'>

		<cfparam name="Attributes.TagName" type="string" default="yAxis"/>
		<cfparam name="Attributes.type" type="string" default="value"/>
		<!---
			[ default: 'value' ]
			Axis type.
			Optional:
			'value' value axis for continuous data.
			'category' category axis for discrete categories of data, for the time type must pass the data set Category Data.
			'time' timeline for continuous time-series data, compared with the value axis format with a time axis, on a scale computing are different, for example, according to span the range to decide month, week, day or hour range scale.
			'log' logarithmic axis. Suitable for number data.
		--->
		<cfparam name="Attributes.position" type="string" default="right"/>
		<!---
			The y axis.
			Optional:
			'left'
			'right'
			The default grid in the first y-axis in the grid on the left side ( 'left' position), the second y-axis, as the first y-axis on the other side.
		--->
		<cfparam name="Attributes.name" type="string" default=""/>
		<cfparam name="Attributes.max" type="string" default="auto"/>
		<cfparam name="Attributes.show" type="boolean" default="true"/>
		<cfparam name="Attributes.showAxisLine" type="boolean" default="false"/>
		<cfparam name="Attributes.showAxisTick" type="boolean" default="false"/>
		<cfparam name="Attributes.showSplitLine" type="boolean" default="true"/>
		<cfparam name="Attributes.axisTickLineColor" type="string" default=""/> <!--- list of colors --->
		<cfparam name="Attributes.splitLineColors" type="string" default=""/> <!--- list of colors --->
		<cfparam name="Attributes.labelFormatType" type="string" default=""/> <!--- short-money ---->
		<cfparam name="Attributes.datasource" type="any" default=""/>

		<cfset cf_echart = getBaseTagData("cf_echart").Attributes/>

		<cftry>
			<cfset multiple_series = true/>
			<cfset cf_myAxis = getBaseTagData("cf_myAxis").Attributes/>
			<cfcatch type = "any">
				<cfset multiple_series = false/>
			</cfcatch>
		</cftry>
		<cfif !multiple_series>
		yAxis : [
		</cfif>
			{
				<cfif Attributes.type != "">
					type : '#Attributes.type#',
				</cfif>
				<cfif(!IsEmpty(Attributes.datasource))	>
					data : [
						<cfif isQuery(Attributes.datasource)>

							<cfparam name="Attributes.columnName" type="string"/>

							<cfloop query="Attributes.datasource">
								'#evaluate(Attributes.columnName)#',
							</cfloop>
						<cfelse>
							<!--- list --->
							<cfset _len_data = listLen(Attributes.datasource)/>
							<cfloop list="#Attributes.datasource#" index="i" item="xi">
								'#xi#'<cfif i neq _len_data>,</cfif>
							</cfloop>

						</cfif>
				],
				</cfif>
				<cfif cf_echart.font != "">
					nameTextStyle:{
						fontFamily: '#cf_echart.font#'
					},
				</cfif>
				show : #Attributes.show#,
				<cfif attributes.name != "">
					name: '#attributes.name#',
				</cfif>
				position: '#Attributes.position#',
				<cfif Attributes.max neq "auto">
					max: '#Attributes.max#',
				</cfif>
				axisTick:{
					<cfif Attributes.axisTickLineColor neq "">
						lineStyle : {
							color : '#Attributes.axisTickLineColor#'
						},
					</cfif>
					show :#Attributes.showAxisTick#
				},
				axisLine:{
					show :#Attributes.showAxisLine#
				},
				axisLabel : {
					<cfif cf_echart.font != "">
						fontFamily : '#cf_echart.font#',
					</cfif>
					formatter:
					<cfswitch expression="#Attributes.labelFormatType#">
						<cfcase value="short-money">
							function (params) {
								return abbrNum(params, 2);
							}
						</cfcase>
						<cfdefaultcase>'{value}'</cfdefaultcase>
					</cfswitch>
				},
				splitLine:{
					show : #Attributes.showSplitLine#,
					<cfif Attributes.splitLineColors != "">
						lineStyle : {
							color : [
								'#replace(Attributes.splitLineColors,",","','","all")#'
							]
						}
					</cfif>
				}
			},
		<cfif !multiple_series>
		],
		</cfif>


	</cfif>

</cfoutput>