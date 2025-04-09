class fetchMonthFilterModel {
  List<DropDown>? dropDown;

  fetchMonthFilterModel({this.dropDown});

  fetchMonthFilterModel.fromJson(Map<String, dynamic> json) {
    if (json['Drop_Down'] != null) {
      dropDown = <DropDown>[];
      json['Drop_Down'].forEach((v) {
        dropDown!.add(DropDown.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.dropDown != null) {
      data['Drop_Down'] = this.dropDown!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DropDown {
  String? date;
  String? monthName;

  DropDown({this.date, this.monthName});

  DropDown.fromJson(Map<String, dynamic> json) {
    date = json['Date'];
    monthName = json['Month_Name']; // Updated to match JSON key "Month_Name"
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Date'] = this.date;
    data['Month_Name'] = this.monthName; // Updated to match JSON key "Month_Name"
    return data;
  }
}