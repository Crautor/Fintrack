import 'package:flutter/material.dart';
import 'notification_card.dart';

class NotificationSection extends StatelessWidget {
  final String title;
  final List<NotificationCard> cards;

  const NotificationSection({
    super.key,
    required this.title,
    required this.cards,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        ...cards,
      ],
    );
  }
}