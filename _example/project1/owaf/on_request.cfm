<cfscript>
	
	f = application.fn
	$f = application.fn
	tr = $f.tr
	
	cfinclude(template="http_header.cfm")
	cfinclude(template="global_function.cfm")
/* 
	if(left(cgi.request_url,5) == "http:") 	{
		if(!ListFindNoCase("localhost", cgi.SERVER_NAME))	{
			location(replace(cgi.request_url,"http://","https://"), false)
		}
	}
 */
	lock scope="session" throwontimeout="true" timeout="10" type="exclusive" {
		cfparam(name="session.user.islogin", default=false, type="boolean")
		cfparam(name="session.user.pageURLs", default="")
		cfparam(name="session.request_url", default="index.cfm")
		cfparam(name="session.lang", default="")
		//cfparam(name="session.rb", default="")
	}

	//set request scope for user

	
	// set locale from browser 
	if(isDefined("url.lang"))	{
		if(url.lang == "en" || url.lang == "fr")	{
			lock scope="session" throwontimeout="true" timeout="10" type="exclusive" {
				session.lang = url.lang
			}
		}
	}

	lock scope="session" throwontimeout="true" timeout="10" type="readonly" {
		request.user = session.user
		request.lang = session.lang
		setLocale(request.lang)
	}

	if(request.lang == "")	{
		var lng = listFirst(cgi.http_accept_language)
		setLocale(lng)
		// support only for fr 
		if(listFirst(lng,'-') == "fr")	{
			request.lang = "fr"
		}
	}
 


	// set english words into the application variable

	var current_page = listlast(cgi.script_name,'/');

	if(!request.user.islogin && !listfindnocase('onboarding.cfm,test.cfm,process_login.cfm,login.cfm,forget.cfm,register.cfm,confirm.cfm,clear.cfm,logout.cfm,outlook_api.cfm,google_api.cfm',current_page))	{

		if(current_page == 'index.cfm')	{

			lock scope="session" throwontimeout="true" timeout="10" type="exclusive"	{
				if(listlast(cgi.request_url,'/') is not 'login.cfm')	{

					session['request_url'] = cgi.request_url;
				}
			}

			location url='login.cfm' addToken=false;

		}
		var login_page = listFirst(cgi.script_name,'/') & '/inc/relogin.cfm';
		include template='../inc/relogin.cfm';

	}
	else {
		// controller
		cfparam(name="request.user.DefaultPageURL" default="home.welcome")
		cfparam(name="url.controller" default="#request.user.DefaultPageURL#")

		var cgi_query_string = urldecode(cgi.query_string);
		qlen = listlen(cgi_query_string);
		if (qlen)	{
			for (i = 1; i lte qlen; i = i + 1)	{
				item = listgetat(cgi_query_string, i);
				cntl_id = listFirst(item,'=');
				if (cntl_id eq "!")	{
					url.controller = listLast(item,'=');
				}
			}
		}
		//writeOutput(url.controller);

		if(listlen(cgi_query_string,'|') gt 1)	{
			//abort listlen(cgi_query_string,':');
			other_url_param = listlast(cgi_query_string,'|');

			loop list=other_url_param item="url_item" delimiters="&"	{

				url[listfirst(url_item,'=')] = listlast(url_item,'=');

			}
		}

		var url_ = url.controller;
		if(isDefined("url['!']"))	{
			var url_ = url["!"];
		}
		//writedump(url.controller);
		switch(listlen(url.controller,'.')){
			case 2:
				url.controller = replace(listlast(url_,'.'),'_','','all');
				url.controller = listfirst(url_,'.') & '.' & url.controller;
			break;
			case 3:
				ctrl_page = listfirst(url_,'.') & '.' & listgetat(url_,2,'.');
				url.controller = replace(listgetat(url_,2,'.'),'_','','all');
				url.controller = listfirst(url_,'.') & '.' & url.controller & '.' & listlast(url_,'.');
			break;
		}

		//abort url.title;
		url.current_page_url = url.controller;

		// check for the title in the current page then add it to page view history ====

		lock timeout="40" scope="session" type="exclusive"	{

			if(!isdefined("session.viewPageHistory"))	{
				session.viewPageHistory = queryNew("url,title,id,key");
				session.viewPageHistoryCount=1;
			}

			param name="url.title" default="";

			if(url.title neq "")	{
				// check if item is in the list
				query name='qt' dbtype='query'	{
					echo("SELECT * FROM session.viewPageHistory WHERE url = '" & url.current_page_url & "'");
				}

				if (qt.recordcount) 	{

					query name='session.viewPageHistory' dbtype='query'	{
						echo("SELECT * FROM session.viewPageHistory WHERE url <> '" & url.current_page_url & "'");
					}
				}

				session.viewPageHistory.addRow()
				session.viewPageHistory.setCell('title',url.title)
				session.viewPageHistory.setCell('url',url.current_page_url)
				session.viewPageHistory.setCell('id',session.viewPageHistoryCount)
				cfparam(name="url.key", default="0")
				session.viewPageHistory.setCell('key',url.key)
				session.viewPageHistoryCount++
			}

		}


		// write into request
		lock timeout="30" scope="session" type="readonly"	{
			request.viewPageHistory = session.viewPageHistory;
		}
		// ============================================================================


		if(listFindNoCase(request.user.pageURLs, listfirst(url_,'@')))	{

			cfparam(name="url.key", default="#listLast(url.controller,'@')#")

			url.key = listFirst(url.key,':');


			if(url.controller != "")	{

				_action = listLast(url.controller,'.');
				_controller = replacenocase(url.controller,'.'&_action,'')
				_action = listFirst(_action,'@');

				cfparam(name="ctrl_page", default="#_controller#")

				url.current_page_url = url.controller;
				if(isnumeric(url.key))	{
					if(listlen(url.current_page_url,'@') is 1)	{
						url.current_page_url = url.current_page_url & '@' & url.key;
					}
					// create : parameter ...
				}

				try {
					view = evaluate('controller("' & _controller & '").' & replace(_action,'_','','all') & '(url)');
				}
				catch(any error) {

					//ignore missing function
					/*if(findnocase("hasnofunction",replace(error.message,' ','','all')))	{

						view = error.message;
						//abort error.message;
						//view = evaluate('controller("' & _controller & '").' & replace(_action,'_','','all') & '(url)');

					}
					else 	{*/

						view = evaluate('controller("' & _controller & '").' & replace(_action,'_','','all') & '(url)');

					//}

				}

				request.view_path = "views/";
	 			//request._page = url_;
	 			//request.include_page = request.view_path & lcase(replace(ctrl_page,'.','/','all')) & "/" & lcase(_action) & ".cfm";
				request.include_page = request.view_path & listfirst(lcase(replace(url_,'.','/','all')),'@') & ".cfm";

			}
		}
		else 	{

			request.include_page = 'views/secure_page.cfm';

		}

	}

	//writedump(cgi);

</cfscript>