// Root class for the entire JSON response
class fetchVisitReportsModel {
  final int status;
  final String message;
  final ProductReport productReport;
  final UserReport userReport;

  fetchVisitReportsModel({
    required this.status,
    required this.message,
    required this.productReport,
    required this.userReport,
  });

  factory fetchVisitReportsModel.fromJson(Map<String, dynamic> json) {
    return fetchVisitReportsModel(
      status: json['status'] as int,
      message: json['message'] as String,
      productReport: ProductReport.fromJson(json['product_report'] as Map<String, dynamic>),
      userReport: UserReport.fromJson(json['user_report'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'product_report': productReport.toJson(),
      'user_report': userReport.toJson(),
    };
  }
}

// Class for the "product_report" section
class ProductReport {
  final List<ProductData> data;
  final List<Total> totals;
  final int finalTotalBooking;
  final int finalTotalCancel;
  final int moreData;

  ProductReport({
    required this.data,
    required this.totals,
    required this.finalTotalBooking,
    required this.finalTotalCancel,
    required this.moreData,
  });

  factory ProductReport.fromJson(Map<String, dynamic> json) {
    return ProductReport(
      data: (json['data'] as List<dynamic>)
          .map((e) => ProductData.fromJson(e as Map<String, dynamic>))
          .toList(),
      totals: (json['totals'] as List<dynamic>)
          .map((e) => Total.fromJson(e as Map<String, dynamic>))
          .toList(),
      finalTotalBooking: json['final_total_booking'] as int,
      finalTotalCancel: json['final_total_cancel'] as int,
      moreData: json['more_data'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      'totals': totals.map((e) => e.toJson()).toList(),
      'final_total_booking': finalTotalBooking,
      'final_total_cancel': finalTotalCancel,
      'more_data': moreData,
    };
  }
}

// Class for each item in the "data" list under "product_report"
class ProductData {
  final String userName;
  final String isInactive;
  final List<MonthData> months;
  final int totalBooking;
  final int totalCancel;

  ProductData({
    required this.userName,
    required this.isInactive,
    required this.months,
    required this.totalBooking,
    required this.totalCancel,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      userName: json['user_name'] as String,
      isInactive: json['is_inactive'] as String,
      months: (json['months'] as List<dynamic>)
          .map((e) => MonthData.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalBooking: json['total_booking'] as int,
      totalCancel: json['total_cancel'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_name': userName,
      'is_inactive': isInactive,
      'months': months.map((e) => e.toJson()).toList(),
      'total_booking': totalBooking,
      'total_cancel': totalCancel,
    };
  }
}

// Class for each item in the "months" list under "product_report" and "user_report"
class MonthData {
  final String month;
  final int visitCount;
  final int cancelBookingCount;

  MonthData({
    required this.month,
    required this.visitCount,
    required this.cancelBookingCount,
  });

  factory MonthData.fromJson(Map<String, dynamic> json) {
    return MonthData(
      month: json['month'] as String,
      visitCount: int.parse(json['visit_count'].toString()), // Handle both int and string
      cancelBookingCount: int.parse(json['cancel_booking_count'].toString()), // Handle both int and string
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'visit_count': visitCount,
      'cancel_booking_count': cancelBookingCount,
    };
  }
}

// Class for each item in the "totals" list under "product_report" and "user_report"
class Total {
  final String month;
  final int totalBooking;
  final int totalCancel;

  Total({
    required this.month,
    required this.totalBooking,
    required this.totalCancel,
  });

  factory Total.fromJson(Map<String, dynamic> json) {
    return Total(
      month: json['month'] as String,
      totalBooking: json['total_booking'] as int,
      totalCancel: json['total_cancel'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'total_booking': totalBooking,
      'total_cancel': totalCancel,
    };
  }
}

// Class for the "user_report" section
class UserReport {
  final List<UserData> data;
  final List<Total> totals;
  final int finalTotalBooking;
  final int finalTotalCancel;
  final int moreData;

  UserReport({
    required this.data,
    required this.totals,
    required this.finalTotalBooking,
    required this.finalTotalCancel,
    required this.moreData,
  });

  factory UserReport.fromJson(Map<String, dynamic> json) {
    return UserReport(
      data: (json['data'] as List<dynamic>)
          .map((e) => UserData.fromJson(e as Map<String, dynamic>))
          .toList(),
      totals: (json['totals'] as List<dynamic>)
          .map((e) => Total.fromJson(e as Map<String, dynamic>))
          .toList(),
      finalTotalBooking: json['final_total_booking'] as int,
      finalTotalCancel: json['final_total_cancel'] as int,
      moreData: json['more_data'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      'totals': totals.map((e) => e.toJson()).toList(),
      'final_total_booking': finalTotalBooking,
      'final_total_cancel': finalTotalCancel,
      'more_data': moreData,
    };
  }
}

// Class for each item in the "data" list under "user_report"
class UserData {
  final String userName;
  final String switcherActive;
  final List<MonthData> months;
  final int totalBooking;
  final int totalCancel;

  UserData({
    required this.userName,
    required this.switcherActive,
    required this.months,
    required this.totalBooking,
    required this.totalCancel,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userName: json['user_name'] as String,
      switcherActive: json['switcher_active'] as String,
      months: (json['months'] as List<dynamic>)
          .map((e) => MonthData.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalBooking: json['total_booking'] as int,
      totalCancel: json['total_cancel'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_name': userName,
      'switcher_active': switcherActive,
      'months': months.map((e) => e.toJson()).toList(),
      'total_booking': totalBooking,
      'total_cancel': totalCancel,
    };
  }
}