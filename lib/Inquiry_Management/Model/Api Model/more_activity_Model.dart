import 'dart:convert';

class MoreActivityResponse {
  final List<ActivityData>? list;
  final int? result;
  final int? rowCount;
  final List<Employee>? employees;

  MoreActivityResponse({
    this.list,
    this.result,
    this.rowCount,
    this.employees,
  });

  factory MoreActivityResponse.fromJson(Map<String, dynamic> json) {
    return MoreActivityResponse(
      list: (json['list'] as List<dynamic>?)
          ?.map((item) => ActivityData.fromJson(item))
          .toList(),
      result: json['result'],
      rowCount: json['row_count'],
      employees: (json['employee'] as List<dynamic>?)
          ?.map((item) => Employee.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'list': list?.map((item) => item.toJson()).toList(),
      'result': result,
      'row_count': rowCount,
      'employee': employees?.map((item) => item.toJson()).toList(),
    };
  }
}

class ActivityData {
  final String? createdDate;
  final String? inquiryId;
  final String? username;
  final String? status;
  final String? stage;
  final String? inquiryLog;

  ActivityData({
    this.createdDate,
    this.inquiryId,
    this.username,
    this.status,
    this.stage,
    this.inquiryLog,
  });

  factory ActivityData.fromJson(Map<String, dynamic> json) {
    return ActivityData(
      createdDate: json['created_date'],
      inquiryId: json['inquiry_id'],
      username: json['username'],
      status: json['status'],
      stage: json['stage'],
      inquiryLog: json['inquiry_log'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'created_date': createdDate,
      'inquiry_id': inquiryId,
      'username': username,
      'status': status,
      'stage': stage,
      'inquiry_log': inquiryLog,
    };
  }
}

class Employee {
  final String? userId;
  final String? firstname;
  final String? userRole;

  Employee({
    this.userId,
    this.firstname,
    this.userRole,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      userId: json['user_id'],
      firstname: json['firstname'],
      userRole: json['user_role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'firstname': firstname,
      'user_role': userRole,
    };
  }
}
