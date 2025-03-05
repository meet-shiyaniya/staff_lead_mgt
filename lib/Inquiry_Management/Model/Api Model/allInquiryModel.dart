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
  final String inquiry_source_type;
  final String intersted_site_name;
  final String property_type;
  final String property_sub_type;
  final String approx_buy;
  final String email;
  final String day_skip;
  final String hour_skip;
  final String assign_id;


  Inquiry(
      {required this.id,
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
        required this.InqStatus,
        required this.inquiry_source_type,
        required this.intersted_site_name,
        required this.property_sub_type,
        required this.approx_buy,
        required this.email,
        required this.day_skip,
        required this.hour_skip,
        required this.assign_id,


        required this.property_type});

  factory Inquiry.fromJson(Map<String, dynamic> json) {
    return Inquiry(
        id: json['id'] ?? "",
        fullName: json['full_name'] ?? "N/A",
        mobileno: json['mobileno'] ?? "N/A",
        remark: json['remark'] ?? "N/A",
        createdAt: json['created_at'] ?? "",
        budget: json['budget'] ?? "",
        nxtfollowup: json['nxt_follow_up'] ?? "",
        dayskip: json['day_skip'] ?? "",
        hourskip: json['hour_skip'] ?? "",
        InqType: json['inquiry_type'] ?? "",
        InqArea: json['intrested_area'] ?? "",
        PurposeBuy: json['purpose_buy'] ?? "",
        InqStage: json['inquiry_stages'] ?? "",
        InqStatus: json['inquiry_status'] ?? "",
        inquiry_source_type: json['inquiry_source_type'] ?? "",
        intersted_site_name: json['intersted_site_name'] ?? "",
        property_sub_type: json['property_sub_type'] ?? "",
        approx_buy: json['approx_buy'] ?? "",
        email: json['email'] ?? "",
        property_type: json['property_type'] ?? "",
        day_skip: json['day_skip'] ?? "0",
        hour_skip: json['hour_skip'] ?? "0",
        assign_id: json['assign_id'] ?? "");
  }
}

class PaginatedInquiries {
  final int? currentPage;
  final int? totalPages;
  final int? totalRecords;
  final List<Inquiry> inquiries;
  final List<InquiryStatus> inquiryStatus; // Add this field

  PaginatedInquiries({
    required this.currentPage,
    required this.totalPages,
    required this.totalRecords,
    required this.inquiries,
    required this.inquiryStatus, // Include in constructor
  });

  factory PaginatedInquiries.fromJson(Map<String, dynamic> json) {
    var list = json['inquiries'] as List;
    List<Inquiry> inquiriesList = list.map((i) => Inquiry.fromJson(i)).toList();

    var statusList = json['pagination']['inquiry_status'] as List? ?? [];
    List<InquiryStatus> inquiryStatusList =
    statusList.map((s) => InquiryStatus.fromJson(s)).toList();

    return PaginatedInquiries(
      currentPage: json['pagination']['current_page'] ?? 1,
      totalPages: json['pagination']['total_pages'] ?? 1,
      totalRecords: json['pagination']['total_records'] ?? 0,
      inquiries: inquiriesList,
      inquiryStatus: inquiryStatusList, // Assign parsed status list
    );
  }
}

class InquiryStatus {
  final String inquiryStatus;
  final String Total_Sum;
  final String fresh;
  final String contacted;
  final String appointment;
  final String visited;
  final String negotiations;
  final String feedBack;
  final String reAppointment;
  final String reVisited;
  final String converted;

  InquiryStatus({
    required this.inquiryStatus,
    required this.Total_Sum,
    required this.fresh,
    required this.contacted,
    required this.appointment,
    required this.visited,
    required this.negotiations,
    required this.feedBack,
    required this.reAppointment,
    required this.reVisited,
    required this.converted,

  });

  factory InquiryStatus.fromJson(Map<String, dynamic> json) {
    return InquiryStatus(
      inquiryStatus: json['inquiry_status'] ?? '',

      fresh: json['Fresh'] ?? '0',
      contacted: json['Contacted'] ?? '0',
      appointment: json['Appointment'] ?? '0',
      visited: json['Visited'] ?? '0',
      negotiations: json['Negotiations'] ?? '0',
      feedBack: json['Feed_Back'] ?? '0',
      reAppointment: json['Re_Appointment'] ?? '0',
      reVisited: json['Re_Visited'] ?? '0',
      converted: json['Converted'] ?? '0',
      Total_Sum: json['Total_Sum'] ?? '0',
    );
  }
}