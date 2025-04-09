// To parse this JSON data, do
//
//     final visitEntryModel = visitEntryModelFromJson(jsonString);

import 'dart:convert';

VisitEntryModel visitEntryModelFromJson(String str) => VisitEntryModel.fromJson(json.decode(str));

String visitEntryModelToJson(VisitEntryModel data) => json.encode(data.toJson());

class VisitEntryModel {
  Inquiries inquiries;
  List<Project> projects;
  List<UnitNo> unitNo;

  VisitEntryModel({
    required this.inquiries,
    required this.projects,
    required this.unitNo,
  });

  factory VisitEntryModel.fromJson(Map<String, dynamic> json) => VisitEntryModel(
    inquiries: Inquiries.fromJson(json["inquiries"]),
    projects: List<Project>.from(json["Projects"].map((x) => Project.fromJson(x))),
    unitNo: List<UnitNo>.from(json["Unit No"].map((x) => UnitNo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "inquiries": inquiries.toJson(),
    "Projects": List<dynamic>.from(projects.map((x) => x.toJson())),
    "Unit No": List<dynamic>.from(unitNo.map((x) => x.toJson())),
  };
}

class Inquiries {
  String iscountvisit;
  String isSiteVisit;
  String fullName;
  String mobileno;
  String address;
  String propertySubType;
  String propertyType;
  String budget;
  String purposeBuy;
  String intrestedProduct;
  String unitNo;

  Inquiries({
    required this.iscountvisit,
    required this.fullName,
    required this.mobileno,
    required this.address,
    required this.propertySubType,
    required this.propertyType,
    required this.budget,
    required this.purposeBuy,
    required this.intrestedProduct,
    required this.unitNo,
    required this.isSiteVisit
  });

  factory Inquiries.fromJson(Map<String, dynamic> json) => Inquiries(
    isSiteVisit: json["isSiteVisit"],
    iscountvisit: json["iscountvisit"],
    fullName: json["full_name"],
    mobileno: json["mobileno"],
    address: json["address"],
    propertySubType: json["property_sub_type"],
    propertyType: json["property_type"],
    budget: json["budget"],
    purposeBuy: json["purpose_buy"],
    intrestedProduct: json["intrested_product"],
    unitNo: json["unit_no"],
  );

  Map<String, dynamic> toJson() => {
    "iscountvisit": iscountvisit,
    "full_name": fullName,
    "mobileno": mobileno,
    "address": address,
    "property_sub_type": propertySubType,
    "property_type": propertyType,
    "budget": budget,
    "purpose_buy": purposeBuy,
    "intrested_product": intrestedProduct,
    "unit_no": unitNo,
  };
}

class Project {
  String id;
  String projectSubType;

  Project({
    required this.id,
    required this.projectSubType,
  });

  factory Project.fromJson(Map<String, dynamic> json) => Project(
    id: json["id"],
    projectSubType: json["project_sub_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "project_sub_type": projectSubType,
  };
}

class UnitNo {
  String unitNo;
  String propertySize;

  UnitNo({
    required this.unitNo,
    required this.propertySize,
  });

  factory UnitNo.fromJson(Map<String, dynamic> json) => UnitNo(
    unitNo: json["unit_no"],
    propertySize: json["property_size"],
  );

  Map<String, dynamic> toJson() => {
    "unit_no": unitNo,
    "property_size": propertySize,
  };
}
