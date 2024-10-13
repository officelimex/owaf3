component extends="project1.owaf.com.Controller"   {

	private any function _inner_pages()	{

		return [
			profile : {
				url : "employee.view", title : "Profile"
			},
			appraisals : {
				url : "employee.profile.appraisals", title : "Appraisals"
			},
			documents : {
				url : "employee.documents", title : "Documents"
			},
			beneficiaries : {
				url : "employee.beneficiaries", title : "Beneficiaries"
			}
		]
	}

	public struct function profile(urlparam)	{

		var rt = {}
		var emp = getEmployee()
		rt.employee = emp.findQ(request.user.employeeid)
		rt.manager = emp.findQ(val(request.user.managerid))
		rt.manager2 = emp.findQ(val(rt.employee.Manager2Id))
		var uid = val(rt.employee.UserId)
		rt.user_role = getUserRole()
										.join(application.model.ROLE)
										.findByUser(uid)
		rt.user_license = getUserLicense()
												.join(application.model.LICENSE)
												.findByUser(uid)
		
		rt.inner_pages = _inner_pages()

		rt.has_payroll = rt.has_leave =  false
		if(hasLicense(application.LICENSEID.PAYROLL))	{
			rt.has_payroll = true
		}
		if(hasLicense(application.LICENSEID.LEAVE))	{
			rt.has_leave = true
		}

		return rt
	}

	public struct function list(urlparam)	{

		var rt = {}
		rt.page_name = arguments.urlparam.key
		if(rt.page_name == "employee.list" || rt.page_name == 0)	{
			rt.page_name = "Active"
		}
		rt.pageid = getRandomVariable()
		rt.filter = ""
		if(rt.page_name != "All")	{
			rt.filter = "status.Name:[#rt.page_name#]"
		}

		return rt
	}

	public struct function unConfirmedList(uparam)	{

		var rt = {}
		rt.filter = "status.StatusId:#application.status.ACTIVE# AND employee.Confirmed:[No] AND employee.Type:[Full-time]"

		return rt
	}

	public struct function view(urlparam)	{

		var rt = {}
		var emp = getEmployee()
		rt.employee = emp.findQ(val(arguments.urlparam.key))
		rt.manager = emp.findQ(val(rt.employee.ManagerId))
		rt.manager2 = emp.findQ(val(rt.employee.Manager2Id))
		var uid = val(rt.employee.UserId)
		rt.user_role = getUserRole()
										.join(application.model.ROLE)
										.findByUser(uid)
		rt.user_license = getUserLicense()
												.join(application.model.LICENSE)
												.findByUser(uid)
		rt.inner_pages = _inner_pages()
		
		rt.has_payroll = rt.has_leave =  false
		if(hasLicense(application.LICENSEID.PAYROLL))	{
			rt.has_payroll = true
		}
		if(hasLicense(application.LICENSEID.LEAVE))	{
			rt.has_leave = true
		}
		return rt
	}

	public struct function exitPage(urlparam)	{

		var rt = {}
		var emp = getEmployee().findQ(val(arguments.urlparam.key))
		rt.userId = emp.UserId
		rt.employeeId = emp.EmployeeId

		return rt
	}

	public struct function sendMessagePage(uparam)	{

		cfparam(name="arguments.uparam.subject", default="")
		var rt = {
			subject  : arguments.uparam.subject,
			employee : getEmployee().findQ(val(arguments.uparam.key))
		}

		return rt
	}

	public struct function org()	{

		var rt = {}
		rt.employee = getEmployee().getOrgChart()

		return rt
	}

	public struct function timeline(uparam)	{

		var rt = {}
		var eid = val(arguments.uparam.key)
		rt.employee = getEmployee().findQ(eid)
		rt.timeline = getEmployeeTimeline().findByEmployee(eid)

		return rt
	}

	public struct function update(urlparam)	{

		var rt = {}
		var emp = getEmployee()

		rt.employeeid = val(arguments.urlparam.key)
		rt.employee = emp.findQ(rt.employeeid)

		rt.userid = val(rt.employee.UserId)

		rt.number = emp.getLeadingNumber(rt.employee.number, 4, true)

		rt.roles = getRoleLicense().getRoleListByHierarchy(request.user.roleids, request.user.Tenant.LicenseIds)//getRole().getRoleListByHierarchy(request.user.roleids)
		rt.user_roleids = listChangeDelims(getUserRole().getListByUser(rt.userid), '`',',')

		rt.tenant_license = getTenantLicense().getListByTenant(request.user.tenantId)
		rt.sel_license = getUserLicense().findByUser(rt.userid).columnData("LicenseId").ToList('`')

		rt.dept = getDepartment().getList()
		rt.job_title = getJobTitle().getList()
		rt.grade_level = getGradeLevel().getList()
		rt.job_level = getJobLevel().getList()
		rt.loc = getLocation().getListByCompany(request.user.companyid)
		rt.sub_loc = getStore().getList()
		rt.mgr = emp.getListBut(rt.employeeid)
		rt.sales_cat = getEmployeeSalesCategory().getList()
		rt.coy = getCompany().getList()
		rt.companyid = val(rt.employee.user_CompanyId)
		if(rt.companyid == 0)	{
			rt.companyid = request.user.companyid
		}
		if(hasLicense(application.LICENSEID.PAYROLL))	{

			rt.bank = getBank().getActiveList()
			rt.pfa = getPFA().getList()
			rt.currency = getCurrency().getList()
			var prFieldName = getPayrollFieldName()
			rt.employee_allowance = prFieldName.findByEmployeeAndType(rt.employeeid, "Allowance")
			rt.employee_deduction = prFieldName.findByEmployeeAndType(rt.employeeid, "Deduction")
			rt.company = getCompany().findQ(request.user.company.Id)

		}

		return rt
	}

	public struct function requestUpdateForApproval(urlparam)	{
		
		var rt = {}
		
		rt.employeeR = getEmployeeProfileUpdateRequest().findQ(val(arguments.urlparam.key)) 
		rt.employee = getEmployee().findQ(rt.employeeR.EmployeeId) 

		return rt
	}

	public struct function salaryRecords(p)	{

		var rt = {}

		rt.employeeId = val(arguments.p.key)
		
		return rt
	}

	this.leaveHistory = this.salaryRecords

	public void function changePassword()	{}

	public void function uploadExcelPage()	{}

	remote string function save() returnFormat="plain" 	{

		return getEmployee().saveData(form).toString()
	}

	remote void function reinstate(required numeric eid)	{

		getEmployee().reinstate(arguments.eid)

	}

	remote void function saveChangedPassword()	{

		getUser().changePassword(form)

	}

	remote void function saveExit()	{

		getEmployee().exit(form)

	}

	remote void function importExcelFile(required string session)	{

		var nupload = fileUpload(getTempDirectory(), "data", " ", "MakeUnique")
		var fn = readData(fileRead(nupload.serverdirectory & "/" & nupload.serverfile))
		var obj_sheet = New owaf3.com.util.spreadsheet.spreadsheet()

	}

	remote string function search(required string q) returnFormat="plain"	{

		return getEmployee().search(arguments.q)
	}

	remote string function approvalUpdateRequest() {

		return getEmployeeProfileUpdateRequest().approve(form)
	}

	remote void function sendMessage() {

		getEmployee().sendBDMessage(form)
	}

	remote string function importEmployee(required string key) returnFormat="json"{

		return serializeJson(getEmployee().import(arguments.key))
	}

	remote string function checkEmail(required string email, string t)	returnFormat="json"	{

		var tid =	val(arguments.t)
		var token = generateSecretKey("DESEDE","168")
		var ip = cgi.REMOTE_ADDR
		var rt = {
			"type": "error",
			"token": token, 
			"ip":ip,
			"message" : tr("You can sign in from this device for today.")
		}
		// lookup ip and determine if to proceed or not
		var l = queryExecute("
		 	SELECT COUNT(IP) Total FROM login WHERE IP = '#ip#' AND Email = :email GROUP BY IP
		", {email : arguments.email})
		if(l.total <= 9)	{
			var wc = ""
			if(tid)	{
				wc = " AND employee.TenantId = #tid#"
			}
			var emp = queryExecute("
				SELECT Email FROM employee
				INNER JOIN user ON user.UserId = employee.UserId
				WHERE user.Email = :email AND user.Email <> '' AND employee.StatusId = #application.status.ACTIVE# #wc#
				LIMIT 0,1
			", {
				email : arguments.email
			})
			if(emp.RecordCount)	{
				rt.type = "success"
				rt.message = tr("Enter your password")
			}
			else{
				rt.type = "error"
				rt.token = ""
				rt.message = "#tr('Try again')#, #9-val(l.total)# #tr('time(s) remaining')#"
				cfheader(statusCode = "404", statusText = "Server error")
			}

			// register login call 
			queryExecute("
				INSERT INTO login SET 
					Token = :token,
					IP 		= '#ip#',
					Email = :email
			", {
				token : token,
				email : arguments.email
			})
		}
		else {
			rt.token = ""
			cfheader(statusCode = "401", statusText = "Server error")
		}

		return serializeJson(rt)
	}

}