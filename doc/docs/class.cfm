<cfoutput>

<cfquery name="qM">
	SELECT 
		*, mt.Title MethodType, c.Title ComponentTitle,
		m.Name Method, c.Description ComponentDescription
	FROM method m
	INNER JOIN component c ON c.ComponentId = m.ComponentId
	INNER JOIN method_type mt ON mt.MethodTypeId = m.MethodTypeId
	WHERE m.ComponentId = #url.id#
	ORDER BY mt.MethodTypeId, m.Name
</cfquery>

<cfquery name="qMT" dbtype="query">
	SELECT MethodType,MethodTypeId FROM qM
	GROUP BY MethodType,MethodTypeId 
</cfquery>

<div id="content" class="content">

	<h1>#qM.ComponentTitle#</h1>
	<h5><cfif qM.BaseComponent neq "">
		Extends #qM.BaseComponent#
	</cfif>
	</h5>
	
	<p>#qM.ComponentDescription#</p>

	<cfloop query="qMT">

		<h2 id="#qMT.MethodType#">#qMT.MethodType#</h2>
		<cfquery name="qM_" dbtype="query">
			SELECT * FROM qM
			WHERE MethodTypeId = #qMT.MethodTypeId#
		</cfquery> 
			


		<cfloop query="qM_">

			<cfquery name="qPR">
				SELECT * FROM parameter WHERE MethodId = #qM_.MethodId#
			</cfquery>

			<p></p>
 
			<cfquery name="qPR1" dbtype="query">
				SELECT * FROM qPR 
			</cfquery>
			<h3 id="#qM_.Method#">#qM_.Method#<small>(#qPR1.columnData('Name').toList(', ')#)</small></h3>
			<p>#qM_.Description#</p>
			<cfif qPR.recordcount>
				<h4>Parameters:</h4>
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
				  					#qPR.Description#
				  					<cfif qPR.Default neq "">
				  						<br/><b>Default:</b> #qPR.Default#
				  					</cfif>
				  				</td>
				  			</tr>
				  		</cfloop>
				  	</tbody>
				</table>
			</cfif>
			<!--- example here --->
			<cfif qM_.Example neq "">
				<h4>Example:</h4>
				<pre class="prettyprint "><code>#qM_.Example#</code></pre>
			</cfif>
			<cfif qM_.Returns neq "">
				<h4>Returns:</h4><ul><li>#qM_.Returns#</li></ul>
			<cfelse>
				<h4>Returns:</h4><ul><li>Void</li></ul>
			</cfif> 

			<cfif qM_.recordcount neq qM_.currentrow>
				<hr/>
			</cfif>

		</cfloop>
				  
		
	</cfloop> 

</div>

<div id="table-of-contents" class="table-of-contents">
	<h2>Table of Contents</h2>
	<ul> 

		<cfloop query="qMT"> 
			<li><a href="###qMT.MethodType#">#qMT.MethodType#</a>
				<cfquery name="qM__" dbtype="query">
					SELECT * FROM qM
					WHERE MethodTypeId = #qMT.MethodTypeId#
				</cfquery>
				<cfif qM__.MethodType EQ "Initialization">

				<cfelse>
					<ul>
						<cfloop query="qM__">
							<li><a href="###qM__.Method#">#qM__.Method#</a></li> 
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
</script>