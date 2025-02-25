class Realtostaffattendancemodel {
  int? status;
  String? message;
  List<Data>? data;

  Realtostaffattendancemodel({this.status, this.message, this.data});

  Realtostaffattendancemodel.fromJson(Map<String, dynamic> json) {
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
  String? entryDateTime;
  String? exitDateTime;
  String? hourCount;
  String? createdAt;
  String? status;
  String? isExitDay;
  String? isStatus;
  String? punchDate;
  Null? punchTimeArray;
  String? isDelete;
  Null? deletedBy;
  Null? deletedDate;
  String? workTime;
  String? bioStatus;
  String? workStatus;
  String? intimeStatus;
  String? intimeValue;
  String? outtimeStatus;
  String? outtimeValue;

  Data(
      {this.id,
        this.userId,
        this.entryDateTime,
        this.exitDateTime,
        this.hourCount,
        this.createdAt,
        this.status,
        this.isExitDay,
        this.isStatus,
        this.punchDate,
        this.punchTimeArray,
        this.isDelete,
        this.deletedBy,
        this.deletedDate,
        this.workTime,
        this.bioStatus,
        this.workStatus,
        this.intimeStatus,
        this.intimeValue,
        this.outtimeStatus,
        this.outtimeValue});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    entryDateTime = json['entry_date_time'];
    exitDateTime = json['exit_date_time'];
    hourCount = json['hour_count'];
    createdAt = json['created_at'];
    status = json['status'];
    isExitDay = json['is_exit_day'];
    isStatus = json['is_status'];
    punchDate = json['punch_date'];
    punchTimeArray = json['punch_time_array'];
    isDelete = json['is_delete'];
    deletedBy = json['deleted_by'];
    deletedDate = json['deleted_date'];
    workTime = json['work_time'];
    bioStatus = json['bio_status'];
    workStatus = json['work_status'];
    intimeStatus = json['intime_status'];
    intimeValue = json['intime_value'];
    outtimeStatus = json['outtime_status'];
    outtimeValue = json['outtime_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['entry_date_time'] = this.entryDateTime;
    data['exit_date_time'] = this.exitDateTime;
    data['hour_count'] = this.hourCount;
    data['created_at'] = this.createdAt;
    data['status'] = this.status;
    data['is_exit_day'] = this.isExitDay;
    data['is_status'] = this.isStatus;
    data['punch_date'] = this.punchDate;
    data['punch_time_array'] = this.punchTimeArray;
    data['is_delete'] = this.isDelete;
    data['deleted_by'] = this.deletedBy;
    data['deleted_date'] = this.deletedDate;
    data['work_time'] = this.workTime;
    data['bio_status'] = this.bioStatus;
    data['work_status'] = this.workStatus;
    data['intime_status'] = this.intimeStatus;
    data['intime_value'] = this.intimeValue;
    data['outtime_status'] = this.outtimeStatus;
    data['outtime_value'] = this.outtimeValue;
    return data;
  }
}