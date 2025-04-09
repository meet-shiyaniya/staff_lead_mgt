class EditLeadData {
  final String id;
  final String fullName;
  final String mobileno;
  final String altmobileno;
  final String email;
  final String houseno;
  final String society;
  final String area;
  final String city;
  final String countryCode;
  final String altCountryCode;
  final String intrestedArea;
  final String intrestedAreaName;
  final String interstedSiteName;
  final String budget;
  final String purposeBuy;
  final String approxBuy;
  final String propertyConfiguration;
  final String inquiryType;
  final String inquirySourceType;
  final String nxtFollowUp;
  final String inquiryDescription;

  EditLeadData({
    required this.id,
    required this.fullName,
    required this.mobileno,
    required this.altmobileno,
    required this.email,
    required this.houseno,
    required this.society,
    required this.area,
    required this.city,
    required this.countryCode,
    required this.altCountryCode,
    required this.intrestedArea,
    required this.intrestedAreaName,
    required this.interstedSiteName,
    required this.budget,
    required this.purposeBuy,
    required this.approxBuy,
    required this.propertyConfiguration,
    required this.inquiryType,
    required this.inquirySourceType,
    required this.nxtFollowUp,
    required this.inquiryDescription,
  });

  factory EditLeadData.fromJson(Map<String, dynamic> json) {
    return EditLeadData(
      id: json['id']?.toString() ?? '', // Ensure string type
      fullName: json['full_name'] ?? '',
      mobileno: json['mobileno'] ?? '',
      altmobileno: json['altmobileno'] ?? '',
      email: json['email'] ?? '',
      houseno: json['houseno'] ?? '',
      society: json['society'] ?? '',
      area: json['area'] ?? '',
      city: json['city'] ?? '',
      countryCode: json['country_code'] ?? '',
      altCountryCode: json['alt_country_code'] ?? '',
      // Handle intrested_area as a string, not an object
      intrestedArea: json['intrested_area'] is Map
          ? json['intrested_area']['id']?.toString() ?? ''
          : json['intrested_area']?.toString() ?? '',
      intrestedAreaName: json['intrested_area_name'] ?? '',
      interstedSiteName: json['intersted_site_name'] ?? '',
      budget: json['budget'] ?? '',
      purposeBuy: json['purpose_buy'] ?? '',
      approxBuy: json['approx_buy'] ?? '',
      propertyConfiguration: json['PropertyConfiguration'] ?? '',
      // Safely handle nested objects
      inquiryType: json['inquiry_type'] is Map
          ? json['inquiry_type']['id']?.toString() ?? ''
          : json['inquiry_type']?.toString() ?? '',
      inquirySourceType: json['inquiry_source_type'] is Map
          ? json['inquiry_source_type']['id']?.toString() ?? ''
          : json['inquiry_source_type']?.toString() ?? '',
      nxtFollowUp: json['nxt_follow_up'] ?? '',
      inquiryDescription: json['inquiry_description'] ?? '',
    );
  }


  @override
  String toString() {
    return 'EditLeadData(id: $id, fullName: $fullName, mobileno: $mobileno, area: $area, city: $city)';
  }
}