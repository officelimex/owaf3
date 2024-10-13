<cfquery name="qC">
	SELECT * FROM tag WHERE TagId = #url.key#
</cfquery>
<cfoutput>
	<div class="row">
		<div class="col-sm-6">
			<label for="Name">Name</label>
			<input type="text" class="form-control" name="Name" required value="#qC.Name#"/>
		</div>
		<div class="col-sm-6">
			<label for="ComponentId">Component</label>
			<input type="text" class="form-control" name="ComponentId" required value="#qC.ComponentId#"/>
		</div>
	</div>
	<br/>
	<label for="Description">Description</label>
	<textarea name="Description" class="form-control">#qC.Description#</textarea>
	<br/>
	<label for="TagExample">Tag Example</label>
	<textarea name="TagExample" class="form-control" rows="10">#qC.TagExample#</textarea>
	<br/>
	<label for="ScriptExample">Script Example</label>
	<textarea name="ScriptExample" class="form-control" rows="10">#qC.ScriptExample#</textarea>
</cfoutput>