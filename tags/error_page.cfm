<cfoutput>

	<cfif ThisTag.ExecutionMode == "Start">

		<cfparam name="Attributes.TagName" type="string" default="error page"/>
		<cfparam name="Attributes.url" type="string" default=""/>
		<cfparam name="Attributes.title" type="string" >
		<cfparam name="Attributes.type" type="string" default="System"/>
		<cfparam name="Attributes.message" type="string" default=""/>
		<cfparam name="Attributes.detail" type="string" default=""/>
		<cfparam name="Attributes.image" type="string"/>
		<cfparam name="Attributes.class" type="string" default="bg-white vh-100"/>
		
    <div class="container #attributes.class#" style="padding:10em 0;">
      
      <div class="row align-items-center">
   
        <div class="col-md-7 col-sm-12">
        
          <div class="text-center">
          
            <h6 class="text-uppercase text-muted mb-4">#attributes.type# Error</h6>
            <hr/>
            <h1 class="display-4 mb-3">#attributes.title#</h1>
  
            <p class="text-muted mb-4 lucee-err-msg">
              #attributes.message#
            </p>
            <cfif Attributes.url != "">
              <hr/>
              <cf_link url="#attributes.url#" class="btn btn-lg btn-primary">Return to your dashboard</cf_link>
            </cfif>
            <cfif Attributes.detail != "">
              <hr/>
              <div class="text-left lucee-err-detail">
                #Attributes.detail#
              </div>
            </cfif>
          </div>

        </div>

        <div class="col-md-5 col-sm-12">
  
          <div class="text-center pl-4">
            <img src="assets/#attributes.image#" class="img-fluid">
          </div>
  
        </div>
  
      </div> 
      
    </div>

	</cfif>
</cfoutput>