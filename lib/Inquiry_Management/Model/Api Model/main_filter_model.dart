// To parse this JSON data, do
//
//     final allInquiryFilter = allInquiryFilterFromJson(jsonString);

import 'dart:convert';

AllInquiryFilter allInquiryFilterFromJson(String str) => AllInquiryFilter.fromJson(json.decode(str));

String allInquiryFilterToJson(AllInquiryFilter data) => json.encode(data.toJson());

class AllInquiryFilter {
  int status;
  String message;
  Pagination pagination;
  List<Map<String, String>> inquiries;

  AllInquiryFilter({
    required this.status,
    required this.message,
    required this.pagination,
    required this.inquiries,
  });

  factory AllInquiryFilter.fromJson(Map<String, dynamic> json) => AllInquiryFilter(
    status: json["status"],
    message: json["message"],
    pagination: Pagination.fromJson(json["pagination"]),
    inquiries: List<Map<String, String>>.from(json["inquiries"].map((x) => Map.from(x).map((k, v) => MapEntry<String, String>(k, v)))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "pagination": pagination.toJson(),
    "inquiries": List<dynamic>.from(inquiries.map((x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
  };
}

class Pagination {
  int currentPage;
  int totalPages;
  int totalRecords;
  int perPage;

  Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalRecords,
    required this.perPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    currentPage: json["current_page"],
    totalPages: json["total_pages"],
    totalRecords: json["total_records"],
    perPage: json["per_page"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "total_pages": totalPages,
    "total_records": totalRecords,
    "per_page": perPage,
  };
}
