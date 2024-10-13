function openURL(_url) {
	var win = window.open(_url, '_blank');
	win.focus();
}

function showModal(url, options) {

	if (options == undefined) { options = {}; }
	if (options.title == undefined) { options.title = 'Dialog'; }
	if (options.param == undefined) { options.param = ''; }
	if (options.backdrop == undefined) { options.backdrop = false; }

	url = url.replace("?!=", "");
	var page_id = url.replaceAll(".", "_");
	page_id = page_id.replace("@", "_");
	var contl = url.split("@");

	if (contl[1] == undefined) {
		url = contl[0];
		url2 = contl[0];
	}
	else {
		url = contl[0] + "&key=" + contl[1];
		url2 = contl[0] + "@" + contl[1];
	}

	$('#__app_modal_title').html(options.title);
	$.ajax({
		url: view_path + contl[0].replaceAll(".", "/") + '.cfm?rand=' + Math.random() + '&controller=' + url + '&' + options.param,
		cache: false,
		beforeSend: function () {
			//showProgressBar();
			// clear the content
			$('#__app_modal_body').html("<div align='center'><img src='assets/img/loading.gif'/></div><br/><br/><br/>");
		}
	}).done(function (data) {
		$('#__app_modal_body').html(data);
	}).fail(function (xhr) {
		$('#__app_modal_body').html("<div class='text-danger'>" + getErrorMessage(xhr) + "</div><br/><br/><br/>");
	});

	$('#__app_modal').modal({
		backdrop: options.backdrop
	});
}
/*
OPTIONS
	changeURL 		: determine if to change the url on the brower on not
	forcePageReload : determin if to repload all the content of the page
	title 			: the title of the page
	param			: other parameter to pass to the url
	renderTo 		: the id of the element to render the content to
*/
function loadTabPage(url, options) {

	if (options == undefined) { options = {}; }
	if (options.changeURL == undefined) { options.changeURL = true; }
	if (options.forcePageReload == undefined) { options.forcePageReload = false; }
	if (options.param == undefined) { options.param = ''; }

	url = url.replace("?!=", "");
	var page_id = url.replaceAll(".", "_");
	page_id = page_id.replace("@", "_");
	var contl = url.split("@");

	if (contl[1] == undefined) {
		url = contl[0];
		url2 = contl[0];
	}
	else {
		url = contl[0] + "&key=" + contl[1];
		url2 = contl[0] + "@" + contl[1];
	}
	var module_id = contl[0].split(".");

	if (options.forcePageReload === true) {
		$('#' + module_id[0]).remove();
	}

	app_content = $('#app_content');
	//app_title = $('#app_title');

	module_content = $('#' + module_id[0]);
	render_to_page = $('#' + page_id);
	is_tab_content = false;
	//options.renderTo == undefined = from grid view and breadcrump
	//options.renderTo == content = from main menu
	if (options.renderTo != undefined) {
		if (options.renderTo != 'content') {
			is_tab_content = true;
			render_to_page = $('#' + options.renderTo);
		}
	}
	if (!module_content.length) {
		app_content.append("<div id='" + module_id[0] + "' class='app_module'></div>");
		module_content = $('#' + module_id[0]);
	}
	if (!render_to_page.length) {
		module_content.append("<div id='" + page_id + "' class='app_page'></div>");
		render_to_page = $('#' + page_id);
	}

	// create the container first, asin <div id="client_list"> then <div id="client_list$1">
	//console.log(options.forcePageReload);
	if ((!render_to_page.find('div').length) || (options.forcePageReload === true)) {
		$.ajax({
			url: view_path + contl[0].replaceAll(".", "/") + '.cfm?controller=' + url + '&' + options.param,
			//url: 'views/' + contl[0].replaceAll(".","/") + '.cfm?rand=' + Math.random() + '&controller=' + url + '&' + options.param,
			beforeSend: function () {
				showProgressBar();
			},
			cache: false
		}).done(function (data) {
			render_to_page.html(data);
			//console.log(is_tab_content);
			//if(is_tab_content===false)	{showSelectPage(module_content, render_to_page);}
			if (options.changeURL === true) {
				// build default container like in the index page to house [data]
				//window.history.pushState(null, null, '?!=' + url2);
				//window.history.pushState({html: app_content[0].innerHTML}, "", '?!=' + url2);
			}
			//if(options.title!=undefined)	{app_title.html(options.title);}
		}).fail(function (xhr) {
			showError(xhr);
		}).always(function () {
			hideProgressBar();
		});
	}
	else {
		//if(is_tab_content===false)	{showSelectPage(module_content, render_to_page);}
		//app_title.html(options.title);
		if (options.changeURL) {
			// build default container like in the index page to house [data]
			//window.history.pushState(null, null, '?!=' + url2);
			//window.history.pushState({html: app_content[0].innerHTML}, "", '?!=' + url2);
		}
	}
}

/*
OPTIONS
	changeURL 		: determine if to change the url on the browser or not
	forcePageReload : determine if to reload all the content of the page
	title 			: the title of the page
	param			: other parameter to pass to the url
	renderTo 		: the id of the element to render the content to
	modalurl 		: if you want to load a modal first
*/
function loadPage(url, options) {

	if (options == undefined) { options = {}; }
	if (options.title == undefined) { options.title = ''; }
	if (options.handle == undefined) { options.handle = null } else { console.log(options.handle) }
	if (options.changeURL == undefined) { options.changeURL = true; }
	if (options.forcePageReload == undefined) { options.forcePageReload = false; }
	if (options.refreshModule == undefined) { options.refreshModule = false; }
	if (options.param == undefined) { options.param = ''; }
	if (options.modalurl == undefined) { options.modalurl = ''; }

	if (options.modalurl != '') {
		showModal(options.modalurl)
	}

	url = url.replace("?!=", "");
	var page_id = url.replaceAll(".", "_");
	page_id = page_id.replace("@", "_");
	var contl = url.split("@");

	if (contl[1] == undefined) {
		url = contl[0];
		url2 = contl[0];
	}
	else {
		url = contl[0] + "&key=" + contl[1];
		url2 = contl[0] + "@" + contl[1];
	}
	var module_id = contl[0].split(".");

	app_content = $('#app_content');
	//app_title = $('#app_title');
	app_history = $('#__app_history ul');

	if (options.refreshModule === true) {
		$('#' + module_id[0]).remove();
	}

	module_content = $('#' + module_id[0]);
	render_to_page = $('#' + page_id);

	is_tab_content = false;
	//options.renderTo == undefined = from grid view and breadcrumb
	//options.renderTo == content = from main menu
	if (options.renderTo != undefined) {
		if (options.renderTo != 'content') {
			is_tab_content = true;
			render_to_page = $('#' + options.renderTo);
		}
	}
	if (!module_content.length) {
		app_content.append("<div id='" + module_id[0] + "' class='app_module'></div>");
		module_content = $('#' + module_id[0]);
	}
	if (!render_to_page.length) {
		module_content.append("<div id='" + page_id + "' class='app_page'></div>");
		render_to_page = $('#' + page_id);
	}

	// create the container first, asin <div id="client_list"> then <div id="client_list$1">
	//console.log(options.forcePageReload);
	if ((!render_to_page.find('div').length) || (options.forcePageReload === true)) {
		options.title = options.title.replace('_', ' ');
		$.ajax({
			url: view_path + contl[0].replaceAll(".", "/") + '.cfm?controller=' + url + '&' + options.param + '&title=' + options.title,
			//url: 'views/' + contl[0].replaceAll(".","/") + '.cfm?rand=' + Math.random() + '&controller=' + url + '&' + options.param,
			beforeSend: function () {
				showProgressBar();
			},
			cache: false
		}).done(function (data) {
			render_to_page.html(data);
			if (is_tab_content === false) { showSelectPage(module_content, render_to_page); }
			if (options.changeURL === true) {
				// build default container like in the index page to house [data]
				//window.history.pushState({html: app_content[0].innerHTML},"", '?!=' + url2);
				window.history.pushState(null, null, '?!=' + url2);
				// scroll to
				// create histor
				/*if(options.title != '')	{
					app_history.html(app_history.html() + '<li><a onclick="loadPage(' + "'?!=" + url2 + "')" + '">' + options.title + '</a></li>');
					appHistoryScrollRight();
				}*/
				//alert('d');
			}
			//if(options.title!='')	{app_title.html(options.title);}
		}).fail(function (xhr) {
			showError(xhr);
		}).always(function () {
			hideProgressBar();
		});
	}
	else {
		if (is_tab_content === false) { showSelectPage(module_content, render_to_page); }
		//app_title.html(options.title);
		if (options.changeURL) {
			// build default container like in the index page to house [data]
			//window.history.pushState({html: app_content[0].innerHTML},"", '?!=' + url2);
			window.history.pushState(null, null, '?!=' + url2);
		}
	}
}

function appHistoryScrollRight() {
	var leftPos = app_history.width();
	app_history.animate({ scrollLeft: leftPos + 2000 }, 800);
	//console.log(leftPos);
}
function showProgressBar() {

	$('#owaf_progress_bar').append("<span class='overlay'></span><i class='fal fa-spinner fa-pulse fa-4x'></i>");

}

function hideProgressBar() {

	$('#owaf_progress_bar').html('');

}

function showSelectPage(m, p) {
	console.log('sel')
	$('.app_module').addClass('hide');
	$('.app_page').addClass('hide');
	m.removeClass('hide');
	p.removeClass('hide');
	$('#app_content').scrollTop(0);
	// this is a hack for echarts
	//window.dispatchEvent(new Event('resize'));

}

function showError(xhr) {

	var errorPage = $(xhr.responseText), msg = "", err_msg_label, detail_msg = "", stacktrace_msg = "";
	var tbl = errorPage.find("#-lucee-err");

	if (tbl[0] == undefined) {
		// loop through prevObject and
		tbl.prevObject.each(function () {
			if (this.id == '-lucee-err') {
				tbl = $(this);
			}
		});
	}

	if (tbl.find("tr:nth-child(2) td:last")[0] != undefined) {
		msg = tbl.find("tr:nth-child(2) td:last")[0].innerHTML;

		// check the third row. it might be detail or stacktrace
		err_msg_label = tbl.find("tr:nth-child(3) td:first")[0].innerHTML;
		if (err_msg_label == 'Detail') {
			detail_msg = '<hr/>' + tbl.find("tr:nth-child(3) td:last")[0].innerHTML;
		}
		else {
			//stacktrace_msg = '<hr/>'+tbl.find("tr:nth-child(3) td:last")[0].innerHTML;
		}

		/*$.growl.default_options.type = 'danger';
		$.growl({
			message: msg + detail_msg + stacktrace_msg,
			icon: 'fal fa-exclamation-triangle',
			title: 'Error'
		});*/

		//var err = $.parseJSON(xhr.responseText);
		errorNotice(msg + detail_msg + stacktrace_msg);
	}

	//console.log(msg);
}

function getErrorMessage(xhr) {

	var errorPage = $(xhr.responseText), msg = ""
	var tbl = errorPage.find("#-lucee-err");

	if (tbl[0] == undefined) {
		// loop through prevObject and
		tbl.prevObject.each(function () {
			if (this.id == '-lucee-err') {
				tbl = $(this);
			}
		});
	}

	if (tbl.find("tr:nth-child(2) td:last")[0] != undefined) {
		msg = tbl.find("tr:nth-child(2) td:last")[0].innerHTML;
	}

	return msg

}

function ajaxRequest(url, btn, donefn) {
	if (donefn == undefined) { donefn = function () { }; }
	$.ajax({
		url: 'controllers/' + url + '&rand=' + Math.random(),
		cache: false,
		beforeSend: function () {
			btn.className += ' disabled';
			showProgressBar();
		},
	}).done(function (data) {
		donefn(data);
	}).fail(function (xhr) {
		showError(xhr);
	}).always(function (data) {
		btn.className = btn.className.replace(' disabled', '');
		hideProgressBar();
	});
}

function ajaxCall(url, donefn) {
	$.ajax({
		url: 'controllers/' + url + '&rand=' + Math.random(),
		beforeSend: function () {
			showProgressBar();
		},
		cache: false,
	}).done(function (data) {
		donefn(data);
	}).fail(function (xhr) {
		showError(xhr);
	}).always(function (data) { hideProgressBar(); });
}

function itemCreatedNotice(msg) {
	$.growl.default_options.type = 'success';
	//$.growl.default_options.position = {from: 'top', align: 'right'};
	$.growl({
		message: msg,
		icon: 'fal fa-save',
		title: 'Data Saved'
	});
}

/*function warningNotice(msg)	{
	$.growl.default_options.type = 'warning';
	$.growl({
		message: msg,
		icon: 'fal fa-exclamation-circle',
		title: 'Warning'
	});
}*/

function errorNotice(msg) {
	// excape quotes
	var msg_ = msg.replaceAll("'", "");
	msg_ = msg_.replaceAll('"', "");
	msg_ = msg_.replaceAll('\\', "/");

	$.growl.default_options.type = 'danger';
	$.growl({
		message: msg,// + '<hr/><a onclick="loadPage(' + "'support.request.new@" + Math.random() +"',{param:" + "'subject=Error on&body=" + msg_ + "'" + '})" class="btn btn-sm btn-danger">Report Error</a>',
		icon: 'fal fa-exclamation-triangle',
		title: 'Error'
	});
}

function itemSaveNotice(msg) {
	$.growl.default_options.type = 'success';
	$.growl({
		message: msg,
		icon: 'fal fa-save',
		title: ''
	});
}



var myMessages = ['info', 'warning', 'error', 'success']; // define the messages types
function hideAllMessages() {
	var messagesHeights = new Array(); // this array will store height for each

	for (i = 0; i < myMessages.length; i++) {
		messagesHeights[i] = $('.' + myMessages[i]).outerHeight();
		$('.' + myMessages[i]).css('top', -messagesHeights[i]); //move element outside viewport
	}
}

function showMessage(type) {
	$('.af_' + type + '-trigger').click(function () {
		hideAllMessages();
		$('.af_' + type).animate({ top: "0" }, 500);
	});
}



$(document).ready(function () {


	$('a.link').click(function (e) {
		e.preventDefault();

		//var opt = {"renderTo": e.target.attributes['target'].nodeValue, "title": e.target.attributes['title'].nodeValue};
		var _forceload = true;
		var _reload_module = true;
		if (typeof e.target.attributes['forcepagereload'] === 'undefined') {
			_forceload = false;
		}
		if (typeof e.target.attributes['refreshModule'] === 'undefined') {
			_reload_module = false;
		}

		var opt = {
			"forcePageReload": _forceload,
			"refreshModule": _reload_module,
			"renderTo": e.target.attributes['target'].value,
			"param": "title=" + e.target.attributes['title'].value
		};

		loadPage(e.target.attributes['href'].value, opt);
		// this is used in the mobile view to remove the menu from display
		$("div.left").toggleClass("mobile-sidebar");
		$("div.right").toggleClass("mobile-content");
	});

	$.growl.default_options = {
		ele: "body",
		type: "info",
		allow_dismiss: true,
		position: {
			from: "top",
			align: "right"
		},
		offset: 30,
		spacing: 10,
		z_index: 999999999,
		fade_in: 400,
		delay: 10000,
		pause_on_mouseover: true,
		onGrowlShow: null,
		onGrowlShown: null,
		onGrowlClose: null,
		onGrowlClosed: null,
		template: {
			icon_type: 'class',
			container: '<div class="col-xs-7 col-sm-4 col-md-3 alert">',
			dismiss: '<a data-dismiss="alert" aria-hidden="true" class="close"><i class="fal fa-times-circle"></i></a>',//'<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>',
			title: '<strong>',
			title_divider: '<br/>',
			message: ''
		}
	};
});

window.onpopstate = function (e) {
	if (e.state) {
		document.getElementById("app_content").innerHTML = e.state.html;
		//document.title = e.state.pageTitle;
	}
};

String.prototype.replaceAll = function (find, replace) {
	var str = this;
	return str.replace(new RegExp(find.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&'), 'g'), replace);
};

// Extend the default Number object with a formatMoney() method:
// usage: someVar.formatMoney(decimalPlaces, symbol, thousandsSeparator, decimalSeparator)
// defaults: (2, "$", ",", ".")
Number.prototype.formatMoney = function (places, symbol, thousand, decimal) {
	places = !isNaN(places = Math.abs(places)) ? places : 2;
	symbol = symbol !== undefined ? symbol : "";
	thousand = thousand || ",";
	decimal = decimal || ".";
	var number = this,
		negative = number < 0 ? "-" : "",
		i = parseInt(number = Math.abs(+number || 0).toFixed(places), 10) + "",
		j = (j = i.length) > 3 ? j % 3 : 0;
	return symbol + negative + (j ? i.substr(0, j) + thousand : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + thousand) + (places ? decimal + Math.abs(number - i).toFixed(places).slice(2) : "");
};

function moneyFormat(number) {
	var r = 0.00;
	if ($.isNumeric(number)) {
		number = Number(number);
		r = number.toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,');
	}
	return r;
}

function abbrNum(number, decPlaces) {
	// 2 decimal places => 100, 3 => 1000, etc
	decPlaces = Math.pow(10, decPlaces);

	// Enumerate number abbreviations
	var abbrev = ["k", "m", "b", "t"];

	// Go through the array backwards, so we do the largest first
	for (var i = abbrev.length - 1; i >= 0; i--) {

		// Convert array index to "1000", "1000000", etc
		var size = Math.pow(10, (i + 1) * 3);

		// If the number is bigger or equal do the abbreviation
		if (size <= number) {
			// Here, we multiply by decPlaces, round, and then divide by decPlaces.
			// This gives us nice rounding to a particular decimal place.
			number = Math.round(number * decPlaces / size) / decPlaces;

			// Handle special case where we round up to the next abbreviation
			if ((number == 1000) && (i < abbrev.length - 1)) {
				number = 1;
				i++;
			}

			// Add the letter for the abbreviation
			number += abbrev[i];

			// We are done... stop
			break;
		}
	}

	return number;
}

function x__gridremoveTR(grid_id, tr_n) {

	tr_n = tr_n + 1;
	$('#' + grid_id + ' tbody tr:nth-child(' + tr_n + ')').addClass('animated rollOut');
	console.log($('#' + grid_id + ' tbody tr:nth-child(' + tr_n + ')'));

}

function closeModal() {

	$('#__app_modal').modal('hide');

}