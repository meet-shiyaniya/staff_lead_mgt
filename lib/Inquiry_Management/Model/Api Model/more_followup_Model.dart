class Activity {
  final String? inquiryId;
  final String? inquiryStages;
  final String? inquiryType;
  final String? createdDate;
  final String? nextFollowup;
  final String? remark;

  Activity({
    this.inquiryId,
    this.inquiryStages,
    this.inquiryType,
    this.createdDate,
    this.nextFollowup,
    this.remark,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      inquiryId: json['inquiry_id'] as String?,
      inquiryStages: json['inquiry_stages'] as String?,
      inquiryType: json['inquiry_type'] as String?,
      createdDate: json['created_date'] as String?,
      nextFollowup: json['next_followup'] as String?,
      remark: json['remark'] as String?,
    );
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
      userId: json['user_id'] as String?,
      firstname: json['firstname'] as String?,
      userRole: json['user_role'] as String?,
    );
  }
}

class ActivityResponse {
  final List<Activity>? activityData;
  final List<Employee>? employees;

  ActivityResponse({
    this.activityData,
    this.employees,
  });

  factory ActivityResponse.fromJson(Map<String, dynamic> json) {
    return ActivityResponse(
      activityData: json['list'] != null && json['list'] is List
          ? (json['list'] as List)
          .map((item) => Activity.fromJson(item as Map<String, dynamic>))
          .toList()
          : [], // Default to empty list if null or invalid
      employees: json['employee'] != null && json['employee'] is List
          ? (json['employee'] as List)
          .map((item) => Employee.fromJson(item as Map<String, dynamic>))
          .toList()
          : [], // Default to null if invalid
    );
  }

}
