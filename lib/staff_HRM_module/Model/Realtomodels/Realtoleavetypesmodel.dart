class Realtoleavetypesmodel {
  int? status;
  String? message;
  Data? data;

  Realtoleavetypesmodel({this.status, this.message, this.data});

  Realtoleavetypesmodel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? username;
  String? firstname;
  String? head;
  String? headName;
  List<TypeOfLeave>? typeOfLeave;

  Data(
      {this.username,
        this.firstname,
        this.head,
        this.headName,
        this.typeOfLeave});

  Data.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    firstname = json['firstname'];
    head = json['head'];
    headName = json['head_name'];
    if (json['type_of_leave'] != null) {
      typeOfLeave = <TypeOfLeave>[];
      json['type_of_leave'].forEach((v) {
        typeOfLeave!.add(new TypeOfLeave.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['firstname'] = this.firstname;
    data['head'] = this.head;
    data['head_name'] = this.headName;
    if (this.typeOfLeave != null) {
      data['type_of_leave'] = this.typeOfLeave!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TypeOfLeave {
  String? id;
  String? annualLimit;
  String? leaveType;

  TypeOfLeave({this.id, this.annualLimit, this.leaveType});

  TypeOfLeave.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    annualLimit = json['annual_limit'];
    leaveType = json['leave_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['annual_limit'] = this.annualLimit;
    data['leave_type'] = this.leaveType;
    return data;
  }
}