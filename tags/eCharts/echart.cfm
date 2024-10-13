<cfoutput>

	<cfif thisTag.ExecutionMode eq 'start'>

		<cfparam name="Attributes.TagName" type="string" default="echart"/>
		<cfparam name="Attributes.id" type="string" default="#application.fn.getRandomVariable()#"/>
		<cfparam name="Attributes.width" type="string" default="100%"/>
		<cfparam name="Attributes.align" type="string" default=""/>
		<cfparam name="Attributes.height" type="string" default="200px"/>
		<cfparam name="Attributes.right" type="string" default=""/>
		<cfparam name="Attributes.top" type="string" default=""/>
		<cfparam name="Attributes.bottom" type="string" default=""/>
		<cfparam name="Attributes.left" type="string" default=""/>
		<cfparam name="Attributes.Title" type="string" default=""/>
		<cfparam name="Attributes.SubTitle" type="string" default=""/>
		<cfparam name="Attributes.TitleAlign" type="string" default="center"/>
		<cfparam name="Attributes.class" type="string" default=""/>
		<cfparam name="Attributes.onClick" type="string" default=""/><!--- js code here --->
		<cfparam name="Attributes.font" type="string" default=""/><!--- js code here --->
		<cfparam name="Attributes.colors" type="string" default=""/><!--- list of colors --->
		<cfparam name="Attributes.theme" type="string" default="infographic"/><!---default"/--->


		<cfparam name="Attributes.type" type="string" default="mix"/>	<!--- the type of chart to render --->

		<cfparam name="Attributes.showToolbox" type="boolean" default="true"/>

		<div id="#Attributes.id#" class="#Attributes.class#" <cfif Attributes.align != ""> align="#Attributes.align#" </cfif> style="width:#Attributes.width#; height:#Attributes.height#"></div>

		<cfset echartid = application.fn.getRandomVariable()/>
		<cfset opt_var = application.fn.getRandomVariable()/>

		<cfparam name="request.tag.echart.to_resize" default=""/>

		<cfset request.tag.echart.to_resize = ListAppend(request.tag.echart.to_resize, "#echartid#.resize()", ";")/>
		<cfif request.tag.echart.to_resize == "">
			<cfset request.tag.echart.to_resize = "#echartid#.resize();"/>
		</cfif>

		<script type="text/javascript">

			var #echartid# = echarts.init(document.getElementById('#Attributes.id#'),'#attributes.theme#');

	<cfelse>

		<cfset Content = THISTAG.GeneratedContent />
		<cfset THISTAG.GeneratedContent = "" />

			var #opt_var# = {
				<cfif Attributes.colors != "">
					<cfset f1 = replace(Attributes.colors,',',"','",'all')/>
					<cfset f1 = replace(f1, '##',"'##") & "'"/>
					color: [#f1#],
				</cfif>
				grid : {
					<cfif Attributes.right != "">right:'#Attributes.right#',</cfif>
					<cfif Attributes.top != "">top:'#Attributes.top#',</cfif>
					<cfif Attributes.bottom != "">bottom:'#Attributes.bottom#',</cfif>
					left:'#Attributes.left#'
				},
				<cfif Attributes.Title != "" || Attributes.SubTitle != "">
				title: [
					{
						textStyle : {
							fontFamily : '#Attributes.font#'
						},
						subtextStyle : {
							fontFamily : '#Attributes.font#'
						},
						text: '#Attributes.Title#',
						<cfif Attributes.SubTitle != "">subtext: '#Attributes.SubTitle#',</cfif>
						left: '#Attributes.TitleAlign#'
					}
				],
				</cfif>
				tooltip : {
					<cfswitch expression="#attributes.type#">
						<cfcase value="mix">
							trigger: 'axis',
						</cfcase>
						<cfcase value="pie">
							trigger: 'item',
						</cfcase>
						<cfcase value="calendar">
							position: 'top',
							formatter: function (p) {
								var format = echarts.format.formatTime('yyyy-MM-dd', p.data[0]);
								return format + ': ' + p.data[1];
							}
						</cfcase>
						<cfdefaultcase>
							axisPointer:{
								show: true,
								type:'shadow',
								shadowStyle : {
									color: 'rgba(150,150,150,0.1)'
								}
							}
						</cfdefaultcase>
					</cfswitch>
				
				},

				<cfswitch expression="#attributes.type#">
					<cfcase value="mix">
						calculable : true,
					</cfcase>
				</cfswitch>

				#Content#

			}

			#echartid#.setOption(#opt_var#);
			window.onresize = function() {
				#request.tag.echart.to_resize#;
			};
			document.addEventListener("start", () => {
				#request.tag.echart.to_resize#;
			});

			<cfif attributes.OnClick != "">
				#echartid#.on('click', function(e) 	{
					#attributes.OnClick#;
				});
			</cfif>


		</script>

	</cfif>

</cfoutput>