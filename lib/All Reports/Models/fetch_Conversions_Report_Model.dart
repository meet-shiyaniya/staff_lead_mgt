// To parse this JSON data, do
//
//     final fetchConversionsReportModel = fetchConversionsReportModelFromJson(jsonString);

import 'dart:convert';

FetchConversionsReportModel fetchConversionsReportModelFromJson(String str) => FetchConversionsReportModel.fromJson(json.decode(str));

String fetchConversionsReportModelToJson(FetchConversionsReportModel data) => json.encode(data.toJson());

class FetchConversionsReportModel {
  int status;
  String message;
  SiteReport siteReport;
  UserReport userReport;
  SourceReport sourceReport;

  FetchConversionsReportModel({
    required this.status,
    required this.message,
    required this.siteReport,
    required this.userReport,
    required this.sourceReport,
  });

  factory FetchConversionsReportModel.fromJson(Map<String, dynamic> json) => FetchConversionsReportModel(
    status: json["status"],
    message: json["message"],
    siteReport: SiteReport.fromJson(json["site_report"]),
    userReport: UserReport.fromJson(json["user_report"]),
    sourceReport: SourceReport.fromJson(json["source_report"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "site_report": siteReport.toJson(),
    "user_report": userReport.toJson(),
    "source_report": sourceReport.toJson(),
  };
}

class SiteReport {
  List<SiteReportDatum> data;
  List<TotalElement> totals;
  int finalTotalBooking;
  int finalTotalCancel;
  int moreData;

  SiteReport({
    required this.data,
    required this.totals,
    required this.finalTotalBooking,
    required this.finalTotalCancel,
    required this.moreData,
  });

  factory SiteReport.fromJson(Map<String, dynamic> json) => SiteReport(
    data: List<SiteReportDatum>.from(json["data"].map((x) => SiteReportDatum.fromJson(x))),
    totals: List<TotalElement>.from(json["totals"].map((x) => TotalElement.fromJson(x))),
    finalTotalBooking: json["final_total_booking"],
    finalTotalCancel: json["final_total_cancel"],
    moreData: json["more_data"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "totals": List<dynamic>.from(totals.map((x) => x.toJson())),
    "final_total_booking": finalTotalBooking,
    "final_total_cancel": finalTotalCancel,
    "more_data": moreData,
  };
}

class SiteReportDatum {
  String userName;
  String isInactive;
  List<PurpleMonth> months;
  int totalBooking;
  int totalCancel;

  SiteReportDatum({
    required this.userName,
    required this.isInactive,
    required this.months,
    required this.totalBooking,
    required this.totalCancel,
  });

  factory SiteReportDatum.fromJson(Map<String, dynamic> json) => SiteReportDatum(
    userName: json["user_name"],
    isInactive: json["is_inactive"],
    months: List<PurpleMonth>.from(json["months"].map((x) => PurpleMonth.fromJson(x))),
    totalBooking: json["total_booking"],
    totalCancel: json["total_cancel"],
  );

  Map<String, dynamic> toJson() => {
    "user_name": userName,
    "is_inactive": isInactive,
    "months": List<dynamic>.from(months.map((x) => x.toJson())),
    "total_booking": totalBooking,
    "total_cancel": totalCancel,
  };
}

class PurpleMonth {
  String month;
  dynamic visitCount;
  dynamic cancelBookingCount;

  PurpleMonth({
    required this.month,
    required this.visitCount,
    required this.cancelBookingCount,
  });

  factory PurpleMonth.fromJson(Map<String, dynamic> json) => PurpleMonth(
    month: json["month"],
    visitCount: json["visit_count"],
    cancelBookingCount: json["cancel_booking_count"],
  );

  Map<String, dynamic> toJson() => {
    "month": month,
    "visit_count": visitCount,
    "cancel_booking_count": cancelBookingCount,
  };
}

class TotalElement {
  String month;
  int totalBooking;
  int totalCancel;

  TotalElement({
    required this.month,
    required this.totalBooking,
    required this.totalCancel,
  });

  factory TotalElement.fromJson(Map<String, dynamic> json) => TotalElement(
    month: json["month"],
    totalBooking: json["total_booking"],
    totalCancel: json["total_cancel"],
  );

  Map<String, dynamic> toJson() => {
    "month": month,
    "total_booking": totalBooking,
    "total_cancel": totalCancel,
  };
}

class SourceReport {
  List<String> sourceArray;
  List<SourceTotalElement> sourceTotal;
  List<SourcedataWise> sourcedataWise;
  SourceTotalElement total;

  SourceReport({
    required this.sourceArray,
    required this.sourceTotal,
    required this.sourcedataWise,
    required this.total,
  });

  factory SourceReport.fromJson(Map<String, dynamic> json) => SourceReport(
    sourceArray: List<String>.from(json["Source_array"].map((x) => x)),
    sourceTotal: List<SourceTotalElement>.from(json["Source_total"].map((x) => SourceTotalElement.fromJson(x))),
    sourcedataWise: List<SourcedataWise>.from(json["Sourcedata_wise"].map((x) => SourcedataWise.fromJson(x))),
    total: SourceTotalElement.fromJson(json["Total"]),
  );

  Map<String, dynamic> toJson() => {
    "Source_array": List<dynamic>.from(sourceArray.map((x) => x)),
    "Source_total": List<dynamic>.from(sourceTotal.map((x) => x.toJson())),
    "Sourcedata_wise": List<dynamic>.from(sourcedataWise.map((x) => x.toJson())),
    "Total": total.toJson(),
  };
}

class SourceTotalElement {
  int liveCount;
  int cancelCount;

  SourceTotalElement({
    required this.liveCount,
    required this.cancelCount,
  });

  factory SourceTotalElement.fromJson(Map<String, dynamic> json) => SourceTotalElement(
    liveCount: json["live_count"],
    cancelCount: json["cancel_count"],
  );

  Map<String, dynamic> toJson() => {
    "live_count": liveCount,
    "cancel_count": cancelCount,
  };
}

class SourcedataWise {
  String name;
  List<SourcedataWiseDatum> data;

  SourcedataWise({
    required this.name,
    required this.data,
  });

  factory SourcedataWise.fromJson(Map<String, dynamic> json) => SourcedataWise(
    name: json["name"],
    data: List<SourcedataWiseDatum>.from(json["data"].map((x) => SourcedataWiseDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class SourcedataWiseDatum {
  dynamic pshortName;
  dynamic liveCount;
  dynamic cancelCount;

  SourcedataWiseDatum({
    required this.pshortName,
    required this.liveCount,
    required this.cancelCount,
  });

  factory SourcedataWiseDatum.fromJson(Map<String, dynamic> json) => SourcedataWiseDatum(
    pshortName: json["p_shortname"],
    liveCount: json["live_count"],
    cancelCount: json["cancel_count"],
  );

  Map<String, dynamic> toJson() => {
    "p_shortname": pshortName,
    "live_count": liveCount,
    "cancel_count": cancelCount,
  };
}

class UserReport {
  List<UserReportDatum> data;
  List<TotalElement> totals;
  int finalTotalBooking;
  int finalTotalCancel;
  int moreData;

  UserReport({
    required this.data,
    required this.totals,
    required this.finalTotalBooking,
    required this.finalTotalCancel,
    required this.moreData,
  });

  factory UserReport.fromJson(Map<String, dynamic> json) => UserReport(
    data: List<UserReportDatum>.from(json["data"].map((x) => UserReportDatum.fromJson(x))),
    totals: List<TotalElement>.from(json["totals"].map((x) => TotalElement.fromJson(x))),
    finalTotalBooking: json["final_total_booking"],
    finalTotalCancel: json["final_total_cancel"],
    moreData: json["more_data"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "totals": List<dynamic>.from(totals.map((x) => x.toJson())),
    "final_total_booking": finalTotalBooking,
    "final_total_cancel": finalTotalCancel,
    "more_data": moreData,
  };
}

class UserReportDatum {
  String userName;
  bool isActive;
  List<FluffyMonth> months;
  int totalBooking;
  int totalCancel;

  UserReportDatum({
    required this.userName,
    required this.isActive,
    required this.months,
    required this.totalBooking,
    required this.totalCancel,
  });

  factory UserReportDatum.fromJson(Map<String, dynamic> json) => UserReportDatum(
    userName: json["user_name"],
    isActive: json["is_active"],
    months: List<FluffyMonth>.from(json["months"].map((x) => FluffyMonth.fromJson(x))),
    totalBooking: json["total_booking"],
    totalCancel: json["total_cancel"],
  );

  Map<String, dynamic> toJson() => {
    "user_name": userName,
    "is_active": isActive,
    "months": List<dynamic>.from(months.map((x) => x.toJson())),
    "total_booking": totalBooking,
    "total_cancel": totalCancel,
  };
}

class FluffyMonth {
  String month;
  dynamic bookingCount;
  dynamic cancelBookingCount;

  FluffyMonth({
    required this.month,
    required this.bookingCount,
    required this.cancelBookingCount,
  });

  factory FluffyMonth.fromJson(Map<String, dynamic> json) => FluffyMonth(
    month: json["month"],
    bookingCount: json["booking_count"],
    cancelBookingCount: json["cancel_booking_count"],
  );

  Map<String, dynamic> toJson() => {
    "month": month,
    "booking_count": bookingCount,
    "cancel_booking_count": cancelBookingCount,
  };
}