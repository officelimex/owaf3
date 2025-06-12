<cfoutput>
	<cfif ThisTag.ExecutionMode == "Start">
	
		<cfparam name="Attributes.TagName" type="string" default="CalendarView"/>
		<cfparam name="Attributes.year" type="numeric" default="#year(now())#"/>
		<cfparam name="Attributes.data1" type="array" default="[]"/>
		<cfparam name="Attributes.url" type="string" default=""/>
	
	<cfelse>
	
		<cfset m = 0/>
		<cfset ww = "sun,mon,tue,wed,thu,fri,sat"/>
		
		<cfloop from="1" to="1" index="i">
						
			<div class="row">
				<cfloop from="1" to="12" index="j">
					<cfset m++/>
					<cfset data["m#m#"] = []/>
					<div class="col-lg-6 col-xl-4 col-xxl-3">
						<div class="card">
							<div class="card-header">
								<div class="card-header-title">
									<div class="row">
										<div class="col text-left">#monthAsString(m)#</div>
										<div class="col text-right">
											<cfset pic = name = al = bgc = ""/>
											<cfloop array="#Attributes.data1#" item="item">
												<cfif findNocase("#Attributes.year#/#m#", item.Date)>
													<cfset pic = listAppend(pic, item.picture, "|")/>
													<cfset name = listAppend(name, item.name, "|")/>
													<cfset al = listAppend(al, item.ALIAS, "|")/>
													<cfset bgc = listAppend(bgc, item.Color, "|")/>
													<cfset data["m#m#"].append(item)/>
												</cfif>
												
											</cfloop>
											<!--- <cfdump var="#data["m#m#"]#"/> --->
											<cfif pic != "">
												<cf_PictureGroup picture="#pic#" name="#name#" alias="#al#" bgcolor="#bgc#" max="8" size="xs"/>
											</cfif>
										</div>
									</div>
								</div>
							</div>
							<div class="">
								<div class="xcontainer">
									<div class="grid-calendar">
	
										<div class="row calendar-week-header">
											<cfloop list="S,M,T,W,T,F,S" item="wh">
												<div class="col-xs-1 grid-cell">
													<div>
														<div>
															<cfset cls = "">
															<cfif wh == "S">
																<cfset cls = "red"/>
															</cfif>
															<span class="#cls#">#wh#</span>
														</div>
													</div>
												</div>
											</cfloop>
										</div>
	
										<cfset dy = d = 0/>
										<cfset eday = daysInMonth("#Attributes.year#/#m#/1")+1/>
										<cfset fday = dateFormat("#Attributes.year#/#m#/1",'ddd')/>
										<cfloop from="1" to="6" index="j">
											<div class="row calendar-week">
												<cfloop from="1" to="7" index="k">
													<!--- start --->
													<cfif fday == listGetAt(ww, k) || d>
														<cfset dy++/>
														<cfset d++/>
													</cfif>
													<!--- end of date --->
													<cfif dy GTE eday>
														<cfset d = 0/>
													</cfif>
													<div class="col-xs-1 grid-cell">
														<div>
															<div>
																<cfif d>
																	<cfset now_ = "#attributes.year#/#m#/#d#"/>
																	<cfset popv = ""/>
																	<cfloop array="#data['m#m#']#" item="item">
																		<cfif findNocase(now_, item.date)>
																			<cfset cpopv = "
																				<div class='mr-3 ml-2 ' style='min-width:400px;'>
																					<div class='row align-items-center'>
																						<div clas='col-auto'>
																							<div class='avatar avatar-sm mr-3'>
																								<img src='#application.s3.url#pub/#request.user.tenantid#/passport/#item.picture#' class='avatar-img rounded-circle'/>
																							</div>
																						</div>
																						<div clas='col'>
																							<div style='color:###item.color#'>#item.Name#</div>
																							<div>#item.Status# - #item.Type#</div>
																						</div>
																					</div>
																				</div>
																			"/>
																			<cfset popv = listAppend(popv, cpopv, "|")/>
																			<a class="leave" <cfif Attributes.url neq "">href="javascript:showModal('#Attributes.url#~#item.key#', {title: 'Info for #item.Name#'});"</cfif> data-toggle="popover" data-placement="bottom" data-trigger="hover" data-html="true" data-content="#cpopv#" style="background-color:###item.color#">&nbsp;&nbsp;#item.Alias#</a>
																		</cfif>																		
																	</cfloop>
																	<cfset c = replace(popv,'|',"<hr class='mt-2 mb-2'/>",'all')/>
																	<span class="day" 
																		data-toggle="popover" 
																		data-placement="bottom" 
																		data-trigger="hover" data-html="true" 
																		data-content="#c#">#d#</span>
																	
																</cfif>
															</div>
														</div>
													</div>
												</cfloop>
											</div>
										</cfloop>
									
									</div>
								</div>
	
	
	
	
	
	
	
	
	
	
	
	
							</div>
						</div>
					</div>
				</cfloop>
			</div>
		</cfloop>
	
	
	</cfif>

	<script>
$(function () {
  $('[data-toggle="popover"]').popover()
})
	</script>
 
	</cfoutput>