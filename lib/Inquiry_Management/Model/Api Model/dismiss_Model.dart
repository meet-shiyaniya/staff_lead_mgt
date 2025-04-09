class DismissedRequestModel {
  int? statusDataAllow;
  int? status;
  String? message;
  int? response;
  DismissPagination? pagination;
  List<DismissInquiryStatus>? inquiryStatusList;
  List<DismissInquiry>? inquiryList;
  int? totalMembersCount;

  DismissedRequestModel({
    this.statusDataAllow,
    this.status,
    this.message,
    this.response,
    this.pagination,
    this.inquiryStatusList,
    this.inquiryList,
    this.totalMembersCount,
  });

  factory DismissedRequestModel.fromJson(Map<String, dynamic> json) {
    return DismissedRequestModel(
      statusDataAllow: json['stutus_data_allow'] as int?,
      status: json['stutus'] as int?,
      message: json['Message'] as String?,
      response: json['response'] as int?,
      pagination: json['pagination'] != null
          ? DismissPagination.fromJson(json['pagination'] as Map<String, dynamic>)
          : null,
      inquiryStatusList: (json['inquiry_status'] as List<dynamic>?)
          ?.map((e) => DismissInquiryStatus.fromJson(e as Map<String, dynamic>))
          .toList(),
      inquiryList: (json['inquiries'] as List<dynamic>?)
          ?.map((e) => DismissInquiry.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalMembersCount: json['total_members_count'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'stutus_data_allow': statusDataAllow,
    'stutus': status,
    'Message': message,
    'response': response,
    'pagination': pagination?.toJson(),
    'inquiry_status': inquiryStatusList?.map((e) => e.toJson()).toList(),
    'inquiries': inquiryList?.map((e) => e.toJson()).toList(),
    'total_members_count': totalMembersCount,
  };
}

class DismissPagination {
  int? totalRecords;
  int? totalPages;
  int? currentPage;

  DismissPagination({
    this.totalRecords,
    this.totalPages,
    this.currentPage,
  });

  factory DismissPagination.fromJson(Map<String, dynamic> json) {
    return DismissPagination(
      totalRecords: json['total_records'] as int?,
      totalPages: json['total_pages'] as int?,
      currentPage: json['current_page'] is String
          ? int.tryParse(json['current_page'] as String) ?? 0 // Parse String to int if needed
          : json['current_page'] as int?, // Use directly if int
    );
  }

  Map<String, dynamic> toJson() => {
    'total_records': totalRecords,
    'total_pages': totalPages,
    'current_page': currentPage,
  };
}

class DismissInquiryStatus {
  String? inquiryStatus;
  String? totalSum;
  String? fresh;
  String? contacted;
  String? appointment;
  String? visited;
  String? negotiations;
  String? feedback;
  String? reAppointment;
  String? reVisited;
  String? converted;

  DismissInquiryStatus({
    this.inquiryStatus,
    this.totalSum,
    this.fresh,
    this.contacted,
    this.appointment,
    this.visited,
    this.negotiations,
    this.feedback,
    this.reAppointment,
    this.reVisited,
    this.converted,
  });

  factory DismissInquiryStatus.fromJson(Map<String, dynamic> json) {
    return DismissInquiryStatus(
      inquiryStatus: json['inquiry_status'] as String?,
      totalSum: json['Total_Sum'] as String?,
      fresh: json['Fresh'] as String?,
      contacted: json['Contacted'] as String?,
      appointment: json['Appointment'] as String?,
      visited: json['Visited'] as String?,
      negotiations: json['Negotiations'] as String?,
      feedback: json['Feed_Back'] as String?,
      reAppointment: json['Re_Appointment'] as String?,
      reVisited: json['Re_Visited'] as String?,
      converted: json['Converted'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'inquiry_status': inquiryStatus,
    'Total_Sum': totalSum,
    'Fresh': fresh,
    'Contacted': contacted,
    'Appointment': appointment,
    'Visited': visited,
    'Negotiations': negotiations,
    'Feed_Back': feedback,
    'Re_Appointment': reAppointment,
    'Re_Visited': reVisited,
    'Converted': converted,
  };

  // Optional: Add getters if you need int values for calculations
  int get totalSumValue => int.tryParse(totalSum ?? '0') ?? 0;
  int get freshValue => int.tryParse(fresh ?? '0') ?? 0;
  int get contactedValue => int.tryParse(contacted ?? '0') ?? 0;
  int get appointmentValue => int.tryParse(appointment ?? '0') ?? 0;
  int get visitedValue => int.tryParse(visited ?? '0') ?? 0;
  int get negotiationsValue => int.tryParse(negotiations ?? '0') ?? 0;
  int get feedbackValue => int.tryParse(feedback ?? '0') ?? 0;
  int get reAppointmentValue => int.tryParse(reAppointment ?? '0') ?? 0;
  int get reVisitedValue => int.tryParse(reVisited ?? '0') ?? 0;
  int get convertedValue => int.tryParse(converted ?? '0') ?? 0;
}

class DismissInquiry {
  String? id;
  String? userId;
  String? ownerId;
  String? assignId;
  String? headStatus;
  String? head;
  String? inquiryStages;
  String? fullName;
  String? address;
  String? dob;
  String? anniDate;
  String? mobileno;
  String? altmobileno;
  String? email;
  String? houseno;
  String? society;
  String? area;
  String? city;
  String? state;
  String? country;
  String? propertyType;
  String? propertySubType;
  String? intrestedProduct;
  String? interstedSiteName;
  String? budget;
  String? purposeBuy;
  String? approxBuy;
  String? intrestedArea;
  String? intrestedAreaName;
  String? inquiryType;
  String? inquirySourceType;
  String? appointmentDate;
  String? nxtFollowUp;
  String? feedback;
  String? unitNo;
  String? unitSize;
  String? paymentref;
  String? cashPay;
  String? dpAmount;
  String? loanAmount;
  String? remark;
  String? inquiryDescription;
  String? createdAt;
  String? inquiryCnr;
  String? broker;
  String? inquiryCloseReason;
  String? isSiteVisit;
  String? isVisit;
  String? isCountVisit;
  String? visitDate;
  String? revisitDate;
  String? visitedSite;
  String? bookingDate;
  String? isAppoitement;
  String? userType;
  String? adId;
  String? adsetId;
  String? campaignId;
  String? campaignName;
  String? formId;
  String? formName;
  String? altCountryCode;
  String? countryCode;
  String? leadId;
  String? botContactno;
  String? botPlatformId;
  String? botAssetsId;
  String? isRequest;
  String? isBot;
  String? pageId;
  String? senderId;
  String? isDelete;
  String? deletedBy;
  String? deletedDate;
  String? propertyConfiguration;
  String? lastCnrDate;
  String? daySkip;
  String? hourSkip;
  String? ssmComment;
  String? ivrQueueStatus;
  String? inquiryStatus;

  DismissInquiry({
    this.id,
    this.userId,
    this.ownerId,
    this.assignId,
    this.headStatus,
    this.head,
    this.inquiryStages,
    this.fullName,
    this.address,
    this.dob,
    this.anniDate,
    this.mobileno,
    this.altmobileno,
    this.email,
    this.houseno,
    this.society,
    this.area,
    this.city,
    this.state,
    this.country,
    this.propertyType,
    this.propertySubType,
    this.intrestedProduct,
    this.interstedSiteName,
    this.budget,
    this.purposeBuy,
    this.approxBuy,
    this.intrestedArea,
    this.intrestedAreaName,
    this.inquiryType,
    this.inquirySourceType,
    this.appointmentDate,
    this.nxtFollowUp,
    this.feedback,
    this.unitNo,
    this.unitSize,
    this.paymentref,
    this.cashPay,
    this.dpAmount,
    this.loanAmount,
    this.remark,
    this.inquiryDescription,
    this.createdAt,
    this.inquiryCnr,
    this.broker,
    this.inquiryCloseReason,
    this.isSiteVisit,
    this.isVisit,
    this.isCountVisit,
    this.visitDate,
    this.revisitDate,
    this.visitedSite,
    this.bookingDate,
    this.isAppoitement,
    this.userType,
    this.adId,
    this.adsetId,
    this.campaignId,
    this.campaignName,
    this.formId,
    this.formName,
    this.altCountryCode,
    this.countryCode,
    this.leadId,
    this.botContactno,
    this.botPlatformId,
    this.botAssetsId,
    this.isRequest,
    this.isBot,
    this.pageId,
    this.senderId,
    this.isDelete,
    this.deletedBy,
    this.deletedDate,
    this.propertyConfiguration,
    this.lastCnrDate,
    this.daySkip,
    this.hourSkip,
    this.ssmComment,
    this.ivrQueueStatus,
    this.inquiryStatus,
  });

  factory DismissInquiry.fromJson(Map<String, dynamic> json) {
    return DismissInquiry(
      id: json['id'] as String?,
      userId: json['user_id'] as String?,
      ownerId: json['owner_id'] as String?,
      assignId: json['assign_id'] as String?,
      headStatus: json['head_status'] as String?,
      head: json['head'] as String?,
      inquiryStages: json['inquiry_stages'] as String?,
      fullName: json['full_name'] as String?,
      address: json['address'] as String?,
      dob: json['dob'] as String?,
      anniDate: json['anni_date'] as String?,
      mobileno: json['mobileno'] as String?,
      altmobileno: json['altmobileno'] as String?,
      email: json['email'] as String?,
      houseno: json['houseno'] as String?,
      society: json['society'] as String?,
      area: json['area'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      propertyType: json['property_type'] as String?,
      propertySubType: json['property_sub_type'] as String?,
      intrestedProduct: json['intrested_product'] as String?,
      interstedSiteName: json['intersted_site_name'] as String?,
      budget: json['budget'] as String?,
      purposeBuy: json['purpose_buy'] as String?,
      approxBuy: json['approx_buy'] as String?,
      intrestedArea: json['intrested_area'] as String?,
      intrestedAreaName: json['intrested_area_name'] as String?,
      inquiryType: json['inquiry_type'] as String?,
      inquirySourceType: json['inquiry_source_type'] as String?,
      appointmentDate: json['appointment_date'] as String?,
      nxtFollowUp: json['nxt_follow_up'] as String?,
      feedback: json['feedback'] as String?,
      unitNo: json['unit_no'] as String?,
      unitSize: json['unit_size'] as String?,
      paymentref: json['paymentref'] as String?,
      cashPay: json['cash_pay'] as String?,
      dpAmount: json['dp_amount'] as String?,
      loanAmount: json['loan_amount'] as String?,
      remark: json['remark'] as String?,
      inquiryDescription: json['inquiry_description'] as String?,
      createdAt: json['created_at'] as String?,
      inquiryCnr: json['inquiry_cnr'] as String?,
      broker: json['broker'] as String?,
      inquiryCloseReason: json['inquiry_close_reason'] as String?,
      isSiteVisit: json['isSiteVisit'] as String?,
      isVisit: json['isvisit'] as String?,
      isCountVisit: json['iscountvisit'] as String?,
      visitDate: json['visit_date'] as String?,
      revisitDate: json['revisit_date'] as String?,
      visitedSite: json['visitedsite'] as String?,
      bookingDate: json['booking_date'] as String?,
      isAppoitement: json['isAppoitement'] as String?,
      userType: json['user_type'] as String?,
      adId: json['ad_id'] as String?,
      adsetId: json['adset_id'] as String?,
      campaignId: json['campaign_id'] as String?,
      campaignName: json['campaign_name'] as String?,
      formId: json['form_id'] as String?,
      formName: json['form_name'] as String?,
      altCountryCode: json['alt_country_code'] as String?,
      countryCode: json['country_code'] as String?,
      leadId: json['lead_id'] as String?,
      botContactno: json['bot_contactno'] as String?,
      botPlatformId: json['bot_platform_id'] as String?,
      botAssetsId: json['bot_assets_id'] as String?,
      isRequest: json['is_request'] as String?,
      isBot: json['is_bot'] as String?,
      pageId: json['page_id'] as String?,
      senderId: json['sender_id'] as String?,
      isDelete: json['is_delete'] as String?,
      deletedBy: json['deleted_by'] as String?,
      deletedDate: json['deleted_date'] as String?,
      propertyConfiguration: json['PropertyConfiguration'] as String?,
      lastCnrDate: json['last_cnr_date'] as String?,
      daySkip: json['day_skip'] as String?,
      hourSkip: json['hour_skip'] as String?,
      ssmComment: json['ssm_comment'] as String?,
      ivrQueueStatus: json['ivr_queue_status'] as String?,
      inquiryStatus: json['inquiry_status'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'owner_id': ownerId,
    'assign_id': assignId,
    'head_status': headStatus,
    'head': head,
    'inquiry_stages': inquiryStages,
    'full_name': fullName,
    'address': address,
    'dob': dob,
    'anni_date': anniDate,
    'mobileno': mobileno,
    'altmobileno': altmobileno,
    'email': email,
    'houseno': houseno,
    'society': society,
    'area': area,
    'city': city,
    'state': state,
    'country': country,
    'property_type': propertyType,
    'property_sub_type': propertySubType,
    'intrested_product': intrestedProduct,
    'intersted_site_name': interstedSiteName,
    'budget': budget,
    'purpose_buy': purposeBuy,
    'approx_buy': approxBuy,
    'intrested_area': intrestedArea,
    'intrested_area_name': intrestedAreaName,
    'inquiry_type': inquiryType,
    'inquiry_source_type': inquirySourceType,
    'appointment_date': appointmentDate,
    'nxt_follow_up': nxtFollowUp,
    'feedback': feedback,
    'unit_no': unitNo,
    'unit_size': unitSize,
    'paymentref': paymentref,
    'cash_pay': cashPay,
    'dp_amount': dpAmount,
    'loan_amount': loanAmount,
    'remark': remark,
    'inquiry_description': inquiryDescription,
    'created_at': createdAt,
    'inquiry_cnr': inquiryCnr,
    'broker': broker,
    'inquiry_close_reason': inquiryCloseReason,
    'isSiteVisit': isSiteVisit,
    'isvisit': isVisit,
    'iscountvisit': isCountVisit,
    'visit_date': visitDate,
    'revisit_date': revisitDate,
    'visitedsite': visitedSite,
    'booking_date': bookingDate,
    'isAppoitement': isAppoitement,
    'user_type': userType,
    'ad_id': adId,
    'adset_id': adsetId,
    'campaign_id': campaignId,
    'campaign_name': campaignName,
    'form_id': formId,
    'form_name': formName,
    'alt_country_code': altCountryCode,
    'country_code': countryCode,
    'lead_id': leadId,
    'bot_contactno': botContactno,
    'bot_platform_id': botPlatformId,
    'bot_assets_id': botAssetsId,
    'is_request': isRequest,
    'is_bot': isBot,
    'page_id': pageId,
    'sender_id': senderId,
    'is_delete': isDelete,
    'deleted_by': deletedBy,
    'deleted_date': deletedDate,
    'PropertyConfiguration': propertyConfiguration,
    'last_cnr_date': lastCnrDate,
    'day_skip': daySkip,
    'hour_skip': hourSkip,
    'ssm_comment': ssmComment,
    'ivr_queue_status': ivrQueueStatus,
    'inquiry_status': inquiryStatus,
  };
}