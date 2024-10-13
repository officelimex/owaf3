<cfoutput>

	<cfif thisTag.ExecutionMode eq 'start'>

		<cfparam name="Attributes.TagName" type="string" default="Data"/>
		<cfparam name="Attributes.name" type="string" default=""/>
		<cfparam name="Attributes.type" type="string"/>

		
		<cfparam name="Attributes.datasource" type="any"/>
  <cfelse>
		{
      <cfif attributes.name != "">
        name:'#Attributes.name#',
      </cfif>
      type: '#Attributes.type#',
      lineStyle: {
        normal: {
          width: 2,
          opacity: 0.5
        }
      },
      symbol: 'none',
      areaStyle: {
        normal: {
          opacity: 0.3
        }
      },
			data:[

      <cfif isArray(Attributes.datasource)>
        <cfloop array="#Attributes.datasource#" item="x">
          {
            lineStyle: {
              normal: {
              <cfif isdefined("x.type")>
                type: '#x.type#',
              </cfif>
              <cfif isdefined("x.lineColor")>
                color: '#x.lineColor#',
              </cfif>
              }
            },
            areaStyle: {
              normal: {
              <cfif isdefined("x.opacity")>
                opacity: #x.opacity#,
              </cfif>
              <cfif isdefined("x.bgcolor")>
                color: '#x.bgcolor#'
              </cfif>
              }
            },
            value : [<cfif isArray(x.value)>#x.value.tolist()#<cfelse>#x.value#</cfif>],
            name : '#x.name#',
          },
        </cfloop>
      </cfif>
      ]
		},

	</cfif>

</cfoutput>