
import 'dart:ui';

class Task {
  // final String title;
  final String time;
  final int leads;
  final Color color;
  // final List<String> avatars;

  Task({
    // required this.title,
    required this.time,
    required this.leads,
    required this.color,
    // required this.avatars,
  });
}

class FollowupData {
  final int id;
  final String name;
  final String member;
  final String inquiryType;
  final String dateTime;
  final String nextfollowup;
  final String product;
  final String apxbuying;
  final String duration;
  final String services;
  final String label;

  FollowupData({
    required this.id,
    required this.name,
    required this.member,
    required this.inquiryType,
    required this.dateTime,
    required this.nextfollowup,
    required this.product,
    required this.apxbuying,
    required this.duration,
    required this.services,
    required this.label,

  });
}
class LeadModel{
  final String id;
  final String name;
  final String label;
  final String username;
  final String followUpDate;
  final String nextFollowUpDate;
  final String inquiryType;
  final String phone;
  final String email;
  final String source;
  final String product;
  final String apxbuying;
  final String duration;
  final String services;
  final String description;
  LeadModel(
      this.id,
      this.name,
      this.username,
      this.label,
      this.followUpDate,
      this.nextFollowUpDate,
      this.inquiryType,
      this.phone,
      this.email,
      this.source,
      this.product,
      this.apxbuying,
      this.services,
      this.duration,
      this.description

      );
}