// To parse this JSON data, do
//
//     final inquiryFilter = inquiryFilterFromJson(jsonString);

import 'dart:convert';

InquiryFilter inquiryFilterFromJson(String str) => InquiryFilter.fromJson(json.decode(str));

String inquiryFilterToJson(InquiryFilter data) => json.encode(data.toJson());

class InquiryFilter {
  List<InquiryStage> inquiryStages;
  List<InquiryStatusFilter> inquiryStatus;
  List<To> assignTo;
  List<To> ownerTo;
  List<InquiryDetail> inquiryDetails;
  List<InquirySourceType> inquirySourceType;
  List<InquirySource> inquirySource;
  List<ProjectType> projectType;
  List<AreaCityCountry> areaCityCountry;
  List<PropertyConfiguration> propertyConfiguration;
  List<ProjectSubType> projectSubType;
  List<IntSite> intSite;

  InquiryFilter({
    required this.inquiryStages,
    required this.inquiryStatus,
    required this.assignTo,
    required this.ownerTo,
    required this.inquiryDetails,
    required this.inquirySourceType,
    required this.inquirySource,
    required this.projectType,
    required this.areaCityCountry,
    required this.propertyConfiguration,
    required this.projectSubType,
    required this.intSite,
  });

  factory InquiryFilter.fromJson(Map<String, dynamic> json) => InquiryFilter(
    inquiryStages: List<InquiryStage>.from(json["inquiry_stages"].map((x) => InquiryStage.fromJson(x))),
    inquiryStatus: List<InquiryStatusFilter>.from(json["inquiry_status"].map((x) => InquiryStatusFilter.fromJson(x))),
    assignTo: List<To>.from(json["Assign_to"].map((x) => To.fromJson(x))),
    ownerTo: List<To>.from(json["Owner_to"].map((x) => To.fromJson(x))),
    inquiryDetails: List<InquiryDetail>.from(json["inquiry_details"].map((x) => InquiryDetail.fromJson(x))),
    inquirySourceType: List<InquirySourceType>.from(json["inquiry_source_type"].map((x) => InquirySourceType.fromJson(x))),
    inquirySource: List<InquirySource>.from(json["inquiry_source"].map((x) => InquirySource.fromJson(x))),
    projectType: List<ProjectType>.from(json["project_type"].map((x) => ProjectType.fromJson(x))),
    areaCityCountry: List<AreaCityCountry>.from(json["area_city_country"].map((x) => AreaCityCountry.fromJson(x))),
    propertyConfiguration: List<PropertyConfiguration>.from(json["PropertyConfiguration"].map((x) => PropertyConfiguration.fromJson(x))),
    projectSubType: List<ProjectSubType>.from(json["project_sub_type"].map((x) => ProjectSubType.fromJson(x))),
    intSite: List<IntSite>.from(json["IntSite"].map((x) => IntSite.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "inquiry_stages": List<dynamic>.from(inquiryStages.map((x) => x.toJson())),
    "inquiry_status": List<dynamic>.from(inquiryStatus.map((x) => x.toJson())),
    "Assign_to": List<dynamic>.from(assignTo.map((x) => x.toJson())),
    "Owner_to": List<dynamic>.from(ownerTo.map((x) => x.toJson())),
    "inquiry_details": List<dynamic>.from(inquiryDetails.map((x) => x.toJson())),
    "inquiry_source_type": List<dynamic>.from(inquirySourceType.map((x) => x.toJson())),
    "inquiry_source": List<dynamic>.from(inquirySource.map((x) => x.toJson())),
    "project_type": List<dynamic>.from(projectType.map((x) => x.toJson())),
    "area_city_country": List<dynamic>.from(areaCityCountry.map((x) => x.toJson())),
    "PropertyConfiguration": List<dynamic>.from(propertyConfiguration.map((x) => x.toJson())),
    "project_sub_type": List<dynamic>.from(projectSubType.map((x) => x.toJson())),
    "IntSite": List<dynamic>.from(intSite.map((x) => x.toJson())),
  };
}

class AreaCityCountry {
  String id;
  String area;
  City city;
  String state;
  String country;

  AreaCityCountry({
    required this.id,
    required this.area,
    required this.city,
    required this.state,
    required this.country,
  });

  factory AreaCityCountry.fromJson(Map<String, dynamic> json) => AreaCityCountry(
    id: json["id"],
    area: json["area"],
    city: cityValues.map[json["city"]]!,
    state: json["state"],
    country: json["country"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "area": area,
    "city": cityValues.reverse[city],
    "state": state,
    "country": country,
  };
}

enum City {
  EMPTY,
  SURAT
}

final cityValues = EnumValues({
  "": City.EMPTY,
  "surat": City.SURAT
});

class To {
  String id;
  String firstname;
  String userRole;

  To({
    required this.id,
    required this.firstname,
    required this.userRole,
  });

  factory To.fromJson(Map<String, dynamic> json) => To(
    id: json["id"],
    firstname: json["firstname"],
    userRole: json["user_role"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstname": firstname,
    "user_role": userRole,
  };
}

class InquiryDetail {
  String id;
  String inquiryDetails;

  InquiryDetail({
    required this.id,
    required this.inquiryDetails,
  });

  factory InquiryDetail.fromJson(Map<String, dynamic> json) => InquiryDetail(
    id: json["id"],
    inquiryDetails: json["inquiry_details"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "inquiry_details": inquiryDetails,
  };
}

class InquirySource {
  String id;
  String source;

  InquirySource({
    required this.id,
    required this.source,
  });

  factory InquirySource.fromJson(Map<String, dynamic> json) => InquirySource(
    id: json["id"],
    source: json["source"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "source": source,
  };
}

class InquirySourceType {
  String id;
  String inquirySourceType;

  InquirySourceType({
    required this.id,
    required this.inquirySourceType,
  });

  factory InquirySourceType.fromJson(Map<String, dynamic> json) => InquirySourceType(
    id: json["id"],
    inquirySourceType: json["inquiry_source_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "inquiry_source_type": inquirySourceType,
  };
}

class InquiryStage {
  String id;
  String inquiryStages;

  InquiryStage({
    required this.id,
    required this.inquiryStages,
  });

  factory InquiryStage.fromJson(Map<String, dynamic> json) => InquiryStage(
    id: json["id"],
    inquiryStages: json["inquiry_stages"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "inquiry_stages": inquiryStages,
  };
}

class InquiryStatusFilter {
  String id;
  String inquiryStatus;

  InquiryStatusFilter({
    required this.id,
    required this.inquiryStatus,
  });

  factory InquiryStatusFilter.fromJson(Map<String, dynamic> json) => InquiryStatusFilter(
    id: json["id"],
    inquiryStatus: json["inquiry_status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "inquiry_status": inquiryStatus,
  };
}

class IntSite {
  String id;
  String productName;

  IntSite({
    required this.id,
    required this.productName,
  });

  factory IntSite.fromJson(Map<String, dynamic> json) => IntSite(
    id: json["id"],
    productName: json["product_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_name": productName,
  };
}

class ProjectSubType {
  String id;
  String projectSubType;
  String projectType;

  ProjectSubType({
    required this.id,
    required this.projectSubType,
    required this.projectType,
  });

  factory ProjectSubType.fromJson(Map<String, dynamic> json) => ProjectSubType(
    id: json["id"],
    projectSubType: json["project_sub_type"],
    projectType: json["project_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "project_sub_type": projectSubType,
    "project_type": projectType,
  };
}

class ProjectType {
  String id;
  String projectType;

  ProjectType({
    required this.id,
    required this.projectType,
  });

  factory ProjectType.fromJson(Map<String, dynamic> json) => ProjectType(
    id: json["id"],
    projectType: json["project_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "project_type": projectType,
  };
}

class PropertyConfiguration {
  String id;
  String propertyconfigurationType;

  PropertyConfiguration({
    required this.id,
    required this.propertyconfigurationType,
  });

  factory PropertyConfiguration.fromJson(Map<String, dynamic> json) => PropertyConfiguration(
    id: json["id"],
    propertyconfigurationType: json["propertyconfiguration_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "propertyconfiguration_type": propertyconfigurationType,
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
