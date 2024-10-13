<cfoutput>
<!doctype html>
<!--[if lt IE 7]> <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
<!--[if IE 7]>    <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
<!--[if IE 8]>    <html class="no-js lt-ie9" lang="en"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->
<head>

	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta name="viewport" content="width=device-width">

	<title>OWAF | Documentation</title>
	<link rel="stylesheet" href="assets/css/bootstrap.min.css">
	<link rel="stylesheet" href="assets/css/reset.css">
	<link rel="stylesheet" href="assets/css/style.css">


	<script src="assets/js/libs/modernizr-2.5.3.min.js"></script>
	<script src="assets/js/libs/prettify.js"></script>
	<script src="assets/js/libs/mootools-core-1.4.5.min.js"></script>
	<script src="assets/js/libs/mootools-more-1.4.0.1.min.js"></script>
	<script src="assets/js/libs/moobile-simulator.js"></script>
	<script src="assets/js/plugins.js"></script>
	<script src="assets/js/script.js"></script>
	<script src="assets/js/jquery-2.1.3.min.js"></script>
	<script src="assets/js/bootstrap.min.js"></script>

	<!---script type="text/javascript">
		Moobile.Simulator.setResourcePath('../../assets/shared/resources');
	</script--->
<style type="text/css">a{cursor: pointer;}</style>
</head>
<body>

	<!--[if lt IE 7]><p class=chromeframe>Your browser is <em>ancient!</em> <a href="https://browsehappy.com/">Upgrade to a different browser</a> or <a href="https://www.google.com/chromeframe/?redirect=true">install Google Chrome Frame</a> to experience this site.</p><![endif]-->

<!--- default modal ---->
<div class="modal fade" id="modalform">
	<form action="" id="_form">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
			    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
			    <h4 class="modal-title">Modal title</h4>
			</div>
		  	<div class="modal-body">
		    	<p>One fine body&hellip;</p>
		  	</div>
		  	<div class="modal-footer">
		    	<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
		    	<button type="submit" class="btn btn-primary">Save changes</button>
		  	</div>
		</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
	</form>
</div><!-- /.modal -->


	<div id="sidebar" class="sidebar">
		<h1>Guides</h1>

		<ul class="file-list">
			<li><a class="link" href="guides/getting_started.htm">Getting Started</a></li>
			<li><a class="link" href="guides/hello_world.htm">Hello World</a></li>
		</ul>

		<h1>Components</h1>

		<cfquery name="qCom_type">
			SELECT * FROM component_type
		</cfquery>

		<cfloop query="#qCom_type#">
			<cfquery name="qCom">
				SELECT * FROM component
				WHERE ComponentTypeId = #qCom_type.ComponentTypeId#
				ORDER BY Title
			</cfquery>

			<!---h2>#qCom_type.Title#</h2--->
			<cfif qCom_type.ComponentTypeId eq 3>
				<h1>Tags</h1>
			</cfif>
			<ul class="file-list">
				<cfloop query="qCom">
					<li><a class="link" href="docs/#lcase(qCom.Type)#.cfm?id=#qCom.ComponentId#"><span>owaf.</span>#qCom.Title#</a></li>
				</cfloop>
			</ul>

		</cfloop>


	</div>


	<div id="content" class="">
		<div class="content full intro"></div>
	</div>

 	<script>
		$$('a').addEvent('click', function(e){
			e.stop();
			//console.log(e.target.getAttribute('href'));
			var content = $$('##content');
			$$('a').removeClass('current');
			content.removeClass('intro');
			content.set('load', {evalScripts: true});
			content.load(e.target.getAttribute('href'));
			e.target.addClass('current');
			/*new Request.HTML({
			    url: e.target.getAttribute('href'),
			    method: 'get',
			    onRequest: function(){
			        content.set('text', 'loading...');
			        $$('a').removeClass('current');
			    },
			    onSuccess: function(responseText){
			        content.set('html', responseText);
			        e.target.addClass('current');
			    },
			    onFailure: function(x){
			       //console.log(x);
			       content.set('html', x.responseText);

			    }
			}).send(); */
		});

		$('##modalform').on('show.bs.modal', function (event) {
			var a = $(event.relatedTarget); // Button that triggered the modal

			var modal = $(this);
			var _url = a.data('url');
			var _key = a.data('key');
			modal.find('.modal-title').text(a.data('title'));
			modal.find('.modal-body').load('forms/'+_url+'.cfm?key='+_key);
			modal.find('form').attr('action', 'forms/save.cfm?object='+_url+'&key='+_key);

		})

		//Callback handler for form submit event
		$("##_form").submit(function(e) 	{
		 	e.preventDefault();
		    var formObj = $(this);
		    var formData = formObj.serialize();
		    console.log(formData);
		    //alert(formObj.attr("action"));
	        $.ajax({
	            url: formObj.attr("action"),
	            data: formData,
	          	method: 'POST',
	            success: function (data) {
	                 $('##modalform').modal('hide');
	            },
	            cache: false
	        });
		});
 	</script>

</body>
</html>

</cfoutput>