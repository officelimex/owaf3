<cfoutput>
<cfif ThisTag.ExecutionMode == "Start">

	<cfparam name="Attributes.tagname" type="string" default="TableEdit"/>
	<cfparam name="Attributes.Id" type="string" default="#application.fn.GetRandomVariable()#"/>
	<cfparam name="Attributes.name" type="string" default=""/>  <!--- with this name, you can have more than one of this tag in a form --->
	<cfparam name="Attributes.type" type="string" default="query"/> <!--- depreciate --->
	<cfparam name="Attributes.datatype" type="string" default="#Attributes.type#"/>
	<cfparam name="Attributes.datasource" type="any" default=""/>
	<cfparam name="Attributes.striped" type="boolean" default="false"/>
	<cfparam name="Attributes.hover" type="boolean" default="true"/>
	<cfparam name="Attributes.compressed" type="boolean" default="false"/>
	<cfparam name="Attributes.bordered" type="boolean" default="false"/>
	<cfparam name="Attributes.defaultView" type="string" default="text"/> <!--- we have only two views. edit and text views --->
	<cfparam name="Attributes.allowNewLineItem" type="boolean" default="true"/>
	<cfparam name="Attributes.canDelete" type="boolean" default="true"/> <!--- ability to delete line item --->
	<cfparam name="Attributes.editAll" type="boolean" default="true"/> <!--- once clicked, all the table will turn to form --->
	<cfparam name="Attributes.newLineItemText" type="string" default="Add new line item"/> <!--- once clicked, all the table will turn to form --->
	<cfparam name="Attributes.Caption" type="string" default=""/>
	<cfparam name="Attributes.SubTotal" type="string" default=""/>
	<cfparam name="Attributes.max" type="numeric" default="0"/>
	<cfparam name="Attributes.class" type="string" default="table-responsive"/>

	<cfset request.TableEdit.tag = Attributes/>

	<!--- set the name of the action button --->
	<cfset action_var = "action"/>
	<cfif Attributes.name != "">
		<cfset action_var = Attributes.name & "_" & action_var/>
	</cfif>

<cfelse>

<cfset is_query = isQuery(Attributes.datasource)/>

<cfset cls = "table"/>
<cfif Attributes.striped><cfset cls = ListAppend(cls,"table-striped"," ")/></cfif>
<cfif Attributes.hover><cfset cls = ListAppend(cls,"table-hover"," ")/></cfif>
<cfif Attributes.compressed><cfset cls = ListAppend(cls,"table-condensed"," ")/></cfif>
<cfif Attributes.bordered><cfset cls = ListAppend(cls,"table-bordered"," ")/></cfif>

<style>.strock-text{text-decoration:line-through; color:gray;}</style>
<!---<cfif Attributes.type eq "query">
	<cfset totalRecord = Attributes.datasource.recordcount/>
</cfif>--->
<cfset display_label = "hide"/>
<cfset display_form = ""/>
<cfif !Attributes.editAll>
	<cfset display_label = ""/>
	<cfset display_form = "hide"/>
</cfif>

<div class="#Attributes.class#">
<table class="#cls#" width="100%" id="#Attributes.Id#">
<cfif Attributes.caption != ""><caption>#Attributes.caption#</caption></cfif>
<thead>
	<tr>
		<cfloop array="#request.TableEdit.columns#" item="attr">
			<cfif !attr.hidden>
				<th class="#attr.class#"
					<cfif attr.align neq"">style="text-align:#attr.align#;"</cfif>
					<cfif attr.nowrap> nowrap </cfif>
				>
					<div>
						#attr.caption#
						<cfif attr.required>
							<sup class="red">*</sup>
						</cfif>
						<cfif attr.type eq "money">
							<cfif attr.currency neq "">
								(#attr.currency#)
							</cfif>
						</cfif>
					</div>
					<cfif attr.help != "">
						<div style="margin-top:-3px;line-height: 10px;"><small style="color:gray;font-size:9px;">#attr.help#</small></div>
					</cfif>
				</th>
			</cfif>
		</cfloop>
		<cfif Attributes.canDelete>
			<th width="1%"></th>
		</cfif>
	</tr>
</thead>
<tbody>

	<cfif is_query>

		<cfset j = 0/>

		<cfloop query="Attributes.datasource">
			<cfset j++/>

			<!--- display hidden value here ---->
			<cfloop array="#request.TableEdit.columns#" item="attr" index="i">
				<cfif attr.hidden>
					<cfif isDefined(attr.value)>
						<cfset val_ = trim(evaluate(attr.value))/>
					<cfelse>
						<cfset val_ = ""/>
					</cfif>
					<input type="hidden" value="#val_#" name="#attr.name#_#j#"/>
				</cfif>
			</cfloop>
			<cfset action_id = application.fn.GetRandomVariable()/>

			<!--- check action command from the datasource ---->
			<cfset action_value = ""/>
			<cftry>

				<cfset action_value = trim(evaluate(action_var))/>
				<cfcatch type="any">
					<cfset action_value = ""/>
				</cfcatch>

			</cftry>

			<input type="hidden" value="#action_value#" id="#action_id#" name="#action_var#_#j#"/>

			<cfset tr_id = application.fn.GetRandomVariable()/>
			<tr id="#tr_id#">
				<cfloop array="#request.TableEdit.columns#" item="attr" index="i">
					<cfif !attr.hidden>
						<td class="#attr.class#"
							<cfif attr.align neq""> style="text-align:#attr.align#;" </cfif>
							<cfif attr.nowrap> nowrap </cfif>
							<cfif attr.width is not ""> width="#attr.width#" </cfif>
						>

							<cfset td_id = tr_id & i/>

							<!---- display data of the table by checking type ---->
							<cfswitch expression="#attr.type#">

								<cfcase value="money">
									<cfset value_2 = trim(evaluate(attr.value))/>
									<cfset value_ = numberformat(value_2,'9,999.99')/>
									<div class="input-group cf_table_edit_input #display_form# pull-right">
										<cfif attr.readOnly>
											#value_#
										<cfelse>
											<cfif attr.currency != "">
												<span class="input-group-addon money">#attr.currency#</span>
											</cfif>
											<input type="text" width="100%" class="form-control text-right addon tag-xmoney" value="#value_2#" id="#attr.id#_#j#" name="#attr.name#_#j#"
												<cfif attr.required>required</cfif>
												<cfif attr.min != ""> data-rule-min="#attr.min#" </cfif>
											/>
										</cfif>
									</div>
									<div class="cf_table_edit_label #display_label#"><div>#value_#</div></div>
								</cfcase>

								<cfcase value="textarea">
									<cfif isDefined(attr.value)>
										<cfset value_ = trim(evaluate(attr.value))/>
									<cfelse>
										<cfset value_ = ""/>
									</cfif>
									<div class="cf_table_edit_input #display_form#">
										<cfif attr.readOnly>
											#value_#
										<cfelse>
											<textarea type="text" width="100%" id="#attr.id#_#j#" class="form-control" name="#attr.name#_#j#" rows="#attr.rows#"
											<cfif attr.required> required</cfif>>#value_#</textarea>
										</cfif>
									</div>
									<div class="cf_table_edit_label #display_label#"><div>#value_#</div></div>
								</cfcase>

								<cfcase value="select">

									<cftry>

										<cfset val__ = trim(evaluate(attr.selected))/>

										<cfcatch type="any">
											<cfset val__ = ""/>
										</cfcatch>

									</cftry>
									<cfset getselpos = listfindnocase(attr.Value, val__, attr.delimiters)/>
									<cfif getselpos eq 0>
										<cfset getselpos = 1/>
									</cfif>
									<cfset val_ = listGetAt(attr.Display, getselpos, attr.delimiters)/>
									<div class="cf_table_edit_input #display_form#">
										<cfif attr.readOnly>
											#val_#
											<input type="hidden" name="#attr.name#_#j#" id="#attr.id#_#j#" value="#val__#" />
										<cfelse>
											<select name="#attr.name#_#j#" id="#attr.id#_#j#" class="form-control" <cfif attr.required> required</cfif>>
												<option value=""> - </option>
												<cfloop list="#attr.Value#" item="sel" index="k" delimiters="#attr.delimiters#">
													<option value="#sel#" <cfif val__ eq sel> selected </cfif> >
														#ListGetAt(attr.Display,k,attr.delimiters)#
													</option>
												</cfloop>
											</select>
										</cfif>
									</div>
									<div class="cf_table_edit_label #display_label#"><div>#val_#</div></div>
								</cfcase>

								<cfcase value="check,checkbox">

									<cftry>

										<cfset val__ = trim(evaluate(attr.selected))/>

										<cfcatch type="any">
											<cfset val__ = ""/>
										</cfcatch>

									</cftry>
									<cfset getselpos = listfindnocase(attr.Value, val__, attr.delimiters)/>
									<cfif getselpos eq 0>
										<cfset getselpos = 1/>
									</cfif>
									<cfset val_ = listGetAt(attr.Display, getselpos, attr.delimiters)/>
									<div class="cf_table_edit_input #display_form#">

										<cfif attr.readOnly>
											#val_#
											<input type="hidden" name="#attr.name#_#j#" id="#attr.id#_#j#" value="#val__#" />
										<cfelse>

											<cfloop list="#attr.Value#" item="sel" index="k" delimiters="#attr.delimiters#">

												<label class="<cfif attr.inline>checkbox-inline<cfelse>#attr.type#</cfif>">

													<input type="checkbox" name="#attr.name#_#j#" value="#sel#" class="icheck"
													<cfif attr.readOnly> disabled </cfif>
													<cfif attr.required> required </cfif>
													<cfif listFindnocase(val__, sel, attr.delimiters)> checked </cfif>
													/> #ListGetAt(attr.Display,k,attr.delimiters)#

												</label>

											</cfloop>

										</cfif>
									</div>
									<div class="cf_table_edit_label #display_label#"><div>#val_#</div></div>
								</cfcase>

								<cfcase value="select2">
									<cftry>
										<cfset _text = trim(evaluate(attr.text))/>

										<cfif _text == "">
											<cfset _text = trim(evaluate(attr.text2))/>
										</cfif>
										<cfset _name = replacenocase(attr.name, Attributes.name & "_", "")/>
										<cfset val__ = trim(evaluate(_name)) & "`" & _text/> 
										<cfcatch type="expression">
											<cfset val__ =  "`" & evaluate(attr.value)/>
										</cfcatch>
									</cftry>

									<cfset val__2 = serializejson(val__)/>
									<cfset val_ = '"' & val__2.listlast('`')/> 

									<!--- check for defaultTaggedValue --->
									<!---cfif attr.defaultTaggedValue neq "">
										<cfset val_ = '"' & trim(evaluate(attr.defaultTaggedValue)) & '"'/>
									</cfif--->
									<div class="cf_table_edit_input #display_form#">
										<cfif attr.readOnly>
											#val_#
										<cfelse>
											<!---textarea name="#attr.name#_#j#" id="#attr.id#_#j#" class="form-control">#val__#</textarea--->
											<input type="hidden" name="#attr.name#_#j#" id="#attr.id#_#j#" class="form-control" value="#val__#"/>

											<script type="text/javascript">
											$(document).ready(function() {
												$("###Attributes.Id# ###attr.id#_#j#").select2({
													<!---placeholder: "",--->
													multiple:#attr.multiple#
													<cfif !attr.URL.isempty()>
														<cfif val_.len() gt 1>
															,initSelection : function (element, callback) {
																var vl = element.val().split(",");
																<!---var data = []
																for (var i = 0; i < vl.length; i++) {
																	var vl2 = vl[i].split("`");
																	data.push({id: vl2[0], text: vl2[1]});
																}
																callback(data);
																console.log(data);--->
																var vl = element.val().split("`");
																var data = {id: vl[0], text: vl[1]};
																callback(data);
																//console.log(element);
															}
														</cfif>
														<cfif attr.Tagging>
															,tokenSeparators: [","],
															createSearchChoice: function(term, data) {
																if ($(data).filter(function() {return this.text.localeCompare(term) === 0;}).length === 0) { return {id: term,text: term};}
															}
														</cfif>
														,maximumSelectionSize:#attr.selection#
														,minimumInputLength: 1,
														ajax: {dataType: "json",
															url: "controllers/#attr.URL#",
															data: function (term, page) {  return {q: term, page_limit: 10, page: page, #attr.jsparam#};},
															results: function (data) {/*console.log(data)*/;return {results: data};}
														}
													</cfif>


												});

												$("###Attributes.Id# ###attr.id#_#j#").on("change", function(e) {
													if(e.added != undefined)   {
														//console.log(e.added.text);
														$("###Attributes.Id# ###attr.id#_#j#").val(e.added.id+'`'+e.added.text);
													}
												});
											});
											</script>
										</cfif>
									</div>
									<div class="cf_table_edit_label #display_label#"><div>#val_#</div></div>
								</cfcase>

								<cfcase value="integer,number,float" delimiters=",">

									<cfif isDefined(attr.value)>
										<cfset val_ = trim(evaluate(attr.value))/>
									<cfelse>
										<cfset val_ = ""/>
									</cfif>

									<div class="cf_table_edit_input #display_form#">
										<cfset readoc = false/>
										<cfif attr.readonlyIf != "">
											<cfset attr.readOnly = evaluate(attr.readonlyIf)/>
										</cfif>
										<cfif attr.readOnly>
											<cfif attr.format == "number">
												#numberformat(val_,'9,999')#
											<cfelse>
												#val_#
											</cfif>
										<cfelse>
											<input type="number" width="100%" class="form-control text-right" onchange="#attr.onChange#" value="#val_#" name="#attr.name#_#j#"
											<cfif attr.required> required</cfif>
											<cfif attr.min is not ""> data-rule-min="#attr.min#" </cfif>
											/>
										</cfif>
									</div>
									<div class="cf_table_edit_label #display_label#"><div>#val_#</div></div>

								</cfcase>

								<cfcase value="date,datetime" delimiters=",">

									<cfif isDefined(attr.value)>
										<cfset val_ = trim(evaluate(attr.value))/>
									<cfelse>
										<cfset val_ = ""/>
									</cfif>
									<cfif isdate(val_)>
										<cfset val_ = dateformat(val_,'yyyy/mm/dd')/>
									</cfif>
									<div class="cf_table_edit_input #display_form#">
										<cfif attr.readOnly>
											#dateformat(val_,'d-mmm-yyyy')#
										<cfelse>
											<input type="date" style="#attr.elementStyle#" class="form-control" value="#dateformat(val_,'yyyy-mm-dd')#" name="#attr.name#_#j#"
											<cfif attr.required> required</cfif>/>
										</cfif>
									</div>
									<div class="cf_table_edit_label #display_label#"><div>#dateformat(val_,'d-mmm-yyyy')#</div></div>

								</cfcase>

								<cfcase value="template">
									<cfset val_ = ntemp = attr.value/>
									<cfloop list="#attr.value#" item="temp" delimiters="]">
										<!--- get the field name --->
										<cfset fld = listlast(temp,'[')/>
										<cfset fld_result = evaluate(fld)/>

										<cfif IsNumeric(fld_result)>
											<cfif attr.format == "money">
												<cfset fld_result = application.fn.moneyFormat(fld_result)/>
											<cfelse>
												<cfset fld_result = numberFormat(fld_result, '_,___')/>
											</cfif>
										</cfif>
										<cfif isDate(fld_result)>
											<cfset fld_result = dateformat(fld_result, 'dd-mmm-yy')/>
										</cfif>
										<cfset val_ = replaceNoCase(val_, '[#fld#]', fld_result)/>
									</cfloop>
									<cfset val_ = replaceNoCase(val_, chr(10),'<br/>','all')/>
									<div class="cf_table_edit_input #display_form#" name="#attr.name#_#j#">
										#val_#
									</div>
									<div class="cf_table_edit_label #display_label#"><!--- <div>#val_#</div> ---></div>
								</cfcase>

								<cfcase value="document">
									Working on this
								</cfcase>

								<cfdefaultcase>
									<cfif isDefined(attr.value)>
										<cfset val_ = trim(Attributes.datasource[attr.value])/>
									<cfelse>
										<cfset val_ = ""/>
									</cfif>
									<div class="cf_table_edit_input #display_form#">
										<cfif attr.readOnly>
											#val_#
										<cfelse>

											<input <cfif attr.autocomplete == true>autocomplete="on"</cfif> type="text" width="100%" class="form-control" value="#val_#" name="#attr.name#_#j#"
											<cfif attr.required> required</cfif>/>

										</cfif>
									</div>
									<div class="cf_table_edit_label #display_label#"><div>#val_#</div></div>
								</cfdefaultcase>

							</cfswitch>

						</td>
					</cfif>
				</cfloop>
				<cfif Attributes.canDelete>
					<td>

						<a class="btn btn-primary btn-sm cf_table_edit_edit #display_label#" title="Edit line-item" data-tr="#tr_id#" id="#Attributes.Id#_edit_#j#"></a>
						<a class="btn btn-danger btn-sm cf_table_edit_del #display_form#" title="Delete line-item" data-tr="#tr_id#" data-action="#action_id#" id="#Attributes.Id#_del_#j#"></a>

					</td>
				</cfif>
			</tr>
		</cfloop>

	<cfelse>

	</cfif>
</tbody>
<cfif isQuery(Attributes.datasource)>
	<cfset j = Attributes.datasource.recordcount/>
<cfelse>
	<cfset j = 0/>
</cfif>

<!--- allow addition on new line item --->
<cfif Attributes.allowNewLineItem>


	<tbody class="cf_table_edit_new hide">
		<tr>
		<cfloop array="#request.TableEdit.columns#" item="attr" index="i">
			<cfif attr.hidden>
				<input type="hidden" value="0" name="#attr.name#"/>
			</cfif>
		</cfloop>

		<input type="hidden" value="N" name="#action_var#"/>

	<cfloop array="#request.TableEdit.columns#" item="attr" index="i">
		<cfif !attr.hidden>
		<td class="#attr.class#"
			<cfif attr.align neq""> style="text-align:#attr.align#;" </cfif>
			<cfif attr.nowrap> nowrap </cfif>
			<cfif attr.width is not ""> width="#attr.width#" </cfif>
		>

			<cfswitch expression="#attr.type#">

				<cfcase value="money">
					<div class="input-group">
						<cfif attr.currency is not "">
							<span class="input-group-addon money">#attr.currency#</span>
						</cfif>
						<input type="text" width="100%" class="form-control text-right addon tag-xmoney" id="#attr.id#" name="#attr.name#"
							<cfif attr.required>required</cfif>
							<cfif attr.min is not ""> data-rule-min="#attr.min#" </cfif>
						/>
					</div>
				</cfcase>

				<cfcase value="textarea">
					<textarea type="text" width="100%" class="form-control" name="#attr.name#" rows="#attr.rows#"
					<cfif attr.required> required</cfif>
					></textarea>
				</cfcase>

				<cfcase value="select">
					 
					<select name="#attr.name#" class="form-control" <cfif attr.required> required</cfif>>
						<option value=""> - </option>
						<cfloop list="#attr.Value#" item="sel" index="k" delimiters="#attr.delimiters#">
							<option value="#sel#">#ListGetAt(attr.Display,k,attr.delimiters)#</option>
						</cfloop>
					</select>

				</cfcase>

				<cfcase value="check,checkbox">

					<label class="<cfif attr.inline>checkbox-inline<cfelse>#attr.type#</cfif>">
						<cfloop list="#attr.Value#" item="sel" index="k" delimiters="#attr.delimiters#">
							<input type="checkbox" name="#attr.name#" value="#sel#" class="icheck"
								<cfif attr.readOnly> disabled </cfif>
								<cfif attr.required> required </cfif>/>#ListGetAt(attr.Display,k,attr.delimiters)#</option>
						</cfloop>
					</label>

				</cfcase>

				<cfcase value="select2">

					<input type="hidden" name="#attr.name#" onchange="#attr.onChange#" class="form-control"/>

				</cfcase>

				<cfcase value="integer,number,float" delimiters=",">
	
					<input type="number" width="100%" class="form-control text-right" data-rule-number="true" onchange="#attr.onChange#" name="#attr.name#"
						<cfif attr.required> required</cfif>
						<cfif attr.min is not ""> data-rule-min="#attr.min#" </cfif>
					/>

				</cfcase>

				<cfcase value="date,datetime" delimiters=",">

					<input type="#attr.type#" style="#attr.elementStyle#" class="form-control " name="#attr.name#"
						<cfif attr.required> required</cfif>
					/>

				</cfcase>

				<cfcase value="template">
					<cfset _id = replace(attr.name, "[","_","all")/>
					<cfset _id = replace(_id, "]","_","all")/>
					<div class="mt-3" name="#attr.name#"></div>

				</cfcase>

				<cfcase value="document">
					<a class="btn btn-sm btn-info" href="
					javascript:directModal('awaf/tags/tableedit/upload_file.cfm', {title: 'Upload Documents','param':'sessionid=#attr.sessionid#'});
					">Upload File</a>
				</cfcase>

				<cfdefaultcase>
					<input type="text" width="100%" class="form-control" name="#attr.name#"
					<cfif attr.required> required</cfif>/>
				</cfdefaultcase>

			</cfswitch>

		</td>
		</cfif>

	</cfloop>

		<cfif Attributes.canDelete>
			<td><a class="btn btn-danger btn-sm cf_table_edit_delx" title="Delete line-item"></a></td>
		</cfif>

	</tr>
	</tbody>

	<tbody class="cf_table_edit_new_here"></tbody>

	<cfif attributes.SubTotal != "">
		<tr class="cf_table_edit_subtotal_section">
			<td colspan="#request.TableEdit.totalcolumn#" class="cf_table_edit_subtotal_data" align="right">#Attributes.SubTotal#</td>
			<td></td>
		</tr>
	</cfif>
	<tr>
		<td colspan="#request.TableEdit.totalcolumn+1#" align="right">
			<a class="btn btn-default btn-sm cf_table_edit_add" title="Add a new line-item">#Attributes.NewLineItemText#</a>
		</td>
	</tr>
	
</cfif>
</table>
</div>

<!--- counter : count new item --->
<cfset new_counter = application.fn.GetRandomVariable()/>
<input type="hidden" value="#j#" id="#new_counter#"/>

<!--- jsscript ---->

<script type="text/javascript">
	<cfset edit_function =  application.fn.GetRandomVariable()/>

	function #edit_function#(b)  {

		<cfset edit_input = application.fn.GetRandomVariable()/>
		<cfset edit_label = application.fn.GetRandomVariable()/>
		<cfset edit_b = application.fn.GetRandomVariable()/>
		<cfset del_b = application.fn.GetRandomVariable()/>
		var #del_b# = $(b);
		document.getElementById(#del_b#.data('action')).value = 'D';
		var #edit_input# = $('##'+#del_b#.data('tr') + ' .cf_table_edit_input');
		var #edit_label# = $('##'+#del_b#.data('tr') + ' .cf_table_edit_label');
		var #edit_b# = $('##'+#del_b#.data('tr') + ' a.cf_table_edit_edit');
		#edit_input#.addClass('hide');
		#edit_label#.removeClass('hide').addClass('strock-text');
		#del_b#.addClass('hide');
		#edit_b#.removeClass('hide');

	}

	$(document).ready(function() {

		$("###Attributes.id# input.tag-xmoney").on({
			keyup: function() {
				this.value = numberWithCommas($(this).val());
			}
		});

		$('###Attributes.Id# a.cf_table_edit_del').on('click',  function(e) {

			#edit_function#(e.target);

		});

		<cfloop array="#request.TableEdit.columns#" item="attr" index="i">
			<cfif (attr.type == 'checkbox' || attr.type == 'check')>
				$('###Attributes.id# input.icheck').iCheck({checkboxClass: 'icheckbox_square', radioClass: 'iradio_square'});
				<cfbreak>
			</cfif>
		</cfloop>

		<!--- loop through query to check the action ---->
		<cfif isQuery(Attributes.datasource)>
			<cfset i = 0/>
			<cfloop query="Attributes.datasource">
				<cfset i ++/>
				<cftry>
					<cfset action_value = evaluate(action_var)>
					<cfcatch type="any">
						<cfset action_value = "">
					</cfcatch>
				</cftry>
				<cfif action_value == "D">
					#edit_function#('###Attributes.Id#_del_#i#');
				</cfif>
			</cfloop>
		</cfif>

		$('###Attributes.Id# a.cf_table_edit_edit').on('click',  function(e) {
			<cfset del_b = application.fn.GetRandomVariable()/>
			<cfset edit_b = application.fn.GetRandomVariable()/>
			<cfset edit_input = application.fn.GetRandomVariable()/>
			<cfset edit_label = application.fn.GetRandomVariable()/>
			var #edit_b# = $(e.target);
			var #del_b# = $('##'+#edit_b#.data('tr') + ' a.cf_table_edit_del');
			document.getElementById(#del_b#.data('action')).value = '';
			var #edit_label# = $('##'+#edit_b#.data('tr') + ' .cf_table_edit_label');
			var #edit_input# = $('##'+#edit_b#.data('tr') + ' .cf_table_edit_input');
			#edit_label#.addClass('hide');
			#edit_input#.removeClass('hide');
			#del_b#.removeClass('hide');
			#edit_b#.addClass('hide');
		});

	<cfif Attributes.allowNewLineItem>

		<cfset _add_new_line_item =  application.fn.GetRandomVariable()/>
		var #_add_new_line_item# = $('###Attributes.Id# a.cf_table_edit_add');
		#_add_new_line_item#.on('click', function(e)  {

			var this_ = $(e.target);
			var new_row = $("###Attributes.Id# .cf_table_edit_new").children().clone(true,true)
			new_row.removeClass('hide');
			new_row.appendTo('###Attributes.Id# .cf_table_edit_new_here');
			/// set the id and name
			var counter = document.getElementById('#new_counter#');
			counter.value = parseInt(counter.value) + 1;
			<cfset l = k = ""/>
			<cfset x = []/>
			<cfloop array="#request.TableEdit.columns#" item="attr" index="i">
				<cfset l = listappend(l, attr.name)/>
				<cfset x.Append({
					"#attr.name#" : {
						"onchange" 	: attr.onchange,
						"type"			: attr.type
					}
				})/>
			</cfloop>
			<cfset l = l & ",#action_var#"/>
			<cfset l = listQualify(l, '"')/>
			var flds = [#l#];
			for (var i = 0; i < flds.length; i++) {
				v = #serializeJSON(x)#;
				//console.log(v[0][flds[i]]);
				if(v[0][flds[i]] != undefined)	{
					new_row.find('[name="' + flds[i] + '"]')[0].setAttribute('onchange', v[0][flds[i]].onchange);
				}
				if(v[i] != undefined)	{
					//console.log(v[i][flds[i]]);

				}
				//console.log(flds[i]);
				new_row.find('[name="' + flds[i] + '"]')[0].setAttribute('name',flds[i] + '_' + counter.value);
				
				//if(v[i][]type)
			}
			<!--- check for select2--->
			<cfloop array="#request.TableEdit.columns#" item="attr" index="i">
				<cfif attr.type is 'select2'>
					var sel2id =  "###Attributes.Id# input[name='#attr.name#_"+counter.value+"']";
					$(sel2id).select2({
						multiple:#attr.multiple#
						<cfif !attr.URL.isempty()>
							<cfif attr.Tagging>
								,tokenSeparators: [","],
								createSearchChoice: function(term, data) {
									if ($(data).filter(function() {return this.text.localeCompare(term) === 0;}).length === 0) { return {id: term,text: term};}
								}
							</cfif>
							,maximumSelectionSize: #attr.selection#
							,minimumInputLength: 1,
							ajax: {dataType: "json",
								url: "controllers/#attr.URL#",
								quietMillis: 500,
								data: function (term, page) {  return {q: term, page_limit: 10,page: page, #attr.jsparam#};},
								results: function (data) {return {results: data};}
							}
						</cfif>
					});

					// TODO: remove
					/*$(sel2id).on("change", function(e) {
						if(e.added != undefined)   {
							$(sel2id).val(e.added.id+'`'+e.added.text);
						}
					});*/
				</cfif>
			</cfloop>
		});

		<!--- automatically add blank row --->
		<cfif is_query>
			<cfif !attributes.datasource.recordcount>
				setTimeout(function() {
					#_add_new_line_item#.trigger('click');
				},10);
			</cfif>
		</cfif>

		$('###Attributes.Id# a.cf_table_edit_delx').on('click',  function(e) {
			if(confirm('Are you sure you want to delete this line item?'))  {
				$(this).closest('tr').remove();
			}
		});

	</cfif>


	});

</script>


</cfif>
</cfoutput>