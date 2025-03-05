import 'dart:convert';

FetchBookingData2 fetchBookingData2FromJson(String str) => FetchBookingData2.fromJson(json.decode(str));

String fetchBookingData2ToJson(FetchBookingData2 data) => json.encode(data.toJson());

class FetchBookingData2 {
  List<Datum> data;
  List<Manager> manager;
  List<Manager> staff;
  List<ChannelPartner> channelPartner;
  List<Customer> customer;

  FetchBookingData2({
    required this.data,
    required this.manager,
    required this.staff,
    required this.channelPartner,
    required this.customer,
  });

  factory FetchBookingData2.fromJson(Map<String, dynamic> json) => FetchBookingData2(
    data: List<Datum>.from(json["Data"].map((x) => Datum.fromJson(x))),
    manager: List<Manager>.from(json["Manager"].map((x) => Manager.fromJson(x))),
    staff: List<Manager>.from(json["Staff"].map((x) => Manager.fromJson(x))),
    channelPartner: List<ChannelPartner>.from(json["Channel Partner"].map((x) => ChannelPartner.fromJson(x))),
    customer: List<Customer>.from(json["Customer"].map((x) => Customer.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Data": List<dynamic>.from(data.map((x) => x.toJson())),
    "Manager": List<dynamic>.from(manager.map((x) => x.toJson())),
    "Staff": List<dynamic>.from(staff.map((x) => x.toJson())),
    "Channel Partner": List<dynamic>.from(channelPartner.map((x) => x.toJson())),
    "Customer": List<dynamic>.from(customer.map((x) => x.toJson())),
  };
}

class ChannelPartner {
  String id;
  String brokername;

  ChannelPartner({
    required this.id,
    required this.brokername,
  });

  factory ChannelPartner.fromJson(Map<String, dynamic> json) => ChannelPartner(
    id: json["id"],
    brokername: json["brokername"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "brokername": brokername,
  };
}

class Customer {
  String id;
  String name;

  Customer({
    required this.id,
    required this.name,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

class Datum {
  String houseno;
  String society;
  String area;
  String city;

  Datum({
    required this.houseno,
    required this.society,
    required this.area,
    required this.city,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    houseno: json["houseno"],
    society: json["society"],
    area: json["area"],
    city: json["city"],
  );

  Map<String, dynamic> toJson() => {
    "houseno": houseno,
    "society": society,
    "area": area,
    "city": city,
  };
}

class Manager {
  String id;
  String firstname;

  Manager({
    required this.id,
    required this.firstname,
  });

  factory Manager.fromJson(Map<String, dynamic> json) => Manager(
    id: json["id"],
    firstname: json["firstname"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstname": firstname,
  };
}