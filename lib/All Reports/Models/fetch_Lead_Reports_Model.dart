// // To parse this JSON data, do
// //
// //     final fetchLeadReportsModel = fetchLeadReportsModelFromJson(jsonString);
//
// import 'dart:convert';
//
// FetchLeadReportsModel fetchLeadReportsModelFromJson(String str) => FetchLeadReportsModel.fromJson(json.decode(str));
//
// String fetchLeadReportsModelToJson(FetchLeadReportsModel data) => json.encode(data.toJson());
//
// class FetchLeadReportsModel {
//   int status;
//   String message;
//   CampaignReport campaignReport;
//   LeadReport leadReport;
//
//   FetchLeadReportsModel({
//     required this.status,
//     required this.message,
//     required this.campaignReport,
//     required this.leadReport,
//   });
//
//   factory FetchLeadReportsModel.fromJson(Map<String, dynamic> json) => FetchLeadReportsModel(
//     status: json["status"],
//     message: json["message"],
//     campaignReport: CampaignReport.fromJson(json["campaign_report"]),
//     leadReport: LeadReport.fromJson(json["lead_report"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "status": status,
//     "message": message,
//     "campaign_report": campaignReport.toJson(),
//     "lead_report": leadReport.toJson(),
//   };
// }
//
// class CampaignReport {
//   List<Campaign> campaigns;
//   Totals totals;
//
//   CampaignReport({
//     required this.campaigns,
//     required this.totals,
//   });
//
//   factory CampaignReport.fromJson(Map<String, dynamic> json) => CampaignReport(
//     campaigns: List<Campaign>.from(json["campaigns"].map((x) => Campaign.fromJson(x))),
//     totals: Totals.fromJson(json["totals"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "campaigns": List<dynamic>.from(campaigns.map((x) => x.toJson())),
//     "totals": totals.toJson(),
//   };
// }
//
// class Campaign {
//   String campaignName;
//   List<Ad> ads;
//   int totalInquiry;
//   int totalLead;
//   int totalVisit;
//   int totalBooking;
//
//   Campaign({
//     required this.campaignName,
//     required this.ads,
//     required this.totalInquiry,
//     required this.totalLead,
//     required this.totalVisit,
//     required this.totalBooking,
//   });
//
//   factory Campaign.fromJson(Map<String, dynamic> json) => Campaign(
//     campaignName: json["campaign_name"],
//     ads: List<Ad>.from(json["ads"].map((x) => Ad.fromJson(x))),
//     totalInquiry: json["total_inquiry"],
//     totalLead: json["total_lead"],
//     totalVisit: json["total_visit"],
//     totalBooking: json["total_booking"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "campaign_name": campaignName,
//     "ads": List<dynamic>.from(ads.map((x) => x.toJson())),
//     "total_inquiry": totalInquiry,
//     "total_lead": totalLead,
//     "total_visit": totalVisit,
//     "total_booking": totalBooking,
//   };
// }
//
// class Ad {
//   String adsetName;
//   String adName;
//   String inquiryCount;
//   String leadCount;
//   String inquiryVisitsCount;
//   String inquiryBookingCount;
//
//   Ad({
//     required this.adsetName,
//     required this.adName,
//     required this.inquiryCount,
//     required this.leadCount,
//     required this.inquiryVisitsCount,
//     required this.inquiryBookingCount,
//   });
//
//   factory Ad.fromJson(Map<String, dynamic> json) => Ad(
//     adsetName: json["adset_name"],
//     adName: json["ad_name"],
//     inquiryCount: json["inquiry_count"],
//     leadCount: json["lead_count"],
//     inquiryVisitsCount: json["inquiry_visits_count"],
//     inquiryBookingCount: json["inquiry_booking_count"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "adset_name": adsetName,
//     "ad_name": adName,
//     "inquiry_count": inquiryCount,
//     "lead_count": leadCount,
//     "inquiry_visits_count": inquiryVisitsCount,
//     "inquiry_booking_count": inquiryBookingCount,
//   };
// }
//
// class Totals {
//   int finalTotalInquiry;
//   int finalTotalLead;
//   int finalTotalVisit;
//   int finalTotalBooking;
//   String faildInquiryCount;
//   int faildLeadCount;
//   String faildVisitCount;
//   String faildBookingCount;
//
//   Totals({
//     required this.finalTotalInquiry,
//     required this.finalTotalLead,
//     required this.finalTotalVisit,
//     required this.finalTotalBooking,
//     required this.faildInquiryCount,
//     required this.faildLeadCount,
//     required this.faildVisitCount,
//     required this.faildBookingCount,
//   });
//
//   factory Totals.fromJson(Map<String, dynamic> json) => Totals(
//     finalTotalInquiry: json["final_total_inquiry"],
//     finalTotalLead: json["final_total_lead"],
//     finalTotalVisit: json["final_total_visit"],
//     finalTotalBooking: json["final_total_booking"],
//     faildInquiryCount: json["faild_inquiry_count"],
//     faildLeadCount: json["faild_lead_count"],
//     faildVisitCount: json["faild_visit_count"],
//     faildBookingCount: json["faild_booking_count"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "final_total_inquiry": finalTotalInquiry,
//     "final_total_lead": finalTotalLead,
//     "final_total_visit": finalTotalVisit,
//     "final_total_booking": finalTotalBooking,
//     "faild_inquiry_count": faildInquiryCount,
//     "faild_lead_count": faildLeadCount,
//     "faild_visit_count": faildVisitCount,
//     "faild_booking_count": faildBookingCount,
//   };
// }
//
// class LeadReport {
//   List<Datum> data;
//   List<List<ExportDatum>> exportData;
//
//   LeadReport({
//     required this.data,
//     required this.exportData,
//   });
//
//   factory LeadReport.fromJson(Map<String, dynamic> json) => LeadReport(
//     data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
//     exportData: List<List<ExportDatum>>.from(json["export_data"].map((x) => List<ExportDatum>.from(x.map((x) => ExportDatum.fromJson(x))))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "data": List<dynamic>.from(data.map((x) => x.toJson())),
//     "export_data": List<dynamic>.from(exportData.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
//   };
// }
//
// class Datum {
//   String timePeriod;
//   dynamic product2;
//   dynamic product7;
//   dynamic product20;
//   int total;
//
//   Datum({
//     required this.timePeriod,
//     required this.product2,
//     required this.product7,
//     required this.product20,
//     required this.total,
//   });
//
//   factory Datum.fromJson(Map<String, dynamic> json) => Datum(
//     timePeriod: json["time_period"],
//     product2: json["product_2"],
//     product7: json["product_7"],
//     product20: json["product_20"],
//     total: json["total"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "time_period": timePeriod,
//     "product_2": product2,
//     "product_7": product7,
//     "product_20": product20,
//     "total": total,
//   };
// }
//
// class ExportDatum {
//   String productName;
//   dynamic bookingCount;
//   MonthName monthName;
//   String cancelBookingCount;
//
//   ExportDatum({
//     required this.productName,
//     required this.bookingCount,
//     required this.monthName,
//     required this.cancelBookingCount,
//   });
//
//   factory ExportDatum.fromJson(Map<String, dynamic> json) => ExportDatum(
//     productName: json["product_name"],
//     bookingCount: json["booking_count"],
//     monthName: monthNameValues.map[json["month_name"]]!,
//     cancelBookingCount: json["cancel_booking_count"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "product_name": productName,
//     "booking_count": bookingCount,
//     "month_name": monthNameValues.reverse[monthName],
//     "cancel_booking_count": cancelBookingCount,
//   };
// }
//
// enum MonthName {
//   ANB,
//   BEH,
//   MRV,
//   STV,
//   CPH,
//   GNB,
//   MDV,
//   AMV,
//   KKB
// }
//
// final monthNameValues = EnumValues({
//   "ANB": MonthName.ANB,
//   "BEH": MonthName.BEH,
//   "MRV": MonthName.MRV,
//   "STV": MonthName.STV,
//   "CPH": MonthName.CPH,
//   "GNB": MonthName.GNB,
//   "MDV": MonthName.MDV,
//   "AMV": MonthName.AMV,
//   "KKB": MonthName.KKB
// });
//
// class EnumValues<T> {
//   Map<String, T> map;
//   late Map<T, String> reverseMap;
//
//   EnumValues(this.map);
//
//   Map<T, String> get reverse {
//     reverseMap = map.map((k, v) => MapEntry(v, k));
//     return reverseMap;
//   }
// }


import 'dart:convert';

FetchLeadReportsModel fetchLeadReportsModelFromJson(String str) => FetchLeadReportsModel.fromJson(json.decode(str));

String fetchLeadReportsModelToJson(FetchLeadReportsModel data) => json.encode(data.toJson());

class FetchLeadReportsModel {
  int status;
  String message;
  CampaignReport campaignReport;
  LeadReport leadReport;

  FetchLeadReportsModel({
    required this.status,
    required this.message,
    required this.campaignReport,
    required this.leadReport,
  });

  factory FetchLeadReportsModel.fromJson(Map<String, dynamic> json) => FetchLeadReportsModel(
    status: json["status"],
    message: json["message"],
    campaignReport: CampaignReport.fromJson(json["campaign_report"]),
    leadReport: LeadReport.fromJson(json["lead_report"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "campaign_report": campaignReport.toJson(),
    "lead_report": leadReport.toJson(),
  };
}

class CampaignReport {
  List<Campaign> campaigns;
  Totals totals;

  CampaignReport({
    required this.campaigns,
    required this.totals,
  });

  factory CampaignReport.fromJson(Map<String, dynamic> json) => CampaignReport(
    campaigns: List<Campaign>.from(json["campaigns"].map((x) => Campaign.fromJson(x))),
    totals: Totals.fromJson(json["totals"]),
  );

  Map<String, dynamic> toJson() => {
    "campaigns": List<dynamic>.from(campaigns.map((x) => x.toJson())),
    "totals": totals.toJson(),
  };
}

class Campaign {
  String campaignName;
  List<Ad> ads;
  int totalInquiry;
  int totalLead;
  int totalVisit;
  int totalBooking;

  Campaign({
    required this.campaignName,
    required this.ads,
    required this.totalInquiry,
    required this.totalLead,
    required this.totalVisit,
    required this.totalBooking,
  });

  factory Campaign.fromJson(Map<String, dynamic> json) => Campaign(
    campaignName: json["campaign_name"],
    ads: List<Ad>.from(json["ads"].map((x) => Ad.fromJson(x))),
    totalInquiry: json["total_inquiry"],
    totalLead: json["total_lead"],
    totalVisit: json["total_visit"],
    totalBooking: json["total_booking"],
  );

  Map<String, dynamic> toJson() => {
    "campaign_name": campaignName,
    "ads": List<dynamic>.from(ads.map((x) => x.toJson())),
    "total_inquiry": totalInquiry,
    "total_lead": totalLead,
    "total_visit": totalVisit,
    "total_booking": totalBooking,
  };
}

class Ad {
  String adsetName;
  String adName;
  String inquiryCount;
  String leadCount;
  String inquiryVisitsCount;
  String inquiryBookingCount;

  Ad({
    required this.adsetName,
    required this.adName,
    required this.inquiryCount,
    required this.leadCount,
    required this.inquiryVisitsCount,
    required this.inquiryBookingCount,
  });

  factory Ad.fromJson(Map<String, dynamic> json) => Ad(
    adsetName: json["adset_name"],
    adName: json["ad_name"],
    inquiryCount: json["inquiry_count"],
    leadCount: json["lead_count"],
    inquiryVisitsCount: json["inquiry_visits_count"],
    inquiryBookingCount: json["inquiry_booking_count"],
  );

  Map<String, dynamic> toJson() => {
    "adset_name": adsetName,
    "ad_name": adName,
    "inquiry_count": inquiryCount,
    "lead_count": leadCount,
    "inquiry_visits_count": inquiryVisitsCount,
    "inquiry_booking_count": inquiryBookingCount,
  };
}

class Totals {
  int finalTotalInquiry;
  int finalTotalLead;
  int finalTotalVisit;
  int finalTotalBooking;
  String faildInquiryCount;
  int faildLeadCount;
  String faildVisitCount;
  String faildBookingCount;

  Totals({
    required this.finalTotalInquiry,
    required this.finalTotalLead,
    required this.finalTotalVisit,
    required this.finalTotalBooking,
    required this.faildInquiryCount,
    required this.faildLeadCount,
    required this.faildVisitCount,
    required this.faildBookingCount,
  });

  factory Totals.fromJson(Map<String, dynamic> json) => Totals(
    finalTotalInquiry: json["final_total_inquiry"],
    finalTotalLead: json["final_total_lead"],
    finalTotalVisit: json["final_total_visit"],
    finalTotalBooking: json["final_total_booking"],
    faildInquiryCount: json["faild_inquiry_count"],
    faildLeadCount: json["faild_lead_count"],
    faildVisitCount: json["faild_visit_count"],
    faildBookingCount: json["faild_booking_count"],
  );

  Map<String, dynamic> toJson() => {
    "final_total_inquiry": finalTotalInquiry,
    "final_total_lead": finalTotalLead,
    "final_total_visit": finalTotalVisit,
    "final_total_booking": finalTotalBooking,
    "faild_inquiry_count": faildInquiryCount,
    "faild_lead_count": faildLeadCount,
    "faild_visit_count": faildVisitCount,
    "faild_booking_count": faildBookingCount,
  };
}

class LeadReport {
  List<Datum> data;
  List<List<ExportDatum>> exportData;

  LeadReport({
    required this.data,
    required this.exportData,
  });

  factory LeadReport.fromJson(Map<String, dynamic> json) => LeadReport(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    exportData: List<List<ExportDatum>>.from(
        json["export_data"].map((x) => List<ExportDatum>.from(x.map((x) => ExportDatum.fromJson(x))))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "export_data": List<dynamic>.from(exportData.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
  };
}

class Datum {
  String timePeriod;
  Map<String, dynamic> products; // Dynamic map to hold product counts (e.g., BEH, STV, etc.)
  int total;

  Datum({
    required this.timePeriod,
    required this.products,
    required this.total,
  });

  factory Datum.fromJson(Map<String, dynamic> json) {
    // Extract all product fields dynamically (excluding time_period and total)
    Map<String, dynamic> products = {};
    json.forEach((key, value) {
      if (key != "time_period" && key != "total") {
        products[key] = value; // e.g., "BEH": 0, "STV": 0, etc.
      }
    });

    return Datum(
      timePeriod: json["time_period"],
      products: products,
      total: json["total"],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      "time_period": timePeriod,
      "total": total,
    };
    json.addAll(products);
    return json;
  }
}

class ExportDatum {
  String productName;
  dynamic bookingCount;
  String monthName; // Changed to String to directly store the month_name value
  String cancelBookingCount;

  ExportDatum({
    required this.productName,
    required this.bookingCount,
    required this.monthName,
    required this.cancelBookingCount,
  });

  factory ExportDatum.fromJson(Map<String, dynamic> json) => ExportDatum(
    productName: json["product_name"],
    bookingCount: json["booking_count"],
    monthName: json["month_name"], // Directly store the string value
    cancelBookingCount: json["cancel_booking_count"],
  );

  Map<String, dynamic> toJson() => {
    "product_name": productName,
    "booking_count": bookingCount,
    "month_name": monthName,
    "cancel_booking_count": cancelBookingCount,
  };
}