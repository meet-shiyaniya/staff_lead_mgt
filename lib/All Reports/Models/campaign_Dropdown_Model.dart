class campaignDropdownModel {
  List<DropDown>? dropDown;

  campaignDropdownModel({this.dropDown});

  campaignDropdownModel.fromJson(Map<String, dynamic> json) {
    if (json['Drop_Down'] != null) {
      dropDown = <DropDown>[];
      json['Drop_Down'].forEach((v) {
        dropDown!.add(new DropDown.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dropDown != null) {
      data['Drop_Down'] = this.dropDown!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DropDown {
  String? pageId;
  String? pageName;

  DropDown({this.pageId, this.pageName});

  DropDown.fromJson(Map<String, dynamic> json) {
    pageId = json['page_id'];
    pageName = json['page_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page_id'] = this.pageId;
    data['page_name'] = this.pageName;
    return data;
  }
}