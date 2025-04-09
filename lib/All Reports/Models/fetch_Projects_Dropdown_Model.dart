// To parse this JSON data, do
//
//     final fetchProjectsDropdownModel = fetchProjectsDropdownModelFromJson(jsonString);

import 'dart:convert';

FetchProjectsDropdownModel fetchProjectsDropdownModelFromJson(String str) => FetchProjectsDropdownModel.fromJson(json.decode(str));

String fetchProjectsDropdownModelToJson(FetchProjectsDropdownModel data) => json.encode(data.toJson());

class FetchProjectsDropdownModel {
  List<Project> project;

  FetchProjectsDropdownModel({
    required this.project,
  });

  factory FetchProjectsDropdownModel.fromJson(Map<String, dynamic> json) => FetchProjectsDropdownModel(
    project: List<Project>.from(json["project"].map((x) => Project.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "project": List<dynamic>.from(project.map((x) => x.toJson())),
  };
}

class Project {
  String id;
  String productName;

  Project({
    required this.id,
    required this.productName,
  });

  factory Project.fromJson(Map<String, dynamic> json) => Project(
    id: json["id"],
    productName: json["product_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_name": productName,
  };
}