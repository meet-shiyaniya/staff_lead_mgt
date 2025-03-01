class fetchTransferInquiryModel {
  Action? action;
  List<Employee>? employee;

  fetchTransferInquiryModel({this.action, this.employee});

  fetchTransferInquiryModel.fromJson(Map<String, dynamic> json) {
    action =
    json['Action'] != null ? new Action.fromJson(json['Action']) : null;
    if (json['Employee'] != null) {
      employee = <Employee>[];
      json['Employee'].forEach((v) {
        employee!.add(new Employee.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.action != null) {
      data['Action'] = this.action!.toJson();
    }
    if (this.employee != null) {
      data['Employee'] = this.employee!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Action {
  String? assignFollowups;
  String? transferOwnership;

  Action({this.assignFollowups, this.transferOwnership});

  Action.fromJson(Map<String, dynamic> json) {
    assignFollowups = json['assign_followups'];
    transferOwnership = json['transfer_ownership'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['assign_followups'] = this.assignFollowups;
    data['transfer_ownership'] = this.transferOwnership;
    return data;
  }
}

class Employee {
  String? id;
  String? firstname;

  Employee({this.id, this.firstname});

  Employee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstname'] = this.firstname;
    return data;
  }
}