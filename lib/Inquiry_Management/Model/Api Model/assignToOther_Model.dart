class InquiryFollowup {
  final String id;
  final String userId;
  final String ownerId;
  final String assignId;
  final String headStatus;
  final String head;
  final String inquiryStages;
  final String fullName;
  final String address;
  final String dob;
  final String anniDate;
  final String mobileno;
  final String altmobileno;
  final String email;
  final String houseno;
  final String society;
  final String area;
  final String city;
  final String state;
  final String country;
  final String propertyType;
  final String propertySubType;
  final String interestedProduct;
  final String interestedSiteName;
  final String budget;
  final String purposeBuy;
  final String approxBuy;
  final String interestedArea;
  final String interestedAreaName;
  final String inquiryType;
  final String inquirySourceType;
  final String appointmentDate;
  final String nextFollowUp;
  final String feedback;
  final String unitNo;
  final String unitSize;
  final String paymentRef;
  final String cashPay;
  final String dpAmount;
  final String loanAmount;
  final String remark;
  final String inquiryDescription;
  final String createdAt;
  final String inquiryCnr;
  final String broker;
  final String inquiryCloseReason;
  final String isSiteVisit;
  final String isVisit;
  final String isCountVisit;
  final String visitDate;
  final String revisitDate;
  final String visitedSite;
  final String bookingDate;
  final String isAppointment;
  final String userType;
  final String adId;
  final String adsetId;
  final String campaignId;
  final String campaignName;
  final String formId;
  final String formName;
  final String altCountryCode;
  final String countryCode;
  final String leadId;
  final String botContactNo;
  final String botPlatformId;
  final String botAssetsId;
  final String isRequest;
  final String isBot;
  final String? pageId; // Nullable since it can be null
  final String? senderId; // Nullable since it can be null
  final String isDelete;
  final String? deletedBy; // Nullable since it can be null
  final String? deletedDate; // Nullable since it can be null
  final String propertyConfiguration;
  final String lastCnrDate;
  final String daySkip;
  final String hourSkip;
  final String ssmComment;
  final String ivrQueueStatus;
  final String inquiryStatus;

  InquiryFollowup({
    required this.id,
    required this.userId,
    required this.ownerId,
    required this.assignId,
    required this.headStatus,
    required this.head,
    required this.inquiryStages,
    required this.fullName,
    required this.address,
    required this.dob,
    required this.anniDate,
    required this.mobileno,
    required this.altmobileno,
    required this.email,
    required this.houseno,
    required this.society,
    required this.area,
    required this.city,
    required this.state,
    required this.country,
    required this.propertyType,
    required this.propertySubType,
    required this.interestedProduct,
    required this.interestedSiteName,
    required this.budget,
    required this.purposeBuy,
    required this.approxBuy,
    required this.interestedArea,
    required this.interestedAreaName,
    required this.inquiryType,
    required this.inquirySourceType,
    required this.appointmentDate,
    required this.nextFollowUp,
    required this.feedback,
    required this.unitNo,
    required this.unitSize,
    required this.paymentRef,
    required this.cashPay,
    required this.dpAmount,
    required this.loanAmount,
    required this.remark,
    required this.inquiryDescription,
    required this.createdAt,
    required this.inquiryCnr,
    required this.broker,
    required this.inquiryCloseReason,
    required this.isSiteVisit,
    required this.isVisit,
    required this.isCountVisit,
    required this.visitDate,
    required this.revisitDate,
    required this.visitedSite,
    required this.bookingDate,
    required this.isAppointment,
    required this.userType,
    required this.adId,
    required this.adsetId,
    required this.campaignId,
    required this.campaignName,
    required this.formId,
    required this.formName,
    required this.altCountryCode,
    required this.countryCode,
    required this.leadId,
    required this.botContactNo,
    required this.botPlatformId,
    required this.botAssetsId,
    required this.isRequest,
    required this.isBot,
    this.pageId,
    this.senderId,
    required this.isDelete,
    this.deletedBy,
    this.deletedDate,
    required this.propertyConfiguration,
    required this.lastCnrDate,
    required this.daySkip,
    required this.hourSkip,
    required this.ssmComment,
    required this.ivrQueueStatus,
    required this.inquiryStatus,
  });

  factory InquiryFollowup.fromJson(Map<String, dynamic> json) {
    return InquiryFollowup(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      ownerId: json['owner_id'] ?? '',
      assignId: json['assign_id'] ?? '',
      headStatus: json['head_status'] ?? '',
      head: json['head'] ?? '',
      inquiryStages: json['inquiry_stages'] ?? '',
      fullName: json['full_name'] ?? 'N/A',
      address: json['address'] ?? '',
      dob: json['dob'] ?? '',
      anniDate: json['anni_date'] ?? '',
      mobileno: json['mobileno'] ?? 'N/A',
      altmobileno: json['altmobileno'] ?? '',
      email: json['email'] ?? '',
      houseno: json['houseno'] ?? '',
      society: json['society'] ?? '',
      area: json['area'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      propertyType: json['property_type'] ?? '',
      propertySubType: json['property_sub_type'] ?? '',
      interestedProduct: json['intrested_product'] ?? '',
      interestedSiteName: json['intersted_site_name'] ?? '',
      budget: json['budget'] ?? '',
      purposeBuy: json['purpose_buy'] ?? '',
      approxBuy: json['approx_buy'] ?? '',
      interestedArea: json['intrested_area'] ?? '',
      interestedAreaName: json['intrested_area_name'] ?? '',
      inquiryType: json['inquiry_type'] ?? '',
      inquirySourceType: json['inquiry_source_type'] ?? '',
      appointmentDate: json['appointment_date'] ?? '',
      nextFollowUp: json['nxt_follow_up'] ?? '',
      feedback: json['feedback'] ?? '',
      unitNo: json['unit_no'] ?? '',
      unitSize: json['unit_size'] ?? '',
      paymentRef: json['paymentref'] ?? '',
      cashPay: json['cash_pay'] ?? '',
      dpAmount: json['dp_amount'] ?? '',
      loanAmount: json['loan_amount'] ?? '',
      remark: json['remark'] ?? 'N/A',
      inquiryDescription: json['inquiry_description'] ?? '',
      createdAt: json['created_at'] ?? '',
      inquiryCnr: json['inquiry_cnr'] ?? '',
      broker: json['broker'] ?? '',
      inquiryCloseReason: json['inquiry_close_reason'] ?? '',
      isSiteVisit: json['isSiteVisit'] ?? '',
      isVisit: json['isvisit'] ?? '',
      isCountVisit: json['iscountvisit'] ?? '',
      visitDate: json['visit_date'] ?? '',
      revisitDate: json['revisit_date'] ?? '',
      visitedSite: json['visitedsite'] ?? '',
      bookingDate: json['booking_date'] ?? '',
      isAppointment: json['isAppoitement'] ?? '',
      userType: json['user_type'] ?? '',
      adId: json['ad_id'] ?? '',
      adsetId: json['adset_id'] ?? '',
      campaignId: json['campaign_id'] ?? '',
      campaignName: json['campaign_name'] ?? '',
      formId: json['form_id'] ?? '',
      formName: json['form_name'] ?? '',
      altCountryCode: json['alt_country_code'] ?? '',
      countryCode: json['country_code'] ?? '',
      leadId: json['lead_id'] ?? '',
      botContactNo: json['bot_contactno'] ?? '',
      botPlatformId: json['bot_platform_id'] ?? '',
      botAssetsId: json['bot_assets_id'] ?? '',
      isRequest: json['is_request'] ?? '',
      isBot: json['is_bot'] ?? '',
      pageId: json['page_id'],
      senderId: json['sender_id'],
      isDelete: json['is_delete'] ?? '',
      deletedBy: json['deleted_by'],
      deletedDate: json['deleted_date'],
      propertyConfiguration: json['PropertyConfiguration'] ?? '',
      lastCnrDate: json['last_cnr_date'] ?? '',
      daySkip: json['day_skip'] ?? '0',
      hourSkip: json['hour_skip'] ?? '0',
      ssmComment: json['ssm_comment'] ?? '',
      ivrQueueStatus: json['ivr_queue_status'] ?? '',
      inquiryStatus: json['inquiry_status'] ?? '',
    );
  }
}
class InquiryStatusFollowup {
  final String inquiryStatus;
  final String totalSum;
  final String fresh;
  final String contacted;
  final String appointment;
  final String visited;
  final String negotiations;
  final String feedBack;
  final String reAppointment;
  final String reVisited;
  final String converted;

  InquiryStatusFollowup({
    required this.inquiryStatus,
    required this.totalSum,
    required this.fresh,
    required this.contacted,
    required this.appointment,
    required this.visited,
    required this.negotiations,
    required this.feedBack,
    required this.reAppointment,
    required this.reVisited,
    required this.converted,
  });

  factory InquiryStatusFollowup.fromJson(Map<String, dynamic> json) {
    return InquiryStatusFollowup(
      inquiryStatus: json['inquiry_status'] ?? '',
      totalSum: json['Total_Sum'] ?? '0',
      fresh: json['Fresh'] ?? '0',
      contacted: json['Contacted'] ?? '0',
      appointment: json['Appointment'] ?? '0',
      visited: json['Visited'] ?? '0',
      negotiations: json['Negotiations'] ?? '0',
      feedBack: json['Feed_Back'] ?? '0',
      reAppointment: json['Re_Appointment'] ?? '0',
      reVisited: json['Re_Visited'] ?? '0',
      converted: json['Converted'] ?? '0',
    );
  }
}
class PaginatedInquiriesFollowup {
  final int? statusDataAllow;
  final int? status;
  final String? message;
  final int? response;
  final int? currentPage;
  final int? totalPages;
  final int? totalRecords;
  final List<InquiryFollowup> inquiries; // Updated to InquiryFollowup
  final List<InquiryStatusFollowup> inquiryStatus;

  PaginatedInquiriesFollowup({
    required this.statusDataAllow,
    required this.status,
    required this.message,
    required this.response,
    required this.currentPage,
    required this.totalPages,
    required this.totalRecords,
    required this.inquiries,
    required this.inquiryStatus,
  });

  factory PaginatedInquiriesFollowup.fromJson(Map<String, dynamic> json) {
    var inquiryList = json['inquiries'] as List;
    List<InquiryFollowup> inquiriesList =
    inquiryList.map((i) => InquiryFollowup.fromJson(i)).toList();

    var statusList = json['inquiry_status'] as List? ?? [];
    List<InquiryStatusFollowup> inquiryStatusList =
    statusList.map((s) => InquiryStatusFollowup.fromJson(s)).toList();

    return PaginatedInquiriesFollowup(
      statusDataAllow: json['stutus_data_allow'] ?? 0,
      status: json['stutus'] ?? 0,
      message: json['Message'] ?? '',
      response: json['response'] ?? 0,
      currentPage: int.tryParse(json['pagination']['current_page'] ?? '1') ?? 1,
      totalPages: json['pagination']['total_pages'] ?? 1,
      totalRecords: json['pagination']['total_records'] ?? 0,
      inquiries: inquiriesList,
      inquiryStatus: inquiryStatusList,
    );
  }
}