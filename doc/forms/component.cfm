<cfquery name="qC">
	SELECT * FROM component WHERE ComponentId = #url.key#
</cfquery>
<cfoutput>
	<div class="row">
		<div class="col-sm-6">
			<label for="Title">Title</label>
			<input type="text" class="form-control" name="Title" required value="#qC.Title#"/>
		</div>

		<div class="col-sm-6">
			<label for="Type">Type</label>
			<input type="text" class="form-control" name="Type" required value="#qC.Type#"/>
		</div>
	</div>
	<br/>
	<label for="Description">Description</label>
	<textarea name="Description" class="form-control">#qC.Description#</textarea>
</cfoutput>