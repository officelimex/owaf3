<cfscript>

	public string function ajaxLink1(required string url, string renderTo)	{

		var str = arguments.url
		str = "javascript:loadPage('#str#',{renderTo:'#arguments.renderTo#'})";
		return str;
	}

	public string function generateLink(required string url, string renderTo)	{

		var str = arguments.url;
		str = "javascript:loadPage('#str#',{renderTo:'#arguments.renderTo#'})";
		return str;
	}

	public boolean function isProductionServer()	{
		var rt = false;
		if(application.owaf.mode==0)	{
			rt = true;
		}
		return rt;
	}

	public string function encryptString(required string str)	{

		return encrypt(arguments.str, application.owaf.secretKey,'AES/CBC/PKCS5Padding','Hex');
	}

	public string function decryptString(required string str)	{

		return decrypt(arguments.str, application.owaf.secretKey, 'AES/CBC/PKCS5Padding', 'Hex');
	}

	public string function wrapItem(required string whatToWrap, required string class, string elementToUse = 'span')	{

		return "<" & arguments.elementToUse & " class=\'" & arguments.class & "\'>'+" & arguments.whatToWrap & "+'</" & arguments.elementToUse & ">";

	}

	public string function wrapProgress(required string whatToWrap, required string whatToWrap2, required string class, string elementToUse = 'span')	{

		return "<div> '+" & arguments.whatToWrap  & " + '</div><div class=\'progress\' style=\'margin-top:5px;height:5px\'><div class=\'progress-bar  #arguments.class#\' role=\'progressbar\' aria-valuenow=\''+" & arguments.whatToWrap2  & " + '\' aria-valuemin=\'0\' aria-valuemax=\'100\' style=\'width:'+" & arguments.whatToWrap2  & " + '%\'></div></div>"

	}

	public string function AppraisalProgressBar(required string status)	{

		var num = 0
		var lbl = ""

		switch(arguments.Status)	{
			case '':
				num = application.status.APPRAISAL.NOT_STARTED[2]
				lbl = "primary"
			break;
			case application.status.APPRAISAL.OBJECTIVE_SETTINGS[1]:
				num = application.status.APPRAISAL.OBJECTIVE_SETTINGS[2]
				lbl = "primary"
			break;
			case application.status.APPRAISAL.EMPLOYEE_NEED_TO_AGREE[1]:
				num = application.status.APPRAISAL.EMPLOYEE_NEED_TO_AGREE[2]
				lbl = "primary"
			break;
			case application.status.APPRAISAL.MANAGER_NEED_TO_AGREE[1]:
				num = application.status.APPRAISAL.MANAGER_NEED_TO_AGREE[2]
				lbl = "primary"
			break;
			case application.status.APPRAISAL.HR_NEED_TO_AGREE[1]:
				num = application.status.APPRAISAL.HR_NEED_TO_AGREE[2]
				lbl = "primary"
			break;
			case application.status.APPRAISAL.SCORING[1]:
				num = application.status.APPRAISAL.SCORING[2]
				lbl = "warning"
			break;
			case application.status.APPRAISAL.EMPLOYEE_NEED_TO_REVIEW[1]:
				num = application.status.APPRAISAL.EMPLOYEE_NEED_TO_REVIEW[2]
				lbl = "info"
			break;
			case application.status.APPRAISAL.MANAGER_NEED_TO_REVIEW[1]:
				num = application.status.APPRAISAL.MANAGER_NEED_TO_REVIEW[2]
				lbl = "info"
			break;
			case application.status.APPRAISAL.MANAGER_NEED_TO_SIGNOFF[1]:
				num = application.status.APPRAISAL.MANAGER_NEED_TO_SIGNOFF[2]
				lbl = "info"
			break;
			case application.status.APPRAISAL.HR_NEED_TO_SIGNOFF[1]:
				num = application.status.APPRAISAL.HR_NEED_TO_SIGNOFF[2]
				lbl = "info"
			break;
			case application.status.APPRAISAL.MANAGER_CHANGED_SCORE[1]:
				num = application.status.APPRAISAL.MANAGER_CHANGED_SCORE[2]
				lbl = "info"
			break;
			case application.status.APPRAISAL.HOD_NEED_TO_REVIEW[1]:
				num = application.status.APPRAISAL.HOD_NEED_TO_REVIEW[2]
				lbl = "info"
			break;
			case application.status.APPRAISAL.HOD_NEED_TO_SIGNOFF[1]:
				num = application.status.APPRAISAL.HOD_NEED_TO_SIGNOFF[2]
				lbl = "info"
			break;
			case application.status.APPRAISAL.EMPLOYEE_NEED_TO_SIGNOFF[1]:
				num = application.status.APPRAISAL.EMPLOYEE_NEED_TO_SIGNOFF[2]
				lbl = "info"
			break;
			case application.status.APPRAISAL.APPRAISAL_COMMITTEE[1]:
				num = application.status.APPRAISAL.APPRAISAL_COMMITTEE[2]
				lbl = "info"
			break;
			case application.status.APPRAISAL.APPRAISAL_MEETING[1]:
				num = application.status.APPRAISAL.APPRAISAL_MEETING[2]
				lbl = "info"
			break;
			case application.status.APPRAISAL.EMPLOYEE_DISAGREE[1]:
				num = application.status.APPRAISAL.EMPLOYEE_DISAGREE[2]
				lbl = "warning"
			break;
			case application.status.APPRAISAL.COMPLETE[1]:
				num = application.status.APPRAISAL.COMPLETE[2]
				lbl = "success"
			break;
		}

		return "
			<div>#arguments.status#</div>
			<div class='progress' style='margin-top:5px;height:5px;margin-bottom:0;'>
				<div class='progress-bar progress-bar-#lbl#' role='progressbar' aria-valuenow='#num#' aria-valuemin='0' aria-valuemax='100' style='width:#num#%'></div>
			</div>
		"

	}

	public any function controller(required string cntr)	{

		arguments.cntr = replace(arguments.cntr,'_','','all');

		return createObject("component", "officelimex.controllers." & arguments.cntr).init()
	}

	public any function model(required string modl)	{

		return createObject("component","officelimex.models." & ListFirst(arguments.modl, ' ')).init()
	}

</cfscript>