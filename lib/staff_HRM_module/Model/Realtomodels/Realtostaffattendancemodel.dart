class Realtostaffattendancemodel {
  String? status;
  Data? data;
  String? timestamp;

  Realtostaffattendancemodel({this.status, this.data, this.timestamp});

  Realtostaffattendancemodel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['timestamp'] = this.timestamp;
    return data;
  }
}

class Data {
  String? month;
  int? year;
  int? staffId;
  List<Calendar>? calendar;

  Data({this.month, this.year, this.staffId, this.calendar});

  Data.fromJson(Map<String, dynamic> json) {
    month = json['month'];
    year = json['year'];
    staffId = json['staff_id'];
    if (json['calendar'] != null) {
      calendar = <Calendar>[];
      json['calendar'].forEach((v) {
        calendar!.add(new Calendar.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['month'] = this.month;
    data['year'] = this.year;
    data['staff_id'] = this.staffId;
    if (this.calendar != null) {
      data['calendar'] = this.calendar!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Calendar {
  String? date;
  String? status;
  String? statusColor;
  String? inTime;
  String? outTime;
  String? inStatusColor;
  String? outStatusColor;
  String? workTime;
  int? isWeekoff;
  int? isLeave;
  Holiday? holiday;

  Calendar(
      {this.date,
        this.status,
        this.statusColor,
        this.inTime,
        this.outTime,
        this.inStatusColor,
        this.outStatusColor,
        this.workTime,
        this.isWeekoff,
        this.isLeave,
        this.holiday});

  Calendar.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    status = json['status'];
    statusColor = json['status_color'];
    inTime = json['in_time'];
    outTime = json['out_time'];
    inStatusColor = json['in_status_color'];
    outStatusColor = json['out_status_color'];
    workTime = json['work_time'];
    isWeekoff = json['is_weekoff'];
    isLeave = json['is_leave'];
    holiday =
    json['holiday'] != null ? new Holiday.fromJson(json['holiday']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['status'] = this.status;
    data['status_color'] = this.statusColor;
    data['in_time'] = this.inTime;
    data['out_time'] = this.outTime;
    data['in_status_color'] = this.inStatusColor;
    data['out_status_color'] = this.outStatusColor;
    data['work_time'] = this.workTime;
    data['is_weekoff'] = this.isWeekoff;
    data['is_leave'] = this.isLeave;
    if (this.holiday != null) {
      data['holiday'] = this.holiday!.toJson();
    }
    return data;
  }
}

class Holiday {
  String? name;
  String? status;

  Holiday({this.name, this.status});

  Holiday.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['status'] = this.status;
    return data;
  }
}