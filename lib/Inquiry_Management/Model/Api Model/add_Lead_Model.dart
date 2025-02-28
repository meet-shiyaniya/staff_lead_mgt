class AddLeadDataModel {
  final List<CstStatus> cststatus;
  final List<AreaCityCountry> areaCityCountry;
  final List<AreaCityCountry> intArea;
  final Budget? budget;
  final PurposeOfBuying? purposeOfBuying;
  final List<PropertyConfiguration> propertyConfiguration;
  final List<IntSite> intSite;
  final List<InqType> inqType;
  final List<InqSource> inqSource;
  final ApxTime? apxTime;

  AddLeadDataModel({
    required this.cststatus,
    required this.areaCityCountry,
    required this.intArea,
    required this.budget,
    required this.purposeOfBuying,
    required this.propertyConfiguration,
    required this.intSite,
    required this.inqType,
    required this.inqSource,
    required this.apxTime,
  });
  factory AddLeadDataModel.fromJson(Map<String, dynamic> json) => AddLeadDataModel(
    cststatus: (json['cststatus'] as List<dynamic>?)?.map((x) => CstStatus.fromJson(x)).toList() ?? [],
    areaCityCountry: (json['area_city_country'] as List<dynamic>?)?.map((x) => AreaCityCountry.fromJson(x)).toList() ?? [],
    intArea: (json['IntArea'] as List<dynamic>?)?.map((x) => AreaCityCountry.fromJson(x)).toList() ?? [],
    budget: json['Budget'] != null ? Budget.fromJson(json['Budget']!) : null,
    purposeOfBuying: json['Purpose_of_Buying'] != null ? PurposeOfBuying.fromJson(json['Purpose_of_Buying']!) : null,
    propertyConfiguration: (json['PropertyConfiguration'] as List<dynamic>?)?.map((x) => PropertyConfiguration.fromJson(x)).toList() ?? [],
    intSite: (json['IntSite'] as List<dynamic>?)?.map((x) => IntSite.fromJson(x)).toList() ?? [],
    inqType: (json['InqType'] as List<dynamic>?)?.map((x) => InqType.fromJson(x)).toList() ?? [],
    inqSource: (json['InqSource'] as List<dynamic>?)?.map((x) => InqSource.fromJson(x)).toList() ?? [],
    apxTime: json['ApxTime'] != null ? ApxTime.fromJson(json['ApxTime']!) : null,
  );
}


class CstStatus {
  final String fillInterest;

  CstStatus({required this.fillInterest});

  factory CstStatus.fromJson(Map<String, dynamic> json) =>
      CstStatus(fillInterest: json['fill_interest']);
}

class AreaCityCountry {
  final String id;
  final String area;
  final String city;
  final String state;
  final String country;

  AreaCityCountry({
    required this.id,
    required this.area,
    required this.city,
    required this.state,
    required this.country,
  });

  factory AreaCityCountry.fromJson(Map<String, dynamic> json) => AreaCityCountry(
    id: json['id'] ?? '',  // Use ?? to provide default value if 'id' is null
    area: json['area'] ?? '',
    city: json['city'] ?? '',
    state: json['state'] ?? '',
    country: json['country'] ?? '',
  );
}

class Budget {
  final String values;

  Budget({required this.values});


  factory Budget.fromJson(Map<String, dynamic> json) => Budget(
    values: json['values'] ?? '', //provide a default value
  );
}

class PurposeOfBuying {
  final String investment;
  final String personalUse;

  PurposeOfBuying({required this.investment, required this.personalUse});

  factory PurposeOfBuying.fromJson(Map<String, dynamic> json) => PurposeOfBuying(
    investment: json['Investment'],
    personalUse: json['Personal_Use'],
  );
}

class PropertyConfiguration {
  final String id;
  final String propertyType;

  PropertyConfiguration({required this.id, required this.propertyType});

  factory PropertyConfiguration.fromJson(Map<String, dynamic> json) =>
      PropertyConfiguration(
        id: json['id'],
        propertyType: json['propertyconfiguration_type'],
      );
}

class IntSite {
  final String id;
  final String productName;

  IntSite({required this.id, required this.productName});

  factory IntSite.fromJson(Map<String, dynamic> json) => IntSite(
    id: json['id'] ?? '',
    productName: json['product_name'] ?? '',
  );
}

class InqType {
  final String id;
  final String inquiryDetails;

  InqType({required this.id, required this.inquiryDetails});

  factory InqType.fromJson(Map<String, dynamic> json) => InqType(
    id: json['id'] ?? '',  // Use ?? to provide default value if 'id' is null
    inquiryDetails: json['inquiry_details'] ?? '',
  );
}

class InqSource {
  final String id;
  final String source;

  InqSource({required this.id, required this.source});

  factory InqSource.fromJson(Map<String, dynamic> json) => InqSource(
    id: json['id'],
    source: json['source'].trim(),
  );
}

class ApxTime {
  final String apxTimeData;

  ApxTime({required this.apxTimeData});

  factory ApxTime.fromJson(Map<String, dynamic> json) => ApxTime(
      apxTimeData: json['ApxTimeData'] ?? '' //provide a default value
  );
}

class NextSlot {
  final String id;
  final String source;
  final bool disabled;

  NextSlot({
    required this.id,
    required this.source,
    required this.disabled,
  });

  factory NextSlot.fromJson(Map<String, dynamic> json) {
    return NextSlot(
      id: json['id'] as String,
      source: json['source'] as String,
      disabled: json['disabled'] == 'true', // Convert string "true" to bool
    );
  }
}