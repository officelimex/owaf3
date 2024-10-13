<cfoutput>
	<cfscript>
		_model = model(url.model_desc);
		_model.new({
			'#_model._pk_field#' : '#form.pk#',
			'#form.name#'			: '#form.value#'
		}).save();
		// return the pk
		#form.pk#
	</cfscript>
</cfoutput>