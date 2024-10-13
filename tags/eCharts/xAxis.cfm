<cfoutput>

	<cfif thisTag.ExecutionMode eq 'start'>

		<cfparam name="Attributes.TagName" type="string" default="xAxis"/>
		<cfparam name="Attributes.type" type="string" default="category"/>
		<!---
			[ default: 'category' ]
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
		<cfparam name="Attributes.show" type="boolean" default="true"/>
		<cfparam name="Attributes.showAxisLine" type="boolean" default="false"/>
		<cfparam name="Attributes.showAxisTick" type="boolean" default="false"/>
		<cfparam name="Attributes.showSplitLine" type="boolean" default="false"/>
		<cfparam name="Attributes.splitLineColors" type="string" default=""/>

		<cfparam name="Attributes.axisLabelInterval" type="string" default=""/>

		<cfparam name="Attributes.datasource" type="any" default=""/>
		<cfparam name="Attributes.max" type="string" default=""/>

		<cfset cf_echart = getBaseTagData("cf_echart").Attributes/>


		xAxis : [
			{
				<cfif Attributes.type != "">
					type : '#Attributes.type#',
				</cfif>
				<cfif Attributes.max != "">max: #Attributes.max#,</cfif>
				show : #Attributes.show#,
				axisTick:{
					show :#Attributes.showAxisTick#
				},
				axisLine:{
					show :#Attributes.showAxisLine#
				},
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
				splitLine:{
					show : #Attributes.showSplitLine#
					<cfif Attributes.splitLineColors neq "">,
						lineStyle : {
							color : [
								'#replace(Attributes.splitLineColors,",","','","all")#'
							]
						}
					</cfif>
				},
				axisLabel:{
					<cfif cf_echart.font != "">
						fontFamily : '#cf_echart.font#',
					</cfif>
					<cfif Attributes.axisLabelInterval != "">interval : 0</cfif>
				}
			}
		],


		</cfif>

</cfoutput>