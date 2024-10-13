function openURL(_url) {
	var win = window.open(_url, '_blank');
	win.focus();
}

var app_modal_body = $('#__app_modal_body');

function showModal(url, options) {

	if (options == undefined) {
		options = {};
	}
	if (options.title == undefined) {
		options.title = 'Dialog';
	}

	if (options.param == undefined) {
		options.param = '';
	}
	if (options.keyboard == undefined) {
		options.keyboard = false;
	}
	if (options.backdrop == undefined) {// true, false, static
		options.backdrop = 'static';
	}
	if (options.position == undefined) {
		options.position = 'center'; // left, right
	}

	url = url.replace("?!=", "");
	var page_id = url.replaceAll(".", "_");
	page_id = page_id.replace("@", "_");
	page_id = page_id.replaceAll(" ", "_");
	page_id = page_id.replaceAll("-", "_");

	var contl = url.split("@");

	if (contl[1] == undefined) {
		url = contl[0];
		url2 = contl[0];
	} else {
		url = contl[0] + "&key=" + contl[1];
		url2 = contl[0] + "@" + contl[1];
	}

	$('#__app_modal_title').html(options.title);

	$.ajax({
		url: view_path + contl[0].replaceAll(".", "/") + '.cfm?rand=' + uuidv4() + '&controller=' + url + '&' + options.param,
		cache: false,
		beforeSend: function () {
			//showProgressBar();
			app_modal_body.html("<div class=''><div class='loader loader-primary'></div></div>");
			
		}
	}).done(function (data) {
		app_modal_body.html(data);
	}).fail(function (xhr) {
		app_modal_body.html("<div class='text-danger'>" + getErrorMessage(xhr) + "</div>");
	});

	// postion modal
	var _m = $('#__app_modal');

	var _mi = $('#__app_modal .modal-dialog');
	_m.removeClass("fixed-right");
	_m.removeClass("fixed-left");
	_mi.removeClass("modal-dialog-vertical");
	if (options.position == 'center') {
		_mi.addClass("modal-dialog-centered");
	}
	else {
		_mi.removeClass("modal-dialog-centered");
		_mi.addClass("modal-dialog-vertical");
		_m.addClass("fixed-" + options.position);
	}

	_m.modal();
	_m.data('bs.modal')._config.backdrop = options.backdrop;
	_m.data('bs.modal')._config.keyboard = options.keyboard;

	setTimeout(function(){ app_modal_body.scrollTop(0); }, 250);

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

	if (options == undefined) {
		options = {};
	}
	if (options.changeURL == undefined) {
		options.changeURL = true;
	}
	if (options.forcePageReload == undefined) {
		options.forcePageReload = false;
	}
	if (options.param == undefined) {
		options.param = '';
	}

	url = url.replace("?!=", "");
	var page_id = url.replaceAll(".", "_");
	page_id = page_id.replace("@", "_");
	var contl = url.split("@");

	if (contl[1] == undefined) {
		url = contl[0];
		url2 = contl[0];
	} else {
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
	if ((!render_to_page.find('div').length) || (options.forcePageReload === true)) {
		$.ajax({
			url: view_path + contl[0].replaceAll(".", "/") + '.cfm?controller=' + url + '&' + options.param,
			//url: 'views/' + contl[0].replaceAll(".","/") + '.cfm?rand=' + uuidv4() + '&controller=' + url + '&' + options.param,
			beforeSend: function () {
				showProgressBar();
			},
			cache: false
		}).done(function (data) {
			render_to_page.html(data);
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
	} else {
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
	param					: other parameter to pass to the url
	renderTo 		: the id of the element to render the content to
	modalurl 		: if you want to load a modal first
	samePage 		: false -
*/
function loadPage(url, options) {
	
	if (options == undefined) 								{options = {};}
	if (options.title == undefined) 					{options.title = '';}
	if (options.samePage == undefined) 				{options.samePage = false;}
	if (options.handle == undefined) 					{options.handle = null}
	if (options.changeURL == undefined) 			{options.changeURL = true;}
	if (options.forcePageReload == undefined) {options.forcePageReload = false;}
	if (options.refreshModule == undefined) 	{options.refreshModule = false;}
	if (options.param == undefined) 					{options.param = '';}
	if (options.modalurl == undefined) 				{options.modalurl = '';}
	if (options.scrollTo == undefined) 				{options.scrollTo = '';}
	if (options.donefn == undefined) 					{options.donefn = function() {};}

	if (options.modalurl != '') {
		showModal(options.modalurl)
	}

	url = url.replace("?!=", "");
	var page_id = url.replaceAll(".", "_");
	page_id = page_id.replace("@", "_");
	page_id = page_id.replaceAll(" ", "_");
	page_id = page_id.replaceAll("-", "_");
	var contl = url.split("@");

	if (contl[1] == undefined) {
		url = contl[0];
		url2 = contl[0];
	} else {
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
		if(!options.samePage)	{
			options.samePage = true;
		}
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
	if ((!render_to_page.find('div').length) || (options.forcePageReload === true)) {
		options.title = options.title.replace('_', ' ');
		$.ajax({
			url: view_path + contl[0].replaceAll(".", "/") + '.cfm?controller=' + url + '&' + options.param + '&title=' + options.title,
			//url: 'views/' + contl[0].replaceAll(".","/") + '.cfm?rand=' + uuidv4() + '&controller=' + url + '&' + options.param,
			beforeSend: function () {
				showProgressBar();
			},
			cache: false
		}).done(function (data) {
			if (!options.samePage) {
				showSelectPage(module_content, render_to_page);
			}
			render_to_page.html(data);
			if (is_tab_content === false) {
				showSelectPage(module_content, render_to_page);
			}
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
			if(options.scrollTo != '')	{
				$('#app_content').scrollTop($('#'+options.scrollTo)).offset().top;
			}
			if(options.title!='')	{
				document.title = document.getElementById("__app_title__").value + options.title;
			}

		}).fail(function (xhr) {
			showError(xhr);
		}).always(function () {

			hideProgressBar();
			if (typeof _gaq !== 'undefined') {
				_gaq.push(['_trackPageview', url2]);
			}

			options.donefn();

		});
	} else {
		if (is_tab_content === false) {
			showSelectPage(module_content, render_to_page);
		}
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
	app_history.animate({
		scrollLeft: leftPos + 2000
	}, 800);
}

function showProgressBar() {

	$('#owaf_progress_bar').append("<div class='overlay'></div>");

}

function hideProgressBar() {

	$('#owaf_progress_bar').html('');

}

function showSelectPage(m, p) {
	$('.app_page').addClass('hide');
	$('.app_module').addClass('hide');
	m.removeClass('hide');
	p.removeClass('hide');
	$('#app_content').scrollTop(0);
}

function showError(xhr) {

	var errorPage = $(xhr.responseText)
	var pg = errorPage.find("#__owaf__error__msg");
	if (pg.length == 1) {
		var msg = pg[0].innerHTML;
		var title = errorPage.find("#__owaf__error__title")[0].innerHTML;
		errorNotice(msg, title);
	}
}

function getErrorMessage(xhr) { 

	return $(xhr.responseText).find("#__owaf__error__msg")[0].innerHTML;
}

function ajaxRequest(url, btn, donefn) {
	if (donefn == undefined) {
		donefn = function () { };
	}
	$.ajax({
		url: 'controllers/' + url + '&rand=' + uuidv4(),
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
		showError(data);
		btn.className = btn.className.replace(' disabled', '');
		hideProgressBar();
	});
}

function ajaxCall(url, donefn) {
	if (donefn == undefined) {
		donefn = function () { };
	}
	$.ajax({
		url: 'controllers/' + url + '&rand=' + uuidv4(),
		beforeSend: function () {
			showProgressBar();
		},
		cache: false,
	}).done(function (data) {
		donefn(data);
	}).fail(function (xhr) {
		showError(xhr);
	}).always(function (data) {
		hideProgressBar();
	});
}

function itemCreatedNotice(msg) {
	$.notify({
		message: msg,
		icon: 'fa fa-info-circle'//,
		//title: 'Data Saved'
	}, {
			placement: {
				from: 'top',
				align: 'center'
			},		
			offset: {
				y: 10,
				x: 10
			},
			z_index: 999999,
			mouse_over: 'pause',
			type: 'success',
			animate: {
				enter: 'animated fadeInDown',
				exit: 'animated fadeOutUp'
			}
		});
}

function errorNotice(msg, title) {
	if(title == "undefined")	{
		title = "Error";
	}
	// excape quotes
	//var msg_ = msg.replaceAll("'", "");
	//msg_ = msg_.replaceAll('"', "");
	//msg_ = msg_.replaceAll('\\', "/");
	msg_ = msg.replaceAll('&lt;', "<");
	msg_ = msg_.replaceAll('&gt;', ">");
	$.notify({
		message: msg_, // + '<hr/><a onclick="loadPage(' + "'support.request.new@" + uuidv4() +"',{param:" + "'subject=Error on&body=" + msg_ + "'" + '})" class="btn btn-sm btn-danger">Report Error</a>',
		icon: 'fa fa-exclamation-triangle',
		title: '' + '<br/>'
	}, {
			placement: {
				from: 'top',
				align: 'center'
			},
			offset: {
				y: 10,
				x: 10
			},
			z_index: 999999,
			mouse_over: 'pause',
			type: 'danger',
			animate: {
				enter: 'animated fadeInDown',
				exit: 'animated fadeOutUp'
			}
		});
}

function itemSaveNotice(msg) {
	$.notify({
		message: msg,
		icon: 'fa fa-save',
		title: ''
	}, {
			placement: {
				from: 'top',
				align: 'center'
			},
			offset: {
				y: 60,
				x: 15
			},
			z_index: 999999,
			mouse_over: 'pause',
			type: 'success',
			animate: {
				enter: 'animated fadeInDown',
				exit: 'animated fadeOutUp'
			}
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

/*function showMessage(type) {
	$('.af_' + type + '-trigger').click(function () {
		hideAllMessages();
		$('.af_' + type).animate({
			top: "0"
		}, 500);
	});
}*/

$(document).ready(function () {

	$('#__app_modal').on('hidden.bs.modal', function (event) {
		$('#__app_modal_back_container').html('');
	})

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
			"forcePageReload" : _forceload,
			"refreshModule" : _reload_module,
			"renderTo" : e.target.attributes['target'].value,
			"title" : e.target.attributes['title'].value
		};
		loadPage(e.target.attributes['href'].value, opt);
		// this is used in the mobile view to remove the menu from display
		triggerOverlay();
	});

});

function triggerOverlay()	{
	if(document.documentElement.clientWidth <= 755)	{
		$(".menu-overlay").trigger("click");
	}
}

window.onpopstate = function (e) {
	if (e.state) {
		document.getElementById("app_content").innerHTML = e.state.html;
		//document.title = e.state.pageTitle;
	}
};

String.prototype.replaceAllNocase = function (strReplace, strWith) {
	var reg = new RegExp(strReplace, 'ig');
	return this.replace(reg, strWith);
};

String.prototype.replaceAll = function (find, replace) {
	var str = this;
	return str.replace(new RegExp(find.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&'), 'g'), replace);
};

// Extend the default Number object with a formatMoney() method:
// usage: someVar.formatMoney(decimalPlaces, symbol, thousandsSeparator, decimalSeparator)
// defaults: (2, "$", ",", ".")
Number.prototype.formatMoney = String.prototype.formatMoney = function (places, symbol, thousand, decimal) {
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

function numberWithCommas(x) {
	x = x.toString()
	x = x.replaceAll(',','');
	var parts = x.toString().split(".");
	parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");

	return parts.join(".");
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

}

function closeModal() {

	$('#__app_modal').modal('hide');

}

function createGravatar(picture, size, class_name) {

	return "<img src='" + picture + "' width='" + size + "px' class='" + class_name + "'/>";

}
window.addEventListener('online', nowOnline);
window.addEventListener('offline', nowOffline);
var menu_profile_info_graf_status = $('#menu_profile_info div')
function nowOffline() {
	showNotification('Error: ', 'fe fe-wifi-off', 'danger', 'You are currently offline, you are not connected to the internet 😵')
	menu_profile_info_graf_status.removeClass("avatar-online")
	menu_profile_info_graf_status.addClass("avatar-offline")
}
function nowOnline() {
	showNotification('Connection: ', 'fe fe-wifi', 'success', 'You are back Online... 😎')
	menu_profile_info_graf_status.removeClass("avatar-offline")
	menu_profile_info_graf_status.addClass("avatar-online")
}

function showNotification(title, icon, type, msg) {
	$.notify({
		message: msg,
		icon: icon,
		title: title
	}, {
			offset: {
				y: 10,
				x: 10
			},
			z_index: 999999,
			mouse_over: 'pause',
			type: type,
			animate: {
				enter: 'animated fadeInRight',
				exit: 'animated fadeOutRight'
			}
		}
	);
}

function x__updateGridData(td_object, data_entered, field_name, pk, pk_field, update_other_field, model, fn) {
	//alert('d');
	console.log(update_other_field);
	var _model = model.split('.');
	_model = _model[_model.length - 1];
	field_name = field_name.replaceAll("_", "");
	field_name = field_name.replaceAllNocase(_model, "");
	//console.log(field_name +'///'+_model);
	$.ajax({
		url: 'controllers/' + model.replaceAll(".", "/") + '.cfc?method=' + fn,
		data: field_name + '=' + data_entered + '&' + pk_field + '=' + pk + '&' + update_other_field,
		type: 'POST',
		beforeSend: function () {
			td_object.attr("contenteditable", "false");
			td_object.addClass("muted");
			//blockpage();
			//showProgressBar();
		},
		cache: false
	}).done(function (data) {
		td_object.removeClass("muted");
		td_object.removeClass("danger");
		//console.log(data);
	}).fail(function (xhr) {
		td_object.addClass("danger");
		showError(xhr);
	}).always(function () {
		td_object.attr("contenteditable", "true");
		hideProgressBar();
	});

}

window.onscroll = function() {scrollFunction()};
function scrollFunction() {
	var ___x_top = document.getElementById("___x_top");
  if (document.body.scrollTop > 1000 || document.documentElement.scrollTop > 1000) {
    ___x_top.style.display = "block";
  } else {
    ___x_top.style.display = "none";
  }
}

function __top_to_top() {
	//$(window).scrollTop(0);
	$("html, body").animate({ scrollTop: 0 }, "fast");
}

// chartjs function
function __l_chartjs(a, e) {
	for (var t in e) "object" != typeof e[t] ? a[t] = e[t] : __l_chartjs(a[t], e[t])
}

function __updateChartjs(a)	{
	$('[data-toggle="chart"]').on({
		change: function() {
			a.is("[data-add]") && __updateChartjs1(a)
		},
		click: function() {
			a.is("[data-update]") && __updateChartjs2(a)
		}
	})
}

function __updateChartjs1(a) {
	var e = a.data("add"),
		t = $(a.data("target")).data("chart");
	a.is(":checked") ? function a(e, t) {
		for (var o in t) Array.isArray(t[o]) ? t[o].forEach(function(a) {
			e[o].push(a)
		}) : a(e[o], t[o])
	}(t, e) : function a(e, t) {
		for (var o in t) Array.isArray(t[o]) ? t[o].forEach(function(a) {
			e[o].pop()
		}) : a(e[o], t[o])
	}(t, e), t.update()
}

function __updateChartjs2(a) {
	var e = a.data("update"),
		t = $(a.data("target")).data("chart");
		__l_chartjs(t, e),
		function(a, e) {
			if (void 0 !== a.data("prefix") || void 0 !== a.data("prefix")) {
				var l = a.data("prefix") ? a.data("prefix") : "",
					n = a.data("suffix") ? a.data("suffix") : "";
				e.options.scales.yAxes[0].ticks.callback = function(a) {
					if (!(a % 10)) return l + a + n
				}, e.options.tooltips.callbacks.label = function(a, e) {
					var t = e.datasets[a.datasetIndex].label || "",
						o = a.yLabel,
						r = "";
					return 1 < e.datasets.length && (r += '<span class="popover-body-label mr-auto">' + t + "</span>"), r += '<span class="popover-body-value">' + l + o + n + "</span>"
				}
			}
		}(a, t), t.update()
}

function uuidv4() {
  return ([1e7]+-1e3+-4e3+-8e3+-1e11).replace(/[018]/g, c =>
    (c ^ crypto.getRandomValues(new Uint8Array(1))[0] & 15 >> c / 4).toString(16)
  )
} 

var md5=function(s){function L(k,d){return(k<<d)|(k>>>(32-d))}function K(G,k){var I,d,F,H,x;F=(G&2147483648);H=(k&2147483648);I=(G&1073741824);d=(k&1073741824);x=(G&1073741823)+(k&1073741823);if(I&d){return(x^2147483648^F^H)}if(I|d){if(x&1073741824){return(x^3221225472^F^H)}else{return(x^1073741824^F^H)}}else{return(x^F^H)}}function r(d,F,k){return(d&F)|((~d)&k)}function q(d,F,k){return(d&k)|(F&(~k))}function p(d,F,k){return(d^F^k)}function n(d,F,k){return(F^(d|(~k)))}function u(G,F,aa,Z,k,H,I){G=K(G,K(K(r(F,aa,Z),k),I));return K(L(G,H),F)}function f(G,F,aa,Z,k,H,I){G=K(G,K(K(q(F,aa,Z),k),I));return K(L(G,H),F)}function D(G,F,aa,Z,k,H,I){G=K(G,K(K(p(F,aa,Z),k),I));return K(L(G,H),F)}function t(G,F,aa,Z,k,H,I){G=K(G,K(K(n(F,aa,Z),k),I));return K(L(G,H),F)}function e(G){var Z;var F=G.length;var x=F+8;var k=(x-(x%64))/64;var I=(k+1)*16;var aa=Array(I-1);var d=0;var H=0;while(H<F){Z=(H-(H%4))/4;d=(H%4)*8;aa[Z]=(aa[Z]|(G.charCodeAt(H)<<d));H++}Z=(H-(H%4))/4;d=(H%4)*8;aa[Z]=aa[Z]|(128<<d);aa[I-2]=F<<3;aa[I-1]=F>>>29;return aa}function B(x){var k="",F="",G,d;for(d=0;d<=3;d++){G=(x>>>(d*8))&255;F="0"+G.toString(16);k=k+F.substr(F.length-2,2)}return k}function J(k){k=k.replace(/rn/g,"n");var d="";for(var F=0;F<k.length;F++){var x=k.charCodeAt(F);if(x<128){d+=String.fromCharCode(x)}else{if((x>127)&&(x<2048)){d+=String.fromCharCode((x>>6)|192);d+=String.fromCharCode((x&63)|128)}else{d+=String.fromCharCode((x>>12)|224);d+=String.fromCharCode(((x>>6)&63)|128);d+=String.fromCharCode((x&63)|128)}}}return d}var C=Array();var P,h,E,v,g,Y,X,W,V;var S=7,Q=12,N=17,M=22;var A=5,z=9,y=14,w=20;var o=4,m=11,l=16,j=23;var U=6,T=10,R=15,O=21;s=J(s);C=e(s);Y=1732584193;X=4023233417;W=2562383102;V=271733878;for(P=0;P<C.length;P+=16){h=Y;E=X;v=W;g=V;Y=u(Y,X,W,V,C[P+0],S,3614090360);V=u(V,Y,X,W,C[P+1],Q,3905402710);W=u(W,V,Y,X,C[P+2],N,606105819);X=u(X,W,V,Y,C[P+3],M,3250441966);Y=u(Y,X,W,V,C[P+4],S,4118548399);V=u(V,Y,X,W,C[P+5],Q,1200080426);W=u(W,V,Y,X,C[P+6],N,2821735955);X=u(X,W,V,Y,C[P+7],M,4249261313);Y=u(Y,X,W,V,C[P+8],S,1770035416);V=u(V,Y,X,W,C[P+9],Q,2336552879);W=u(W,V,Y,X,C[P+10],N,4294925233);X=u(X,W,V,Y,C[P+11],M,2304563134);Y=u(Y,X,W,V,C[P+12],S,1804603682);V=u(V,Y,X,W,C[P+13],Q,4254626195);W=u(W,V,Y,X,C[P+14],N,2792965006);X=u(X,W,V,Y,C[P+15],M,1236535329);Y=f(Y,X,W,V,C[P+1],A,4129170786);V=f(V,Y,X,W,C[P+6],z,3225465664);W=f(W,V,Y,X,C[P+11],y,643717713);X=f(X,W,V,Y,C[P+0],w,3921069994);Y=f(Y,X,W,V,C[P+5],A,3593408605);V=f(V,Y,X,W,C[P+10],z,38016083);W=f(W,V,Y,X,C[P+15],y,3634488961);X=f(X,W,V,Y,C[P+4],w,3889429448);Y=f(Y,X,W,V,C[P+9],A,568446438);V=f(V,Y,X,W,C[P+14],z,3275163606);W=f(W,V,Y,X,C[P+3],y,4107603335);X=f(X,W,V,Y,C[P+8],w,1163531501);Y=f(Y,X,W,V,C[P+13],A,2850285829);V=f(V,Y,X,W,C[P+2],z,4243563512);W=f(W,V,Y,X,C[P+7],y,1735328473);X=f(X,W,V,Y,C[P+12],w,2368359562);Y=D(Y,X,W,V,C[P+5],o,4294588738);V=D(V,Y,X,W,C[P+8],m,2272392833);W=D(W,V,Y,X,C[P+11],l,1839030562);X=D(X,W,V,Y,C[P+14],j,4259657740);Y=D(Y,X,W,V,C[P+1],o,2763975236);V=D(V,Y,X,W,C[P+4],m,1272893353);W=D(W,V,Y,X,C[P+7],l,4139469664);X=D(X,W,V,Y,C[P+10],j,3200236656);Y=D(Y,X,W,V,C[P+13],o,681279174);V=D(V,Y,X,W,C[P+0],m,3936430074);W=D(W,V,Y,X,C[P+3],l,3572445317);X=D(X,W,V,Y,C[P+6],j,76029189);Y=D(Y,X,W,V,C[P+9],o,3654602809);V=D(V,Y,X,W,C[P+12],m,3873151461);W=D(W,V,Y,X,C[P+15],l,530742520);X=D(X,W,V,Y,C[P+2],j,3299628645);Y=t(Y,X,W,V,C[P+0],U,4096336452);V=t(V,Y,X,W,C[P+7],T,1126891415);W=t(W,V,Y,X,C[P+14],R,2878612391);X=t(X,W,V,Y,C[P+5],O,4237533241);Y=t(Y,X,W,V,C[P+12],U,1700485571);V=t(V,Y,X,W,C[P+3],T,2399980690);W=t(W,V,Y,X,C[P+10],R,4293915773);X=t(X,W,V,Y,C[P+1],O,2240044497);Y=t(Y,X,W,V,C[P+8],U,1873313359);V=t(V,Y,X,W,C[P+15],T,4264355552);W=t(W,V,Y,X,C[P+6],R,2734768916);X=t(X,W,V,Y,C[P+13],O,1309151649);Y=t(Y,X,W,V,C[P+4],U,4149444226);V=t(V,Y,X,W,C[P+11],T,3174756917);W=t(W,V,Y,X,C[P+2],R,718787259);X=t(X,W,V,Y,C[P+9],O,3951481745);Y=K(Y,h);X=K(X,E);W=K(W,v);V=K(V,g)}var i=B(Y)+B(X)+B(W)+B(V);return i.toLowerCase()};

var setHeightWidth = function (id) {

	lv_height = window.innerHeight;
	lv_width = window.innerWidth;

  $('#' + id + ' .xlv-app-xlv-s-list').css('height', (lv_height-133));
  $('#' + id + ' .xlv--body').css('height', (lv_height-72));
  $('#' + id + ' .xlv-app-sidebar').css('height', (lv_height));

};

function toTitleCase(str) {
  return str.toLowerCase().split(' ').map(function(word) {
    return (word.charAt(0).toUpperCase() + word.slice(1));
  }).join(' ');
}

function exportTableToExcel(tableID, filename = ''){
	var downloadLink;
	var dataType = 'application/vnd.ms-excel';
	var tableSelect = document.getElementById(tableID);
	var tableHTML = tableSelect.outerHTML.replace(/ /g, '%20').replace(/#/g, '%23');
	
	// Specify file name
	filename = filename?filename+'.xls':'excel_data.xls';
	
	// Create download link element
	downloadLink = document.createElement("a");
	
	document.body.appendChild(downloadLink);
	
	if(navigator.msSaveOrOpenBlob){
			var blob = new Blob(['\ufeff', tableHTML], {
					type: dataType
			});
			navigator.msSaveOrOpenBlob( blob, filename);
	}
	else{
			// Create a link to the file
			downloadLink.href = 'data:' + dataType + ', ' + tableHTML;
	
			// Setting the file name
			downloadLink.download = filename;
			
			//triggering the function
			downloadLink.click();
	}
}