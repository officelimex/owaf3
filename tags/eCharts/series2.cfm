<cfoutput>

	<cfif thisTag.ExecutionMode eq 'start'>

		<cfparam name="Attributes.TagName" type="string" default="series2"/>

		<cfset cf_echart = getBaseTagData("cf_echart").Attributes/>

		<cfparam name="Attributes.font" type="string" default="#cf_echart.font#"/>

		series: {
			type: 'heatmap',
			coordinateSystem: 'calendar',
	<cfelse>

		<cfset Content = THISTAG.GeneratedContent />
		<cfset THISTAG.GeneratedContent = "" />

			#Content#

		}

	</cfif>

</cfoutput>