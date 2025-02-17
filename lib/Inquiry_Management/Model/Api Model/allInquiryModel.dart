class Inquiry {
  final String id;
  final String fullName;
  final String mobileno;
  final String remark;
  final String createdAt;

  Inquiry({
    required this.id,
    required this.fullName,
    required this.mobileno,
    required this.remark,
    required this.createdAt,
  });

  factory Inquiry.fromJson(Map<String, dynamic> json) {
    return Inquiry(
      id: json['id'] ?? "",
      fullName: json['full_name'] ?? "N/A",
      mobileno: json['mobileno'] ?? "N/A",
      remark: json['remark'] ?? "N/A",
      createdAt: json['created_at'] ?? "",
    );
  }
}

class PaginatedInquiries {
  final int currentPage;
  final int totalPages;
  final int totalRecords;
  final List<Inquiry> inquiries;

  PaginatedInquiries({
    required this.currentPage,
    required this.totalPages,
    required this.totalRecords,
    required this.inquiries,
  });

  factory PaginatedInquiries.fromJson(Map<String, dynamic> json) {
    var list = json['inquiries'] as List;
    List<Inquiry> inquiriesList = list.map((i) => Inquiry.fromJson(i)).toList();

    return PaginatedInquiries(
      currentPage: json['pagination']['current_page'] ?? 1,
      totalPages: json['pagination']['total_pages'] ?? 1,
      totalRecords: json['pagination']['total_records'] ?? 0,
      inquiries: inquiriesList,
    );
  }
}
