import 'package:flutter/material.dart';

class NotificationData {
  final IconData icon;
  final String title;
  final String description;
  final String time;
  final String date;
  final Color iconBackground;
  final String? category;

  NotificationData({
    required this.icon,
    required this.title,
    required this.description,
    required this.time,
    required this.date,
    required this.iconBackground,
    this.category,
  });
}

