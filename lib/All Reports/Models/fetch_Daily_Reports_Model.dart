import 'dart:convert';

enum ProductName {
  APPOINTMENT,
  BOOKING,
  CALL,
  CLOSE,
  INQ,
  VISIT;

  static ProductName fromString(String value) {
    return ProductName.values.firstWhere(
          (e) => e.name == value.toUpperCase(),
      orElse: () => throw Exception('Invalid ProductName: $value'),
    );
  }
}

class FetchDailyReportsModel {
  final int status;
  final List<List<Datum>> data;
  final Totals totals;

  FetchDailyReportsModel({
    required this.status,
    required this.data,
    required this.totals,
  });

  factory FetchDailyReportsModel.fromJson(Map<String, dynamic> json) {
    return FetchDailyReportsModel(
      status: json['status'] as int,
      data: (json['data'] as List<dynamic>)
          .map((e) => (e as List<dynamic>)
          .map((item) => Datum.fromJson(item as Map<String, dynamic>))
          .toList())
          .toList(),
      totals: Totals.fromJson(json['totals'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'data': data.map((e) => e.map((item) => item.toJson()).toList()).toList(),
    'totals': totals.toJson(),
  };
}

class Datum {
  final String monthName;
  final int bookingCount;
  final ProductName productName;

  Datum({
    required this.monthName,
    required this.bookingCount,
    required this.productName,
  });

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      monthName: json['month_name'] as String,
      bookingCount: json['booking_count'] as int,
      productName: ProductName.fromString(json['product_name'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'month_name': monthName,
    'booking_count': bookingCount,
    'product_name': productName.name,
  };
}

class Totals {
  final int inq;
  final int call;
  final int appointment;
  final int visit;
  final int booking;
  final int close;

  Totals({
    required this.inq,
    required this.call,
    required this.appointment,
    required this.visit,
    required this.booking,
    required this.close,
  });

  factory Totals.fromJson(Map<String, dynamic> json) {
    return Totals(
      inq: json['Inq'] as int,
      call: json['Call'] as int,
      appointment: json['Appointment'] as int,
      visit: json['Visit'] as int,
      booking: json['Booking'] as int,
      close: json['Close'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'Inq': inq,
    'Call': call,
    'Appointment': appointment,
    'Visit': visit,
    'Booking': booking,
    'Close': close,
  };
}