class FollowupInquiry {
  final String id;
  final String userId;
  final String ownerId;
  final String assignId;
  final String headStatus;
  final String head;
  final String inquiryStages; // This is the key field for individual inquiry stages
  final String? fullName;
  final String? address;
  final String? dob;
  final String? anniDate;
  final String mobileno;
  final String? altMobileno;
  final String? email;
  final String? houseNo;
  final String? society;
  final String? area;
  final String? city;
  final String? state;
  final String? country;
  final String? propertyType;
  final String? propertySubType;
  final String interestedProduct;
  final String interestedSiteName;
  final String? budget;
  final String? purposeBuy;
  final String? approxBuy;
  final String interestedArea;
  final String interestedAreaName;
  final String inquiryType;
  final String inquirySourceType;
  final String appointmentDate;
  final String nextFollowUp;
  final String? feedback;
  final String unitNo;
  final String? unitSize;
  final String? paymentRef;
  final String? cashPay;
  final String? dpAmount;
  final String? loanAmount;
  final String? remark;
  final String? inquiryDescription;
  final String createdAt;
  final String inquiryCnr;
  final String? broker;
  final String? inquiryCloseReason;
  final String isSiteVisit;
  final String isVisit;
  final String isCountVisit;
  final String visitDate;
  final String revisitDate;
  final String? visitedSite;
  final String bookingDate;
  final String isAppointment; // Fixed typo
  final String userType;
  final String? adId;
  final String? adsetId;
  final String? campaignId;
  final String? campaignName;
  final String? formId;
  final String? formName;
  final String? altCountryCode;
  final String? countryCode;
  final String? leadId;
  final String? botContactNo;
  final String botPlatformId;
  final String botAssetsId;
  final String isRequest;
  final String isBot;
  final String? pageId;
  final String? senderId;
  final String isDelete;
  final String? deletedBy;
  final String? deletedDate;
  final String propertyConfiguration;
  final String lastCnrDate;
  final String daySkip;
  final String hourSkip;
  final String? ssmComment;
  final String ivrQueueStatus;
  final String inquiryStatus;

  FollowupInquiry({
    required this.id,
    required this.userId,
    required this.ownerId,
    required this.assignId,
    required this.headStatus,
    required this.head,
    required this.inquiryStages,
    this.fullName,
    this.address,
    this.dob,
    this.anniDate,
    required this.mobileno,
    this.altMobileno,
    this.email,
    this.houseNo,
    this.society,
    this.area,
    this.city,
    this.state,
    this.country,
    this.propertyType,
    this.propertySubType,
    required this.interestedProduct,
    required this.interestedSiteName,
    this.budget,
    this.purposeBuy,
    this.approxBuy,
    required this.interestedArea,
    required this.interestedAreaName,
    required this.inquiryType,
    required this.inquirySourceType,
    required this.appointmentDate,
    required this.nextFollowUp,
    this.feedback,
    required this.unitNo,
    this.unitSize,
    this.paymentRef,
    this.cashPay,
    this.dpAmount,
    this.loanAmount,
    this.remark,
    this.inquiryDescription,
    required this.createdAt,
    required this.inquiryCnr,
    this.broker,
    this.inquiryCloseReason,
    required this.isSiteVisit,
    required this.isVisit,
    required this.isCountVisit,
    required this.visitDate,
    required this.revisitDate,
    this.visitedSite,
    required this.bookingDate,
    required this.isAppointment,
    required this.userType,
    this.adId,
    this.adsetId,
    this.campaignId,
    this.campaignName,
    this.formId,
    this.formName,
    this.altCountryCode,
    this.countryCode,
    this.leadId,
    this.botContactNo,
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
    this.ssmComment,
    required this.ivrQueueStatus,
    required this.inquiryStatus,
  });

  factory FollowupInquiry.fromJson(Map<String, dynamic> json) {
    return FollowupInquiry(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      ownerId: json['owner_id'] ?? '',
      assignId: json['assign_id'] ?? '',
      headStatus: json['head_status'] ?? '',
      head: json['head'] ?? '',
      inquiryStages: json['inquiry_stages'] ?? '',
      fullName: json['full_name'],
      address: json['address'],
      dob: json['dob'],
      anniDate: json['anni_date'],
      mobileno: json['mobileno'] ?? '',
      altMobileno: json['altmobileno'],
      email: json['email'],
      houseNo: json['houseno'],
      society: json['society'],
      area: json['area'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      propertyType: json['property_type'],
      propertySubType: json['property_sub_type'],
      interestedProduct: json['intrested_product'] ?? '',
      interestedSiteName: json['intersted_site_name'] ?? '',
      budget: json['budget'],
      purposeBuy: json['purpose_buy'],
      approxBuy: json['approx_buy'],
      interestedArea: json['intrested_area'] ?? '',
      interestedAreaName: json['intrested_area_name'] ?? '',
      inquiryType: json['inquiry_type'] ?? '',
      inquirySourceType: json['inquiry_source_type'] ?? '',
      appointmentDate: json['appointment_date'] ?? '',
      nextFollowUp: json['nxt_follow_up'] ?? '',
      feedback: json['feedback'],
      unitNo: json['unit_no'] ?? '',
      unitSize: json['unit_size'],
      paymentRef: json['paymentref'],
      cashPay: json['cash_pay'],
      dpAmount: json['dp_amount'],
      loanAmount: json['loan_amount'],
      remark: json['remark'],
      inquiryDescription: json['inquiry_description'],
      createdAt: json['created_at'] ?? '',
      inquiryCnr: json['inquiry_cnr'] ?? '',
      broker: json['broker'],
      inquiryCloseReason: json['inquiry_close_reason'],
      isSiteVisit: json['isSiteVisit'] ?? '',
      isVisit: json['isvisit'] ?? '',
      isCountVisit: json['iscountvisit'] ?? '',
      visitDate: json['visit_date'] ?? '',
      revisitDate: json['revisit_date'] ?? '',
      visitedSite: json['visitedsite'],
      bookingDate: json['booking_date'] ?? '',
      isAppointment: json['isAppoitement'] ?? '', // Fixed typo
      userType: json['user_type'] ?? '',
      adId: json['ad_id'],
      adsetId: json['adset_id'],
      campaignId: json['campaign_id'],
      campaignName: json['campaign_name'],
      formId: json['form_id'],
      formName: json['form_name'],
      altCountryCode: json['alt_country_code'],
      countryCode: json['country_code'],
      leadId: json['lead_id'],
      botContactNo: json['bot_contactno'],
      botPlatformId: json['bot_platform_id'] ?? '',
      botAssetsId: json['bot_assets_id'] ?? '',
      isRequest: json['is_request'] ?? '',
      isBot: json['is_bot'] ?? '',
      pageId: json['page_id']?.toString(),
      senderId: json['sender_id']?.toString(),
      isDelete: json['is_delete'] ?? '',
      deletedBy: json['deleted_by']?.toString(),
      deletedDate: json['deleted_date']?.toString(),
      propertyConfiguration: json['PropertyConfiguration'] ?? '',
      lastCnrDate: json['last_cnr_date'] ?? '',
      daySkip: json['day_skip'] ?? '',
      hourSkip: json['hour_skip'] ?? '',
      ssmComment: json['ssm_comment'],
      ivrQueueStatus: json['ivr_queue_status'] ?? '',
      inquiryStatus: json['inquiry_status'] ?? '',
    );
  }
}

class InquiryStatus {
  final String inquiryStatus;
  final int totalSum;
  final int fresh;
  final int contacted;
  final int appointment;
  final int visited;
  final int negotiations;
  final int feedback; // Fixed typo
  final int reAppointment;
  final int reVisited;
  final int converted;

  InquiryStatus({
    required this.inquiryStatus,
    required this.totalSum,
    required this.fresh,
    required this.contacted,
    required this.appointment,
    required this.visited,
    required this.negotiations,
    required this.feedback,
    required this.reAppointment,
    required this.reVisited,
    required this.converted,
  });

  factory InquiryStatus.fromJson(Map<String, dynamic> json) {
    return InquiryStatus(
      inquiryStatus: json['inquiry_status'] ?? '',
      totalSum: int.parse(json['Total_Sum'] ?? '0'),
      fresh: int.parse(json['Fresh'] ?? '0'),
      contacted: int.parse(json['Contacted'] ?? '0'),
      appointment: int.parse(json['Appointment'] ?? '0'),
      visited: int.parse(json['Visited'] ?? '0'),
      negotiations: int.parse(json['Negotiations'] ?? '0'),
      feedback: int.parse(json['Feed_Back'] ?? '0'),
      reAppointment: int.parse(json['Re_Appointment'] ?? '0'),
      reVisited: int.parse(json['Re_Visited'] ?? '0'),
      converted: int.parse(json['Converted'] ?? '0'),
    );
  }
}

class PaginatedInquiries {
  final int statusDataAllow;
  final int status;
  final String message;
  final int response;
  final int currentPage;
  final int totalPages;
  final int totalRecords;
  final List<FollowupInquiry> inquiries;
  final List<InquiryStatus> inquiryStatus;
  final int totalMembersCount;

  PaginatedInquiries({
    required this.statusDataAllow,
    required this.status,
    required this.message,
    required this.response,
    required this.currentPage,
    required this.totalPages,
    required this.totalRecords,
    required this.inquiries,
    required this.inquiryStatus,
    required this.totalMembersCount,
  });

  factory PaginatedInquiries.fromJson(Map<String, dynamic> json) {
    var inquiriesList = json['inquiries'] as List? ?? [];
    var statusList = json['inquiry_status'] as List? ?? [];

    return PaginatedInquiries(
      statusDataAllow: json['stutus_data_allow'] ?? 0, // Fixed typo
      status: json['stutus'] ?? 0, // Fixed typo
      message: json['Message'] ?? '',
      response: json['response'] ?? 0,
      currentPage: json['pagination']?['current_page'] ?? 1,
      totalPages: json['pagination']?['total_pages'] ?? 1,
      totalRecords: json['pagination']?['total_records'] ?? 0,
      inquiries: inquiriesList.map((i) => FollowupInquiry.fromJson(i)).toList(),
      inquiryStatus: statusList.map((s) => InquiryStatus.fromJson(s)).toList(),
      totalMembersCount: json['total_members_count'] ?? 0,
    );
  }
}