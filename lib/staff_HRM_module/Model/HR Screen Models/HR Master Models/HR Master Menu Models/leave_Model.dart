class leaveModel {

  int no;
  String leaveName;
  String leaveType;
  String paidType;
  int? annualLimit;

  leaveModel({

    required this.no,
    required this.leaveName,
    required this.leaveType,
    required this.paidType,
    this.annualLimit,

  });

}