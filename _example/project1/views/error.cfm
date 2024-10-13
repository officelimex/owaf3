<!---<cfdump var="#request.err#"/>--->

<cfoutput>

  <cfset d = ""/>
  <cfloop array="#request.err.TagContext#" item="i">
    <cfset d = listAppend(d, "<li>#i.codePrintHTML#</li>")/>
  </cfloop>
  
  <cfset etype = trim(request.err.type)/>
  <cfif etype == "java.lang.NullPointerException">
    <cfset etype = "Network"/>
  </cfif>
  
  
  <!doctype html>
  <html lang="en">
    <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
      <meta name="description" content="">
      <title>Error</title>
    </head>
    <body class="d-flex align-items-center bg-auth border-top border-top-2 border-primary">
  
      <!-- CONTENT
      ================================================== -->
      <div class="container">
        <div class="row align-items-center">
          <div class="col-12 col-md-5 offset-xl-2 offset-md-1 order-md-2 mb-5 mb-md-0">
  
            <div class="text-center">
              <img src="assets/img/illustrations/lost.svg" width="24%" class="img-fluid">
            </div>
  
          </div>
          <div class="col-12 col-md-6 col-xl-4 order-md-1 my-5">
            
            <div class="text-center">
            
              <h6 class="text-uppercase text-muted mb-4" id="__owaf__error__title">
                #etype# Error
              </h6>
  
              <h1 class="display-4 mb-3">
                <cfif isdefined("request.err.name")>#request.err.name#</cfif> Issue 😭
              </h1>
  
              <p class="text-muted mb-4 bg-white" id="__owaf__error__msg">
                <cfif etype == "java.lang.NullPointerException">
                  #etype# Error
                <cfelse>
                  #request.err.Message#
                </cfif>
              </p>
  
              <p class="text-left text-muted mb-4" id="__owaf__error__trace">
                <cfif application.owaf.mode == 0 > <!-- </cfif>
                  <cfif isdefined("request.err.additional.sql")>
                    #request.err.additional.sql#<br/><br/>
                  </cfif>
                  #request.err.rootCause.TagContext[1].codePrintPlain#
                  <br/>
                  <br/>
                  #request.err.rootCause.TagContext[1].template# @ #request.err.rootCause.TagContext[1].line#
                <cfif application.owaf.mode == 0>--></cfif>
              </p>
  
              <a href="#application.site.url#" class="btn btn-lg btn-primary">
                Return to your dashboard
              </a>
            
            </div>
  
          </div>
        </div> <!-- / .row -->
      </div> <!-- / .container -->
    </body>
  </html> 
  
  </cfoutput>