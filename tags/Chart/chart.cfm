<cfoutput>

	<cfif thisTag.ExecutionMode == 'start'>

		<cfparam name="Attributes.TagName" type="string" default="chart"/>
		<cfparam name="Attributes.Id" type="string" default="#application.fn.GetRandomVariable()#"/>
		<cfparam name="Attributes.type" type="string"/><!--- pie, line --->
		<cfparam name="Attributes.legend" type="boolean" default="false"/>
		<cfparam name="Attributes.legendPosition" type="string" default="bottom"/>
		<cfparam name="Attributes.stacked" type="boolean" default="false"/>
		<cfparam name="Attributes.ticks" type="numeric" default="4"/>
		<cfparam name="Attributes.title" type="string" default=""/>
		<cfparam name="Attributes.titlePosition" type="string" default="top"/>
		<cfparam name="Attributes.height" type="string" default=""/>
		<cfparam name="Attributes.ShowAxes" type="boolean" default="true"/>
		<cfparam name="Attributes.ShowxAxes" type="boolean" default="true"/>
		<cfparam name="Attributes.ShowyAxes" type="boolean" default="true"/>

		<cfparam name="Attributes.barThickness" type="numeric" default="10"/>
		
		<cfparam name="Attributes.MinY" type="string" default=""/>
		<cfparam name="Attributes.MaxY" type="string" default=""/>

		<cfset request.chart.dataset.yAxisID = {}/>

		<div class="chart" <cfif Attributes.height != "">style="height: #Attributes.height#"</cfif>>
				<canvas id="#Attributes.Id#" class="chart-canvas" ></canvas>
		</div>

  <cfelse>

		<cfset Content = THISTAG.GeneratedContent />
		<cfset THISTAG.GeneratedContent = "" />

			<script type="text/javascript">
					$(function() {

							var _#Attributes.Id# = document.getElementById("#Attributes.Id#").getContext('2d');
							new Chart(_#Attributes.Id#, {
									type: '#Attributes.type#',
									data: #Content#,

									options: {

											<cfif attributes.title != "">
												title: {
													display: true,
													text: '#attributes.title#',
													position : '#attributes.titlePosition#'
												},
											</cfif>
											legend: {
												display: #Attributes.legend#,
												position: "#Attributes.legendPosition#",
												align: "start"
											},

											scales: {

											<cfswitch expression="#Attributes.type#">
													<cfcase value="horizontalBar">
														yAxes: [{
															position: 'left',
															ticks: {
															},
															gridLines:{
																color:ThemeCharts.colors.gray[900],
																zeroLineColor:ThemeCharts.colors.gray[900]
															},
															barThickness: #Attributes.barThickness#,
														}],
														xAxes: [{
															display : #Attributes.ShowxAxes#,
														}]
													</cfcase>
													<cfcase value="bar,line">
															xAxes: [{
																display : #Attributes.ShowAxes#,
																<cfif Attributes.stacked>stacked: true,</cfif>
																barPercentage: 0.8,
																categoryPercentage:0.1
															}],
															yAxes: [

																	<cfset ii=0/>
																	<cfloop collection="#request.chart.dataset.yAxisID#" item="item" index="i">
																			<cfset ii++/>
																			{
																					type: 'linear',
																					<cfif ii ==1>
																							position: 'left',

																					<cfelse>
																							position: 'right',
																							ticks: {
																									maxTicksLimit:4,
																							},
																					</cfif>
																					id: '#i#',
																					gridLines:{
																						color:ThemeCharts.colors.gray[900],
																						zeroLineColor:ThemeCharts.colors.gray[900]
																					}
																					<cfif Attributes.stacked>,stacked: true</cfif>
																			},
																	</cfloop>
																	<cfif ii == 0>
																			{
																				display : #Attributes.ShowAxes#,
																					<!---gridLines:{
																							color:ThemeCharts.colors.gray[900],
																							zeroLineColor:ThemeCharts.colors.gray[900]
																					},--->
																							ticks: {
																									maxTicksLimit:#Attributes.ticks#,
																									<cfif Attributes.MinY != "">
																										min:#Attributes.MinY#,
																									</cfif>
																									<cfif Attributes.MaxY != "">
																										max:#Attributes.MaxY#,
																									</cfif>
																							},
																					<cfif Attributes.stacked>,stacked: true</cfif>


																			}
																	</cfif>
															]
													</cfcase>
											</cfswitch>

											}
									}
							});

					});
			</script>

  </cfif>

</cfoutput>