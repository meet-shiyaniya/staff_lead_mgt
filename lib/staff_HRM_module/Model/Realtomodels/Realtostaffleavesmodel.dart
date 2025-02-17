class Realtostaffleavesmodel {
  int? status;
  String? message;
  List<Data>? data;

  Realtostaffleavesmodel({this.status, this.message, this.data});

  Realtostaffleavesmodel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? userId;
  String? head;
  String? fullName;
  String? underTeam;
  String? date;
  String? createdAt;
  String? reportingTo;
  String? leaveApplyDays;
  String? leaveFromDate;
  String? leaveToDate;
  String? leaveReason;
  String? typeOfLeave;
  String? status;
  String? inAbsemnt;
  String? isAbsemnt;
  String? checkStatus;
  String? leaveReject;
  String? isDelete;
  Null? deletedBy;
  Null? deletedDate;
  String? typeOfLeaveId;
  String? leaveStatusType;

  Data(
      {this.id,
        this.userId,
        this.head,
        this.fullName,
        this.underTeam,
        this.date,
        this.createdAt,
        this.reportingTo,
        this.leaveApplyDays,
        this.leaveFromDate,
        this.leaveToDate,
        this.leaveReason,
        this.typeOfLeave,
        this.status,
        this.inAbsemnt,
        this.isAbsemnt,
        this.checkStatus,
        this.leaveReject,
        this.isDelete,
        this.deletedBy,
        this.deletedDate,
        this.typeOfLeaveId,
        this.leaveStatusType});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    head = json['head'];
    fullName = json['full_name'];
    underTeam = json['under_team'];
    date = json['date'];
    createdAt = json['created_at'];
    reportingTo = json['reporting_to'];
    leaveApplyDays = json['leave_apply_days'];
    leaveFromDate = json['leave_from_date'];
    leaveToDate = json['leave_to_date'];
    leaveReason = json['leave_reason'];
    typeOfLeave = json['type_of_leave'];
    status = json['status'];
    inAbsemnt = json['in_absemnt'];
    isAbsemnt = json['is_absemnt'];
    checkStatus = json['check_status'];
    leaveReject = json['leave_reject'];
    isDelete = json['is_delete'];
    deletedBy = json['deleted_by'];
    deletedDate = json['deleted_date'];
    typeOfLeaveId = json['type_of_leave_id'];
    leaveStatusType = json['leave_status_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['head'] = this.head;
    data['full_name'] = this.fullName;
    data['under_team'] = this.underTeam;
    data['date'] = this.date;
    data['created_at'] = this.createdAt;
    data['reporting_to'] = this.reportingTo;
    data['leave_apply_days'] = this.leaveApplyDays;
    data['leave_from_date'] = this.leaveFromDate;
    data['leave_to_date'] = this.leaveToDate;
    data['leave_reason'] = this.leaveReason;
    data['type_of_leave'] = this.typeOfLeave;
    data['status'] = this.status;
    data['in_absemnt'] = this.inAbsemnt;
    data['is_absemnt'] = this.isAbsemnt;
    data['check_status'] = this.checkStatus;
    data['leave_reject'] = this.leaveReject;
    data['is_delete'] = this.isDelete;
    data['deleted_by'] = this.deletedBy;
    data['deleted_date'] = this.deletedDate;
    data['type_of_leave_id'] = this.typeOfLeaveId;
    data['leave_status_type'] = this.leaveStatusType;
    return data;
  }
}