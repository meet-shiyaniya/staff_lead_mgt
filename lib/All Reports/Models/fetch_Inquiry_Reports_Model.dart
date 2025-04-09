// inquiry_report_model.dart
import 'dart:convert';

class inquiryReportModel {
  final List<UserData> userData;
  final List<UserDataTotal> userDataTotal;
  final List<InquiryTypeReport> inquiryTypeReport;
  final List<InquiryTypeReportTotal> inquiryTypeReportTotal;
  final List<InquirySourceReport> inquirySourceReport;
  final List<InquirySourceReportTotal> inquirySourceReportTotal;

  inquiryReportModel({
    required this.userData,
    required this.userDataTotal,
    required this.inquiryTypeReport,
    required this.inquiryTypeReportTotal,
    required this.inquirySourceReport,
    required this.inquirySourceReportTotal,
  });

  factory inquiryReportModel.fromJson(Map<String, dynamic> json) {
    return inquiryReportModel(
      userData: (json['user_data'] as List)
          .map((e) => UserData.fromJson(e))
          .toList(),
      userDataTotal: (json['user_data_total'] as List)
          .map((e) => UserDataTotal.fromJson(e))
          .toList(),
      inquiryTypeReport: (json['Inquiry_Type_Report'] as List)
          .map((e) => InquiryTypeReport.fromJson(e))
          .toList(),
      inquiryTypeReportTotal: (json['Inquiry_Type_Report_total'] as List)
          .map((e) => InquiryTypeReportTotal.fromJson(e))
          .toList(),
      inquirySourceReport: (json['inq_source_repo'] as List)
          .map((e) => InquirySourceReport.fromJson(e))
          .toList(),
      inquirySourceReportTotal: (json['inq_source_repo_total'] as List)
          .map((e) => InquirySourceReportTotal.fromJson(e))
          .toList(),
    );
  }
}

class UserData {
  final String firstname;
  final String fresh;
  final String contacted;
  final String appointment;
  final String visited;
  final String negotiations;
  final String dismissed;
  final String feedback;
  final String reappointment;
  final String booking;
  final String total;

  UserData({
    required this.firstname,
    required this.fresh,
    required this.contacted,
    required this.appointment,
    required this.visited,
    required this.negotiations,
    required this.dismissed,
    required this.feedback,
    required this.reappointment,
    required this.booking,
    required this.total,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      firstname: json['firstname'] ?? '', // Handle null firstname
      fresh: json['fresh'].toString(),
      contacted: json['Contected'].toString(),
      appointment: json['appointment'].toString(),
      visited: json['visited'].toString(),
      negotiations: json['Negotiations'].toString(),
      dismissed: json['Dismissed'].toString(),
      feedback: json['feedback'].toString(),
      reappointment: json['Reappointment'].toString(),
      booking: json['Booking'].toString(),
      total: json['total'].toString(),
    );
  }
}

class UserDataTotal {
  final String total;
  final int fresh;
  final int contacted;
  final int appointment;
  final int visited;
  final int negotiations;
  final int dismissed;
  final int feedback;
  final int reappointment;
  final int booking;
  final int maintotal;

  UserDataTotal({
    required this.total,
    required this.fresh,
    required this.contacted,
    required this.appointment,
    required this.visited,
    required this.negotiations,
    required this.dismissed,
    required this.feedback,
    required this.reappointment,
    required this.booking,
    required this.maintotal,
  });

  factory UserDataTotal.fromJson(Map<String, dynamic> json) {
    return UserDataTotal(
      total: json['Total'] ?? 'Total',
      fresh: json['fresh'] ?? 0,
      contacted: json['Contected'] ?? 0,
      appointment: json['appointment'] ?? 0,
      visited: json['visited'] ?? 0,
      negotiations: json['Negotiations'] ?? 0,
      dismissed: json['Dismissed'] ?? 0,
      feedback: json['feedback'] ?? 0,
      reappointment: json['Reappointment'] ?? 0,
      booking: json['Booking'] ?? 0,
      maintotal: json['maintotal'] ?? 0,
    );
  }
}

class InquiryTypeReport {
  final String? inquiryDetails; // Made nullable
  final String live;
  final String close;
  final String total;

  InquiryTypeReport({
    this.inquiryDetails, // Nullable, no required
    required this.live,
    required this.close,
    required this.total,
  });

  factory InquiryTypeReport.fromJson(Map<String, dynamic> json) {
    return InquiryTypeReport(
      inquiryDetails: json['inquiry_details'], // Allow null
      live: json['live'].toString(),
      close: json['Close'].toString(),
      total: json['total'].toString(),
    );
  }
}

class InquiryTypeReportTotal {
  final String total;
  final String? inquiryDetails; // Made nullable
  final String live;
  final String close;
  final int totalCount;

  InquiryTypeReportTotal({
    required this.total,
    this.inquiryDetails, // Nullable, no required
    required this.live,
    required this.close,
    required this.totalCount,
  });

  factory InquiryTypeReportTotal.fromJson(Map<String, dynamic> json) {
    return InquiryTypeReportTotal(
      total: json['Total'] ?? 'Total',
      inquiryDetails: json['inquiry_details'], // Allow null
      live: json['live'].toString(),
      close: json['Close'].toString(),
      totalCount: json['total'] ?? 0,
    );
  }
}

class InquirySourceReport {
  final String? source; // Made nullable
  final String? inquirySourceType; // Made nullable
  final String live;
  final String close;
  final String total;

  InquirySourceReport({
    this.source, // Nullable, no required
    this.inquirySourceType, // Nullable, no required
    required this.live,
    required this.close,
    required this.total,
  });

  factory InquirySourceReport.fromJson(Map<String, dynamic> json) {
    return InquirySourceReport(
      source: json['source'], // Allow null
      inquirySourceType: json['inquiry_source_type'], // Allow null
      live: json['live'].toString(),
      close: json['Close'].toString(),
      total: json['total'].toString(),
    );
  }
}

class InquirySourceReportTotal {
  final String total;
  final int live;
  final int close;
  final int totalCount;

  InquirySourceReportTotal({
    required this.total,
    required this.live,
    required this.close,
    required this.totalCount,
  });

  factory InquirySourceReportTotal.fromJson(Map<String, dynamic> json) {
    return InquirySourceReportTotal(
      total: json['Total'] ?? 'Total',
      live: json['live'] ?? 0,
      close: json['Close'] ?? 0,
      totalCount: json['total'] ?? 0,
    );
  }
}