<!---TOFIX: Filter does not work unless the cf_search tag is present ---->
<cfoutput>

	<cfif thisTag.ExecutionMode == 'start'>

		<cfparam name="Attributes.TagName" type="string" default="grid"/>
		<cfparam name="Attributes.model" type="string"/>
		<cfparam name="Attributes.name" type="string" default="#replace(listFirst(Attributes.model,' '),'.','_','all')#"/>
		<cfparam name="Attributes.key" type="string" default=""/>
		<cfparam name="Attributes.class" type="string" default=""/>
		<cfparam name="Attributes.containerClass" type="string" default="card"/>
		
		<cfparam name="Attributes.clearCache" type="boolean" default="false"/>
		
		<cfparam name="Attributes.saveState" type="boolean" default="false"/>
		<cfif attributes.saveState>
			<cfparam name="Attributes.id" type="string" default="#Attributes.name#"/>
		<cfelse>
			<cfparam name="Attributes.id" type="string" default="#application.fn.GetRandomVariable()#"/>
		</cfif>
		
		<cfparam name="Attributes.TableJSId" type="string" default="#application.fn.GetRandomVariable()#"/>
		<!---cfset Attributes.name = Attributes.name & "_" & Attributes.id/--->
		<cfparam name="Attributes.sortDirection" type="string" default="desc"/>
		<cfparam name="Attributes.sortBy" type="string" default="0"/>
		<cfparam name="Attributes.responsive" type="boolean" default="true"/>
		<cfparam name="Attributes.hover" type="boolean" default="true"/>
		<cfparam name="Attributes.condensed" type="boolean" default="false"/>
		<cfparam name="Attributes.striped" type="boolean" default="false"/>
		<cfparam name="Attributes.bordered" type="boolean" default="false"/>
		<cfparam name="Attributes.filter" type="string" default=""/>
		<cfparam name="Attributes.rows" type="numeric" default="20"/>
		<cfparam name="Attributes.export" type="string" default=""/><!--- list export, excel, pdf, html, htm --->

		<cfparam name="Attributes.pagingType" type="string" default="numbers"/>
		<cfparam name="Attributes.groupBy" type="string" default=""/>
		<cfparam name="Attributes.having" type="string" default=""/>

		<cfparam name="Attributes.fixedLeftColumns" type="numeric" default="0"/>
		<cfparam name="Attributes.fixedRightColumns" type="numeric" default="-1"/>

		<cfparam name="Attributes.fixedHeader" type="boolean" default="false"/>

		<cfparam name="Attributes.onSelect" type="string" default=""/>
		<cfparam name="Attributes.select" type="string" default="true"/> <!--- true|false,multiple https://datatables.net/reference/option/select | https://datatables.net/extensions/select/ --->
		<cfparam name="Attributes.scroller" type="boolean" default="false"/>
		<cfparam name="Attributes.scrollY" type="string" default="70vh"/>
		<cfparam name="Attributes.scrollX" type="boolean" default="true"/>
		
		<cfparam name="Attributes.showPager" type="boolean" default="true"/>
		<cfparam name="Attributes.hideToolBar" type="boolean" default="false"/>

		<cfparam name="Attributes.selectClause" type="string" default=""/> <!--- overright default model.select clause statement --->

		<cfif Attributes.scroller>
			<cfset attributes.showPager = false/>
		</cfif>

        <!--- export attributes --->
		<cfparam name="Attributes.exportFileName" type="string" default="#Attributes.name#_#dateformat(now(),'dd_mmm')#_#timeformat(now(),'h_m_ss')#.xls"/>
		<cfparam name="Attributes.exportTitle" type="string" default=""/>
			<!--- end export attributes --->

			<cfif !attributes.showPager>
				<style>
					###Attributes.id# .card-footer{display:none;visibility: hidden;}
				</style>
			</cfif>

			<cfif attributes.hideToolBar>
				<style>
					###Attributes.id# .data-table-toolbar{display:none;}
				</style>
			</cfif>

			<cfset cssopt = ""/>
			<cfif Attributes.hover> <cfset cssopt = listAppend(cssopt,"table-hover", " ")/> </cfif>
			<cfif Attributes.condensed> <cfset cssopt = listAppend(cssopt,"table-condensed", " ")/> </cfif>
			<cfif Attributes.striped> <cfset cssopt = listAppend(cssopt,"table-striped", " ")/> </cfif>
			<cfif Attributes.bordered> <cfset cssopt = listAppend(cssopt,"table-bordered", " ")/> </cfif>
			<div class="#Attributes.containerClass#">
			<div id="#Attributes.id#" <cfif Attributes.responsive>class="table-responsive"</cfif>>
			<table id="#Attributes.id#_tbl" class="card-table table #cssopt# #Attributes.class#" data-page-length='#Attributes.rows#' data-order='[[ #Attributes.sortby#, "#Attributes.sortdirection#" ]]'>

			<cfset request.grid.join = ArrayNew(1)/>
			<cfset request.grid.cutomJoin = ArrayNew(1)/>
			<cfset request.grid.aggregate = ArrayNew(1)/>
			<cfset request.grid.tag = Attributes/>
			<cfset request.grid.hasSearch = false/>
			<cfset request.grid.hasFilter = false/>

    <cfelse>

      </table>

      </div>
    </div>

			<cfset col_list = ""/>
			<cfset scol_list = ""/>
			<cfset tcol_list = ""/>
			<cfset col_class = ""/>
			<cfloop array="#request.grid.columns#" item="x" index="j">
				<!--- set key --->
				<cfif Attributes.key eq "">
					<cfif j eq 1>
						<cfset Attributes.key = x.name/>
					</cfif>
				</cfif>
				<cfset col_list = listAppend(col_list, x.name)/>
				<cfset scol_list = listAppend(scol_list, x.field)/>
				<cfset tcol_list = listAppend(tcol_list, x.caption)/>
				<!--- create class string {"sClass": ""} --->
				<cfif x.class neq "">
					<cfset col_class = listAppend(col_class,'{"sClass" : "#x.class#", "aTargets" : [#j-1#]}')/>
				</cfif>
			</cfloop>

        <!--- check if grid has command --->
        <cfset cmd = false/>
        <cfset cmd_but = cmd_but2 = ""/>
        <cfif isdefined("request.grid.Commands")>
					<cfset cmd = true/>
					<!--- build command --->

					<cfloop array="#request.grid.Commands#" item="x">
						<!--- check condition --->
						<cfset url_ = "loadPage('#x.url#',{})"/>
						<cfset cmd_but = listAppend(cmd_but,"<a href='javascript:;' class='btn btn-sm #x.buttontype#' onclick=#url_#><i class='#x.icon#' data-toggle='tooltip' title='' data-original-title='#x.title#'></i></a>"," ")/>
						<cfset cmd_but2 = listAppend(cmd_but2,"<li><a href='javascript:;'><i class='#x.icon#'></i> #x.title#</a></li>"," ")/>
					</cfloop>
					<cfset cmd_but2 = "<button type='button' class='btn btn-sm dropdown-toggle' data-toggle='dropdown'>Action <span class='caret'></span></button><ul class='dropdown-menu'>" & cmd_but2 & "</ul>"/>

        </cfif>
        <cfset cmd_but=""/>

        <!--- join model --->
        <cfset join = join_stm = select_stm = ""/>
        <cfloop array="#request.grid.join#" item="a" index="b">
            <cfset join = listAppend(join, a.type & "," & a.model & "," & a.fkey & "," & a.deep, "$")/>
        </cfloop>

        <cfif arrayLen(request.grid.cutomjoin)>
            <cfset join_stm = trim(request.grid.cutomjoin[1].join)/>
            <cfset join_stm = replace(join_stm,chr(10),' ','all')/>
            <cfset join_stm = replace(join_stm,chr(13),' ','all')/>
            <cfset select_stm = trim(request.grid.cutomjoin[1].select)/>
            <cfset select_stm = replace(select_stm,chr(10),' ','all')/>
            <cfset select_stm = replace(select_stm,chr(13),' ','all')/>
        </cfif>

        <script type="text/javascript">

            //$(document).ready(function() {
                <cfset oTable = replace(attributes.TableJsId, '-', '','all') />
                <cfset _tags_search = application.fn.GetRandomVariable()/>
								//var #oTable# = {};
                function __#oTable#()   {
                    #oTable# = $('###Attributes.id#_tbl').DataTable( {

												<cfif attributes.saveState>
													"stateSave": true,
													"stateLoaded": function (settings, data) {
														$('###attributes.id# input.search').val( data.search.search );
													},
												</cfif>
												<cfif Attributes.fixedHeader>
													"fixedHeader": {
														"header": true,
														//footer: true
													},
												</cfif>
												<cfif attributes.fixedLeftColumns != 0>
													scrollX: true,
													fixedColumns:   {
														leftColumns: #attributes.fixedLeftColumns#,
														<cfif attributes.fixedRightColumns != -1>
															rightColumns : #attributes.fixedRightColumns#
														</cfif>
													},
												</cfif>
												"initComplete": function(settings, json) {
													$('###Attributes.id#_tbl').removeClass("grid-loading");
												},
                        "dom": "t<'card-footer row'<'col-auto'l><'col'p>>",
												<cfswitch expression="#attributes.select#">
													<cfcase value="true">
														"select": {
															style: 'os',
															blurable: true
														},
													</cfcase>
													<cfcase value="multiple">
														"select": {
															style: 'multi'
														},
													</cfcase>
												</cfswitch>
												"autoWidth": false,
                        "columnDefs": [
                            <cfset c = -1/>
							<!---TODO: Implement later "type": "html"--->
                            <cfloop array="#request.grid.columns#" item="x" index="j">
                                <cfset c++/>
                                {
																	<cfif x.width neq "">"width": "#x.width#",</cfif>
                                    <cfif x.hide>"visible": false,</cfif>
                                    <cfif !x.sortable>"orderable": false,</cfif>

                                        <cfif x.editable>
                                            <!--- TODO: there is an error when inserting into a table with no databefore, there should be a way to refresh the grid --->
                                            "createdCell": function (td, cellData, row, rowData, icol) {
                                                var _c = cellData;
                                                var col = row;
                                                var _td = $(td);
                                                // check if iseditable is
                                                <cfif x.iseditable != "">
                                                    if(#x.iseditable#) 	{
                                                </cfif>
                                                _td.attr("contenteditable","true");
                                                _td.blur(function() {
                                                    //console.log(rowData);
                                                    var entered_data = $(this).html();
                                                    if (cellData!=entered_data)	{
                                                        <!--- find keyfield --->
                                                        <cfset _keyfield = Attributes.key/>
                                                        <cfif x.keyrow != 0>
                                                            <cfset _keyfield = listlast(request.grid.columns[x.keyrow+1].name,'_')/>
                                                        </cfif>
                                                        <!--- build "update_other_fields/updatefield" is need be --->
                                                        <cfset _updatefield = "''"/>
                                                        <cfif x.updatefield neq "">

                                                            <cfloop list="#x.updatefield#" item="uf" delimiters="``">
																															<cfset _first = ""/>
																															<cfset _last = ""/>
																															<cfif listlen(uf,'=') gt 1>
																																<cfset _first = ListFirst(uf,'=')/>
																																<cfset _last = ListLast(uf,'=')/>
																															<cfelse>
																																<cfset _first = _last = uf/>
																															</cfif>
																															<cfif _updatefield == "''">
																																<cfset _updatefield = ""/>
																															</cfif>
																															<cfset _updatefield = ListAppend(_updatefield, "'" & listlast(request.grid.columns[_first+1].name,'_') & "='+row[#_last#]", '&')/>

                                                            </cfloop>
                                                            <cfif _updatefield == ""><cfset _updatefield = "''"/></cfif>

                                                        </cfif>
                                                        
                                                        x__updateGridData(_td, entered_data, '#x.name#', row[#x.keyrow#],'#_keyfield#', #_updatefield#, <cfif x.controller == "">'#Attributes.model#'<cfelse>'#x.controller#'</cfif>, '#x.saveMethod#');
                                                    }
                                                });
                                            // check if iseditable is --- end
                                            <cfif x.iseditable != "">
                                                }
                                            </cfif>
                                            },
                                        <cfelse>
                                            <cfif x.UseId>
																							"createdCell": function (td, cellData, row, rowData, icol) {
																								var _td = $(td);
																								_td.attr("id","true");
																								<cfset _keyfield = Attributes.key/>
																								<cfset _keyfield = listlast(request.grid.columns[j].name,'_')/>
																								_td.attr("id","#lcase(_keyfield)#_"+col[0]);
																							},
                                            <cfelse>
                                                <cfif x.cssStyle != "">
                                                    "createdCell": function (td, cellData, row, rowData, icol) {
                                                        var _td = $(td);
                                                        _td.attr("style","#x.cssStyle#");
                                                    },
                                                </cfif>
                                            </cfif>
                                        </cfif>

                                    "className": "#x.class#"
                                        <cfif x.hide> + " hidden"</cfif>
                                        <cfif x.align is not ""> + " text-#x.align#" </cfif>
                                        <cfif x.nowrap> + " nowrap" </cfif>,

                                    "render": function ( data, type, row, x) {
                                        var oData = col = row;
                                        var self = data;
                                        var rt = data;
                                        <!---cfset x.Template = replace(x.Template,'oData[', 'row[','all')/>
                                        <cfset x.script = replace(x.script,'oData[', 'row[','all')/--->
                                        <cfif x.template neq "">
                                            rt = #x.Template#;
                                        <cfelseif x.script neq "">
                                            rt = (function(){#x.script#;})();
                                        <cfelse>
                                            rt = row[#c#];
                                        </cfif>
                                        return rt;
                                    }, "targets": #c#
                                },
                            </cfloop>
                            <!--- command --->
                            <cfif cmd>
                                {
                                    "className" : "nowrap text-right", "orderable": false, "searchable": false,
                                    "render": function ( data, type, row, _object ) {
                                        var self = data;
                                        var oData = row;
                                        var col = row;
                                        var _data = '';
                                        <cfloop array="#request.grid.Commands#" item="x">
                                            <cfset x.pagetitle = replace(x.pagetitle,' ','&nbsp;','all')/>
                                            <cfset x.pagetitle = replace(x.pagetitle,"'","",'all')/>
                                            var page_column = #x.PageColumn#.toString().replaceAll(" ", "&nbsp;");
                                            page_column = page_column.toString().replaceAll("'", "");
                                            <!---TODO: work progress --->
                                            <cfif x.jsurlparam != "">
                                                <cfset lf = listFirst(x.jsurlparam,"=")/>
                                                <cfset ll = listLast(x.jsurlparam,"=")/>
                                                <cfset param_ ="'param':'#x.urlparam#&#lf#='+#ll#"/>
                                            <cfelse>
                                                <cfset param_ ="'param':'#x.urlparam#'"/>
                                            </cfif>
                                            <cfswitch expression="#x.type#">

                                                <cfcase value="load">
                                                    <cfset murl = "#x.modalurl#~""+#x.key#+"""/>
                                                    <cfif x.modalurl == "">
                                                        <cfset murl = ""/>
                                                    </cfif>
                                                    <cfif x.renderTo == "">
                                                    	<cfset url_ = "loadPage('#x.url#~""+#x.key#+""',{'title':'#x.pagetitle#&nbsp;""+#x.PageColumn#+""','param':'#x.urlparam#','changeURL':#x.changeURL#,'forcePageReload':#x.forcePageReload#,'modalurl':'#murl#'})"/>
																										<cfelse>
																												<cfset _sp = ""/>
																												<cfif x.samePage>
																													<cfset _sp = "'samePage':true,"/>
																												</cfif>
                                                        <cfset url_ = "loadPage('#x.url#~""+#x.key#+""',{#_sp#'title':'#x.pagetitle#&nbsp;""+#x.PageColumn#+""','param':'#x.urlparam#','renderTo':'#x.renderTo#','changeURL':#x.changeURL#,'forcePageReload':#x.forcePageReload#,'modalurl':'#murl#'})"/>
                                                    </cfif>
                                                </cfcase>

																								<cfcase value="modal">  
																										<!---- 'backdrop': '#x.backdrop#','keyboard': #x.keyboard#,  ---->
                                                    <!---cfset _pg_title = request.grid.columns[x.PageColumn+1].Name/--->
                                                    <cfset url_ = "showModal('#x.url#~""+#x.key#+""',{'backdrop':'#x.backdrop#','keyboard':#x.keyboard#,'position':'#x.modalPosition#','title':'#x.pagetitle#&nbsp;""+page_column+""',#param_#})"/>
                                                    <!---cfscript>
                                                        systemoutput("======================", true)
                                                        systemoutput(url_, true)
                                                        systemoutput("======================", true)
                                                    </cfscript--->
                                                </cfcase>

                                                <cfcase value="execute">

																										<cfset url_ = "_executecmd('#x.url#&key=""+#x.key#+""','#x.redirectURL#',this,""+_object.row+"")"/>

                                                </cfcase>

                                                <cfcase value="print">
                                                    <cfset n_url = "views/inc/print/print.cfm?page=" & replace(x.url,'.','/','all') & "&#x.urlparam#"/>
                                                    <cfset url_ = "openURL('#n_url#&id=""+#x.key#+""')"/>
                                                </cfcase>

                                                <cfcase value="blank">
                                                    <cfset n_url = replace(x.url,".","/","all") & ".cfm?"/>
                                                    <cfset url_ = "openURL('#n_url#id=""+#x.key#+""')"/>
                                                </cfcase>

                                            </cfswitch>

                                            if(#x.condition#)   {
                                              _data = _data + "<a href='javascript:;' title='#x.help#' class='btn btn-sm #x.buttontype# #x.class#' onclick=#url_#><i class='#x.icon#'></i> #x.title#</a>";
                                            }

                                        </cfloop>
                                        return _data;
                                    },
                                    "targets" : -1
                                }
                            </cfif>
												], 
												<cfif attributes.scroller>
													"scrollY"					: '#Attributes.scrollY#',
													"scrollCollapse"	: false,
													"scroller"				: true, 
													"deferRender"			: true,
												</cfif>
												"lengthMenu": [5, 10, 15, 20, 30, 50, 70, 100, 150, 300, 500],
												"pagingType": "#Attributes.pagingType#",
                        "serverSide": true,
                        "processing": true,
                        "searching": #request.grid.hasSearch#,
                        "ajax": {
													"url": "owaf/tags/grid/ajax.cfm?grid_name=#Attributes.name#",
													"type": "POST"
                        }

                        <!--- save sAjaxSource inside the session for use with export.cfm, implement this for ajax.cfm ---->
                        <!---cfif attributes.export neq ""--->
                            <cflock scope="Session" type="exclusive" timeout="20">
															<cfset session.tags.grid[Attributes.name].filter = attributes.filter/>
															<cfset session.tags.grid[Attributes.name].model = Attributes.model/>
															<cfset session.tags.grid[Attributes.name].join = join/>
															<cfset session.tags.grid[Attributes.name].Columns = request.grid.columns/>
															<cfset session.tags.grid[Attributes.name].fColumns = scol_list/>
															<cfset session.tags.grid[Attributes.name].Captions = tcol_list/>
															<cfset session.tags.grid[Attributes.name].key = attributes.key/>
															<cfset session.tags.grid[Attributes.name].cmd = cmd/>
															<cfset session.tags.grid[Attributes.name].join_stm = join_stm/>
															<cfset session.tags.grid[Attributes.name].sel_stm = select_stm/>
															<cfset session.tags.grid[Attributes.name].sel_clause = Attributes.selectClause/> <!--- table select clause --->
															<cfset session.tags.grid[Attributes.name].gb = Attributes.groupby/>
															<cfset session.tags.grid[Attributes.name].having = Attributes.having/>
															<cfset session.tags.grid[Attributes.name].sortby = Attributes.sortBy/>
															<cfset session.tags.grid[Attributes.name].sortdir = Attributes.sortDirection/>
															<cfset session.tags.grid[Attributes.name].Title = Attributes.exportTitle/>
															<cfset session.tags.grid[Attributes.name].FileName = Attributes.exportFileName/>
															<cfset session.tags.grid[Attributes.name].Aggregate = request.grid.aggregate/>
                            </cflock>
                        <!----/cfif--->


                    }).on("select", function (e, dt, type, indexes) {
										<cfif attributes.onSelect != "">

											if ( type === 'row' ) {
												var row = dt.rows( {selected:true} ).data()
												var id = "";
												for (let i = 0; i < row.length; i++) {
													id += row[i][0] + ",";
												}
												#attributes.onSelect#
											}												
										}).on('deselect', function ( e, dt, type, indexes ) {
												if ( type === 'row' ) {
													var row = dt.rows( {selected:true} ).data()
													var id = "";
													for (let i = 0; i < row.length; i++) {
														id += row[i][0] + ",";
													}
													#attributes.onSelect#
												}	
										</cfif>

											});

                    <cfif isdefined("request.grid.toolbar[1]")>

											$(".#request.grid.toolbar[1].id#").keyup(function(e) {
												<cfswitch expression="#request.grid.toolbar[1].on#">
													<cfcase value="Any">
															#oTable#.search( this.value ).draw();
													</cfcase>
													<cfdefaultcase>
														if(e.which == 13) {
															#oTable#.search( this.value ).draw();
														}
													</cfdefaultcase>
												</cfswitch>
											});

                    <cfelse>
                        // make action button 12

										</cfif>
										//#oTable#.page( 'last' ).draw( 'page' );
                }

            //});

            $(document).ready(function() {
							
								__#oTable#();
								
								#oTable#.on('page.dt', function() {
									$("html, body").animate({ scrollTop: 0}, "fast");
									$("th:first-child").focus(); 
								});

								#oTable#.on('processing.dt', function ( e, settings, processing ) {
									if(processing)	{
										$('###Attributes.id#_tbl').addClass("grid-loading");
									}else {
										$('table.grid-loading').removeClass("grid-loading");
									}
								});//preInit.dt

                <!--- for filter --->
								<cfif request.grid.hasFilter>
									
									$('###Attributes.id# .grid_filter select').multiselect({
										enableCollapsibleOptGroups: #request.grid.filters[1].group#,
										maxHeight: 400,
										buttonContainer: '<div class="btn-group-sm btn-group"/>',
										nonSelectedText: '<i class="fal fa-filter"></i>',
										enableHTML:true,
										dropLeft: true,
										buttonClass: 'btn btn-outline-primary',
										nSelectedText: ' - Filters selected!',
										onInitialized: function(select, container) {
											<cfinclude template = "inc_select_opt.cfm"/>
										},
										onChange: function(option, checked, select) {
											<cfinclude template = "inc_select_opt.cfm"/>
										}
									});

                </cfif>

								<cfif isdefined("crequest.grid.toolbar[1]")>
									
									#_tags_search#.tagsinput({
										confirmKeys: [32, 13, 9],
										maxTags: 5,
										trimValue: true,
										allowDuplicates: false
									});

									$("###attributes.id# .search .bootstrap-tagsinput input").keyup(function(e) {
										var _x = $(#_tags_search#).val();
										<cfswitch expression="#request.grid.toolbar[1].on#">
												<cfcase value="Any">
														#oTable#.search( _x ).draw();
												</cfcase>
												<cfdefaultcase>
														if(e.which == 13) {
															#oTable#.search( _x ).draw();
														}
												</cfdefaultcase>
										</cfswitch>
									});

                </cfif>
            });

            function _executecmd(_url, rurl, _this, irow)  {
							if(confirm('Are you sure?')) {
								ajaxRequest(_url,_this, function(){});
								if(rurl != "")	{
									loadPage(rurl, {'forcePageReload': true})
								}
							}
            }

            function renderCell(_url, _this, irow)  {
							if(confirm('Are you sure?')) {
								ajaxRequest(_url,_this,x__gridremoveTR('#Attributes.id#_tbl',irow));
							}
            }

        </script>

    </cfif>

</cfoutput>

<cffunction name="toggle" access="private" returntype="boolean">
	<cfargument name="b" required="true" type="boolean">

	<cfset var j = true/>
	<cfif arguments.b>
			<cfset j = false/>
	</cfif>

	<cfreturn j/>
</cffunction>