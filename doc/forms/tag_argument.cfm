<cfquery name="qC">
	SELECT * FROM parameter WHERE ParameterId = #url.key#
</cfquery>
<cfoutput>
	<div class="row">
		<div class="col-sm-6">
			<label for="Name">Name</label>
			<input type="text" class="form-control" name="Name" required value="#qC.Name#"/>
		</div>
		<div class="col-sm-6">
			<label for="ComponentId">Tag </label>
			<input type="text" class="form-control" name="TagId" required value="#qC.TagId#"/>
		</div>
	</div>
	<br/>
	<label for="Description">Description</label>
	<textarea name="Description" class="form-control" rows="9">#qC.Description#</textarea>
	<br/>
	<div class="row">
		<div class="col-sm-6">
			<label for="Required">Required</label>
			<input type="text" class="form-control" name="Required" required value="#qC.Required#"/>
		</div>
		<div class="col-sm-6">
			<label for="Type">Type </label>
			<input type="text" class="form-control" name="Type" required value="#qC.Type#"/>
		</div>
	</div>
	<br/>
	<label for="Default">Default</label>
	<textarea name="Default" class="form-control" >#qC.Default#</textarea>
</cfoutput>