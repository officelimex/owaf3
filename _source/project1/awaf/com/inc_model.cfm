<cfscript>

	public any function getRole()	{

		return model(application.model.ROLE)
	}

	public any function getStockTradeRole()	{

		return model(application.model.STOCKTRADE_ROLE)
	}

	public any function getStockTradeClientRole()	{

		return model(application.model.STOCKTRADE_CLIENT_ROLE)
	}

	public any function getRoleModule()	{

		return model(application.model.ROLE_MODULE)
	}

	public any function getComment()	{

		return model(application.model.COMMENT)
	}

	public any function getMailTemplate()	{

		return model(application.model.MAIL_TEMPLATE)
	}

	public any function getSupportTicket()	{

		return model(application.model.SUPPORT_TICKET)
	}

	public any function getSupportTicketCopy()	{

		return model(application.model.SUPPORT_TICKET_COPY)
	}

	public any function getCommunityPost()	{

		return model(application.model.COMMUNITY_POST)
	}
	
	public any function getManual()	{

		return model(application.model.MANUAL)
	}

	public any function getManualSection()	{

		return model(application.model.MANUAL_SECTION)
	}

	public any function getManualContent()	{

		return model(application.model.MANUAL_CONTENT)
	}

	public any function getManualContentRole()	{

		return model(application.model.MANUAL_CONTENT_ROLE)
	}

	public any function getManualContentTenant()	{

		return model(application.model.MANUAL_CONTENT_TENANT)
	}

	public any function getUserRole()	{

		return model(application.model.USER_ROLE)
	}

	public any function getLogin()	{

		return model(application.model.USER_LOGIN)
	}

	public any function getPermission()	{

		return model(application.model.PERMISSION)
	}

	public any function getModule()	{

		return model(application.model.MODULE)
	}

	public any function getUser()	{

		return model(application.model.USER)
	}

	public any function getTenant()	{

		return model(application.model.TENANT)
	}

	public any function getTenantUser()	{

		return model(application.model.TENANT_USER)
	}

	public any function getJobLevel()	{

		return model(application.model.JOB_LEVEL)
	}

	public any function getJobFamily()	{

		return model(application.model.JOB_FAMILY)
	}

	public any function getPayrollJobLevel()	{

		return model(application.model.PAYROLL_JOB_LEVEL)
	}

	public any function getPayrollStatus()	{

		return model(application.model.PAYROLL_TIMESHEET_STATUS)
	}

	public any function getPayrollSalesTarget()	{

		return model(application.model.PAYROLL_SALES_TARGET)
	}

	public any function getTimesheetStatus()	{

		return model(application.model.PAYROLL_TIMESHEET_STATUS)
	}

	public any function getGradeLevel()	{

		return model(application.model.GRADE_LEVEL)
	}

	public any function getCompanyLocation()	{

		return model(application.model.COMPANY_LOCATION)
	}

	public any function getCompany()	{

		return model(application.model.COMPANY)
	}

	public any function getSalesContact()	{

		return model(application.model.SALES_CONTACT)
	}

	public any function getSalesContactActivity()	{

		return model(application.model.SALES_CONTACT_ACTIVITY)
	}

	public any function getSalesCompany()	{

		return model(application.model.SALES_COMPANY)
	}

	public any function getSalesCustomer()	{

		return model(application.model.SALES_CUSTOMER)
	}

	public any function getSalesCustomerPoint()	{

		return model(application.model.SALES_CUSTOMER_POINT)
	}

	public any function getDepartment()	{

		return model(application.model.DEPARTMENT)
	}

	public any function getUnit()	{

		return model(application.model.UNIT)
	}

	public any function getDailyActivity()	{

		return model(application.model.DAILY_ACTIVITY)
	}

	public any function getAppraisalDevPlan()	{

		return model(application.model.APPRAISAL_DEV_PLAN)
	}

	public any function getAppraisal()	{

		return model(application.model.APPRAISAL)
	}

	public any function getManagerAppraisal()	{

		return model(application.model.MANAGER_APPRAISAL)
	}

	public any function getManagerAppraisalCompetency()	{

		return model(application.model.MANAGER_APPRAISAL_COMPETENCY)
	}

	public any function getAppraisalPeriod()	{

		return model(application.model.APPRAISAL_PERIOD)
	}

	public any function getPeerSelection()	{

		return model(application.model.PEER_SELECTION)
	}

	public any function getPeerSelectionOption()	{

		return model(application.model.PEER_SELECTION_OPTION)
	}

	public any function getPeerAppraisal()	{

		return model(application.model.PEER_APPRAISAL)
	}

	public any function getPeerAppraisalCompetency()	{

		return model(application.model.PEER_APPRAISAL_COMPETENCY)
	}
	
	public any function getPotentialAssessment()	{

		return model(application.model.POTENTIAL_ASSESSMENT)
	}

	public any function getPotentialAssessmentItem()	{

		return model(application.model.POTENTIAL_ASSESSMENT_ITEM)
	}

	public any function getPotentialAssessmentQuestion()	{

		return model(application.model.POTENTIAL_ASSESSMENT_QUESTION)
	}

	public any function getAppraisalRating()	{

		return model(application.model.APPRAISAL_RATING)
	}

	public any function getManagerAppraisal()	{

		return model(application.model.MANAGER_APPRAISAL)
	}

	public any function getManagerAppraisalPF()	{

		return model(application.model.MANAGER_APPRAISAL_PF)
	}

	public any function getAppraisalObjective()	{

		return model(application.model.APPRAISAL_OBJECTIVE)
	}

	public any function getAppraisalPF()	{

		return model(application.model.APPRAISAL_PF)
	}

	public any function getAppraisalDevelopmentPlan()	{

		return model(application.model.APPRAISAL_DEVELOPMENT_PLAN)
	}

	public any function getPFType()	{

		return model(application.model.PF_TYPE)
	}

	public any function getPF()	{

		return model(application.model.PF)
	}

	public any function getAppraisalObjectiveGroup()	{

		return model(application.model.APPRAISAL_OBJECTIVE_GROUP)
	}

	public any function getAppraisalObjectiveTarget()	{

		return model(application.model.APPRAISAL_OBJECTIVE_TARGET)
	}

	public any function getRatingTemplate()	{

		return model(application.model.RATING_TEMPLATE)
	}

	public any function getGlobalObjective()	{

		return model(application.model.GLOBAL_OBJECTIVE)
	}

	public any function getGlobalObjectiveTarget()	{

		return model(application.model.GLOBAL_OBJECTIVE_TARGET)
	}
	
	public any function getApplicant()	{

		return model(application.model.APPLICANT)
	}

	public any function getApplicantSkill()	{

		return model(application.model.APPLICANT_SKILL)
	}

	public any function getApplicantTraining()	{

		return model(application.model.APPLICANT_TRAINING)
	}

	public any function getSkill()	{

		return model(application.model.SKILL)
	}

	public any function getJobTitleSkill()	{

		return model(application.model.JOB_TITLE_SKILL)
	}

	public any function getJobLevelSkill()	{

		return model(application.model.JOB_LEVEL_SKILL)
	}

	public any function getSetting()	{

		return model(application.model.SETTING)
	}

	public any function getVacancy()	{

		return model(application.model.VACANCY)
	}

	public any function getVacancyType()	{

		return model(application.model.VACANCY_TYPE)
	}

	public any function getAppliedApplicant()	{

		return model(application.model.APPLIED_APPLICANT)
	}

	public any function getVacancyList()	{

		return getVacancy().getList()
	}
	
	public any function getJobTitleDegreeLevel()	{

		return model(application.model.JOB_TITLE_DEGREE_LEVEL)
	}

	public any function getVacancyPanel()	{

		return model(application.model.VACANCY_PANEL)
	}

	public any function getApplicantWorkExperience()	{

		return model(application.model.APPLICANT_WORK_EXPERIENCE)
	}

	public any function getApplicantEducation()	{

		return model(application.model.APPLICANT_EDUCATION)
	}

	public any function getDegreeLevel()	{

		return model(application.model.DEGREE_LEVEL)
	}

	public any function getJobTitle()	{

		return model(application.model.JOB_TITLE)
	}

	public any function getOpeningBalance()	{

		return model(application.model.ACCOUNTING_OPENING_BALANCE)
	}

	public any function getJobFunction()	{

		return model(application.model.JOB_FUNCTION)
	}

	public any function getGradeLevel()	{

		return model(application.model.GRADE_LEVEL)
	}

	public any function getJobTitleDepartment()	{

		return model(application.model.JOB_TITLE_DEPARTMENT)
	}

	public any function getEmployee()	{

		return model(application.model.EMPLOYEE)
	}

	public any function getEmployeeOnboarding()	{

		return model(application.model.EMPLOYEE_ONBOARDING)
	}

	public any function getEmployeeCreateRequest()	{

		return model(application.model.EMPLOYEE_CREATE_REQUEST)
	}

	public any function getEmployeeExitRequest()	{

		return model(application.model.EMPLOYEE_EXIT_REQUEST)
	}

	public any function getEmployeeTrainingAttended()	{

		return model(application.model.EMPLOYEE_TRAINING_ATTENDED)
	}

	public any function getEmployeeSalesCategory()	{

		return model(application.model.EMPLOYEE_SALES_CATEGORY)
	}

	public any function getEmployeeOffboarding()	{

		return model(application.model.EMPLOYEE_OFFBOARDING)
	}

	public any function getSurveyQuestion()	{

		return model(application.model.SURVEY_QUESTION)
	}

	public any function getSurveyAnswer()	{

		return model(application.model.SURVEY_ANSWER)
	}

	public any function getEmployeeProfileUpdateRequest()	{

		return model(application.model.EMPLOYEE_PROFILE_UPDATE_REQUEST)
	}

	public any function getEmployeeTimeline()	{

		return model(application.model.EMPLOYEE_TIMELINE)
	}

	public any function getEmployeeTimeline()	{

		return model(application.model.EMPLOYEE_TIMELINE)
	}

	public any function getBeneficiary()	{

		return model(application.model.EMPLOYEE_BENEFICIARY)
	}

	public any function getEmployeeJobHistory()	{

		return model(application.model.EMPLOYEE_JOB_HISTORY)
	}

	public any function getEmployeeTraining()	{

		return model(application.model.EMPLOYEE_TRAINING)
	}

	public any function getEmployeeTrainingTalent()	{

		return model(application.model.EMPLOYEE_TRAINING_TALENT)
	}

	public any function getEmployeeTrainingFeedBack()	{

		return model(application.model.EMPLOYEE_TRAINING_FEEDBACK)
	}

	public any function getTrainingFeedBackQuestion()	{

		return model(application.model.TRAINING_FEEDBACK_QUESTION)
	}

	public any function getTrainingProvider()	{

		return model(application.model.TRAINING_PROVIDER)
	}

	public any function getUserLicense()	{

		return model(application.model.USER_LICENSE)
	}

	public any function getRoleLicense()	{

		return model(application.model.ROLE_LICENSE)
	}

	public any function getTenantLicense()	{

		return model(application.model.TENANT_LICENSE)
	}

	public any function getLicense()	{

		return model(application.model.LICENSE)
	}

	public any function getLocation()	{

		return model(application.model.LOCATION)
	}

	public any function getFixEngineAccount()	{

		return model(application.model.FIXENGINE_ACCOUNT)
	}

	public any function getCompetency()	{

		return model(application.model.COMPETENCY)
	}

	public any function getJobLevelCompetency()	{

		return model(application.model.JOB_LEVEL_COMPETENCY)
	}

	public any function getJobTitleCompetency()	{

		return model(application.model.JOB_TITLE_COMPETENCY)
	}

	public any function getEmployeeRequest()	{

		return model(application.model.EMPLOYEE_REQUEST)
	}

	public any function getEmployeeRequestStage()	{

		return model(application.model.EMPLOYEE_REQUEST_STAGE)
	}

	public any function getAnnouncement()	{

		return model(application.model.ANNOUNCEMENT)
	}

	public any function getAnnouncementPermission()	{

		return model(application.model.ANNOUNCEMENT_PERMISSION)
	}

	public any function getMemo()	{

		return model(application.model.MEMO)
	}

	public any function getMemoTimeline()	{

		return model(application.model.MEMO_TIMELINE)
	}

	public any function getMemoSignOff()	{

		return model(application.model.MEMO_SIGNOFF)
	}

	public any function getMemoType()	{

		return model(application.model.MEMO_TYPE)
	}

	public any function getMemoTypeSignOff()	{

		return model(application.model.MEMO_TYPE_SIGNOFF)
	}

	public any function getAppraisalCompetency()	{

		return model(application.model.APPRAISAL_COMPETENCY)
	}

	public any function getAppraisalFlow()	{

		return model(application.model.APPRAISAL_FLOW)
	}

	public any function getPage()	{

		return model(application.model.PAGE)
	}

	public any function getJobCompetency()	{

		return model(application.model.JOB_COMPETENCY)
	}

	public any function getCompetencyProficiencyLevel()	{

		return model(application.model.COMPETENCY_PROFICIENCY_LEVEL)
	}

	public any function getAppraisalObjective()	{

		return model(application.model.APPRAISAL_OBJECTIVE)
	}

	public any function getEmployeePromotion()	{

		return model(application.model.EMPLOYEE_PROMOTION)
	}

	public any function getPanelInterview()	{

		return model(application.model.PANEL_INTERVIEW)
	}

	public any function getExecutiveInterview()	{

		return model(application.model.EXECUTIVE_INTERVIEW)
	}

	public any function getExecutiveInterviewData()	{

		return model(application.model.EXECUTIVE_INTERVIEW_DATA)
	}

	public any function getTechnicalInterview()	{

		return model(application.model.TECHNICAL_INTERVIEW)
	}

	public any function getHRInterview()	{

		return model(application.model.HR_INTERVIEW)
	}

	public any function getPanelInterviewData()	{

		return model(application.model.PANEL_INTERVIEW_DATA)
	}

	public any function getHRInterviewCriteria()	{

		return model(application.model.HR_INTERVIEW_CRITERIA)
	}

	public any function getPanelInterviewCriteria()	{

		return model(application.model.PANEL_INTERVIEW_CRITERIA)
	}

	public any function getChatInterviewCriteria()	{

		return model(application.model.CHAT_INTERVIEW_CRITERIA)
	}

	public any function getInterviewQuestion()	{

		return model(application.model.INTERVIEW_QUESTION)
	}

	public any function getChatInterview()	{

		return model(application.model.CHAT_INTERVIEW)
	}

	public any function getApplicantCertification()	{

		return model(application.model.APPLICANT_CERTIFICATION)
	}

	public any function getApplicantLanguage()	{

		return model(application.model.APPLICANT_LANGUAGE)
	}

	public any function getSubObjective()	{

		return model(application.model.APPRAISAL_SUB_OBJECTIVE)
	}

	public any function getChatInterviewer()	{

		return model(application.model.CHAT_INTERVIEWER)
	}

	public any function getTechnicalInterviewer()	{

		return model(application.model.TECHNICAL_INTERVIEWER)
	}

	public any function getPanelInterviewer()	{

		return model(application.model.PANEL_INTERVIEWER)
	}

	public any function getState()	{

		return model(application.model.STATE)
	}

	public any function getStatus()	{

		return model(application.model.STATUS)
	}

	public any function getCustomField()	{

		return model(application.model.CUSTOM_FIELD_DATA)
	}
	
	public any function getWF()	{

		return model(application.model.WF)
	}

	public any function getWFApproval()	{

		return model(application.model.WF_APPROVAL)
	}

	public any function getLGA()	{

		return model(application.model.LGA)
	}

	public any function getEmployeeSuccessionPlanCompetency()	{

		return model(application.model.EMPLOYEE_SUCCESSION_PLAN_COMPETENCY)
	}

	public any function getNotification()	{

		return model(application.model.NOTIFICATION)
	}

	public any function getGradeCompetency()	{

		return model(application.model.GRADE_COMPETENCY)
	}

	public any function getCompetencyCategory()	{

		return model(application.model.COMPETENCY_CATEGORY)
	}

	public any function getCompetencyGroup()	{

		return model(application.model.COMPETENCY_GROUP)
	}

	public any function getTalentProfile()	{

		return model(application.model.TALENT_PROFILE)
	}

	public any function getSchool()	{

		return model(application.model.SCHOOL)
	}

	public any function getApplicantLanguage()	{

		return model(application.model.APPLICANT_LANGUAGE)
	}

	public any function getApplicantDepartmentInterest()	{

		return model(application.model.APPLICANT_DEPARTMENT_INTEREST)
	}

	public any function getCustomAppraisalObjectiveGroup()	{

		return model(application.model.CUSTOM_APPRAISAL_OBJECTIVE_GROUP)
	}

	public any function getLeaveType()	{

		return model(application.model.LEAVE_TYPE)
	}

	public any function getLeaveTypeJobTitle()	{

		return model(application.model.LEAVE_TYPE_JOB_TITLE)
	}

	public any function getLeaveTypeJobLevel()	{

		return model(application.model.LEAVE_TYPE_JOB_LEVEL)
	}

	public any function getImageURL()	{

		return model(application.model.IMAGE_URL)
	}

	public any function getLeavePlan()	{

		return model(application.model.LEAVE_PLAN)
	}

	public any function getLeavePlanItem()	{

		return model(application.model.LEAVE_PLAN_ITEM)
	}

	public any function getHoliday()	{

		return model(application.model.LEAVE_HOLIDAY)
	}

	public any function getHolidayLocation()	{

		return model(application.model.HOLIDAY_LOCATION)
	}

	public any function getFile()   {

		return model(application.model.FILE)
	}

	public any function getSurveyQuestion()   {

		return model(application.model.SURVEY_QUESTION)
	}

	public any function getAppraisalOtherPF()	{

		return model(application.model.APPRAISAL_OTHER_PF)
	}

	public any function getOtherPF()	{

		return model(application.model.OTHER_PF)
	}

	public any function getCompanyCalendar()	{

		return model(application.model.COMPANY_CALENDAR)
	}

	public any function getLeaveBalance()	{

		return model(application.model.LEAVE_BALANCE)
	}

	public any function getLGA()	{

		return model(application.model.LGA)
	}

	public any function getState()	{

		return model(application.model.STATE)
	}

	public any function getGradeJobLevel()	{

		return model(application.model.GRADE_JOB_LEVEL)
	}

	public any function getEmployeeCompetency()	{

		return model(application.model.EMPLOYEE_COMPETENCY)
	}

	public any function getCareerProfileRole()	{

		return model(application.model.CAREER_PROFILE_ROLE)
	}

	public any function getEmployeeBirthday()	{

		return model(application.model.EMPLOYEE_BIRTHDAY)
	}

	public any function getEmployeeBirthdayMessage()	{

		return model(application.model.EMPLOYEE_BIRTHDAY_MESSAGE)
	}

	public any function getEmployeeEducation()	{

		return model(application.model.EMPLOYEE_EDUCATION)
	}

	public any function getEmployeeCertification()	{

		return model(application.model.EMPLOYEE_CERTIFICATION)
	}

	public any function getJobHistory()	{

		return model(application.model.JOB_HISTORY)
	}

	public any function getAppraisalPenalty()	{

		return model(application.model.APPRAISAL_PENALTY)
	}

	public any function getEmployeeBeneficiary()	{

		return model(application.model.EMPLOYEE_BENEFICIARY)
	}

	public any function getEmployeeDocument()	{

		return model(application.model.EMPLOYEE_DOCUMENT)
	}

	public any function getLoanRequest()	{

		return model(application.model.LOAN_REQUEST)
	}

	public any function getLoanPayment()	{

		return model(application.model.LOAN_PAYMENT)
	}

	public any function getLeave()	{

		return model(application.model.Leave)
	}

	public any function getLeavType()	{

		return model(application.model.Leave_TYPE)
	}

	public any function getLeaveBalance()	{

		return model(application.model.Leave_Balance)
	}

	public any function getPFA()	{

		return model(application.model.PFA)
	}

	public any function getPayrollFieldData()	{

		return model(application.model.PAYROLL_FIELD_DATA)
	}

	public any function getPayrollData()	{

		return model(application.model.PAYROLL_DATA)
	}

	public any function getPayrollFieldName()	{

		return model(application.model.PAYROLL_FIELD_NAME)
	}

	public any function getExtendedAppraisalPeriod()	{

		return model(application.model.EXTEND_APPRAISAL_PERIOD)
	}

	public any function getPayroll()	{

		return model(application.model.PAYROLL)
	}

	public any function getPayrollTimesheet()	{

		return model(application.model.PAYROLL_TIMESHEET)
	}

	public any function getPayrollTimesheetStandIn()	{

		return model(application.model.PAYROLL_TIMESHEET_STANDIN)
	}

	public any function getPayrollStandIn()	{

		return model(application.model.PAYROLL_STANDIN)
	}

	public any function getPayrollOvertime()	{

		return model(application.model.PAYROLL_OVERTIME)
	}

	public any function getPayrollMonthlyOvertime()	{

		return model(application.model.PAYROLL_MONTHLY_OVERTIME)
	}

	public any function getPayrollOvertimeItem()	{

		return model(application.model.PAYROLL_OVERTIME_ITEM)
	}

	public any function getPayrollCompany()	{

		return model(application.model.PAYROLL_COMPANY)
	}

	public any function getPayrollCompanyLocation()	{

		return model(application.model.PAYROLL_COMPANY_LOCATION)
	}

	public any function getBioDataUpdateRequest()	{

		return model(application.model.BIODATA_UPDATE_REQUEST)
	}

	public any function getPolicy()	{

		return model(application.model.POLICY)
	}

	public any function getPolicyRead()	{

		return model(application.model.POLICY_READ)
	}

	public any function getPolicyContent()	{

		return model(application.model.POLICY_CONTENT)
	}

	public any function getPolicySection()	{

		return model(application.model.POLICY_SECTION)
	}

	public any function getTempUser()	{

		return model(application.model.TEMP_USER)
	}


	public any function getClient()	{

		return model(application.model.CLIENT_CLIENT)
	}

	public any function getGL()	{

		return model(application.model.ACCOUNTING_GL)
	}

	public any function getOpeningBalance()	{

		return model(application.model.ACCOUNTING_OPENING_BALANCE)
	}

	public any function getVoucher()	{

		return model(application.model.VOUCHER)
	}

	public any function getNSETrade()	{

		return model(application.model.NSE_TRADE)
	}

	public any function getNSETradeNews()	{

		return model(application.model.NSE_TRADE_NEWS)
	}

	public any function getStock()	{

		return model(application.model.STOCK)
	}

	public any function getAllotment()	{

		return model(application.model.TRADE_ALLOTMENT)
	}

	public any function getTradeRate()	{

		return model(application.model.NSE_TRADE_RATE)
	}

	public any function getTradeOrder()	{

		return model(application.model.TRADE_ORDER)
	}

	public any function getChartOfAccount()	{

		return model(application.model.CHART_OF_ACCOUNT)
	}

	public any function getClientAccount()	{

		return model(application.model.CLIENT_ACCOUNT)
	}

	public any function getClientCSCS()	{

		return model(application.model.CLIENT_CSCS)
	}

	public any function getClientTransaction()	{

		return model(application.model.CLIENT_TRANSACTION)
	}

	public any function getAccountType()	{

		return model(application.model.ACCOUNT_TYPE)
	}

	public any function getBank()	{

		return model(application.model.BANK)
	}

	public any function getCurrency()	{

		return model(application.model.CURRENCY)
	}

	public any function getClientPortfolio()	{

		return model(application.model.CLIENT_PORTFOLIO)
	}

	public any function getSubscriber()	{

		return model(application.model.SUBSCRIBER)
	}

	public any function getUnSubscriberNewsletter()	{

		return model(application.model.UNSUBSCRIBER_NEWSLETTER)
	}

	public any function getSubscriberNewsletter()	{

		return model(application.model.SUBSCRIBER_NEWSLETTER)
	}

	public any function getMailSentLimit()	{

		return model(application.model.NEWSLETTER_MAIL_SENT_LIMIT)
	}

	public any function getSubscriberGroup()	{

		return model(application.model.SUBSCRIBER_GROUP)
	}

	public any function getSubscriberGroupList()	{

		return model(application.model.SUBSCRIBER_GROUP_LIST)
	}

	public any function getNewsletter()	{

		return model(application.model.NEWSLETTER)
	}

	public any function getNewsletterGroupList()	{

		return model(application.model.NEWSLETTER_GROUP_LIST)
	}

	public any function getBlog()	{

		return model(application.model.BLOG)
	}

	public any function getBlogPost()	{

		return model(application.model.BLOG_POST)
	}

	public any function getBlogPostCategory()	{

		return model(application.model.BLOG_POST_CATEGORY)
	}

	public any function getItem()	{

		return model(application.model.ITEM)
	}

	public any function getItemOption()	{

		return model(application.model.ITEM_OPTION)
	}

	public any function getItemOptionValue()	{

		return model(application.model.ITEM_OPTION_VALUE)
	}

	public any function getItemInStore()	{

		return model(application.model.ITEM_IN_STORE)
	}

	public any function getStore()	{

		return model(application.model.STORE)
	}
	
	public any function getMeasurement()	{

		return model(application.model.MEASUREMENT)
	}
	
	public any function getItemCategory()	{

		return model(application.model.ITEM_CATEGORY)
	}
	
	public any function getSalesOrder()	{

		return model(application.model.SALES_ORDER)
	}

	public any function getForm()	{

		return model(application.model.FORM)
	}

	public any function getFormSection()	{

		return model(application.model.FORM_SECTION)
	}

	public any function getFormUser()	{

		return model(application.model.FORM_USER)
	}

	public any function getFormField()	{

		return model(application.model.FORM_FIELD)
	}

	public any function getFormFieldOption()	{

		return model(application.model.FORM_FIELD_OPTION)
	}

	public any function getFormFieldDate()	{

		return model(application.model.FORM_FIELD_DATA)
	}

	public any function getFormFieldOption()	{

		return model(application.model.FORM_FIELD_OPTION)
	}

	public any function getFormGridRow()	{

		return model(application.model.FORM_GRID_ROW)
	}

	public any function getFormGridRowDate()	{

		return model(application.model.FORM_GRID_ROW_DATA)
	}
	
	public any function getFormGridColumn()	{

		return model(application.model.FORM_GRID_COLUMN)
	}

	public any function getSalesBanked()	{

		return model(application.model.SALES_BANKED)
	}

	public any function getSalesFront()	{

		return model(application.model.SALES_FRONT)
	}

	public any function getSalesFrontOrder()	{

		return model(application.model.SALES_FRONT_ORDER)
	}

	public any function getSalesFrontOrderItem()	{

		return model(application.model.SALES_FRONT_ORDER_ITEM)
	}

	public any function getSalesTarget()	{

		return model(application.model.SALES_TARGET)
	}

	public any function getCustomer()	{

		return model(application.model.SALES_CUSTOMER)
	}
	
	public any function getSalesOrderItem()	{

		return model(application.model.SALES_ORDER_ITEM)
	}

	public any function getSalesOrderPaidHistory()	{

		return model(application.model.SALES_ORDER_PAID_HISTORY)
	}	
	
	public any function getPO()	{

		return model(application.model.PO)
	}

	public any function getPOPayment()	{

		return model(application.model.PO_PAYMENT)
	}
	
	public any function getPOItem()	{

		return model(application.model.PO_ITEM)
	}	

	public any function getPOItemReceived()	{

		return model(application.model.PO_ITEM_RECEIVED)
	}
	
	public any function getItemMovement()	{

		return model(application.model.ITEM_MOVEMENT)
	}

	public any function getItemRequest()	{

		return model(application.model.ITEM_REQUEST)
	}

	public any function getItemTransfer()	{

		return model(application.model.ITEM_TRANSFER)
	}

	public any function getItemTransferItem()	{

		return model(application.model.ITEM_TRANSFER_ITEM)
	}
	
	public any function getItemRequestItem()	{

		return model(application.model.ITEM_REQUEST_ITEM)
	}	

	public any function getExpense()	{

		return model(application.model.EXPENSE)
	}

	public any function getExpenseCategory()	{

		return model(application.model.EXPENSE_CATEGORY)
	}

	public any function getExpenseItem()	{

		return model(application.model.EXPENSE_ITEM)
	}
	
	public any function getItemInStoreAdjustmentLog()	{

		return model(application.model.ITEM_IN_STORE_ADJUSTMENT_LOG)
	}

	public any function getVendor()	{

		return model(application.model.VENDOR)
	}

	public any function getAsset()	{

		return model(application.model.ASSET)
	}

	public any function getAssetExpire()	{

		return model(application.model.ASSET_EXPIRE)
	}

	public any function getAssetCategory()	{

		return model(application.model.ASSET_CATEGORY)
	}

	public any function getAssetInLocation()	{

		return model(application.model.ASSET_IN_LOCATION)
	}

	public any function getAssetLocation()	{

		return model(application.model.ASSET_LOCATION)
	}

	public any function getWO()	{

		return model(application.model.WORK_ORDER)
	}

	public any function getWOItem()	{

		return model(application.model.WORK_ORDER_ITEM)
	}

	public any function getAssetWO()	{

		return model(application.model.ASSET_WORK_ORDER)
	}

	public any function getWOLabor()	{

		return model(application.model.WORK_ORDER_LABOR)
	}

	public any function getWOVendor()	{

		return model(application.model.WORK_ORDER_VENDOR)
	}

	public any function model(required string modl)	{

		var arg = getModelDefaultParam(arguments.modl)

		return createObject("component","officelimex.models." & arg.model_name).init(table_name=arg.table_name)
	}

</cfscript>