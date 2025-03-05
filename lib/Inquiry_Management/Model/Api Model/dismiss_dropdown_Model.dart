class InquiryStatusModel {
  final List<Inquirydata> no;
  final List<Inquirydata> yes;

  InquiryStatusModel({required this.no, required this.yes});

  factory InquiryStatusModel.fromJson(Map<String, dynamic> json) {
    return InquiryStatusModel(
      no: (json['No'] as List).map((e) => Inquirydata.fromJson(e)).toList(),
      yes: (json['Yes'] as List).map((e) => Inquirydata.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'No': no.map((e) => e.toJson()).toList(),
      'Yes': yes.map((e) => e.toJson()).toList(),
    };
  }
}

class Inquirydata {
  final String id;
  final String callStatus;
  final String inquiryCloseReason;

  Inquirydata({
    required this.id,
    required this.callStatus,
    required this.inquiryCloseReason,
  });

  factory Inquirydata.fromJson(Map<String, dynamic> json) {
    return Inquirydata(
      id: json['id'],
      callStatus: json['call_status'],
      inquiryCloseReason: json['inquiry_close_reason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'call_status': callStatus,
      'inquiry_close_reason': inquiryCloseReason,
    };
  }
}
