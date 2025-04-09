class performanceModel {
  String? freshToContected;
  String? freshToConnectedTotal;
  String? contectedToAppointment;
  String? connectedToAppointmentTotal;
  String? appointmentToVisit;
  String? appointmentToVisiteTotal;
  String? visitToFeedback;
  String? visiteToFeedbackTotal;
  String? feedbackToRevisit;
  String? feedbackToRevisitTotal;
  String? revisitToConverted;
  String? revisitToConvertedTotal;
  String? freshToVisit;
  String? freshToVisitTotal;
  String? freshToConverted;
  String? freshToConvertedTotal;
  String? freshToConnectedPercentage;
  String? connectedToVisitPercentage;
  String? visitToConvertedPercentage;
  String? freshToAppoinmentPercentage;
  String? freshToVisitedPercentage;
  List<String>? timeStatusname;
  List<int>? timeTotal;
  List<String>? productivityChartStatusname;
  List<int>? productivityChartTotal;
  int? productivityTotalCount;

  performanceModel(
      {this.freshToContected,
        this.freshToConnectedTotal,
        this.contectedToAppointment,
        this.connectedToAppointmentTotal,
        this.appointmentToVisit,
        this.appointmentToVisiteTotal,
        this.visitToFeedback,
        this.visiteToFeedbackTotal,
        this.feedbackToRevisit,
        this.feedbackToRevisitTotal,
        this.revisitToConverted,
        this.revisitToConvertedTotal,
        this.freshToVisit,
        this.freshToVisitTotal,
        this.freshToConverted,
        this.freshToConvertedTotal,
        this.freshToConnectedPercentage,
        this.connectedToVisitPercentage,
        this.visitToConvertedPercentage,
        this.freshToAppoinmentPercentage,
        this.freshToVisitedPercentage,
        this.timeStatusname,
        this.timeTotal,
        this.productivityChartStatusname,
        this.productivityChartTotal,
        this.productivityTotalCount});

  performanceModel.fromJson(Map<String, dynamic> json) {
    freshToContected = json['fresh_to_contected'];
    freshToConnectedTotal = json['fresh_to_connected_total'];
    contectedToAppointment = json['contected_to_appointment'];
    connectedToAppointmentTotal = json['connected_to_appointment_total'];
    appointmentToVisit = json['appointment_to_visit'];
    appointmentToVisiteTotal = json['appointment_to_visite_total'];
    visitToFeedback = json['visit_to_feedback'];
    visiteToFeedbackTotal = json['visite_to_feedback_total'];
    feedbackToRevisit = json['feedback_to_revisit'];
    feedbackToRevisitTotal = json['feedback_to_revisit_total'];
    revisitToConverted = json['revisit_to_converted'];
    revisitToConvertedTotal = json['revisit_to_converted_total'];
    freshToVisit = json['fresh_to_visit'];
    freshToVisitTotal = json['fresh_to_visit_total'];
    freshToConverted = json['fresh_to_converted'];
    freshToConvertedTotal = json['fresh_to_converted_total'];
    freshToConnectedPercentage = json['fresh_to_connected_percentage'];
    connectedToVisitPercentage = json['connected_to_visit_percentage'];
    visitToConvertedPercentage = json['visit_to_converted_percentage'];
    freshToAppoinmentPercentage = json['fresh_to_appoinment_percentage'];
    freshToVisitedPercentage = json['fresh_to_visited_percentage'];
    timeStatusname = json['time_statusname'].cast<String>();
    timeTotal = json['time_total'].cast<int>();
    productivityChartStatusname =
        json['productivity_chart_statusname'].cast<String>();
    productivityChartTotal = json['productivity_chart_total'].cast<int>();
    productivityTotalCount = json['productivity_total_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fresh_to_contected'] = this.freshToContected;
    data['fresh_to_connected_total'] = this.freshToConnectedTotal;
    data['contected_to_appointment'] = this.contectedToAppointment;
    data['connected_to_appointment_total'] = this.connectedToAppointmentTotal;
    data['appointment_to_visit'] = this.appointmentToVisit;
    data['appointment_to_visite_total'] = this.appointmentToVisiteTotal;
    data['visit_to_feedback'] = this.visitToFeedback;
    data['visite_to_feedback_total'] = this.visiteToFeedbackTotal;
    data['feedback_to_revisit'] = this.feedbackToRevisit;
    data['feedback_to_revisit_total'] = this.feedbackToRevisitTotal;
    data['revisit_to_converted'] = this.revisitToConverted;
    data['revisit_to_converted_total'] = this.revisitToConvertedTotal;
    data['fresh_to_visit'] = this.freshToVisit;
    data['fresh_to_visit_total'] = this.freshToVisitTotal;
    data['fresh_to_converted'] = this.freshToConverted;
    data['fresh_to_converted_total'] = this.freshToConvertedTotal;
    data['fresh_to_connected_percentage'] = this.freshToConnectedPercentage;
    data['connected_to_visit_percentage'] = this.connectedToVisitPercentage;
    data['visit_to_converted_percentage'] = this.visitToConvertedPercentage;
    data['fresh_to_appoinment_percentage'] = this.freshToAppoinmentPercentage;
    data['fresh_to_visited_percentage'] = this.freshToVisitedPercentage;
    data['time_statusname'] = this.timeStatusname;
    data['time_total'] = this.timeTotal;
    data['productivity_chart_statusname'] = this.productivityChartStatusname;
    data['productivity_chart_total'] = this.productivityChartTotal;
    data['productivity_total_count'] = this.productivityTotalCount;
    return data;
  }
}
