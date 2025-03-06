// To parse this JSON data, do
//
//     final assignToOtherModel = assignToOtherModelFromJson(jsonString);

import 'dart:convert';

AssignToOtherModel assignToOtherModelFromJson(String str) => AssignToOtherModel.fromJson(json.decode(str));

String assignToOtherModelToJson(AssignToOtherModel data) => json.encode(data.toJson());

class AssignToOtherModel {
  String rowCountHtml;
  String html;
  int totalPage;
  int response;
  int stutusDataAllow;
  int stutus;
  String message;
  int rowcount;
  List<Map<String, String?>> tooltipId;
  int totalMembersCount;

  AssignToOtherModel({
    required this.rowCountHtml,
    required this.html,
    required this.totalPage,
    required this.response,
    required this.stutusDataAllow,
    required this.stutus,
    required this.message,
    required this.rowcount,
    required this.tooltipId,
    required this.totalMembersCount,
  });

  factory AssignToOtherModel.fromJson(Map<String, dynamic> json) => AssignToOtherModel(
    rowCountHtml: json["row_count_html"],
    html: json["html"],
    totalPage: json["total_page"],
    response: json["response"],
    stutusDataAllow: json["stutus_data_allow"],
    stutus: json["stutus"],
    message: json["Message"],
    rowcount: json["rowcount"],
    tooltipId: List<Map<String, String?>>.from(json["tooltip_id"].map((x) => Map.from(x).map((k, v) => MapEntry<String, String?>(k, v)))),
    totalMembersCount: json["total_members_count"],
  );

  Map<String, dynamic> toJson() => {
    "row_count_html": rowCountHtml,
    "html": html,
    "total_page": totalPage,
    "response": response,
    "stutus_data_allow": stutusDataAllow,
    "stutus": stutus,
    "Message": message,
    "rowcount": rowcount,
    "tooltip_id": List<dynamic>.from(tooltipId.map((x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
    "total_members_count": totalMembersCount,
  };
}
