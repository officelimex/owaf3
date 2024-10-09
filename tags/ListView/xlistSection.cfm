<cfoutput>

  <cfif ThisTag.ExecutionMode == "Start">
  
    <cfparam name="Attributes.tagname" type="string" default="xlistSection"/>
    <cfparam name="Attributes.id" type="string" default="#application.fn.GetRandomVariable()#"/>
    <cfparam name="Attributes.width" type="numeric" default="35"/>
    <cfparam name="Attributes.title" type="string"/>
    <cfparam name="Attributes.model" type="string"/>
		<cfparam name="Attributes.name" type="string" default="#replace(listFirst(Attributes.model,' '),'.','_','all')#"/>
    <cfparam name="Attributes.fields" type="string"/>
    <cfparam name="Attributes.searchable" type="string" default="#Attributes.fields#"/>
    <cfparam name="Attributes.select" type="string" default=""/>
    <cfparam name="Attributes.baseSelect" type="string" default="-"/>
    <cfparam name="Attributes.groupBy" type="string" default=""/>
    <cfparam name="Attributes.join" type="string" default=""/>
    <cfparam name="Attributes.filter" type="string" default=""/>
    <cfparam name="Attributes.sortBy" type="string" default=""/>
    <cfparam name="Attributes.sortDir" type="string" default="ASC"/>

    <cfparam name="Attributes.toolbar" type="array" default="#[]#"/>

    <cfset request.listsection.tag = Attributes/>

  <cfelse>

    <style>
      ###Attributes.Id# {
        margin-left: #request.filtersection.tag.width#;
      }
      .xlv-app-wrap.xlv-app-sidebar-toggle ###Attributes.Id# {
        margin-left: 0;
      }
      ###Attributes.Id# .xlv-app-left {
        -ms-flex: 0 0 #Attributes.width#%;
        flex: 0 0 #Attributes.width#%;
        max-width: #Attributes.width#%;
      }
      @media (max-width: 1400px)  {
        ###Attributes.Id# {
          margin-left: 0 !important;
        }
      }
      @media (max-width: 1024px)  {
        ###Attributes.Id# .xlv-app-left {
          -ms-flex: 0 0 100%;
          flex: 0 0 100%;
          max-width: 100%;
        }
      }
    </style>
    <cfset Content = replacenocase(THISTAG.GeneratedContent, "openContent", "_#Attributes.Id#_openContent") />
    <cfset THISTAG.GeneratedContent = "" />

    <script id="template_#Attributes.Id#" type="text/x-handlebars-template">
			#Content#
		</script> 

    <div class="xlv--box" id="#Attributes.Id#">
      <div class="xlv-app-left">
        <header>
          <a href="javascript:void(0)" class="xlv-app_sidebar_move xlv-app-sidebar-move" title="Filter">
            <cfif request.filtersection.tag.width != 0> 
              
              <i class="fal fa-filter text0primary"></i>
              <!--- 
              <span class="feather-icon"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-menu"><line x1="3" y1="12" x2="21" y2="12"></line><line x1="3" y1="6" x2="21" y2="6"></line><line x1="3" y1="18" x2="21" y2="18"></line></svg></span>
              --->
            </cfif>
          </a>
          <span>#Attributes.title#</span>

          <cfif arrayLen(attributes.toolbar) == 0>
            <a></a>
          <cfelse>
            <a></a>
            <cfloop array="#Attributes.toolbar#" item="x">
              <cfif !isdefined("x.modalPosition")>
                <cfset x.modalPosition = "right"/>
              </cfif>
              <cfif !isdefined("x.icontype")>
                <cfset x.icontype = "fal fa-"/>
              </cfif>
              <cfif isdefined("x.icon")>
                <cfset _icon = x.icon/>
              <cfelse>
                <cfset _icon = "plus"/>
              </cfif>
              <cfif isdefined("x.title")>
                <cfset _title = x.title/>
              <cfelse>
                <cfset _title = "New #Attributes.title#"/>
              </cfif>              
              <cf_link icon="#_icon#" icontype="#x.icontype#" modalPosition="#x.modalPosition#" type="modal" url="#x.url#" title="#_title#" modalTitle="#_title#"/>
            </cfloop>
          </cfif>
          <!---
          <a href="javascript:void(0)" class="xlv--compose" data-toggle="modal" data-target="##exampleModalxlv-">
            <span class="feather-icon">
              <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-edit"><path d="M20 14.66V20a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h5.34"></path><polygon points="18 2 22 6 12 16 8 16 8 12 18 2"></polygon></svg>
            </span>
          </a>
          --->
        </header>
        <div role="search" class="xlv--search">
          <div class="input-group">
            <div class="input-group-prepend">
              <span class="feather-icon"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-search"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg></span>
            </div>
            <input type="text" class="form-control" placeholder="Search..." id="_#Attributes.Id#_search"/>
          </div>
        </div>
        <div class="xlv-app-xlv-s-list" style="height: 780px; overflow:auto;"></div>
      </div>

      <cfset attributes.fields = replace(attributes.fields, " ", "","all")/>
      <cfset attributes.searchable = replace(attributes.searchable, " ", "","all")/>

      <cfset search_c = ""/>
      <cfset arr_col = []/>
      <cfloop list="#attributes.fields#" item="fld" index="i">
        <cfset fname = trim(fld)/>
        <cfif listLen(fname,'_')>
          <cfset fld_name = listLast(fname, '_')/>
          <cfset fname = replace(fname, "_#fld_name#", ".#fld_name#")/>
        </cfif>
        <cfset sh = false/> 
        
        <cfif listFindNoCase(attributes.searchable, fld)>
          <cfset sh = true/> 
        </cfif>      
        <cfset arr_col.Append(
          {
            "name": fld, 
            "searchable": sh, 
            "field": fname
          }
        )/>
        <cfset k = i-1/>
        <cfset search_c = listAppend(search_c, "columns[#k#][search][value]=&columns[#k#][data]=#k#&columns[#k#][name]=&columns[#k#][searchable]=true","&")/>
      </cfloop>

      <cflock scope="Session" type="exclusive" timeout="20">
        <cfset session.tags.grid[Attributes.name].filter = Attributes.filter/>
        <cfset session.tags.grid[Attributes.name].model = Attributes.model/>
        <cfset session.tags.grid[Attributes.name].join = ""/>
        <cfset session.tags.grid[Attributes.name].Columns = arr_col/>
        <cfset session.tags.grid[Attributes.name].fColumns = attributes.fields/>
        <cfset session.tags.grid[Attributes.name].Captions = ""/>
        <cfset session.tags.grid[Attributes.name].key = ""/>
        <cfset session.tags.grid[Attributes.name].cmd = false/>
        <cfset session.tags.grid[Attributes.name].join_stm = attributes.join/>
        <cfset session.tags.grid[Attributes.name].sel_stm = attributes.select/>
        <cfset session.tags.grid[Attributes.name].sel_clause = attributes.baseSelect/> 
        <cfset session.tags.grid[Attributes.name].gb = attributes.groupBy/>
        <cfset session.tags.grid[Attributes.name].having = ""/>
        <cfset session.tags.grid[Attributes.name].sortby = Attributes.sortBy/>
        <cfset session.tags.grid[Attributes.name].sortdir = Attributes.sortDir/>
        <cfset session.tags.grid[Attributes.name].title = ""/>
        <cfset session.tags.grid[Attributes.name].fileName = ""/>
        <cfset session.tags.grid[Attributes.name].aggregate = ""/>
      </cflock>

      <cfset xlist.start = 1/> 

    <script>

      var listElm = document.querySelector('###Attributes.Id# .xlv-app-xlv-s-list');
      // Detect when scrolled to bottom.
      listElm.addEventListener('scroll', function() {
        if (listElm.scrollTop + listElm.clientHeight >= listElm.scrollHeight) {
          _loadmore(listElm.childElementCount); 
        }
      }); 

      var _#Attributes.Id#_openContent = function(e) {
        loadPage(e.getAttribute("data-url"), {
          forcePageReload : true,
          samePage				: true,
          changeURL				: false,
          renderTo				: e.getAttribute("data-renderTo"),
          donefn 					: function() 	{setHeightWidth('#Attributes.Id#');}
        });

        var els = document.querySelectorAll("###Attributes.Id# a.media");
        els.forEach(function(el) { 
          el.className = "media";
        }); 
        e.className = "media active-xlv-";
      }
      
      document.querySelector('##_#Attributes.Id#_search').addEventListener("keyup", event => {
        
        if(event.code == "Enter" || event.target.value.length > 2)   {
          _#Attributes.Id#_getdata(event.target.value, 0, true);
        }

      });
      /*
      $("##_#Attributes.Id#_search").keyup(function(e) {
        console.log(e);
        if(e.which == 13) {
          _#Attributes.Id#_getdata(e.target.value, 0, true);
        }
      });
      */

      var _#Attributes.Id#_getdata = function(sh, i, bool) {
        var s_input = document.getElementById("_#Attributes.Id#_search");
        $.ajax({
          url: 'awaf/tags/grid/ajax.cfm?grid_name=#Attributes.name#',
          data: '#search_c#&search[regex]=false&search[value]=' + s_input.value + '&order[0][column]=#attributes.sortBy#&order[0][dir]=#attributes.sortDir#&start='+ i + '&length=50&draw=&',
          type: 'POST',
          beforeSend: function () {
            //s_input.disabled = true;
          },
          cache: false
        }).done(function (data) { 
          if(bool)  {
            $("###Attributes.Id# .xlv-app-xlv-s-list").empty();  
          }
          var _template = Handlebars.compile(document.getElementById('template_#Attributes.Id#').innerHTML);
          $("###Attributes.Id# .xlv-app-xlv-s-list").append(_template(data));
        }).fail(function (xhr) { 
          showError(xhr);
        }).always(function () {
          //s_input.disabled = false;
        });
      }

      var _loadmore = function(s) {
        var i = 1 + s;
        var dsh = '';
        _#Attributes.Id#_getdata(dsh, i, false)
      }

      _loadmore(-1);

    </script>
  </cfif>

</cfoutput>