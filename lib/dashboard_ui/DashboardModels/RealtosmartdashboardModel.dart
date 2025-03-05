import 'dart:convert';

RealtosmartdashboardModel realtosmartdashboardModelFromJson(String str) =>
    RealtosmartdashboardModel.fromJson(json.decode(str));

String realtosmartdashboardModelToJson(RealtosmartdashboardModel data) => json.encode(data.toJson());

class RealtosmartdashboardModel {
  int? todayFollowupCount;
  int? pendingFollowupCount;
  int? totalFollowup;
  int? visitCount;
  int? bookingCount;
  List<ChartCount>? chartCount;
  List<PerfomanceCount>? perfomanceCount;
  List<PerfomanceGrowthCount>? perfomanceGrowthCount;
  List<UserDataPending>? userDataPending;
  List<TotalUserDatum>? totalUserData;
  CalenderData? calenderData;
  List<VisitUpcomingDatum>? visitUpcomingData;
  List<dynamic>? leadQualityReport;
  List<FollowupReport>? followupReport;
  int? countFollowup;
  List<ActivityLogReport>? activityLogReport;
  int? countActivity;
  List<GetCountStatusWise>? getCountStatusWise;
  List<dynamic>? dismissReportCount;
  int? totalCount;

  RealtosmartdashboardModel({
    this.todayFollowupCount = 0,
    this.pendingFollowupCount = 0,
    this.totalFollowup = 0,
    this.visitCount = 0,
    this.bookingCount = 0,
    this.chartCount = const [],
    this.perfomanceCount = const [],
    this.perfomanceGrowthCount = const [],
    this.userDataPending = const [],
    this.totalUserData = const [],
    this.calenderData,
    this.visitUpcomingData = const [],
    this.leadQualityReport = const [],
    this.followupReport = const [],
    this.countFollowup = 0,
    this.activityLogReport = const [],
    this.countActivity = 0,
    this.getCountStatusWise = const [],
    this.dismissReportCount = const [],
    this.totalCount = 0,
  });

  factory RealtosmartdashboardModel.fromJson(Map<String, dynamic> json) => RealtosmartdashboardModel(
    todayFollowupCount: json["today_followup_count"] as int? ?? 0,
    pendingFollowupCount: json["pending_followup_count"] as int? ?? 0,
    totalFollowup: json["total_followup"] as int? ?? 0,
    visitCount: json["visit_count"] as int? ?? 0,
    bookingCount: json["booking_count"] as int? ?? 0,
    chartCount: json["chart_count"] != null
        ? List<ChartCount>.from(json["chart_count"].map((x) => ChartCount.fromJson(x)))
        : [],
    perfomanceCount: json["perfomance_count"] != null
        ? List<PerfomanceCount>.from(json["perfomance_count"].map((x) => PerfomanceCount.fromJson(x)))
        : [],
    perfomanceGrowthCount: json["perfomance_Growth_count"] != null
        ? List<PerfomanceGrowthCount>.from(json["perfomance_Growth_count"].map((x) => PerfomanceGrowthCount.fromJson(x)))
        : [],
    userDataPending: json["user_data_pending"] != null
        ? List<UserDataPending>.from(json["user_data_pending"].map((x) => UserDataPending.fromJson(x)))
        : [],
    totalUserData: json["total_user_data"] != null
        ? List<TotalUserDatum>.from(json["total_user_data"].map((x) => TotalUserDatum.fromJson(x)))
        : [],
    calenderData: json["calender_data"] != null ? CalenderData.fromJson(json["calender_data"]) : null,
    // ✅ Fix: Prevents the error when visit_upcoming_data contains an empty list.
    visitUpcomingData: (json["visit_upcoming_data"] is List && json["visit_upcoming_data"].isNotEmpty && json["visit_upcoming_data"].first is Map)
        ? (json["visit_upcoming_data"] as List).map((x) => VisitUpcomingDatum.fromJson(x)).toList()
        : [],
    leadQualityReport: json["lead_quality_report"] != null ? List<dynamic>.from(json["lead_quality_report"].map((x) => x)) : [],
    followupReport: json["followup_report"] != null
        ? List<FollowupReport>.from(json["followup_report"].map((x) => FollowupReport.fromJson(x)))
        : [],
    countFollowup: json["count_followup"] as int? ?? 0,
    activityLogReport: json["activity_log_report"] != null
        ? List<ActivityLogReport>.from(json["activity_log_report"].map((x) => ActivityLogReport.fromJson(x)))
        : [],
    countActivity: json["count_activity"] as int? ?? 0,
    getCountStatusWise: json["get_count_status_wise"] != null
        ? List<GetCountStatusWise>.from(json["get_count_status_wise"].map((x) => GetCountStatusWise.fromJson(x)))
        : [],
    dismissReportCount: json["dismiss_report_count"] != null
        ? List<dynamic>.from(json["dismiss_report_count"].map((x) => x))
        : [],
    totalCount: json["total_count"] as int? ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "today_followup_count": todayFollowupCount,
    "pending_followup_count": pendingFollowupCount,
    "total_followup": totalFollowup,
    "visit_count": visitCount,
    "booking_count": bookingCount,
    "chart_count": chartCount != null ? List<dynamic>.from(chartCount!.map((x) => x.toJson())) : [],
    "perfomance_count": perfomanceCount != null ? List<dynamic>.from(perfomanceCount!.map((x) => x.toJson())) : [],
    "perfomance_Growth_count":
    perfomanceGrowthCount != null ? List<dynamic>.from(perfomanceGrowthCount!.map((x) => x.toJson())) : [],
    "user_data_pending": userDataPending != null ? List<dynamic>.from(userDataPending!.map((x) => x.toJson())) : [],
    "total_user_data": totalUserData != null ? List<dynamic>.from(totalUserData!.map((x) => x.toJson())) : [],
    "calender_data": calenderData?.toJson(),
    "visit_upcoming_data": visitUpcomingData != null ? List<dynamic>.from(visitUpcomingData!.map((x) => x.toJson())) : [],
    "lead_quality_report": leadQualityReport != null ? List<dynamic>.from(leadQualityReport!.map((x) => x)) : [],
    "followup_report": followupReport != null ? List<dynamic>.from(followupReport!.map((x) => x.toJson())) : [],
    "count_followup": countFollowup,
    "activity_log_report": activityLogReport != null ? List<dynamic>.from(activityLogReport!.map((x) => x.toJson())) : [],
    "count_activity": countActivity,
    "get_count_status_wise":
    getCountStatusWise != null ? List<dynamic>.from(getCountStatusWise!.map((x) => x.toJson())) : [],
    "dismiss_report_count": dismissReportCount != null ? List<dynamic>.from(dismissReportCount!.map((x) => x)) : [],
    "total_count": totalCount,
  };
}

class ActivityLogReport {
  String? inquiryId;
  String? createdDates;
  String? usernamee;
  String? btnNameStage;
  String? btnName;
  String? inquiryLog;

  ActivityLogReport({
    this.inquiryId,
    this.createdDates,
    this.usernamee,
    this.btnNameStage,
    this.btnName,
    this.inquiryLog,
  });

  factory ActivityLogReport.fromJson(Map<String, dynamic> json) {
    return ActivityLogReport(
      inquiryId: json['inquiry_id'] as String? ?? '',
      createdDates: json['created_dates'] as String? ?? '',
      usernamee: json['usernamee'] as String? ?? '',
      btnNameStage: json['btn_name_stage'] as String? ?? '',
      btnName: json['btn_name'] as String? ?? '',
      inquiryLog: json['inquiry_log'] as String? ?? '',
    );
  }

  // Add the toJson method
  Map<String, dynamic> toJson() => {
    'inquiry_id': inquiryId,
    'created_dates': createdDates,
    'usernamee': usernamee,
    'btn_name_stage': btnNameStage,
    'btn_name': btnName,
    'inquiry_log': inquiryLog,
  };
}enum BtnName { CNR, EMPTY, LIVE }

final btnNameValues = EnumValues({
  "CNR": BtnName.CNR,
  "": BtnName.EMPTY,
  "Live": BtnName.LIVE,
});




class CalenderData {
  List<TDatum>? appointmentData;
  List<dynamic>? reappointmentData;
  List<TDatum>? visitData;
  List<dynamic>? revisitData;

  CalenderData({
    this.appointmentData = const [],
    this.reappointmentData = const [],
    this.visitData = const [],
    this.revisitData = const [],
  });

  factory CalenderData.fromJson(Map<String, dynamic> json) => CalenderData(
    appointmentData: json["appointment_data"] != null
        ? List<TDatum>.from(json["appointment_data"].map((x) => TDatum.fromJson(x)))
        : [],
    reappointmentData: json["reappointment_data"] != null
        ? List<dynamic>.from(json["reappointment_data"].map((x) => x))
        : [],
    visitData: json["visit_data"] != null
        ? List<TDatum>.from(json["visit_data"].map((x) => TDatum.fromJson(x)))
        : [],
    revisitData: json["revisit_data"] != null
        ? List<dynamic>.from(json["revisit_data"].map((x) => x))
        : [],
  );

  Map<String, dynamic> toJson() => {
    "appointment_data": appointmentData != null
        ? List<dynamic>.from(appointmentData!.map((x) => x.toJson()))
        : [],
    "reappointment_data": reappointmentData != null
        ? List<dynamic>.from(reappointmentData!.map((x) => x))
        : [],
    "visit_data": visitData != null ? List<dynamic>.from(visitData!.map((x) => x.toJson())) : [],
    "revisit_data": revisitData != null ? List<dynamic>.from(revisitData!.map((x) => x)) : [],
  };
}
class TDatum {
  String? id;
  String? title;
  DateTime? start;
  String? color;
  String? className;

  TDatum({
    this.id = '',
    this.title = '',
    this.start,
    this.color = '',
    this.className = '',
  });

  factory TDatum.fromJson(Map<String, dynamic> json) => TDatum(
    id: json["id"] as String? ?? '',
    title: json["title"] as String? ?? '',
    start: json["start"] != null ? DateTime.parse(json["start"] as String) : null,
    color: json["color"] as String? ?? '',
    className: json["className"] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "start": start?.toIso8601String(),
    "color": color,
    "className": className,
  };
}

class ChartCount {
  String? appoiment;
  String? booking;
  String? cancleBooking;
  String? visit;
  String? inquiry;
  String? data;
  String? lead;
  String? datefild;

  ChartCount({
    this.appoiment = '0',
    this.booking = '0',
    this.cancleBooking = '0',
    this.visit = '0',
    this.inquiry = '0',
    this.data = '0',
    this.lead = '0',
    this.datefild = '',
  });

  factory ChartCount.fromJson(Map<String, dynamic> json) => ChartCount(
    appoiment: json["appointment"] as String? ?? '0',
    booking: json["booking"] as String? ?? '0',
    cancleBooking: json["cancle_booking"] as String? ?? '0',
    visit: json["visit"] as String? ?? '0',
    inquiry: json["inquiry"] as String? ?? '0',
    data: json["data"] as String? ?? '0',
    lead: json["lead"] as String? ?? '0',
    datefild: json["datefild"] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {
    "appointment": appoiment,
    "booking": booking,
    "cancle_booking": cancleBooking,
    "visit": visit,
    "inquiry": inquiry,
    "data": data,
    "lead": lead,
    "datefild": datefild,
  };
}

class FollowupReport {
  String? inquiryId;
  String? createdDates;
  String? usernamee;
  String? inquiryStages;
  String? inquiryTypeName;
  String? nxtfollowdate;
  String? remark;

  FollowupReport({
    this.inquiryId = '',
    this.createdDates = '',
    this.usernamee = '',
    this.inquiryStages = '',
    this.inquiryTypeName = '',
    this.nxtfollowdate = '',
    this.remark = '',
  });

  factory FollowupReport.fromJson(Map<String, dynamic> json) => FollowupReport(
    inquiryId: json["inquiry_id"] != null ? json["inquiry_id"].toString() : '',
    createdDates: json["created_dates"] as String? ?? '',
    usernamee: json["usernamee"] as String? ?? '',
    inquiryStages: json["inquiry_stages"] as String? ?? '',
    inquiryTypeName: json["inquiry_type_name"] as String? ?? '',
    nxtfollowdate: json["nxtfollowdate"] as String? ?? '',
    remark: json["remark"] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {
    "inquiry_id": inquiryId,
    "created_dates": createdDates,
    "usernamee": usernamee,
    "inquiry_stages": inquiryStages,
    "inquiry_type_name": inquiryTypeName,
    "nxtfollowdate": nxtfollowdate,
    "remark": remark,
  };
}

class GetCountStatusWise {
  String? inquiryStages;
  String? inqStatusName;
  String? totalInq;

  GetCountStatusWise({
    this.inquiryStages = '',
    this.inqStatusName = '',
    this.totalInq = '0',
  });

  factory GetCountStatusWise.fromJson(Map<String, dynamic> json) => GetCountStatusWise(
    inquiryStages: json["inquiry_stages"] as String? ?? '',
    inqStatusName: json["inq_status_name"] as String? ?? '',
    totalInq: json["total_inq"] as String? ?? '0',
  );

  Map<String, dynamic> toJson() => {
    "inquiry_stages": inquiryStages,
    "inq_status_name": inqStatusName,
    "total_inq": totalInq,
  };
}

class PerfomanceCount {
  String? coverstionVisit;
  String? coverstionBooking;
  String? month;
  String? leads;
  String? visit;
  String? booking;
  String? oldVisit;
  String? oldBooking;

  PerfomanceCount({
    this.coverstionVisit = '0',
    this.coverstionBooking = '0',
    this.month = '',
    this.leads = '0',
    this.visit = '0',
    this.booking = '0',
    this.oldVisit = '0',
    this.oldBooking = '0',
  });

  factory PerfomanceCount.fromJson(Map<String, dynamic> json) => PerfomanceCount(
    coverstionVisit: json["coverstion_visit"] as String? ?? '0',
    coverstionBooking: json["coverstion_booking"] as String? ?? '0',
    month: json["month"] as String? ?? '',
    leads: json["leads"] as String? ?? '0',
    visit: json["visit"] as String? ?? '0',
    booking: json["booking"] as String? ?? '0',
    oldVisit: json["old_visit"] as String? ?? '0',
    oldBooking: json["old_booking"] as String? ?? '0',
  );

  Map<String, dynamic> toJson() => {
    "coverstion_visit": coverstionVisit,
    "coverstion_booking": coverstionBooking,
    "month": month,
    "leads": leads,
    "visit": visit,
    "booking": booking,
    "old_visit": oldVisit,
    "old_booking": oldBooking,
  };
}

class PerfomanceGrowthCount {
  int? growthBoookings;
  int? growthVisits;

  PerfomanceGrowthCount({
    this.growthBoookings = 0,
    this.growthVisits = 0,
  });

  factory PerfomanceGrowthCount.fromJson(Map<String, dynamic> json) => PerfomanceGrowthCount(
    growthBoookings: json["Growth_boookings"] as int? ?? 0,
    growthVisits: json["Growth_visits"] as int? ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "Growth_boookings": growthBoookings,
    "Growth_visits": growthVisits,
  };
}

class TotalUserDatum {
  // Usernamee? firstname;
  int? autoLeads;
  int? selfLeads;
  int? today;
  int? pending;
  int? total;
  int? userDone;
  int? cnr;

  TotalUserDatum({
    // this.firstname = Usernamee.AKASH_KANANI,
    this.autoLeads = 0,
    this.selfLeads = 0,
    this.today = 0,
    this.pending = 0,
    this.total = 0,
    this.userDone = 0,
    this.cnr = 0,
  });

  factory TotalUserDatum.fromJson(Map<String, dynamic> json) => TotalUserDatum(
    // firstname: usernameeValues.map[json["firstname"] as String?] ?? Usernamee.AKASH_KANANI,
    autoLeads: json["AutoLeads"] as int? ?? 0,
    selfLeads: json["SelfLeads"] as int? ?? 0,
    today: json["Today"] as int? ?? 0,
    pending: json["Pending"] as int? ?? 0,
    total: json["total"] as int? ?? 0,
    userDone: json["user_done"] as int? ?? 0,
    cnr: json["cnr"] as int? ?? 0,
  );

  Map<String, dynamic> toJson() => {
    // "firstname": usernameeValues.reverse[firstname],
    "AutoLeads": autoLeads,
    "SelfLeads": selfLeads,
    "Today": today,
    "Pending": pending,
    "total": total,
    "user_done": userDone,
    "cnr": cnr,
  };
}

class UserDataPending {
  String? switcherActive;
  String? firstname; // Uncommented for consistency
  String? autoLeads;
  String? selfLeads;
  String? today;
  String? pending;
  int? total;
  int? userDone;
  String? cnr;

  UserDataPending({
    this.switcherActive = '',
    this.firstname = '',
    this.autoLeads = '0',
    this.selfLeads = '0',
    this.today = '0',
    this.pending = '0',
    this.total = 0,
    this.userDone = 0,
    this.cnr = '0',
  });

  factory UserDataPending.fromJson(Map<String, dynamic> json) => UserDataPending(
    switcherActive: json["switcher_active"] as String? ?? '',
    firstname: json["firstname"] as String? ?? '',
    autoLeads: json["AutoLeads"] as String? ?? '0',
    selfLeads: json["SelfLeads"] as String? ?? '0',
    today: json["Today"] as String? ?? '0',
    pending: json["Pending"] as String? ?? '0',
    total: json["total"] as int? ?? 0,
    userDone: json["user_done"] is String
        ? int.tryParse(json["user_done"] as String) ?? 0
        : json["user_done"] as int? ?? 0, // Handle both String and int
    cnr: json["cnr"] as String? ?? '0',
  );

  Map<String, dynamic> toJson() => {
    "switcher_active": switcherActive,
    "firstname": firstname,
    "AutoLeads": autoLeads,
    "SelfLeads": selfLeads,
    "Today": today,
    "Pending": pending,
    "total": total,
    "user_done": userDone,
    "cnr": cnr,
  };
}
class VisitUpcomingDatum {
  final String id;
  final String type;
  final String name;
  final String pShortname;
  final String time;

  VisitUpcomingDatum({
    required this.id,
    required this.type,
    required this.name,
    required this.pShortname,
    required this.time,
  });

  factory VisitUpcomingDatum.fromJson(Map<String, dynamic> json) {
    return VisitUpcomingDatum(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      pShortname: json['p_shortname'] ?? '',
      time: json['time'] ?? '',
    );
  }

  // Added toJson method
  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'name': name,
    'p_shortname': pShortname,
    'time': time,
  };
}
class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}