class DashboardpermissionModel {
  bool? mainDboard;
  bool? allDashboard;
  bool? siteDashboard;
  bool? teamDashboard;
  bool? dashbordTodayTask;
  bool? dashbordPerfomancePercentage;
  bool? dashbordChatTable;
  bool? dashbordPendingFollowup;
  bool? dashbordSiteConversation;
  bool? appointmentCalender;
  bool? upcomingTodayVisit;
  bool? dashbordLeadQuality;
  bool? dashbordDismissInqReport;
  bool? dashbordFollowupsSection;
  bool? dashbordActivitySection;
  bool? dashbordStatusWiseIn;

  DashboardpermissionModel(
      {this.mainDboard,
        this.allDashboard,
        this.siteDashboard,
        this.teamDashboard,
        this.dashbordTodayTask,
        this.dashbordPerfomancePercentage,
        this.dashbordChatTable,
        this.dashbordPendingFollowup,
        this.dashbordSiteConversation,
        this.appointmentCalender,
        this.upcomingTodayVisit,
        this.dashbordLeadQuality,
        this.dashbordDismissInqReport,
        this.dashbordFollowupsSection,
        this.dashbordActivitySection,
        this.dashbordStatusWiseIn});

  DashboardpermissionModel.fromJson(Map<String, dynamic> json) {
    mainDboard = json['main_Dboard'];
    allDashboard = json['all_dashboard'];
    siteDashboard = json['site_dashboard'];
    teamDashboard = json['team_dashboard'];
    dashbordTodayTask = json['dashbord_today_task'];
    dashbordPerfomancePercentage = json['dashbord_perfomance_percentage'];
    dashbordChatTable = json['dashbord_chat_table'];
    dashbordPendingFollowup = json['dashbord_pending_followup'];
    dashbordSiteConversation = json['dashbord_site_conversation'];
    appointmentCalender = json['appointment_calender'];
    upcomingTodayVisit = json['upcoming_today_visit'];
    dashbordLeadQuality = json['dashbord_lead_quality'];
    dashbordDismissInqReport = json['dashbord_dismiss_inq_report'];
    dashbordFollowupsSection = json['dashbord_followups_section'];
    dashbordActivitySection = json['dashbord_activity_section'];
    dashbordStatusWiseIn = json['dashbord_status_wise_in'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['main_Dboard'] = this.mainDboard;
    data['all_dashboard'] = this.allDashboard;
    data['site_dashboard'] = this.siteDashboard;
    data['team_dashboard'] = this.teamDashboard;
    data['dashbord_today_task'] = this.dashbordTodayTask;
    data['dashbord_perfomance_percentage'] = this.dashbordPerfomancePercentage;
    data['dashbord_chat_table'] = this.dashbordChatTable;
    data['dashbord_pending_followup'] = this.dashbordPendingFollowup;
    data['dashbord_site_conversation'] = this.dashbordSiteConversation;
    data['appointment_calender'] = this.appointmentCalender;
    data['upcoming_today_visit'] = this.upcomingTodayVisit;
    data['dashbord_lead_quality'] = this.dashbordLeadQuality;
    data['dashbord_dismiss_inq_report'] = this.dashbordDismissInqReport;
    data['dashbord_followups_section'] = this.dashbordFollowupsSection;
    data['dashbord_activity_section'] = this.dashbordActivitySection;
    data['dashbord_status_wise_in'] = this.dashbordStatusWiseIn;
    return data;
  }
}
