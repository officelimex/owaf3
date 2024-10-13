<cfoutput>

	<cfif thisTag.ExecutionMode eq 'start'>

		<cfparam name="Attributes.TagName" type="string" default="legend"/>
		<cfparam name="Attributes.orient" type="string" default="horizontal"/> 		<!--- horizontal, vertical --->
		<cfparam name="Attributes.maporient" type="string" default="vertical"/> 		<!--- horizontal, vertical --->
		<cfparam name="Attributes.range" type="string"/>
		<cfparam name="Attributes.mapleft" type="string" default=""/>
		<cfparam name="Attributes.left" type="string" default=""/>
		<cfparam name="Attributes.maptop" type="string" default=""/>
		<cfparam name="Attributes.min" type="numeric" default="0"/>
		<cfparam name="Attributes.max" type="numeric" default="200"/>
		<cfset cf_echart = getBaseTagData("cf_echart").Attributes/>
 
		visualMap: {
			calculable: true,
			orient: '#Attributes.maporient#',
			min: #Attributes.min#,
			max: #Attributes.max#
			<cfif Attributes.mapleft != "">
				,left: '#Attributes.mapleft#'
			</cfif>
			<cfif Attributes.maptop != "">
				,top: '#Attributes.maptop#'
			</cfif>
		},

		calendar: {
			cellSize: ['auto', 'auto'],
			orient: '#Attributes.orient#',
			range: #Attributes.range#
			<cfif Attributes.left != "">
				,left: '#Attributes.left#'
			</cfif>
		},

	</cfif>

</cfoutput>