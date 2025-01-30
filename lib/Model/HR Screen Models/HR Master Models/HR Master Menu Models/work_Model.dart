import 'package:flutter/material.dart';

class workModel {

  final int no;
  final String departmentName;
  final String fullDayTime;
  final String halfDayTime;
  final String maxOTAllow;
  final int maxLateNumber;
  final Color color;
  final Color subColor;

  workModel ({

    required this.no,
    required this.departmentName,
    required this.fullDayTime,
    required this.halfDayTime,
    required this.maxOTAllow,
    required this.maxLateNumber,
    required this.color,
    required this.subColor,

  });

}