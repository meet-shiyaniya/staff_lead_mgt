class followup_Cnr_Model {
  String? rowCountHtml;
  String? html;
  int? totalPage;
  int? response;
  int? stutusDataAllow;
  int? stutus;
  String? message;
  int? rowcount;
  String? tooltipId;
  List<Tab>? tab;
  List<Data>? data;
  int? totalMembersCount;

  followup_Cnr_Model(
      {this.rowCountHtml,
        this.html,
        this.totalPage,
        this.response,
        this.stutusDataAllow,
        this.stutus,
        this.message,
        this.rowcount,
        this.tooltipId,
        this.tab,
        this.data,
        this.totalMembersCount});

  followup_Cnr_Model.fromJson(Map<String, dynamic> json) {
    rowCountHtml = json['row_count_html'];
    html = json['html'];
    totalPage = json['total_page'];
    response = json['response'];
    stutusDataAllow = json['stutus_data_allow'];
    stutus = json['stutus'];
    message = json['Message'];
    rowcount = json['rowcount'];
    tooltipId = json['tooltip_id'];
    if (json['tab'] != null) {
      tab = <Tab>[];
      json['tab'].forEach((v) {
        tab!.add(new Tab.fromJson(v));
      });
    }
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    totalMembersCount = json['total_members_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['row_count_html'] = this.rowCountHtml;
    data['html'] = this.html;
    data['total_page'] = this.totalPage;
    data['response'] = this.response;
    data['stutus_data_allow'] = this.stutusDataAllow;
    data['stutus'] = this.stutus;
    data['Message'] = this.message;
    data['rowcount'] = this.rowcount;
    data['tooltip_id'] = this.tooltipId;
    if (this.tab != null) {
      data['tab'] = this.tab!.map((v) => v.toJson()).toList();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['total_members_count'] = this.totalMembersCount;
    return data;
  }
}

class Tab {
  String? inquiryStatus;
  String? totalSum;
  String? fresh;
  String? contacted;
  String? appointment;
  String? visited;
  String? negotiations;
  String? feedBack;
  String? reAppointment;
  String? reVisited;
  String? converted;

  Tab(
      {this.inquiryStatus,
        this.totalSum,
        this.fresh,
        this.contacted,
        this.appointment,
        this.visited,
        this.negotiations,
        this.feedBack,
        this.reAppointment,
        this.reVisited,
        this.converted});

  Tab.fromJson(Map<String, dynamic> json) {
    inquiryStatus = json['inquiry_status'];
    totalSum = json['Total_Sum'];
    fresh = json['Fresh'];
    contacted = json['Contacted'];
    appointment = json['Appointment'];
    visited = json['Visited'];
    negotiations = json['Negotiations'];
    feedBack = json['Feed_Back'];
    reAppointment = json['Re_Appointment'];
    reVisited = json['Re_Visited'];
    converted = json['Converted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['inquiry_status'] = this.inquiryStatus;
    data['Total_Sum'] = this.totalSum;
    data['Fresh'] = this.fresh;
    data['Contacted'] = this.contacted;
    data['Appointment'] = this.appointment;
    data['Visited'] = this.visited;
    data['Negotiations'] = this.negotiations;
    data['Feed_Back'] = this.feedBack;
    data['Re_Appointment'] = this.reAppointment;
    data['Re_Visited'] = this.reVisited;
    data['Converted'] = this.converted;
    return data;
  }
}

class Data {
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
  String? isvisit;
  String? iscountvisit;
  String? visitDate;
  String? revisitDate;
  String? visitedsite;
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
  Null? pageId;
  Null? senderId;
  String? isDelete;
  Null? deletedBy;
  Null? deletedDate;
  String? propertyConfiguration;
  String? lastCnrDate;
  String? daySkip;
  String? hourSkip;
  String? ssmComment;
  String? ivrQueueStatus;
  String? inquiryStatus;
  String? inqHour;

  Data(
      {this.id,
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
        this.isvisit,
        this.iscountvisit,
        this.visitDate,
        this.revisitDate,
        this.visitedsite,
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
        this.inqHour});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    ownerId = json['owner_id'];
    assignId = json['assign_id'];
    headStatus = json['head_status'];
    head = json['head'];
    inquiryStages = json['inquiry_stages'];
    fullName = json['full_name'];
    address = json['address'];
    dob = json['dob'];
    anniDate = json['anni_date'];
    mobileno = json['mobileno'];
    altmobileno = json['altmobileno'];
    email = json['email'];
    houseno = json['houseno'];
    society = json['society'];
    area = json['area'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    propertyType = json['property_type'];
    propertySubType = json['property_sub_type'];
    intrestedProduct = json['intrested_product'];
    interstedSiteName = json['intersted_site_name'];
    budget = json['budget'];
    purposeBuy = json['purpose_buy'];
    approxBuy = json['approx_buy'];
    intrestedArea = json['intrested_area'];
    intrestedAreaName = json['intrested_area_name'];
    inquiryType = json['inquiry_type'];
    inquirySourceType = json['inquiry_source_type'];
    appointmentDate = json['appointment_date'];
    nxtFollowUp = json['nxt_follow_up'];
    feedback = json['feedback'];
    unitNo = json['unit_no'];
    unitSize = json['unit_size'];
    paymentref = json['paymentref'];
    cashPay = json['cash_pay'];
    dpAmount = json['dp_amount'];
    loanAmount = json['loan_amount'];
    remark = json['remark'];
    inquiryDescription = json['inquiry_description'];
    createdAt = json['created_at'];
    inquiryCnr = json['inquiry_cnr'];
    broker = json['broker'];
    inquiryCloseReason = json['inquiry_close_reason'];
    isSiteVisit = json['isSiteVisit'];
    isvisit = json['isvisit'];
    iscountvisit = json['iscountvisit'];
    visitDate = json['visit_date'];
    revisitDate = json['revisit_date'];
    visitedsite = json['visitedsite'];
    bookingDate = json['booking_date'];
    isAppoitement = json['isAppoitement'];
    userType = json['user_type'];
    adId = json['ad_id'];
    adsetId = json['adset_id'];
    campaignId = json['campaign_id'];
    campaignName = json['campaign_name'];
    formId = json['form_id'];
    formName = json['form_name'];
    altCountryCode = json['alt_country_code'];
    countryCode = json['country_code'];
    leadId = json['lead_id'];
    botContactno = json['bot_contactno'];
    botPlatformId = json['bot_platform_id'];
    botAssetsId = json['bot_assets_id'];
    isRequest = json['is_request'];
    isBot = json['is_bot'];
    pageId = json['page_id'];
    senderId = json['sender_id'];
    isDelete = json['is_delete'];
    deletedBy = json['deleted_by'];
    deletedDate = json['deleted_date'];
    propertyConfiguration = json['PropertyConfiguration'];
    lastCnrDate = json['last_cnr_date'];
    daySkip = json['day_skip'];
    hourSkip = json['hour_skip'];
    ssmComment = json['ssm_comment'];
    ivrQueueStatus = json['ivr_queue_status'];
    inquiryStatus = json['inquiry_status'];
    inqHour = json['inq_hour'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['owner_id'] = this.ownerId;
    data['assign_id'] = this.assignId;
    data['head_status'] = this.headStatus;
    data['head'] = this.head;
    data['inquiry_stages'] = this.inquiryStages;
    data['full_name'] = this.fullName;
    data['address'] = this.address;
    data['dob'] = this.dob;
    data['anni_date'] = this.anniDate;
    data['mobileno'] = this.mobileno;
    data['altmobileno'] = this.altmobileno;
    data['email'] = this.email;
    data['houseno'] = this.houseno;
    data['society'] = this.society;
    data['area'] = this.area;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['property_type'] = this.propertyType;
    data['property_sub_type'] = this.propertySubType;
    data['intrested_product'] = this.intrestedProduct;
    data['intersted_site_name'] = this.interstedSiteName;
    data['budget'] = this.budget;
    data['purpose_buy'] = this.purposeBuy;
    data['approx_buy'] = this.approxBuy;
    data['intrested_area'] = this.intrestedArea;
    data['intrested_area_name'] = this.intrestedAreaName;
    data['inquiry_type'] = this.inquiryType;
    data['inquiry_source_type'] = this.inquirySourceType;
    data['appointment_date'] = this.appointmentDate;
    data['nxt_follow_up'] = this.nxtFollowUp;
    data['feedback'] = this.feedback;
    data['unit_no'] = this.unitNo;
    data['unit_size'] = this.unitSize;
    data['paymentref'] = this.paymentref;
    data['cash_pay'] = this.cashPay;
    data['dp_amount'] = this.dpAmount;
    data['loan_amount'] = this.loanAmount;
    data['remark'] = this.remark;
    data['inquiry_description'] = this.inquiryDescription;
    data['created_at'] = this.createdAt;
    data['inquiry_cnr'] = this.inquiryCnr;
    data['broker'] = this.broker;
    data['inquiry_close_reason'] = this.inquiryCloseReason;
    data['isSiteVisit'] = this.isSiteVisit;
    data['isvisit'] = this.isvisit;
    data['iscountvisit'] = this.iscountvisit;
    data['visit_date'] = this.visitDate;
    data['revisit_date'] = this.revisitDate;
    data['visitedsite'] = this.visitedsite;
    data['booking_date'] = this.bookingDate;
    data['isAppoitement'] = this.isAppoitement;
    data['user_type'] = this.userType;
    data['ad_id'] = this.adId;
    data['adset_id'] = this.adsetId;
    data['campaign_id'] = this.campaignId;
    data['campaign_name'] = this.campaignName;
    data['form_id'] = this.formId;
    data['form_name'] = this.formName;
    data['alt_country_code'] = this.altCountryCode;
    data['country_code'] = this.countryCode;
    data['lead_id'] = this.leadId;
    data['bot_contactno'] = this.botContactno;
    data['bot_platform_id'] = this.botPlatformId;
    data['bot_assets_id'] = this.botAssetsId;
    data['is_request'] = this.isRequest;
    data['is_bot'] = this.isBot;
    data['page_id'] = this.pageId;
    data['sender_id'] = this.senderId;
    data['is_delete'] = this.isDelete;
    data['deleted_by'] = this.deletedBy;
    data['deleted_date'] = this.deletedDate;
    data['PropertyConfiguration'] = this.propertyConfiguration;
    data['last_cnr_date'] = this.lastCnrDate;
    data['day_skip'] = this.daySkip;
    data['hour_skip'] = this.hourSkip;
    data['ssm_comment'] = this.ssmComment;
    data['ivr_queue_status'] = this.ivrQueueStatus;
    data['inquiry_status'] = this.inquiryStatus;
    data['inq_hour'] = this.inqHour;
    return data;
  }
}