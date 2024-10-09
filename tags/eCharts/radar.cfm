<cfoutput>

	<cfif thisTag.ExecutionMode eq 'start'>

		<cfparam name="Attributes.TagName" type="string" default="Radar"/>
    <cfparam name="Attributes.indicator" type="string"/>
		<cfparam name="Attributes.splitNumber" type="numeric" default="0"/>
		<cfparam name="Attributes.LineStyleColor" type="string" default=""/>
		<cfparam name="Attributes.textStyleColor" type="string" default=""/>
		<cfparam name="Attributes.max" type="numeric" default="0"/>
		
      radar : {
        name: {
          <cfif Attributes.textStyleColor != "">
            textStyle: {
              color: '#Attributes.textStyleColor#' 
            }
          </cfif>
        },
        indicator : [
          <cfloop list="#Attributes.indicator#" item="i">
            {text: '#i#' <cfif Attributes.max>, max: #Attributes.max#</cfif>},
          </cfloop>
        ],
        shape: 'circle',
        <cfif attributes.splitNumber>
          splitNumber: #attributes.splitNumber#,
        </cfif>
        splitArea: {
          show: false
        },
        <cfif Attributes.LineStyleColor != "">
          axisLine: {
            lineStyle: {
              color:'#Attributes.LineStyleColor#'
            }
          }
        </cfif>
      },

      <cfset Content = THISTAG.GeneratedContent />
      <cfset THISTAG.GeneratedContent = "" />

    <cfelse>

      #Content#
 
		

	</cfif>

</cfoutput>