// To parse this JSON data, do
//
//     final fetchSiteReportsModel = fetchSiteReportsModelFromJson(jsonString);

import 'dart:convert';

FetchSiteReportsModel fetchSiteReportsModelFromJson(String str) => FetchSiteReportsModel.fromJson(json.decode(str));

String fetchSiteReportsModelToJson(FetchSiteReportsModel data) => json.encode(data.toJson());

class FetchSiteReportsModel {
  List<BookingBudgetHtml> budgetCount;
  List<BudgetCountTotal> budgetCountTotal;
  List<int> budgetInquiryCount;
  List<String> budgetPercentage;
  List<String> budgetRange;
  List<String> purposeBuy;
  int purposeTotalCount;
  List<int> purposeInquiryCount;
  List<PurposeCount> purposeCount;
  List<PurposeCountTotal> purposeCountTotal;
  List<dynamic> visitBudgetCount;
  List<VisitBudgetCountTotal> visitBudgetCountTotal;
  List<dynamic> visitBudgetInquiryCount;
  List<dynamic> visitBudgetPercentage;
  List<dynamic> visitBudgetRange;
  List<dynamic> visitPurposeBuy;
  int visitPurposeTotalCount;
  List<dynamic> visitPurposeInquiryCount;
  List<dynamic> visitPurposeWiseData;
  List<VisitPurposeWiseDataTotal> visitPurposeWiseDataTotal;
  List<dynamic> visitArea;
  int visitAreaTotalCount;
  List<dynamic> visitAreaInquiryCount;
  List<dynamic> visitAreaWiseData;
  List<VisitAreaWiseDatasTotal> visitAreaWiseDatasTotal;
  List<dynamic> visitSource;
  int visitSourceTotalCount;
  List<dynamic> visitSourceInquiryCount;
  List<dynamic> visitSourceWiseData;
  List<VisitSourceWiseDataTotal> visitSourceWiseDataTotal;
  List<dynamic> visitSize;
  int visitSizeTotalCount;
  List<dynamic> visitSizeInquiryCount;
  List<dynamic> visitSizeWiseData;
  List<VisitSizeWiseDataTotal> visitSizeWiseDataTotal;
  List<BookingBudgetHtml> bookingBudgetHtml;
  List<BookingBudgetHtmlTotal> bookingBudgetHtmlTotal;
  List<int> bookingBudgetInquiryCount;
  List<String> bookingBudgetPercentage;
  List<String> bookingBudgetRange;
  List<String> bookingSource;
  int bookingSourceTotalCount;
  List<int> bookingSourceInquiryCount;
  List<BookingSourceWiseDatum> bookingSourceWiseData;
  List<BookingSourceWiseDataTotal> bookingSourceWiseDataTotal;
  List<dynamic> bookingSize;
  int bookingSizeTotalCount;
  List<dynamic> bookingSizeInquiryCount;
  List<dynamic> bookingSizeWiseData;
  List<BookingSizeWiseDataTotal> bookingSizeWiseDataTotal;
  List<String> bookingArea;
  int bookingAreaTotalCount;
  List<int> bookingAreaInquiryCount;
  List<BookingAreaWiseDatum> bookingAreaWiseData;
  List<BookingAreaWiseDatasTotal> bookingAreaWiseDatasTotal;

  FetchSiteReportsModel({
    required this.budgetCount,
    required this.budgetCountTotal,
    required this.budgetInquiryCount,
    required this.budgetPercentage,
    required this.budgetRange,
    required this.purposeBuy,
    required this.purposeTotalCount,
    required this.purposeInquiryCount,
    required this.purposeCount,
    required this.purposeCountTotal,
    required this.visitBudgetCount,
    required this.visitBudgetCountTotal,
    required this.visitBudgetInquiryCount,
    required this.visitBudgetPercentage,
    required this.visitBudgetRange,
    required this.visitPurposeBuy,
    required this.visitPurposeTotalCount,
    required this.visitPurposeInquiryCount,
    required this.visitPurposeWiseData,
    required this.visitPurposeWiseDataTotal,
    required this.visitArea,
    required this.visitAreaTotalCount,
    required this.visitAreaInquiryCount,
    required this.visitAreaWiseData,
    required this.visitAreaWiseDatasTotal,
    required this.visitSource,
    required this.visitSourceTotalCount,
    required this.visitSourceInquiryCount,
    required this.visitSourceWiseData,
    required this.visitSourceWiseDataTotal,
    required this.visitSize,
    required this.visitSizeTotalCount,
    required this.visitSizeInquiryCount,
    required this.visitSizeWiseData,
    required this.visitSizeWiseDataTotal,
    required this.bookingBudgetHtml,
    required this.bookingBudgetHtmlTotal,
    required this.bookingBudgetInquiryCount,
    required this.bookingBudgetPercentage,
    required this.bookingBudgetRange,
    required this.bookingSource,
    required this.bookingSourceTotalCount,
    required this.bookingSourceInquiryCount,
    required this.bookingSourceWiseData,
    required this.bookingSourceWiseDataTotal,
    required this.bookingSize,
    required this.bookingSizeTotalCount,
    required this.bookingSizeInquiryCount,
    required this.bookingSizeWiseData,
    required this.bookingSizeWiseDataTotal,
    required this.bookingArea,
    required this.bookingAreaTotalCount,
    required this.bookingAreaInquiryCount,
    required this.bookingAreaWiseData,
    required this.bookingAreaWiseDatasTotal,
  });

  factory FetchSiteReportsModel.fromJson(Map<String, dynamic> json) => FetchSiteReportsModel(
    budgetCount: List<BookingBudgetHtml>.from(json["budget_count"].map((x) => BookingBudgetHtml.fromJson(x))),
    budgetCountTotal: List<BudgetCountTotal>.from(json["budget_count_total"].map((x) => BudgetCountTotal.fromJson(x))),
    budgetInquiryCount: List<int>.from(json["budget_inquiry_count"].map((x) => x)),
    budgetPercentage: List<String>.from(json["budget_percentage"].map((x) => x)),
    budgetRange: List<String>.from(json["budget_range"].map((x) => x)),
    purposeBuy: List<String>.from(json["purpose_buy"].map((x) => x)),
    purposeTotalCount: json["purpose_total_count"],
    purposeInquiryCount: List<int>.from(json["purpose_inquiry_count"].map((x) => x)),
    purposeCount: List<PurposeCount>.from(json["purpose_count"].map((x) => PurposeCount.fromJson(x))),
    purposeCountTotal: List<PurposeCountTotal>.from(json["purpose_count_total"].map((x) => PurposeCountTotal.fromJson(x))),
    visitBudgetCount: List<dynamic>.from(json["visit_budget_count"].map((x) => x)),
    visitBudgetCountTotal: List<VisitBudgetCountTotal>.from(json["visit_budget_count_total"].map((x) => VisitBudgetCountTotal.fromJson(x))),
    visitBudgetInquiryCount: List<dynamic>.from(json["visit_budget_inquiry_count"].map((x) => x)),
    visitBudgetPercentage: List<dynamic>.from(json["visit_budget_percentage"].map((x) => x)),
    visitBudgetRange: List<dynamic>.from(json["visit_budget_range"].map((x) => x)),
    visitPurposeBuy: List<dynamic>.from(json["visit_purpose_buy"].map((x) => x)),
    visitPurposeTotalCount: json["visit_purpose_total_count"],
    visitPurposeInquiryCount: List<dynamic>.from(json["visit_purpose_inquiry_count"].map((x) => x)),
    visitPurposeWiseData: List<dynamic>.from(json["visit_purpose_wise_data"].map((x) => x)),
    visitPurposeWiseDataTotal: List<VisitPurposeWiseDataTotal>.from(json["visit_purpose_wise_data_total"].map((x) => VisitPurposeWiseDataTotal.fromJson(x))),
    visitArea: List<dynamic>.from(json["visit_area"].map((x) => x)),
    visitAreaTotalCount: json["visit_area_total_count"],
    visitAreaInquiryCount: List<dynamic>.from(json["visit_area_inquiry_count"].map((x) => x)),
    visitAreaWiseData: List<dynamic>.from(json["visit_area_wise_data"].map((x) => x)),
    visitAreaWiseDatasTotal: List<VisitAreaWiseDatasTotal>.from(json["visit_area_wise_datas_total"].map((x) => VisitAreaWiseDatasTotal.fromJson(x))),
    visitSource: List<dynamic>.from(json["visit_source"].map((x) => x)),
    visitSourceTotalCount: json["visit_source_total_count"],
    visitSourceInquiryCount: List<dynamic>.from(json["visit_source_inquiry_count"].map((x) => x)),
    visitSourceWiseData: List<dynamic>.from(json["visit_source_wise_data"].map((x) => x)),
    visitSourceWiseDataTotal: List<VisitSourceWiseDataTotal>.from(json["visit_source_wise_data_total"].map((x) => VisitSourceWiseDataTotal.fromJson(x))),
    visitSize: List<dynamic>.from(json["visit_size"].map((x) => x)),
    visitSizeTotalCount: json["visit_size_total_count"],
    visitSizeInquiryCount: List<dynamic>.from(json["visit_size_inquiry_count"].map((x) => x)),
    visitSizeWiseData: List<dynamic>.from(json["visit_size_wise_data"].map((x) => x)),
    visitSizeWiseDataTotal: List<VisitSizeWiseDataTotal>.from(json["visit_size_wise_data_total"].map((x) => VisitSizeWiseDataTotal.fromJson(x))),
    bookingBudgetHtml: List<BookingBudgetHtml>.from(json["booking_budget_html"].map((x) => BookingBudgetHtml.fromJson(x))),
    bookingBudgetHtmlTotal: List<BookingBudgetHtmlTotal>.from(json["booking_budget_html_total"].map((x) => BookingBudgetHtmlTotal.fromJson(x))),
    bookingBudgetInquiryCount: List<int>.from(json["booking_budget_inquiry_count"].map((x) => x)),
    bookingBudgetPercentage: List<String>.from(json["booking_budget_percentage"].map((x) => x)),
    bookingBudgetRange: List<String>.from(json["booking_budget_range"].map((x) => x)),
    bookingSource: List<String>.from(json["booking_source"].map((x) => x)),
    bookingSourceTotalCount: json["booking_source_total_count"],
    bookingSourceInquiryCount: List<int>.from(json["booking_source_inquiry_count"].map((x) => x)),
    bookingSourceWiseData: List<BookingSourceWiseDatum>.from(json["booking_source_wise_data"].map((x) => BookingSourceWiseDatum.fromJson(x))),
    bookingSourceWiseDataTotal: List<BookingSourceWiseDataTotal>.from(json["booking_source_wise_data_total"].map((x) => BookingSourceWiseDataTotal.fromJson(x))),
    bookingSize: List<dynamic>.from(json["booking_size"].map((x) => x)),
    bookingSizeTotalCount: json["booking_size_total_count"],
    bookingSizeInquiryCount: List<dynamic>.from(json["booking_size_inquiry_count"].map((x) => x)),
    bookingSizeWiseData: List<dynamic>.from(json["booking_size_wise_data"].map((x) => x)),
    bookingSizeWiseDataTotal: List<BookingSizeWiseDataTotal>.from(json["booking_size_wise_data_total"].map((x) => BookingSizeWiseDataTotal.fromJson(x))),
    bookingArea: List<String>.from(json["booking_area"].map((x) => x)),
    bookingAreaTotalCount: json["booking_area_total_count"],
    bookingAreaInquiryCount: List<int>.from(json["booking_area_inquiry_count"].map((x) => x)),
    bookingAreaWiseData: List<BookingAreaWiseDatum>.from(json["booking_area_wise_data"].map((x) => BookingAreaWiseDatum.fromJson(x))),
    bookingAreaWiseDatasTotal: List<BookingAreaWiseDatasTotal>.from(json["booking_area_wise_datas_total"].map((x) => BookingAreaWiseDatasTotal.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "budget_count": List<dynamic>.from(budgetCount.map((x) => x.toJson())),
    "budget_count_total": List<dynamic>.from(budgetCountTotal.map((x) => x.toJson())),
    "budget_inquiry_count": List<dynamic>.from(budgetInquiryCount.map((x) => x)),
    "budget_percentage": List<dynamic>.from(budgetPercentage.map((x) => x)),
    "budget_range": List<dynamic>.from(budgetRange.map((x) => x)),
    "purpose_buy": List<dynamic>.from(purposeBuy.map((x) => x)),
    "purpose_total_count": purposeTotalCount,
    "purpose_inquiry_count": List<dynamic>.from(purposeInquiryCount.map((x) => x)),
    "purpose_count": List<dynamic>.from(purposeCount.map((x) => x.toJson())),
    "purpose_count_total": List<dynamic>.from(purposeCountTotal.map((x) => x.toJson())),
    "visit_budget_count": List<dynamic>.from(visitBudgetCount.map((x) => x)),
    "visit_budget_count_total": List<dynamic>.from(visitBudgetCountTotal.map((x) => x.toJson())),
    "visit_budget_inquiry_count": List<dynamic>.from(visitBudgetInquiryCount.map((x) => x)),
    "visit_budget_percentage": List<dynamic>.from(visitBudgetPercentage.map((x) => x)),
    "visit_budget_range": List<dynamic>.from(visitBudgetRange.map((x) => x)),
    "visit_purpose_buy": List<dynamic>.from(visitPurposeBuy.map((x) => x)),
    "visit_purpose_total_count": visitPurposeTotalCount,
    "visit_purpose_inquiry_count": List<dynamic>.from(visitPurposeInquiryCount.map((x) => x)),
    "visit_purpose_wise_data": List<dynamic>.from(visitPurposeWiseData.map((x) => x)),
    "visit_purpose_wise_data_total": List<dynamic>.from(visitPurposeWiseDataTotal.map((x) => x.toJson())),
    "visit_area": List<dynamic>.from(visitArea.map((x) => x)),
    "visit_area_total_count": visitAreaTotalCount,
    "visit_area_inquiry_count": List<dynamic>.from(visitAreaInquiryCount.map((x) => x)),
    "visit_area_wise_data": List<dynamic>.from(visitAreaWiseData.map((x) => x)),
    "visit_area_wise_datas_total": List<dynamic>.from(visitAreaWiseDatasTotal.map((x) => x.toJson())),
    "visit_source": List<dynamic>.from(visitSource.map((x) => x)),
    "visit_source_total_count": visitSourceTotalCount,
    "visit_source_inquiry_count": List<dynamic>.from(visitSourceInquiryCount.map((x) => x)),
    "visit_source_wise_data": List<dynamic>.from(visitSourceWiseData.map((x) => x)),
    "visit_source_wise_data_total": List<dynamic>.from(visitSourceWiseDataTotal.map((x) => x.toJson())),
    "visit_size": List<dynamic>.from(visitSize.map((x) => x)),
    "visit_size_total_count": visitSizeTotalCount,
    "visit_size_inquiry_count": List<dynamic>.from(visitSizeInquiryCount.map((x) => x)),
    "visit_size_wise_data": List<dynamic>.from(visitSizeWiseData.map((x) => x)),
    "visit_size_wise_data_total": List<dynamic>.from(visitSizeWiseDataTotal.map((x) => x.toJson())),
    "booking_budget_html": List<dynamic>.from(bookingBudgetHtml.map((x) => x.toJson())),
    "booking_budget_html_total": List<dynamic>.from(bookingBudgetHtmlTotal.map((x) => x.toJson())),
    "booking_budget_inquiry_count": List<dynamic>.from(bookingBudgetInquiryCount.map((x) => x)),
    "booking_budget_percentage": List<dynamic>.from(bookingBudgetPercentage.map((x) => x)),
    "booking_budget_range": List<dynamic>.from(bookingBudgetRange.map((x) => x)),
    "booking_source": List<dynamic>.from(bookingSource.map((x) => x)),
    "booking_source_total_count": bookingSourceTotalCount,
    "booking_source_inquiry_count": List<dynamic>.from(bookingSourceInquiryCount.map((x) => x)),
    "booking_source_wise_data": List<dynamic>.from(bookingSourceWiseData.map((x) => x.toJson())),
    "booking_source_wise_data_total": List<dynamic>.from(bookingSourceWiseDataTotal.map((x) => x.toJson())),
    "booking_size": List<dynamic>.from(bookingSize.map((x) => x)),
    "booking_size_total_count": bookingSizeTotalCount,
    "booking_size_inquiry_count": List<dynamic>.from(bookingSizeInquiryCount.map((x) => x)),
    "booking_size_wise_data": List<dynamic>.from(bookingSizeWiseData.map((x) => x)),
    "booking_size_wise_data_total": List<dynamic>.from(bookingSizeWiseDataTotal.map((x) => x.toJson())),
    "booking_area": List<dynamic>.from(bookingArea.map((x) => x)),
    "booking_area_total_count": bookingAreaTotalCount,
    "booking_area_inquiry_count": List<dynamic>.from(bookingAreaInquiryCount.map((x) => x)),
    "booking_area_wise_data": List<dynamic>.from(bookingAreaWiseData.map((x) => x.toJson())),
    "booking_area_wise_datas_total": List<dynamic>.from(bookingAreaWiseDatasTotal.map((x) => x.toJson())),
  };
}

class BookingAreaWiseDatum {
  String area;
  String total;

  BookingAreaWiseDatum({
    required this.area,
    required this.total,
  });

  factory BookingAreaWiseDatum.fromJson(Map<String, dynamic> json) => BookingAreaWiseDatum(
    area: json["area"],
    total: json["Total"],
  );

  Map<String, dynamic> toJson() => {
    "area": area,
    "Total": total,
  };
}

class BookingAreaWiseDatasTotal {
  String total;
  int bookingAreaTotalCounts;

  BookingAreaWiseDatasTotal({
    required this.total,
    required this.bookingAreaTotalCounts,
  });

  factory BookingAreaWiseDatasTotal.fromJson(Map<String, dynamic> json) => BookingAreaWiseDatasTotal(
    total: json["Total"],
    bookingAreaTotalCounts: json["booking_area_total_counts"],
  );

  Map<String, dynamic> toJson() => {
    "Total": total,
    "booking_area_total_counts": bookingAreaTotalCounts,
  };
}

class BookingBudgetHtml {
  String budgetRange;
  String inquiryCount;

  BookingBudgetHtml({
    required this.budgetRange,
    required this.inquiryCount,
  });

  factory BookingBudgetHtml.fromJson(Map<String, dynamic> json) => BookingBudgetHtml(
    budgetRange: json["budget_range"],
    inquiryCount: json["inquiry_count"],
  );

  Map<String, dynamic> toJson() => {
    "budget_range": budgetRange,
    "inquiry_count": inquiryCount,
  };
}

class BookingBudgetHtmlTotal {
  String total;
  int bookingBudgetTotalCount;

  BookingBudgetHtmlTotal({
    required this.total,
    required this.bookingBudgetTotalCount,
  });

  factory BookingBudgetHtmlTotal.fromJson(Map<String, dynamic> json) => BookingBudgetHtmlTotal(
    total: json["Total"],
    bookingBudgetTotalCount: json["booking_budget_total_count"],
  );

  Map<String, dynamic> toJson() => {
    "Total": total,
    "booking_budget_total_count": bookingBudgetTotalCount,
  };
}

class BookingSizeWiseDataTotal {
  String total;
  int bookingSizeTotalCount;

  BookingSizeWiseDataTotal({
    required this.total,
    required this.bookingSizeTotalCount,
  });

  factory BookingSizeWiseDataTotal.fromJson(Map<String, dynamic> json) => BookingSizeWiseDataTotal(
    total: json["Total"],
    bookingSizeTotalCount: json["booking_size_total_count"],
  );

  Map<String, dynamic> toJson() => {
    "Total": total,
    "booking_size_total_count": bookingSizeTotalCount,
  };
}

class BookingSourceWiseDatum {
  String source;
  String total;

  BookingSourceWiseDatum({
    required this.source,
    required this.total,
  });

  factory BookingSourceWiseDatum.fromJson(Map<String, dynamic> json) => BookingSourceWiseDatum(
    source: json["source"],
    total: json["Total"],
  );

  Map<String, dynamic> toJson() => {
    "source": source,
    "Total": total,
  };
}

class BookingSourceWiseDataTotal {
  String total;
  int bookingSourceTotalCount;

  BookingSourceWiseDataTotal({
    required this.total,
    required this.bookingSourceTotalCount,
  });

  factory BookingSourceWiseDataTotal.fromJson(Map<String, dynamic> json) => BookingSourceWiseDataTotal(
    total: json["Total"],
    bookingSourceTotalCount: json["booking_source_total_count"],
  );

  Map<String, dynamic> toJson() => {
    "Total": total,
    "booking_source_total_count": bookingSourceTotalCount,
  };
}

class BudgetCountTotal {
  String total;
  int budgetTotalCount;

  BudgetCountTotal({
    required this.total,
    required this.budgetTotalCount,
  });

  factory BudgetCountTotal.fromJson(Map<String, dynamic> json) => BudgetCountTotal(
    total: json["Total"],
    budgetTotalCount: json["budget_total_count"],
  );

  Map<String, dynamic> toJson() => {
    "Total": total,
    "budget_total_count": budgetTotalCount,
  };
}

class PurposeCount {
  String purposeBuy;
  String total;

  PurposeCount({
    required this.purposeBuy,
    required this.total,
  });

  factory PurposeCount.fromJson(Map<String, dynamic> json) => PurposeCount(
    purposeBuy: json["purpose_buy"],
    total: json["Total"],
  );

  Map<String, dynamic> toJson() => {
    "purpose_buy": purposeBuy,
    "Total": total,
  };
}

class PurposeCountTotal {
  String total;
  int purposeTotalCount;

  PurposeCountTotal({
    required this.total,
    required this.purposeTotalCount,
  });

  factory PurposeCountTotal.fromJson(Map<String, dynamic> json) => PurposeCountTotal(
    total: json["Total"],
    purposeTotalCount: json["purpose_total_count"],
  );

  Map<String, dynamic> toJson() => {
    "Total": total,
    "purpose_total_count": purposeTotalCount,
  };
}

class VisitAreaWiseDatasTotal {
  String total;
  int visitAreaTotalCounts;

  VisitAreaWiseDatasTotal({
    required this.total,
    required this.visitAreaTotalCounts,
  });

  factory VisitAreaWiseDatasTotal.fromJson(Map<String, dynamic> json) => VisitAreaWiseDatasTotal(
    total: json["Total"],
    visitAreaTotalCounts: json["visit_area_total_counts"],
  );

  Map<String, dynamic> toJson() => {
    "Total": total,
    "visit_area_total_counts": visitAreaTotalCounts,
  };
}

class VisitBudgetCountTotal {
  String total;
  int visitBudgetTotalCount;

  VisitBudgetCountTotal({
    required this.total,
    required this.visitBudgetTotalCount,
  });

  factory VisitBudgetCountTotal.fromJson(Map<String, dynamic> json) => VisitBudgetCountTotal(
    total: json["Total"],
    visitBudgetTotalCount: json["visit_budget_total_count"],
  );

  Map<String, dynamic> toJson() => {
    "Total": total,
    "visit_budget_total_count": visitBudgetTotalCount,
  };
}

class VisitPurposeWiseDataTotal {
  String total;
  int visitPurposeTotalCount;

  VisitPurposeWiseDataTotal({
    required this.total,
    required this.visitPurposeTotalCount,
  });

  factory VisitPurposeWiseDataTotal.fromJson(Map<String, dynamic> json) => VisitPurposeWiseDataTotal(
    total: json["Total"],
    visitPurposeTotalCount: json["visit_purpose_total_count"],
  );

  Map<String, dynamic> toJson() => {
    "Total": total,
    "visit_purpose_total_count": visitPurposeTotalCount,
  };
}

class VisitSizeWiseDataTotal {
  String total;
  int visitSizeTotalCount;

  VisitSizeWiseDataTotal({
    required this.total,
    required this.visitSizeTotalCount,
  });

  factory VisitSizeWiseDataTotal.fromJson(Map<String, dynamic> json) => VisitSizeWiseDataTotal(
    total: json["Total"],
    visitSizeTotalCount: json["visit_size_total_count"],
  );

  Map<String, dynamic> toJson() => {
    "Total": total,
    "visit_size_total_count": visitSizeTotalCount,
  };
}

class VisitSourceWiseDataTotal {
  String total;
  int visitSourceTotalCount;

  VisitSourceWiseDataTotal({
    required this.total,
    required this.visitSourceTotalCount,
  });

  factory VisitSourceWiseDataTotal.fromJson(Map<String, dynamic> json) => VisitSourceWiseDataTotal(
    total: json["Total"],
    visitSourceTotalCount: json["visit_source_total_count"],
  );

  Map<String, dynamic> toJson() => {
    "Total": total,
    "visit_source_total_count": visitSourceTotalCount,
  };
}