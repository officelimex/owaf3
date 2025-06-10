<cfoutput>

  <cfparam name="attributes.anonymous" default="false"/>
  <cfparam name="attributes.editable" default=""/>
  <cfparam name="Attributes.redirectURL" default=""/>
  <cfparam name="Attributes.key" default=""/>
  <cfparam name="Attributes.modelid" default=""/>
  <cfparam name="Attributes.order" default=""/>
  <cfparam name="Attributes.duration" default="3"/>
  
  <cfparam name="view.anonymous" default="#attributes.anonymous#"/>
  <cfparam name="view.editable" default="#attributes.editable#"/>
  <cfparam name="view.redirectURL" default="#attributes.redirectURL#"/>
  <cfparam name="view.pageid" default="#attributes.pageid#"/>
  <cfparam name="view.key" default="#attributes.key#"/>
  <cfparam name="view.modelid" default="#attributes.modelid#"/>
  <cfparam name="view.order" default="#attributes.order#"/>
  <cfparam name="view.order" default="#attributes.duration#"/>
 
  <cfloop query="comments">

    <div class="comment">
      <a id="cid_#comments.CommentId#"></a>
      <div class="row">
        <div class="col-auto">
          <span class="avatar avatar-sm mt-3">
            <cfif view.anonymous>
              <img src="assets/img/profile.png" class="avatar-img rounded-circle">
            <cfelse>
              <img src="#application.s3.url#pub/#comments.company_TenantId#/passport/#comments.postedBy_Picture#" class="avatar-img rounded-circle">
            </cfif>
          </span>
        </div>
        <div class="col ml--2">
          <div class="comment-body">
            <div class="row">
              <div class="col">
                <h5 class="comment-title">
                  <cfif view.anonymous>
                    Anonymous User.
                  <cfelse>
                    #comments.postedBy_FirstName# #comments.postedBy_Surname#.
                  </cfif>
                </h5>
              </div>
              <div class="col-auto text-right">

                <time class="comment-time">#application.fn.DateFormat1(comments.Created)#</time> 
                
                <cfif (view.editable) && (request.user.UserId == comments.PostedByUserId) && (dateDiff('d', comments.Created, now()) <= Attributes.duration)>
                  <cf_link 
                    modaltitle="Update your Comment"
                    type="modal"
                    class="edit"
                    url="plugin.comment.update~#comments.CommentId#" 
                    urlparam="redirect=#view.redirectURL#">edit</cf_link>
                  <span class="edit text-muted">&nbsp;&nbsp;|&nbsp;&nbsp;</span>
                  <cf_link 
                    type="execute"
                    class="edit text-danger"
                    url="plugin/Comment.cfc?method=delete&id=#comments.CommentId#" 
                    renderTo="#view.pageid#"
                    changeURL="false"
                    flashMessage="Comment was deleted"
                    redirectURL="plugin.comment.view"
                    redirectURLparam="pageid=#view.pageid#&key=#view.key#&modelid=#view.modelid#&order=#view.order#&anonymous=#view.anonymous#&editable=#view.editable#&redirectURL=#view.redirectURL#" icon="times"></cf_link>
                <cfelse>
                  <br/>
                </cfif>
              </div>
            </div>
            <div class="comment-text mt--3">
              #application.fn.replaceCarriageReturn(comments.Comment)#
            </div>
            <cfif comments.cc != "">
              <div>
                copy:
                <cfloop list="#comments.cc#" item="_cc" index="i">
                  <cfif i lt 7>
                    <span class="label label-default" style="line-height:20px;background-color:##efe8e8;">#_cc#</span>
                  <cfelse>
                    <span class="label label-default" style="line-height:20px;background-color:##efe8e8;">...</span>
                    <cfbreak>
                  </cfif>
                </cfloop>
              </div>
            </cfif>
            <cfif len(trim(comments.Files))>
              <ul class="fa-ul">
              <cfloop list="#comments.Files#" delimiters="|" item="f" index="i">
              <li>
                <span class="fa-li"><i class="#getfileType(f)#"></i></span>
                <!--- <a target="_blank" href="#application.s3.url#pvt/#comments.company_TenantId#/document/comment/#comments.FileNames#/#f#">...#right(f,45)#</a> --->
                <cfset _key = encrypt(comments.CommentId & "-" & request.user.userid & "-#i++#-#comments.TenantId#" , application.owaf.secretkey, 'AES/CBC/PKCS5Padding', 'Hex')/>
                <small><a target="_blank" href="attachment/view.cfm?file=#_key#">...#right(f,40)#</a></small>
              </li>
              </cfloop>
              </ul>
            </cfif>
          </div>
        </div>
      </div>
    </div>
  </cfloop>

</cfoutput>