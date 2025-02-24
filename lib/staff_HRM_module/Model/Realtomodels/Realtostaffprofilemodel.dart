class Realtostaffprofilemodel {
  int? status;
  String? message;
  StaffProfile? staffProfile;

  Realtostaffprofilemodel({this.status, this.message, this.staffProfile});

  Realtostaffprofilemodel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    staffProfile = json['StaffProfile'] != null
        ? new StaffProfile.fromJson(json['StaffProfile'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.staffProfile != null) {
      data['StaffProfile'] = this.staffProfile!.toJson();
    }
    return data;
  }
}

class StaffProfile {
  String? employeeId;
  String? userName;
  String? name;
  String? profileImg;
  String? gender;
  String? workEmail;
  String? weekofday;
  String? headName;
  String? bloodgroup;
  String? maritalStatus;
  String? altmobileno;
  String? activeFromTime;
  String? activeToTime;
  String? workShift;
  String? assignProject;
  String? address;
  String? userRole;
  String? department;
  String? phoneNumberPersonal;
  String? phoneNumberAllocation;
  String? email;
  String? joinDate;
  String? jobLocation;
  String? sessionActive;
  String? status;
  String? isAttendance;
  String? staffAttendanceMethod;
  String? attendanceMethod;

  StaffProfile(
      {this.employeeId,
        this.userName,
        this.name,
        this.profileImg,
        this.gender,
        this.workEmail,
        this.weekofday,
        this.headName,
        this.bloodgroup,
        this.maritalStatus,
        this.altmobileno,
        this.activeFromTime,
        this.activeToTime,
        this.workShift,
        this.assignProject,
        this.address,
        this.userRole,
        this.department,
        this.phoneNumberPersonal,
        this.phoneNumberAllocation,
        this.email,
        this.joinDate,
        this.jobLocation,
        this.sessionActive,
        this.status,
        this.isAttendance,
        this.staffAttendanceMethod,
        this.attendanceMethod});

  StaffProfile.fromJson(Map<String, dynamic> json) {
    employeeId = json['employee_id'];
    userName = json['user_name'];
    name = json['name'];
    profileImg = json['profile_img'];
    gender = json['gender'];
    workEmail = json['work_email'];
    weekofday = json['weekofday'];
    headName = json['head_name'];
    bloodgroup = json['bloodgroup'];
    maritalStatus = json['marital_status'];
    altmobileno = json['altmobileno'];
    activeFromTime = json['active_from_time'];
    activeToTime = json['active_to_time'];
    workShift = json['work_shift'];
    assignProject = json['assign_project'];
    address = json['address'];
    userRole = json['user_role'];
    department = json['department'];
    phoneNumberPersonal = json['phone_number_personal'];
    phoneNumberAllocation = json['phone_number_allocation'];
    email = json['email'];
    joinDate = json['join_date'];
    jobLocation = json['job_location'];
    sessionActive = json['session_active'];
    status = json['status'];
    isAttendance = json['is_attendance'];
    staffAttendanceMethod = json['Staff_attendance_method'];
    attendanceMethod = json['Attendance_method'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employee_id'] = this.employeeId;
    data['user_name'] = this.userName;
    data['name'] = this.name;
    data['profile_img'] = this.profileImg;
    data['gender'] = this.gender;
    data['work_email'] = this.workEmail;
    data['weekofday'] = this.weekofday;
    data['head_name'] = this.headName;
    data['bloodgroup'] = this.bloodgroup;
    data['marital_status'] = this.maritalStatus;
    data['altmobileno'] = this.altmobileno;
    data['active_from_time'] = this.activeFromTime;
    data['active_to_time'] = this.activeToTime;
    data['work_shift'] = this.workShift;
    data['assign_project'] = this.assignProject;
    data['address'] = this.address;
    data['user_role'] = this.userRole;
    data['department'] = this.department;
    data['phone_number_personal'] = this.phoneNumberPersonal;
    data['phone_number_allocation'] = this.phoneNumberAllocation;
    data['email'] = this.email;
    data['join_date'] = this.joinDate;
    data['job_location'] = this.jobLocation;
    data['session_active'] = this.sessionActive;
    data['status'] = this.status;
    data['is_attendance'] = this.isAttendance;
    data['Staff_attendance_method'] = this.staffAttendanceMethod;
    data['Attendance_method'] = this.attendanceMethod;
    return data;
  }
}