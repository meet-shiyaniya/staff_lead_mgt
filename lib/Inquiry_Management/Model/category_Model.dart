import 'followup_Model.dart';

class CategoryModel {
  final String title;
  final List<LeadModel> leads; // List of leads in this category

  CategoryModel(this.title, this.leads);

  // Count the number of leads in this category
  int get leadCount => leads.length;
}
