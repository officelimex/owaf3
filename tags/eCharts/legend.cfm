<cfoutput>

	<cfif thisTag.ExecutionMode eq 'start'>

		<cfparam name="Attributes.TagName" type="string" default="legend"/>
		<cfparam name="Attributes.value" type="string" default=""/>
		<cfparam name="Attributes.orient" type="string" default=""/> 		<!--- horizontal, vertical --->
		<cfparam name="Attributes.left" type="string" default=""/>
		<cfparam name="Attributes.top" type="string" default=""/>
		<cfparam name="Attributes.bottom" type="string" default=""/>
		<cfparam name="Attributes.position" type="string" default=""/>
		<cfparam name="Attributes.color" type="string" default=""/>
		<cfparam name="Attributes.textcolor" type="string" default=""/>
		<cfparam name="Attributes.icon" type="any" default=""/>
		<cfparam name="Attributes.type" type="string" default="plain"/> <!--- plain/scroll --->

		<cfset _icon.pie = "path://M13.5,45.5L13.5,41.55A3.95,3.95,0,0,1,17.45,45.5ZM11.5,47.5L11.5,42.55A4.95,4.95,0,1,0,16.45,47.5Z"/>
		<cfset _icon.bar = "path://M7,35L7,27.3L9.75,27.3L9.75,35ZM11.125,35L11.125,24L13.875,24L13.875,35ZM15.25,35L15.25,30.6L18,30.6L18,35Z"/>
		<cfset _icon.line = "path://M470.36,195.39a41.38,41.38,0,0,0-82.28,0H356.6v8.9h31.48a41.38,41.38,0,0,0,82.28,0h31.48v-8.9Zm-41.14,37.3a32.86,32.86,0,1,1,32.85-32.85A32.86,32.86,0,0,1,429.22,232.69Z"/>

			<!--- <cfset Attributes.icon = "path://M 10 43 H 11 V 48 L 10 48 L 10 43 M 10 43 H 11 M 12 44 H 13 V 48 H 12 V 44"/> --->
	
		<cfset cf_echart = getBaseTagData("cf_echart").Attributes/>
		<cfif Attributes.color != "">
			color: [
				<cfloop list="#Attributes.color#" item="c">
					'#c#',
				</cfloop>
			],
		</cfif>
		legend: {

<!--- 			<cfif Attributes.icon != "">
				icon : '#Attributes.icon#',
			</cfif> --->
			type : '#Attributes.type#',
			textStyle: {
				<cfif cf_echart.font != "">
					fontFamily : '#cf_echart.font#',
				</cfif>
				<cfif Attributes.textcolor != "">
					color: "#Attributes.textcolor#"
				</cfif>
			},
		
			<cfif Attributes.orient != "">orient: '#Attributes.orient#',</cfif>
			<cfif Attributes.left != "">left: '#Attributes.left#',</cfif>
			<cfif Attributes.top != "">top: '#Attributes.top#',</cfif>
			<cfif Attributes.bottom != "">bottom: '#Attributes.bottom#',</cfif>
			<cfif Attributes.position != "">
				<cfif ListLen(Attributes.position, ' ') == 2>
					x : '#listFirst(Attributes.position, ' ')#',
					y : '#listLast(Attributes.position, ' ')#',
				<cfelse>
					<cfswitch expression="#Attributes.position#">
						<cfcase value="left,right,center" delimiters=",">
							x : '#Attributes.position#',
						</cfcase>
						<cfcase value="top,bottom,middle" delimiters=",">
							y : '#Attributes.position#',
						</cfcase>
					</cfswitch>
				</cfif>
			</cfif>
			data:[ 
				<cfset ilist = listLen(Attributes.icon)/>
				<cfset i=0/>
				<cfloop list="#Attributes.value#" item="l">
					<cfset i++/>
					{
						<cfif ilist gte i>
							icon: '#_icon[listgetAt(Attributes.icon, i)]#',
						<cfelse>
							<cfset licon = listLast(Attributes.icon)/>
							<cfif len(trim(licon))>
								<cfif isDefined(_icon[licon])>
									icon: '#_icon[listLast(Attributes.icon)]#',
								<cfelse>
									icon: '#_icon[Attributes.icon]#',
								</cfif>
							</cfif>
						</cfif>
						name: '#l#'
					},
				</cfloop>
				<!--- {
				##
				name: ['#replace(Attributes.value,",","','","all")#'] --->
			]
		},

		</cfif>

</cfoutput>