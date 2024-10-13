<cfoutput>
	<cfcontent type="application/json"/>
	<cfscript>
		if(val(url.min))	{
			if(url.min > val(form.value))	{
				abort "Minimum value should be #url.min#"
			}
		}
		if(val(url.max))	{
			if(url.max < val(form.value))	{
				abort "Maximum value should be #url.max#"
			}
		}
		var _model = model(url.model_desc);
		_model.new({
			'#_model._pk_field#' : '#form.pk#',
			'#form.name#'					: '#form.value#'
		}).save();
		writeOutput('{"pk":#form.pk#}');
		// check if log-able
		if(isDefined("application.model.LOG---"))	{// disable

			switch(url.model_desc) {

			   case application.model.APPRAISAL:
			   case application.model.APPRAISAL_OBJECTIVE:

					_model.log(form.pk, request.user.userid, "User updates Appraisal/Objective", "#form.name# => #form.value#");

			   break;

			}

		}
	</cfscript>
</cfoutput>