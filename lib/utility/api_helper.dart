class APIHelper {
  static String userName = "salarycreditmob";
  static String password = "S@larymobile";
  static String RAZOR_PAY_ID_TEST = "rzp_test_06MJdyqMNzv8Jq";
  static String RAZOR_PAY_ID_LIVE = "rzp_live_WNiiBDtTmhI1MW";

  //static String baseUrl = "https://mobile.salarycredits.com/v4/";latest
  static String baseUrl = "https://api.salarycredits.com/v2/";
  static String tokenUrl = "${baseUrl}token";

  static String emailLogin = "${baseUrl}api/user/PostAuthenticateUser";
  static String mobileLogin = "${baseUrl}api/user/PostAuthenticateUserMobile";
  static String sendOtp = "${baseUrl}api/user/PostOTP";
  static String verifyMobile = "${baseUrl}api/user/VerifyOTP?aid=";
  static String updateMobileNumber = "${baseUrl}api/user/UpdateMobile?aid=";
  static String getUserInfo = "${baseUrl}api/user/GetUser?aid=";
  static String getUserInfo2 = "${baseUrl}api/user/GetUser?email=";
  static String sendOTPEmail = "${baseUrl}api/user/PostEmailCode";
  static String verifyOTPEmail = "${baseUrl}api/user/VerifyEmail?aid=";
  static String searchEmployer = "${baseUrl}api/data/GetEmployerInfo?ename=";
  static String saveNominatedEmployerRequest = "${baseUrl}api/user/SaveNominatedEmployer";
  static String forgotPassword = "${baseUrl}api/user/ForgotPassword?email=";
  static String profileInfo = "${baseUrl}api/user/GetProfileInfo?aid=";
  static String uploadFile = "${baseUrl}api/file/uploadAppFile";
  static String getDashboardInfo = "${baseUrl}api/user/GetUserDashboardInfo?aid=";
  static String acceptApprovedOffer = "${baseUrl}api/loan/AcceptApprovedOffer?appId=";
  static String getAppPendingStatus = "${baseUrl}api/loan/GetApplicationPending?aid=";
  static String getLoanAvailability = "${baseUrl}api/loan/GetLoanAvailability2";
  static String applyPromoCode = "${baseUrl}api/loan/ApplyPromoCode?aid=";
  static String getPersonalDataMasterData = "${baseUrl}api/loan/GetLoanRequestFormData?aid=";
  static String getPersonalData = "${baseUrl}api/loan/GetPersonalData?aid=";
  static String getMasterData = "${baseUrl}api/data/GetMasterData";
  static String getCityStateData = "${baseUrl}api/data/GetCityStateData";
  static String getCityByPIN = "${baseUrl}api/data/GetCityByPincode?pincode=";
  static String createLoan = "${baseUrl}api/loan/CreateAppLoan";
  static String getLoanDocuments = "${baseUrl}api/file/GetDocuments?aid=";
  static String getConsentDetails = "${baseUrl}api/data/GetConsents?bankid=";
  static String sendOTPApply = "${baseUrl}api/user/PostOTPApply";
  static String applyConfirm = "${baseUrl}api/loan/ApplyConfirm?appid=";
  static String getPendingLoanDetails = "${baseUrl}api/loan/GetPendingLoanDetails?aid=";
  static String getLoanStatusHistory = "${baseUrl}api/loan/GetLoanActions?appid=";
  static String getLoanProcessPending = "${baseUrl}api/loan/GetLoanProcessPending?aid=";
  static String getLoanAgreement = "${baseUrl}api/loan/GetLoanAgreement?aid=";
  static String getLoanAgreementGenerateOTP = "${baseUrl}api/loan/GenerateOTPLoanAgreement?aid=";
  static String acceptLoanAgreement = "${baseUrl}api/loan/AgreementAcceptance";
  static String addPersonalReference = "${baseUrl}api/loan/AddPersonalReference";
  static String getLoanNACHInfo = "${baseUrl}api/loan/GetLoanNACHInfo?aid=";
  static String getApplicationDetails = "${baseUrl}api/loan/ViewApplication?appid=";
  static String getMyShortLoanList = "${baseUrl}api/loan/GetLoanShortDetails?aid=";
  static String cancelLoanRequest = "${baseUrl}api/loan/CancelLoanRequest";
  static String getActiveSalaryAccount = "${baseUrl}api/loan/GetActiveBankAccount?aid=";
  static String getFaqList = "${baseUrl}api/data/GetFaqs?catid=1&lang=";
  static String getFile = "${baseUrl}api/loan/DownloadFile?appid=";
  static String askQueryRequest = "${baseUrl}api/loan/AskQuestion";


  //Debt Consolidation
  static String getDcAvailabilityWithObligations = "${baseUrl}api/DC/GetDCAvailabilityWithObligation?aid=";
  static String getDcAvailability = "${baseUrl}api/DC/GetDCAvailability?aid=";
  static String saveDcConsolidationRequest = "${baseUrl}api/DC/SaveConsolidationRequest";
  static String calculateEMI = "${baseUrl}api/loan/EMICalculator";

  static String GET_MY_SHORT_LOAN_BY_BANK_LIST = "api/loan/GetLoanShortDetailsByBankAccount?accid=";
  static String GET_VIRTUAL_ACCOUNT_DETAILS = "api/loan/GetVirtualAccountDetails?aid=";
  static String SET_LANGUAGE_CODE = "api/user/AddLanguageCode";
  static String GET_KYC_ADDRESS = "api/Onboarding/GetApplicantKycAddress?aid=";
  static String GET_VIRTUAL_ACCOUNT_INFO = "api/Onboarding/GetVirtualAccountInfo?aid=";

  //kyc/card/YBL APIs
  static String GET_USER_KYC_INFO = "api/user/GetUserKYCInfo?aid=";
  static String GET_KYC_STATUS = "api/Onboarding/CheckUserKYC?mobile=";
  static String VERIFY_USER_CARD_AND_KYC_INFO = "api/Onboarding/VerifyUserCardAndKYCInfo";
  static String GENERATE_KYC_OTP = "api/Onboarding/ZeroTouchKYCGenerateOTP";
  static String GENERATE_DIY_KYC_OTP = "api/Onboarding/DIYKYCGenerateOTP";
  static String VERIFY_KYC_OTP = "api/Onboarding/ZeroTouchKYCVerifyOTP";

  static String GET_CARD_CVV = "api/Onboarding/GetVirtualCardCVV";
  static String GET_CARD_INFO = "api/Onboarding/GetVirtualCardInfo";
  static String SET_CARD_PIN = "api/Onboarding/SetCardPIN";
  static String ENABLE_DISABLE_CARD = "api/Onboarding/EnableDisableCard";
  static String BLOCK_CARD_PERMANENTLY = "api/Onboarding/BlockCardPermanently";
  static String ENABLE_DISABLE_PAYMENT_CHANNEL = "api/Onboarding/EnableDisablePaymentChannel";
  static String GET_CARD_CHANNEL_STATUS = "api/Onboarding/GetCardChannelStatus";
  static String GET_CARD_POLICY = "api/Onboarding/GetCardPolicy";
  static String UPDATE_CARD_POLICY = "api/Onboarding/UpdateCardPolicy";
  static String GET_ACCOUNT_STMT = "api/AccountStatement/GetAccountStatementTransaction?aid=";
  static String GET_ACCOUNT_STMT_DETAILS = "api/AccountStatement/GetAccountStatementTransactionDetails?sid=";

  //Razorpay
  static String RAZOR_CREATE_ORDER_FOR_RENT_PAYMENT = "api/Rent/CreateOrderForRentPayment";
  static String RAZOR_SAVE_RENT_PAYMENT_CAPTURE_INFO = "api/Rent/SaveRentPaymentCaptureInfo";
  static String GET_ALL_RENT_PAYMENTS_LIST = "api/Rent/ViewRentPayments?aid=";
  static String GET_ALL_RENT_BENEFICIARY_LIST = "api/Rent/ViewBeneficiary?aid=";
  static String GET_ALL_RENT_SUMMARY = "api/Rent/ViewRentSummary?aid=";
  static String GET_RENT_PAYMENT_DETAILS = "api/Rent/RentPaymentDetails?tid=";

  //Save nominated employer details

  //NOT IN USE
  static String LOAN_LIMIT = "api/loan/GetLoanLimits?aid=";
  static String GET_MY_DOCUMENTS = "api/file/GetDocumentByApplicantId?aid=";
  static String TERM_AND_CONDITION = "api/data/GetTermsUses";
  static String PRIVACY_POLICY = "api/data/GetPrivacyPolicy";
  static String CHANGE_PASSWORD = "api/user/ChangePassword";
  static String UPDATE_EMI = "api/loan/UpdateObligations";
  static String GET_OBLIGATIONS = "api/loan/GetObligations?aid=";
  static String MY_LOAN = "api/loan/GetAllLoans?aid=";
  static String APP_ACTION = " api/loan/GetActions?appid=";
  static String VIEW_APPLICATION = "api/loan/ViewApplication?appid=";
  static String REPAYMENTS_SCHEDULE = "api/loan/CheckEMIPlan?appid=";
  static String GET_DOCUMENT_LIST = "api/loan/GetDocuments?appid=";
  static String GET_LOAN_SUMMARY = "api/loan/GetLoanSummary?appid=";
  static String DELETE_FILE = "api/file/RemoveFile?fid=";
}
