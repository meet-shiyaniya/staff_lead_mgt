class Inquiry {
  final String id;
  final String fullName;
  final String mobileno;
  final String remark;
  final String createdAt;
  final String budget;
  final String nxtfollowup;
  final String dayskip;
  final String hourskip;
  final String InqType;
  final String InqArea;
  final String PurposeBuy;
  final String InqStage;
  final String InqStatus;

  Inquiry({
    required this.id,
    required this.fullName,
    required this.mobileno,
    required this.remark,
    required this.createdAt,
    required this.budget,
    required this.nxtfollowup,
    required this.dayskip,
    required this.hourskip,
    required this.InqType,
    required this.InqArea,
    required this.PurposeBuy,
    required this.InqStage,
    required this.InqStatus
  });

  factory Inquiry.fromJson(Map<String, dynamic> json) {
    return Inquiry(
      id: json['id'] ?? "",
      fullName: json['full_name'] ?? "N/A",
      mobileno: json['mobileno'] ?? "N/A",
      remark: json['remark'] ?? "N/A",
      createdAt: json['created_at'] ?? "",
      budget: json['budget']??"",
      nxtfollowup: json['nxt_follow_up']??"",
      dayskip: json['day_skip']??"",
      hourskip: json['hour_skip']??"",
      InqType: json['inquiry_type']??"",
      InqArea: json['intrested_area']??"",
      PurposeBuy: json['purpose_buy']??"",
      InqStage: json['inquiry_stages']??"",
      InqStatus: json['inquiry_status']??""
    );
  }
}

  class PaginatedInquiries {
  final int currentPage;
  final int totalPages;
  final int totalRecords;
  final String liveFresh;
  final String liveContacted;
  final String liveAppointment;
  final String liveVisited;
  final String liveNegotiation;
  final String liveFeedback;
  final String liveReAppointment;
  final String liveReVisited;
  final String liveConverted;
  final String dismissFresh;
  final String dismissContacted;
  final String dismissAppointment;
  final String dismissVisited;
  final String dismissNegotiation;
  final String dismissFeedback;
  final String dismissReAppointment;
  final String dismissReVisited;
  final String dismissConverted;
  final String dismissRequestFresh;
  final String dismissRequestContacted;
  final String dismissRequestAppointment;
  final String dismissRequestVisited;
  final String conversionRequestVisited; // New for Conversion Request
  final String conversionRequestReAppointment; // New for Conversion Request
  final String dueAppoAppointment; // New for Due Appo

  final List<Inquiry> inquiries;

  PaginatedInquiries({
  required this.currentPage,
  required this.totalPages,
  required this.totalRecords,
  required this.liveFresh,
  required this.liveContacted,
  required this.liveAppointment,
  required this.liveVisited,
  required this.liveNegotiation,
  required this.liveFeedback,
  required this.liveReAppointment,
  required this.liveReVisited,
  required this.liveConverted,
  required this.dismissFresh,
  required this.dismissContacted,
  required this.dismissAppointment,
  required this.dismissVisited,
  required this.dismissNegotiation,
  required this.dismissFeedback,
  required this.dismissReAppointment,
  required this.dismissReVisited,
  required this.dismissConverted,
  required this.dismissRequestFresh,
  required this.dismissRequestContacted,
  required this.dismissRequestAppointment,
  required this.dismissRequestVisited,
  required this.conversionRequestVisited,
  required this.conversionRequestReAppointment,
  required this.dueAppoAppointment,
  required this.inquiries, required CNRReVisited, required CNRReAppointment, required CNRConverted, required CNRFeedback, required CNRNegotiation, required CNRVisited, required CNRAppointment, required CNRFresh, required CNRContacted, required dueAppoConverted, required dueAppoReVisited, required dueAppoReAppointment, required dismissRequestNegotiation, required dismissRequestReAppointment, required dismissRequestFeedback, required dismissRequestReVisited, required conversionRequestContacted, required conversionRequestFresh, required dismissRequestConverted, required conversionRequestNegotiation, required conversionRequestAppointment, required dueAppoFresh, required dueAppoContacted, required conversionRequestConverted, required conversionRequestReVisited, required conversionRequestFeedback, required dueAppoVisited, required dueAppoFeedback, required dueAppoNegotiation,
  });

  factory PaginatedInquiries.fromJson(Map<String, dynamic> json) {
  var list = json['inquiries'] as List;
  List<Inquiry> inquiriesList = list.map((i) => Inquiry.fromJson(i)).toList();

  return PaginatedInquiries(
  currentPage: json['pagination']['current_page'] ?? 1,
  totalPages: json['pagination']['total_pages'] ?? 1,
  totalRecords: json['pagination']['total_records'] ?? 0,
  liveFresh: json['Live Fresh']??"",
  liveContacted: json['Live Contacted']??"",
  liveAppointment: json['Live Appointment']??"",
  liveVisited: json['Live Visited']??"",
  liveNegotiation: json['Live Negotiation']??"",
  liveFeedback: json['Live Feedback']??"",
  liveReAppointment: json['Live ReAppointment']??"",
  liveReVisited: json['Live ReVisited']??"",
  liveConverted: json['Live Converted']??"",
  dismissFresh: json['Dismiss Fresh']??"",
  dismissContacted: json['Dismiss Contacted']??"",
  dismissAppointment: json['Dismiss Appointment']??"",
  dismissVisited: json['Dismiss Visited']??"",
  dismissNegotiation: json['Dismiss Negotiation']??"",
  dismissFeedback: json['Dismiss Feedback']??"",
  dismissReAppointment: json['Dismiss ReAppointment']??"",
  dismissReVisited: json['Dismiss ReVisited']??"",
  dismissConverted: json['Dismiss Converted']??"",
  dismissRequestFresh: json['Dismiss Request Fresh']??"",
  dismissRequestContacted: json['Dismiss Request Contacted']??"",
  dismissRequestAppointment: json['Dismiss Request Appointment']??"",
  dismissRequestVisited: json['Dismiss Request Visited']??"",
  dismissRequestNegotiation: json['Dismiss Request Negotiation']??"",
  dismissRequestFeedback: json['Dismiss Request Feedback']??"",
  dismissRequestReAppointment: json['Dismiss Request ReAppointment']??"",
  dismissRequestReVisited: json['Dismiss Request ReVisited']??"",
  dismissRequestConverted: json['Dismiss Request Converted']??"",
  conversionRequestFresh: json['Conversion Request Fresh']??"",
  conversionRequestContacted: json['Conversion Request Contacted']??"",
  conversionRequestAppointment: json['Conversion Request Appointment']??"",
  conversionRequestVisited: json['Conversion Request Visited']??"",
  conversionRequestNegotiation: json['Conversion Request Negotiation']??"",
  conversionRequestFeedback: json['Conversion Request Feedback']??"",
  conversionRequestReAppointment: json['Conversion Request ReAppointment']??"",
  conversionRequestReVisited: json['Conversion Request ReVisited']??"",
  conversionRequestConverted: json['Conversion Request Converted']??"",
  dueAppoFresh: json['Due Appo Fresh']??"",
  dueAppoContacted: json['Due Appo Contacted']??"",
  dueAppoAppointment: json['Due Appo Appointment']??"",
  dueAppoVisited: json['Due Appo Visited']??"",
  dueAppoNegotiation: json['Due Appo Negotiation']??"",
  dueAppoFeedback: json['Due Appo Feedback']??"",
  dueAppoReAppointment: json['Due Appo ReAppointment']??"",
  dueAppoReVisited: json['Due Appo ReVisited']??"",
  dueAppoConverted: json['Due Appo Converted']??"",
  CNRFresh: json['CNR Fresh']??"",
  CNRContacted: json['CNR Contacted']??"",
  CNRAppointment: json['CNR Appointment']??"",
  CNRVisited: json['CNR Visited']??"",
  CNRNegotiation: json['CNR Negotiation']??"",
  CNRFeedback: json['CNR Feedback']??"",
  CNRReAppointment: json['CNR ReAppointment']??"",
  CNRReVisited: json['CNR ReVisited']??"",
  CNRConverted: json['CNR Converted']??"", inquiries: inquiriesList,

  );
  }
  }

