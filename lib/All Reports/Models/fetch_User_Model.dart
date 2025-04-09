class FetchUserModel {
  List<UserReport>? userReports;

  FetchUserModel({this.userReports});

  factory FetchUserModel.fromJson(Map<String, dynamic> json) {
    return FetchUserModel(
      userReports: (json['inquiries'] as List?)
          ?.map((i) => UserReport.fromJson(i))
          .toList(),
    );
  }
}

class UserReport {
  String? id;
  String? firstname;

  UserReport({this.id, this.firstname});

  factory UserReport.fromJson(Map<String, dynamic> json) {
    return UserReport(
      id: json['id'] as String?,
      firstname: json['firstname'] as String?,
    );
  }
}