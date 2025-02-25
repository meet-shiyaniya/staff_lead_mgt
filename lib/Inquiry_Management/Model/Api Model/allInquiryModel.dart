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
  final int? currentPage;
  final int? totalPages;
  final int? totalRecords;
  final int? liveFresh;
  final int? liveContacted;
  final int? liveAppointment;
  final int? liveVisited;
  final int? liveNegotiation;
  final int? liveFeedback;
  final int? liveReAppointment;
  final int? liveReVisited;
  final int? liveConverted;
  final int? dismissFresh;
  final int? dismissContacted;
  final int? dismissAppointment;
  final int? dismissVisited;
  final int? dismissNegotiation;
  final int? dismissFeedback;
  final int? dismissReAppointment;
  final int? dismissReVisited;
  final int? dismissConverted;
  final int? dismissRequestFresh;
  final int? dismissRequestContacted;
  final int? dismissRequestAppointment;
  final int? dismissRequestVisited;
  final int? conversionRequestVisited; // New for Conversion Request
  final int? conversionRequestReAppointment; // New for Conversion Request
  final int? dueAppoAppointment; // New for Due Appo

  final List<Inquiry> inquiries;

  final int? CNRReVisited;

  final int? CNRReAppointment;
  final int? CNRConverted;
  final int? CNRFeedback;
  final int? CNRNegotiation;
  final int? CNRAppointment;
  final int? CNRFresh;
  final int? CNRVisited;
  final int? CNRContacted;
  final int? dueAppoConverted;
  final int? dueAppoReVisited;
  final int? dueAppoNegotiation;
  final int? dismissRequestReVisited;
  final int? conversionRequestNegotiation;
  final int? conversionRequestConverted;
  final int? conversionRequestFresh;
  final int? dismissRequestReAppointment;
  final int? conversionRequestContacted;
  final int? dismissRequestConverted;
  final int? dueAppoReAppointment;
  final int? dismissRequestFeedback;
  final int? dismissRequestNegotiation;
  final int? conversionRequestAppointment;
  final int? conversionRequestFeedback;
  final int? dueAppoFeedback;
  final int? dueAppoFresh;
  final int? dueAppoVisited;
  final int? dueAppoContacted;
  final int? conversionRequestReVisited;

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
    required this.CNRReVisited,
    required this.CNRReAppointment,
    required this.CNRConverted,
    required this.CNRFeedback,
    required this.CNRNegotiation,
    required this.CNRVisited,
    required this.CNRAppointment,
    required this.CNRFresh,
    required this.CNRContacted,
    required this.dueAppoConverted,
    required this.dueAppoReVisited,
    required this.dueAppoReAppointment,
    required this.dismissRequestNegotiation,
    required this.dismissRequestReAppointment,
    required this.dismissRequestFeedback,
    required this.dismissRequestReVisited,
    required this.conversionRequestContacted,
    required this.conversionRequestFresh,
    required this.dismissRequestConverted,
    required this.conversionRequestNegotiation,
    required this.conversionRequestAppointment,
    required this.dueAppoFresh,
    required this.dueAppoContacted,
    required this.conversionRequestConverted,
    required this.conversionRequestReVisited,
    required this.conversionRequestFeedback,
    required this.dueAppoVisited,
    required this.dueAppoFeedback,
    required this.dueAppoNegotiation,

    required this.inquiries,});

  factory PaginatedInquiries.fromJson(Map<String, dynamic> json) {
    var list = json['inquiries'] as List;
    List<Inquiry> inquiriesList = list.map((i) => Inquiry.fromJson(i)).toList();

    return PaginatedInquiries(
      currentPage: json['pagination']['current_page'] ?? 1,
      totalPages: json['pagination']['total_pages'] ?? 1,
      totalRecords: json['pagination']['total_records'] ?? 0,
      liveFresh: json['pagination']['Live Fresh'] ?? 0,
      liveContacted: json['pagination']['Live Contacted']?? 0,
      liveAppointment: json['pagination']['Live Appointment'] ?? 0,
      liveVisited: json['pagination']['Live Visited'] ?? 0,
      liveNegotiation: json['pagination']['Live Negotiations'] ?? 0, // Updated key
      liveFeedback: json['pagination']['Live Feed Back'] ?? 0, // Updated key
      liveReAppointment: json['pagination']['Live Re Appointment'] ?? 0, // Updated key
      liveReVisited: json['pagination']['Live Re Visited'] ?? 0, // Updated key
      liveConverted: json['pagination']['Live Converted'] ?? 0,
      dismissFresh: json['pagination']['Dismiss Fresh'] ?? 0,
      dismissContacted: json['pagination']['Dismiss Contacted'] ?? 0,
      dismissAppointment: json['pagination']['Dismiss Appointment'] ?? 0,
      dismissVisited: json['pagination']['Dismiss Visited'] ?? 0,
      dismissNegotiation: json['pagination']['Dismiss Negotiations'] ?? 0, // Updated key
      dismissFeedback: json['pagination']['Dismiss Feed Back'] ?? 0, // Updated key
      dismissReAppointment: json['pagination']['Dismiss Re Appointment'] ?? 0, // Updated key
      dismissReVisited: json['pagination']['Dismiss Re Visited'] ?? 0, // Updated key
      dismissConverted: json['pagination']['Dismiss Converted'] ?? 0,
      dismissRequestFresh: json['pagination']['Dismissed Request Fresh'] ?? 0, // Updated key
      dismissRequestContacted: json['pagination']['Dismissed Request Contacted'] ?? 0, // Updated key
      dismissRequestAppointment: json['pagination']['Dismissed Request Appointment'] ?? 0, // Updated key
      dismissRequestVisited: json['pagination']['Dismissed Request Visited'] ?? 0, // Updated key
      dismissRequestNegotiation: json['pagination']['Dismissed Request Negotiations'] ?? 0, // Updated key
      dismissRequestFeedback: json['pagination']['Dismissed Request Feed Back'] ?? 0, // Updated key
      dismissRequestReAppointment: json['pagination']['Dismissed Request Re Appointment'] ?? 0, // Updated key
      dismissRequestReVisited: json['pagination']['Dismissed Request Re Visited'] ?? 0, // Updated key
      dismissRequestConverted: json['pagination']['Dismissed Request Converted'] ?? 0, // Updated key
      conversionRequestFresh: json['pagination']['Conversion Request Fresh'] ?? 0,
      conversionRequestContacted: json['pagination']['Conversion Request Contacted'] ?? 0,
      conversionRequestAppointment: json['pagination']['Conversion Request Appointment'] ?? 0,
      conversionRequestVisited: json['pagination']['Conversion Request Visited'] ?? 0,
      conversionRequestNegotiation: json['pagination']['Conversion Request Negotiations'] ?? 0, // Updated key
      conversionRequestFeedback: json['pagination']['Conversion Request Feed Back'] ?? 0, // Updated key
      conversionRequestReAppointment: json['pagination']['Conversion Request Re Appointment'] ?? 0, // Updated key
      conversionRequestReVisited: json['pagination']['Conversion Request Re Visited'] ?? 0, // Updated key
      conversionRequestConverted: json['pagination']['Conversion Request Converted'] ?? 0,
      dueAppoFresh: json['pagination']['Due Appo Fresh'] ?? 0,
      dueAppoContacted: json['pagination']['Due Appo Contacted'] ?? 0,
      dueAppoAppointment: json['pagination']['Due Appo Appointment'] ?? 0,
      dueAppoVisited: json['pagination']['Due Appo Visited'] ?? 0,
      dueAppoNegotiation: json['pagination']['Due Appo Negotiations'] ?? 0, // Updated key
      dueAppoFeedback: json['pagination']['Due Appo Feed Back'] ?? 0, // Updated key
      dueAppoReAppointment: json['pagination']['Due Appo Re Appointment'] ?? 0, // Updated key
      dueAppoReVisited: json['pagination']['Due Appo Re Visited'] ?? 0, // Updated key
      dueAppoConverted: json['pagination']['Due Appo Converted'] ?? 0,
      CNRFresh: json['pagination']['CNR Fresh'] ?? 0,
      CNRContacted: json['pagination']['CNR Contacted'] ?? 0,
      CNRAppointment: json['pagination']['CNR Appointment'] ?? 0,
      CNRVisited: json['pagination']['CNR Visited'] ?? 0,
      CNRNegotiation: json['pagination']['CNR Negotiations'] ?? 0, // Updated key
      CNRFeedback: json['pagination']['CNR Feed Back'] ?? 0, // Updated key
      CNRReAppointment: json['pagination']['CNR Re Appointment'] ?? 0, // Updated key
      CNRReVisited: json['pagination']['CNR Re Visited'] ?? 0, // Updated key
      CNRConverted: json['pagination']['CNR Converted'] ?? 0,
      inquiries: inquiriesList,
    );
  }
  // Map<String, dynamic> toJson() {
  //   return {
  //     'Live Fresh': liveFresh,
  //     'Live Contacted': liveContacted,
  //     'Live Trial':liveVisited,
  //     'Live Negotiation':liveNegotiation,
  //     "Live Feedback":liveFeedback,
  //     "Live Reappointment":liveReAppointment,
  //     "Live Re-trial":liveConverted,
  //     "Live Converted":liveConverted,
  //     'Dismiss Fresh': dismissFresh,
  //     'Dismiss Contacted': dismissContacted,
  //     'Dismiss Trial':dismissVisited,
  //     'Dismiss Negotiation':dismissNegotiation,
  //     "Dismiss Feedback":dismissFeedback,
  //     "Dismiss Reappointment":dismissReAppointment,
  //     "Dismiss Re-trial":dismissConverted,
  //     "Dismiss Converted":dismissConverted,
  //     'Dismiss Request Fresh': dismissRequestFresh,
  //     'Dismiss Request Contacted': dismissRequestContacted,
  //     'Dismiss Request Trial':dismissRequestVisited,
  //     'DismissRequest Negotiation':dismissRequestVisited,
  //     "Dismiss Request Feedback":dismissRequestContacted,
  //     "Dismiss Request Reappointment":dismissRequestAppointment,
  //     "Dismiss Request Re-trial":dismissRequestVisited,
  //     "Dismiss Request Converted":dismissRequestContacted,
  //     'Conversion Request Fresh': conversionRequestReAppointment,
  //     'Conversion Request Contacted': conversionRequestVisited,
  //     'Conversion Request Trial':conversionRequestContacted,
  //     'Conversion Request Negotiation':conversionRequestNegotiation,
  //     "Conversion Request Feedback":conversionRequestFeedback,
  //     "Conversion Request Reappointment":conversionRequestReAppointment,
  //     "Conversion Request Re-trial":conversionRequestConverted,
  //     "Conversion Request Converted":conversionRequestConverted,
  //     'Due Appo Fresh': dueAppoFresh,
  //     'Due Appo Contacted':dueAppoContacted,
  //     'Due Appo Trial':dueAppoFeedback,
  //     'Due Appo Negotiation':dueAppoNegotiation,
  //     "Due Appo Feedback":dueAppoFeedback,
  //     "Due Appo Reappointment":dueAppoReAppointment,
  //     "Due Appo Re-trial":dueAppoConverted,
  //     "Due Appo Converted":dueAppoConverted,
  //     'CNR Fresh':CNRFresh,
  //     'CNR Contacted':CNRContacted,
  //     'CNR Trial':CNRFeedback,
  //     'CNR Negotiation':CNRNegotiation,
  //     "CNR Feedback":CNRFeedback,
  //     "CNR Reappointment":CNRReAppointment,
  //     "CNR Re-trial":CNRConverted,
  //     "CNR Converted":CNRConverted,
  //
  //
  //
  //
  //   };
  // }

  }

