<cfoutput>

	<cfif thisTag.ExecutionMode eq 'start'>

		<cfparam name="Attributes.TagName" type="string" default="toolbar"/>

		<cfset cf_echart = getBaseTagData("cf_echart").Attributes/>

		toolbox: {
			show : true,
			orient:'vertical',
			itemGap: 20,
			feature : {
				dataView : {show: false, readOnly: false, title: 'Raw data'},
				magicType : {
					show: true,
					title:{
						line : 'Switch to line chart',
						bar : 'Switch to bar chart',
						stack : 'Switch to stacked chart',
						tiled : 'Switch to tiled chart'
					},
					type: ['line', 'bar', 'stack', 'tiled']
				},
				restore : {show: true, title:'Restore'},
				saveAsImage : {show: true, title:'Save as image'}
			}
		},

	</cfif>

</cfoutput>