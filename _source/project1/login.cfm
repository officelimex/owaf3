<cfoutput>
<cfset tinfo = application.fn.getTenantInfo()/>

<cfif isDefined("form.email")>
	
	<cflock scope="Session" throwontimeout="true" timeout="10" type="readonly">
		<cfset request_url = session.request_url/>
	</cflock>

	<cfscript>
		loop list=request_url delimiters='?' item="param_item"	{
			loop list=param_item delimiters='&' item="x"	{
				if(listFirst(x,'=')=="CFID" || listFirst(x,'=')=="CFTOKEN")	{
					request_url = replaceNoCase(request_url, x, "")
				}
			}
		}
		request_url = replace(request_url, '?&', '')
		request_url = replace(request_url, 'www.', '')
	</cfscript>

	<cfset request_url = replacenocase(request_url,'login','index')/>

	<cfset l = CreateObject('component', 'project1.models.tenant.User').init()/>
	<cfset u = l.Login(form.token, form.password, tinfo.tenantId)/>

	<cfset url.error = u.error/>
	<cfif u.error == "">

		<cflock timeout="25" scope="session" type="exclusive">
			<cfset session.user = u.User/>
		</cflock>
		<script language="javascript">
			location.replace('#request_url#');
		</script>

	<cfelse>


	</cfif>

</cfif>

<!doctype html>
<html lang="en">
  <head>

		<cfinclude template="owaf/http_header.cfm"/>

		<meta name="robots" content="noindex">
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1.00001, viewport-fit=cover"/>

		<meta name="description" content="">
		<meta name="google-signin-client_id" content="#tinfo.GSCode#">
		<link rel="stylesheet" href="assets/fonts/feather/feather.min.css">
		<link rel="stylesheet" href="assets/css/login.css?v=1.21">
		<link rel="stylesheet" href="assets/css/theme.min.css" id="stylesheetLight">
		<link rel="shortcut icon" href="assets/img/favicon.png">
		<link rel="apple-touch-icon" href="assets/img/icon-180x180.png" size="180x180">
		<meta name="apple-mobile-web-app-status-bar" content="##FFE1C4">
		<meta name="theme-color" content="##FFE1C4">

    <style>body { display: none; }</style>
		<title>Login &mdash; Project1</title> 

    <style>body { display: none; }</style>
    
  </head>
  <body class="d-flex align-items-center bg-auth border-top border-top-2 border-primary">
    <!-- CONTENT
    ================================================== -->
    <div class="container-fluid">
      <div class="row align-items-center justify-content-center">
        <div class="col-12 col-md-5 col-lg-6 col-xl-4 px-lg-6 my-5">
              
					<div class="text-center mb-md-6 mb-5">
						<cfif val(tinfo.tenantid)> 
							<!--- get size of logo if there --->
							<cfset options = listLast(tinfo.logoURL, '?')>
							<cfset kw = listFirst(options, '=')/>
							<cfset size = "150px"/>
							<cfif kw == 'size'>
								<cfset size = listLast(options, '=')/>
							</cfif>							
							<img src="#tinfo.logoURL#"  width="#size#"/>
						<cfelse>
							<img src="assets/img/logo.png" width="180px">
						</cfif> 
					</div>
					<cfparam name="url.error" default=""/>
					<cfparam name="u.error" default=""/>
          <h1 class="display-4 text-center mb-3">
            #tr("Sign In")#
          </h1>
					<cfif len(url.error)>
						<div class="text-danger text-center">
							#url.error#<br/><br/>
						</div>
					</cfif>          
					<p class="text-muted text-center mb-5">
						#tr("Sign in using your Project1 account")#
					</p>
          
					<form method="post" action="login.cfm">

						<div id="email_dis_group" class="hide mb-4">
							<div id="email_dis_el"></div>
							<a href="login.cfm" class="fe fe-arrow-left"></a>
						</div>

						<div class="form-group" id="email_form_group">

							<div class="input-group input-group-merge">

								<input type="email" class="form-control form-control-appended" required id="email" name="email" placeholder="#tr("Email Address")#">

								<div class="input-group-append">
									<span class="input-group-text">
										<i class="fe fe-mail"></i>
									</span>
								</div>
							</div>
							<small class="form-text text-danger text-center hide" id="email_help"></small>

						</div>

						<div class="form-group hide" id="password_cont">

							<label>#tr("Password")#</label>
							<div class="input-group input-group-merge">
								<input type="password" autocomplete="off" class="form-control form-control-appended" name="password" placeholder="#tr("Enter your password")#">
								<div class="input-group-append">
									<span class="input-group-text">
										<i class="fe fe-lock"></i>
									</span>
								</div>

							</div>
						</div>

						<div class="hide" id="sign_in">
							<button class="btn btn-lg btn-block btn-primary mb-3" type="submit" onclick="login(this)">
								<span id="login_spinner" class="hide spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>
								<span id="sign_in_text">#tr("Sign In")#</span>
							</button>
						</div>
						<div class="" id="_continue">
							<button class="btn btn-lg btn-block btn-primary mb-3" type="button" id="_continue_btn" onclick="conti()">
								<span id="cont_spinner" class="hide spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>
								#tr("Continue")#
							</button>
						</div>

						<div class="text-center mb-1">
							<small class="text-muted text-center">
								#tr("Can't remember your password?")# <a href="forget.cfm">#tr("Retrieve it")#</a>.
							</small>
						</div>

						<cflock type="exclusive" scope="session" >
							<cfset session.tinfo = tinfo/>
						</cflock>
						<input type="hidden" value="" name="token" id="token"/>
					</form>
					

        </div>
        <div class="col-12 col-md-7 col-lg-6 col-xl-8 d-none d-lg-block">
          <div class="bg-cover vh-100 mt--1 mr--3" style="background-image: url('assets/img/cover1.jpg');"></div>
        </div>
      </div>
    </div>

  </body>

	<script>

		var email_help = document.getElementById("email_help");
		var email_el = document.getElementById("email");
		var cont_spinner = document.getElementById("cont_spinner");
		var token = document.getElementById("token");
		var password_cont = document.getElementById("password_cont");
		var _continue = document.getElementById("_continue");
		var _continue_btn = document.getElementById("_continue_btn");
		var sign_in = document.getElementById("sign_in");
		var email_form_group = document.getElementById("email_form_group");
		var email_dis_group = document.getElementById("email_dis_group");
		var email_dis_el = document.getElementById("email_dis_el");
		var login_spinner = document.getElementById("login_spinner");
		var sign_in_text = document.getElementById("sign_in_text");
		
		function login(e)	{
			sign_in_text.innerHTML = "#tr('Signing you in')#...";
			login_spinner.classList.remove("hide");
			e.disabled = false
		}

		function conti() {
			email_help.classList.add("hide");
			cont_spinner.classList.remove("hide");
			_continue_btn.disabled = true
			email_help.innerHTML = "";
			hReq = new XMLHttpRequest();

			if (!hReq) {
				console.log('Giving up :( Cannot create an XMLHTTP instance');
				return false;
			}
			hReq.onreadystatechange = userNameCheck;
			hReq.open('GET', 'controllers/Employee.cfc?method=checkEmail&t=#tinfo.tenantId#&email='+email_el.value);
			hReq.send();
		}

		function userNameCheck() {
			if (hReq.readyState === XMLHttpRequest.DONE) {
				var d = JSON.parse(hReq.responseText)
				if (hReq.status === 200) {
					// email_el.setAttribute('readonly', true);
					token.value = d.token;
					password_cont.classList.remove("hide");
					_continue.classList.add("hide");
					sign_in.classList.remove("hide");
					email_form_group.classList.add("hide");
					email_dis_group.classList.remove("hide");
					email_dis_el.innerHTML = email_el.value;
				} else {
					email_help.classList.remove("hide");
					cont_spinner.classList.add("hide");
					email_help.innerHTML = d.message;
					_continue_btn.disabled = false
				}
			}
		}

	</script>
</html>
</cfoutput>