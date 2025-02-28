class InquiryTimeLineModel {
  String? result;
  List<Data>? data;
  String? inquiryId;

  InquiryTimeLineModel({this.result, this.data, this.inquiryId});

  InquiryTimeLineModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    inquiryId = json['inquiry_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['inquiry_id'] = this.inquiryId;
    return data;
  }
}

class Data {
  String? createdAt;
  String? username;
  String? statusLabel;
  String? nxtfollowdate;
  String? remarktext;
  String? conditionWIseBG;
  String? stagesId;
  String? inquiryLog;

  Data(
      {this.createdAt,
        this.username,
        this.statusLabel,
        this.nxtfollowdate,
        this.remarktext,
        this.conditionWIseBG,
        this.stagesId,
        this.inquiryLog});

  Data.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'];
    username = json['username'];
    statusLabel = json['status_label'];
    nxtfollowdate = json['nxtfollowdate'];
    remarktext = json['remarktext'];
    conditionWIseBG = json['conditionWIseBG'];
    stagesId = json['stages_id'];
    inquiryLog = json['inquiry_log'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.createdAt;
    data['username'] = this.username;
    data['status_label'] = this.statusLabel;
    data['nxtfollowdate'] = this.nxtfollowdate;
    data['remarktext'] = this.remarktext;
    data['conditionWIseBG'] = this.conditionWIseBG;
    data['stages_id'] = this.stagesId;
    data['inquiry_log'] = this.inquiryLog;
    return data;
  }
}
