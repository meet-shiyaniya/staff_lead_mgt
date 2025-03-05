import 'dart:convert';

class InquiryModel {
  final bool result;
  final InquiryData inquiryData;
  final String intrestedProduct;
  final int modelHeaderAccess;
  final List<ProcessedData> processedData;
  final String inquiryCallHtmlBtnAction;
  final int fillInterst;
  final int fillInterstCheck;
  final String propertyConfigurationType;
  final String inquiryRemark;

  InquiryModel({
    required this.result,
    required this.inquiryData,
    required this.intrestedProduct,
    required this.modelHeaderAccess,
    required this.processedData,
    required this.inquiryCallHtmlBtnAction,
    required this.fillInterst,
    required this.fillInterstCheck,
    required this.propertyConfigurationType,
    required this.inquiryRemark,
  });

  factory InquiryModel.fromJson(Map<String, dynamic> json) {
    return InquiryModel(
      result: json['result'],
      inquiryData: InquiryData.fromJson(json['inquiry_all_status_data']),
      intrestedProduct: json['intrested_product'],
      modelHeaderAccess: json['model_header_aceess'],
      processedData: (json['processedData'] as List)
          .map((e) => ProcessedData.fromJson(e))
          .toList(),
      inquiryCallHtmlBtnAction: json['inquiry_call_html_btn_action'],
      fillInterst: json['fill_interst'],
      fillInterstCheck: json['fill_interst_check'],
      propertyConfigurationType: json['propertyconfiguration_type'],
      inquiryRemark: json['inquiry_remark'],
    );
  }
}

class InquiryData {
  final String id;
  final String userId;
  final String ownerId;
  final String assignId;
  final String fullName;
  final String mobileno;
  final String area;
  final String city;
  final String intrestedProduct;
  final String intrestedArea;
  final String budget;
  final String purposeBuy;
  final String approxBuy;
  final String inquiryType;
  final String inquirySourceType;
  final String nxtFollowUp;
  final String remark;
  final String createdAt;
  final String visitDate;
  final String bookingDate;
  final String dpAmount;
  final String inquiryStatus;
  final String issitevisit;

  InquiryData({
    required this.id,
    required this.userId,
    required this.ownerId,
    required this.assignId,
    required this.fullName,
    required this.mobileno,
    required this.area,
    required this.city,
    required this.intrestedProduct,
    required this.intrestedArea,
    required this.budget,
    required this.purposeBuy,
    required this.approxBuy,
    required this.inquiryType,
    required this.inquirySourceType,
    required this.nxtFollowUp,
    required this.remark,
    required this.createdAt,
    required this.visitDate,
    required this.bookingDate,
    required this.dpAmount,
    required this.inquiryStatus,
    required this.issitevisit
  });

  factory InquiryData.fromJson(Map<String, dynamic> json) {
    return InquiryData(
      id: json['id'],
      userId: json['user_id'],
      ownerId: json['owner_id'],
      assignId: json['assign_id'],
      fullName: json['full_name'],
      mobileno: json['mobileno'],
      area: json['area'],
      city: json['city'],
      intrestedProduct: json['intrested_product'],
      intrestedArea: json['intrested_area'],
      budget: json['budget'],
      purposeBuy: json['purpose_buy'],
      approxBuy: json['approx_buy'],
      inquiryType: json['inquiry_type'],
      inquirySourceType: json['inquiry_source_type'],
      nxtFollowUp: json['nxt_follow_up'],
      remark: json['remark'],
      createdAt: json['created_at'],
      visitDate: json['visit_date'],
      bookingDate: json['booking_date'],
      dpAmount: json['dp_amount'],
      inquiryStatus: json['inquiry_status'],
      issitevisit: json['isSiteVisit']
    );
  }
}

class ProcessedData {
  final String createdAt;
  final String username;
  final String statusLabel;
  final String nxtFollowDate;
  final String remarkText;
  final String conditionWiseBG;
  final String stagesId;
  final String status;

  ProcessedData({
    required this.createdAt,
    required this.username,
    required this.statusLabel,
    required this.nxtFollowDate,
    required this.remarkText,
    required this.conditionWiseBG,
    required this.stagesId,
    required this.status,
  });

  factory ProcessedData.fromJson(Map<String, dynamic> json) {
    return ProcessedData(
      createdAt: json['created_at'],
      username: json['username'],
      statusLabel: json['status_label'],
      nxtFollowDate: json['nxtfollowdate'],
      remarkText: json['remarktext'],
      conditionWiseBG: json['conditionWIseBG'],
      stagesId: json['stages_id'],
      status: json['status'],
    );
  }
}
