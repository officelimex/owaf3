<cfoutput>
	<cfif thisTag.ExecutionMode eq 'start'>

		<cfparam name="Attributes.TagName" type="string" default="orgChart2"/>
		<cfparam name="Attributes.id" type="string" default="#application.fn.GetRandomVariable()#"/>
		<cfparam name="Attributes.position" type="string" default="left"/>

		<cfset config = application.fn.GetRandomVariable()/>

		<cfparam name="Attributes.query" type="query"/>
		<cfparam name="Attributes.title" type="string" default="Name"/>
		<cfparam name="Attributes.desc1" type="string" default=""/>
		<cfparam name="Attributes.desc2" type="string" default=""/>
		<cfparam name="Attributes.pk" type="string" default="id"/>
		<cfparam name="Attributes.parent" type="string" default="pid"/>

		<cfparam name="Attributes.imagePrefix" type="string" default=""/>
		<cfparam name="Attributes.imageField" type="string" default=""/>

		<cfparam name="Attributes.NodePadding" default="5px" type="string"/>
		<cfparam name="Attributes.NodeWidth" default="150px" type="string"/>

		<div class="_#Attributes.id#"></div>
		<cfquery name="qC" dbType="query">
			SELECT * FROM Attributes.query WHERE #Attributes.parent# = ''
		</cfquery>
		<script>

			const data = [
				<cfif qC.recordCount gt 1>
					{
						id: "root",
						name: "#request.user.company.Name#",
						position: "", desc1: "", desc2: "#request.user.company.Code#",
						image: "#request.user.company.icon#",
						parentId: "",
					},
				</cfif>
				<cfloop query="#Attributes.query#">
					{
						id: "#Attributes.query[Attributes.pk][currentRow]#",
						name: #serializeJSON(Attributes.query[Attributes.title][currentRow])#,
						position: #serializeJSON(Attributes.query[Attributes.desc1][currentRow])#,
						<cfif Attributes.desc2 neq "">
							desc2: #serializeJSON(Attributes.query[Attributes.desc2][currentRow])#
						<cfelse>
							desc2: ""
						</cfif>,
						image: #serializeJSON(Attributes.imagePrefix & Attributes.query[Attributes.imageField][currentRow])#,
						<cfif Attributes.query[Attributes.parent][currentRow] eq "" && qC.recordCount gt 1>
							parentId: "root"
						<cfelse>
							parentId: "#Attributes.query[Attributes.parent][currentRow]#"
						</cfif>
					},
				</cfloop>
					];
			var #Attributes.id# = new d3.OrgChart()
				.nodeHeight((d) => 85 + 35)
				.nodeWidth((d) => 220 + 10)
				.childrenMargin((d) => 50)
				.compactMarginBetween((d) => 40)
				.compactMarginPair((d) => 35)
				.neighbourMargin((a, b) => 25)
				.linkUpdate(function (d, i, arr) {
					d3.select(this)
						.attr('stroke', '##000') 
						.attr('stroke-width', 1)
				})
				.buttonContent(({ node, state }) => {
					const count = node.data._directSubordinates || 0;
					const colors = [
						'##6E6B6F',
						'##18A8B6',
						'##F45754',
						'##96C62C',
						'##BD7E16',
						'##802F74',
					];
					const color = colors[node.depth % colors.length];
					return `
						<div style="
							font-family: Arial;
							font-size: 10px;
							color: ##fff;
							background-color: ${color};
							border-radius: 5px;
							padding: 4px 8px;
							margin: auto auto;
							border: none;
							display: flex;
							align-items: center;
							gap: 5px;
						">
							<span style="font-size: 9px">
								${
									node.children
										? '<i class="fas fa-angle-up"></i>'
										: '<i class="fas fa-angle-down"></i>'
								}
							</span>
							${count} 
						</div>
					`;
				})
				.nodeContent(function (d, i, arr, state) {
					const imageDiffVert = 25 + 2;
					const colors = [
              '##6E6B6F',
              '##18A8B6',
              '##F45754',
              '##96C62C',
              '##BD7E16',
              '##802F74',
            ];
            const color = colors[d.depth % colors.length];
            const imageDim = 80;
            const lightCircleDim = 95;
            const outsideCircleDim = 110;
					return `
						<div style='border-radius: 10px;background-color:${color};width:${d.width}px;height:${d.height}px;padding-top:${imageDiffVert - 2}px;padding-left:1px;padding-right:1px'>
							<div style="font-family: 'Inter', sans-serif;background-color:white;width:${d.width - 2}px;height:${d.height - imageDiffVert}px;border-radius:10px;border: 1px solid ##E4E2E9">
								<div style="display:flex;justify-content:flex-end;margin-top:5px;margin-right:8px">${d.data.desc2}</div>
								<div style="margin-top:${-imageDiffVert - 25}px;">   
									<img src="${d.data.image}" style="background:white;margin:-5px 10px 10px 10px;border-radius:50%;width:50px;height:50px;border:5px solid ${color};" />
								</div>
								<div style="font-size:15px;color:##08011E;margin-left:20px;margin-top:5px;">${d.data.name}</div>
								<div style="color:##716E7B;margin-left:20px;margin-top:3px;font-size:12px;">${d.data.position}</div>
							</div>
						</div>
					`;
				})
				.container("._#Attributes.id#")
				.data(data) 
				.render();
		</script>
	</cfif>

</cfoutput>