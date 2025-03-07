// import 'package:hr_app/Inquiry_Management/Model/Api%20Model/allInquiryModel.dart';

import 'followup_Model.dart';

class CategoryModel {
  final String title;
  final List<LeadModel> leads; // List of leads in this category

  CategoryModel(this.title, this.leads);

  // Count the number of leads in this category
  int get leadCount => leads.length;
}

class Categorymodel {
  String title;
  int leads;

  Categorymodel(this.title, this.leads);
}