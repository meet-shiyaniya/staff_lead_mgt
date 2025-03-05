class DismissModel {
  String? rowCountHtml;
  String? html;
  int? totalPage;
  int? response;
  int? statusDataAllow;
  int? status;
  String? message;
  int? rowCount;
  String? tooltipId; // Now correctly a String
  List<TabItem>? tab; // New field for the 'tab' array
  List<TooltipItem>? data; // Parse from 'data' key
  int? totalMembersCount;

  DismissModel({
    this.rowCountHtml,
    this.html,
    this.totalPage,
    this.response,
    this.statusDataAllow,
    this.status,
    this.message,
    this.rowCount,
    this.tooltipId,
    this.tab,
    this.data,
    this.totalMembersCount,
  });

  factory DismissModel.fromJson(Map<String, dynamic> json) {
    return DismissModel(
      rowCountHtml: json['row_count_html'] as String?,
      html: json['html'] as String?,
      totalPage: json['total_page'] as int?,
      response: json['response'] as int?,
      statusDataAllow: json['stutus_data_allow'] as int?,
      status: json['stutus'] as int?,
      message: json['Message'] as String?,
      rowCount: json['rowcount'] as int?,
      tooltipId: json['tooltip_id'] as String?, // Parse as String
      tab: (json['tab'] as List<dynamic>?)
          ?.map((e) => TabItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => TooltipItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalMembersCount: json['total_members_count'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'row_count_html': rowCountHtml,
    'html': html,
    'total_page': totalPage,
    'response': response,
    'stutus_data_allow': statusDataAllow,
    'stutus': status,
    'Message': message,
    'rowcount': rowCount,
    'tooltip_id': tooltipId,
    'tab': tab?.map((e) => e.toJson()).toList(),
    'data': data?.map((e) => e.toJson()).toList(),
    'total_members_count': totalMembersCount,
  };
}

class TabItem {
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

  TabItem({
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

  factory TabItem.fromJson(Map<String, dynamic> json) {
    return TabItem(
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
}

class TooltipItem {
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
  String? inquiryType;
  String? inquirySourceType;
  String? appointmentDate;
  String? nxtFollowUp;
  String? feedback;
  String? remark;
  String? createdAt;
  String? inquiryCloseReason;
  String? daySkip;
  String? hourSkip;

  TooltipItem({
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
    this.inquiryType,
    this.inquirySourceType,
    this.appointmentDate,
    this.nxtFollowUp,
    this.feedback,
    this.remark,
    this.createdAt,
    this.inquiryCloseReason,
    this.daySkip,
    this.hourSkip,
  });

  factory TooltipItem.fromJson(Map<String, dynamic> json) {
    return TooltipItem(
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
      inquiryType: json['inquiry_type'] as String?,
      inquirySourceType: json['inquiry_source_type'] as String?,
      appointmentDate: json['appointment_date'] as String?,
      nxtFollowUp: json['nxt_follow_up'] as String?,
      feedback: json['feedback'] as String?,
      remark: json['remark'] as String?,
      createdAt: json['created_at'] as String?,
      inquiryCloseReason: json['inquiry_close_reason'] as String?,
      daySkip: json['day_skip'] as String?,
      hourSkip: json['hour_skip'] as String?,
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
    'inquiry_type': inquiryType,
    'inquiry_source_type': inquirySourceType,
    'appointment_date': appointmentDate,
    'nxt_follow_up': nxtFollowUp,
    'feedback': feedback,
    'remark': remark,
    'created_at': createdAt,
    'inquiry_close_reason': inquiryCloseReason,
    'day_skip': daySkip,
    'hour_skip': hourSkip,
  };
}