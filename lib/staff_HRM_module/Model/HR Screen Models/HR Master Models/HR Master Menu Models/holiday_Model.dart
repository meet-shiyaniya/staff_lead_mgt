class holidayModel {

  final int no;
  final String holidayName;
  final String type;
  final String paidType; // Paid or Unpaid
  final String startHolidayDate; // Start date in DD/MM/YYYY format
  final String endHolidayDate; // End date in DD/MM/YYYY format

  holidayModel({

    required this.no,
    required this.holidayName,
    required this.type,
    required this.paidType,
    required this.startHolidayDate,
    required this.endHolidayDate,

  });

}
