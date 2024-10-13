<cfoutput>

<cfquery name="qTag">
	SELECT
		pt.Name ParentTag, pt.TagId ParentTagId, c.Title ComponentTitle,
		t.Name Tag, c.Description ComponentDescription,
		t.ComponentId
	FROM tag t
	INNER JOIN component c ON c.ComponentId = t.ComponentId
	LEFT JOIN tag pt ON pt.ParentTagId = t.ParentTagId
	WHERE t.ComponentId = #url.id#
	GROUP BY pt.TagId, t.Name
	ORDER BY pt.ParentTagId, t.Name
</cfquery>

<cfquery name="qTag_t">
	SELECT
		-- pt.Name ParentTag, 
		c.Title ComponentTitle, c.Description ComponentDescription,
		t.Name Tag, t.TagId, t.Description, t.TagExample, t.ScriptExample, t.ParentTagId,
		ANY_VALUE(pt.Name) ParentTag 
	FROM tag t
	INNER JOIN component c ON c.ComponentId = t.ComponentId
	LEFT JOIN tag pt ON pt.ParentTagId = t.ParentTagId
	WHERE t.ComponentId = #url.id#
	GROUP BY t.TagId 
	ORDER BY pt.ParentTagId, t.Name
</cfquery>




<div id="content" class="content">

	<h1>
		#qTag.ComponentTitle#
		<a 	data-title="Update Component"
			data-url="component"
			data-toggle="modal"
			data-key="#qTag.ComponentId#"
			data-target="##modalform">.
		</a></h1>

	<p>#qTag.ComponentDescription#</p>



		<cfloop query="qTag_t">

			<cfquery name="qPR">
				SELECT * FROM parameter WHERE TagId = #qTag_t.TagId#
				ORDER BY required, name
			</cfquery>

			<p></p>

			<cfquery name="qPR1" dbtype="query">
				SELECT * FROM qPR
			</cfquery>

			<cfif qTag_t.ParentTag eq "">
				<h2 id="#qTag_t.Tag#">#qTag_t.Tag#		<a 	data-title="Update Tag"
			data-url="tag"
			data-toggle="modal"
			data-key="#qTag_t.TagId#"
			data-target="##modalform">.
		</a></h2>
			<cfelse>
				<h3 id="#qTag_t.Tag#">#qTag_t.Tag#		<a 	data-title="Update Tag"
			data-url="tag"
			data-toggle="modal"
			data-key="#qTag_t.TagId#"
			data-target="##modalform">.
		</a></h3>
			</cfif>



			<p>#qTag_t.Description#</p>
			<cfif qPR.recordcount>
				<h4>Attributes:</h4>
				<table>
					<thead>
						<tr>
							<th>Name</th>
				  			<th>Type</th>
				  			<th>Description</th>
						</tr>
					</thead>
					<tbody>
						<cfloop query="qPR">
							<tr>
								<td nowrap><code>#qPR.Name#</code> <cfif qPR.Required><strong style="color:red">*</strong></cfif></td>
				 				<td>#qPR.Type#</td>
				  				<td>
				  					<cfset desc = replaceNoCase(qPR.Description, "{{TAG_NAME}}", qPR.Name, 'ALL')/>
				  					#desc#
				  					<cfif qPR.Default neq "">
				  						<br/>Default: #qPR.Default#
				  					</cfif>
		<a 	data-title="Update Attributes"
			data-url="tag_argument"
			data-toggle="modal"
			data-key="#qPR.ParameterId#"
			data-target="##modalform">.
		</a>
				  				</td>
				  			</tr>
				  		</cfloop>
				  	</tbody>
				</table>
		<a 	data-title="Update Attributes"
			data-url="tag_argument"
			data-toggle="modal"
			data-key="0"
			data-target="##modalform">+
		</a>
			</cfif>
			<!--- example here --->
			<cfif qTag_t.TagExample neq "" or qTag_t.ScriptExample neq "">
 				<h4>Example:</h4>
				<cfif qTag_t.ScriptExample neq "">
					<pre class="prettyprint"><code>#qTag_t.ScriptExample#</code></pre>
				</cfif>

				<cfif qTag_t.TagExample neq "">
					<cfset e = replace(qTag_t.TagExample, "<", "&lt;", "all")/>
					<cfset e = replace(e, ">", "&gt;", "all")/>
					<pre class="prettyprint"><code>#e#</code></pre>
				</cfif>
			</cfif>

			<cfif qTag_t.recordcount neq qTag_t.currentrow>
				<hr/>
			</cfif>

		</cfloop>



</div>

<div id="table-of-contents" class="table-of-contents">
	<h2>Table of Contents</h2>
	<ul>

		<cfquery name="qPT" dbtype="query">
			SELECT * FROM qTag_t
			WHERE ParentTag = ''
		</cfquery>

		<cfloop query="qPT">

			<li>
				<a href="###qPT.Tag#">#qPT.Tag#</a>
				<cfquery name="qTag__" dbtype="query">
					SELECT * FROM qTag_t
					WHERE ParentTagId = #val(qPT.TagId)#
				</cfquery>

				<cfif qTag__.recordcount>
					<ul>
						<cfloop query="qTag__">
							<li>
								<a href="###qTag__.Tag#">#qTag__.Tag#</a>
								<cfquery name="qTag2" dbtype="query">
									SELECT * FROM qTag_t
									WHERE ParentTagId = #val(qTag__.TagId)#
								</cfquery>
								<cfif qTag2.recordcount>
									<ul>
										<cfloop query="qTag2">
											<li>
												<a href="###qTag2.Tag#">#qTag2.Tag#</a>
												<cfquery name="qTag3" dbtype="query">
													SELECT * FROM qTag_t
													WHERE ParentTagId = #val(qTag2.TagId)#
												</cfquery>
												<cfif qTag3.recordcount>
													<ul>
														<cfloop query="qTag3">
															<li><a href="###qTag3.Tag#">#qTag3.Tag#</a></li>
														</cfloop>
													</ul>
												</cfif>
											</li>
										</cfloop>
									</ul>
								</cfif>
							</li>
						</cfloop>
					</ul>
				</cfif>
			</li>

		</cfloop>

	</ul>
</div>
</cfoutput>

<script type="text/javascript">
	prettyPrint();
	document.getElements('.table-of-contents a').each(function(el) {
		el.addEvent('click', function(e) {

			e.stop();
			document.location.hash = '#lambada';
			document.location.hash = this.href.split('#')[1];

		});

	});

	<!---$$("a.edit_component").addEvent("click", function(){
		$('#modalform').modal();
	});--->
</script>