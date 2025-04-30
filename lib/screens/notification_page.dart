import 'package:flutter/material.dart';
import 'package:fintrack/components/notifications/notification_item.dart';
import 'package:fintrack/components/notifications/notification_data.dart';
import 'package:fintrack/components/headers/default_header.dart';

class NotificationPage extends StatelessWidget {
  NotificationPage({super.key});

  final List<NotificationData> notifications = [
    NotificationData(
      icon: Icons.notifications_active_outlined,
      title: "Alerta!",
      description: "Configure sua poupança automática para atingir sua meta de economia...",
      time: "17:00",
      date: "24 Abril",
      iconBackground: const Color(0xFF00D09E),
    ),
    NotificationData(
      icon: Icons.star_border,
      title: "Nova Atualização",
      description: "Configure sua poupança automática para atingir sua meta de economia...",
      time: "17:00",
      date: "24 Abril",
      iconBackground: const Color(0xFF00D09E),
    ),
    NotificationData(
      icon: Icons.attach_money,
      title: "Transações",
      description: "Uma nova transação foi registrada",
      time: "17:00",
      date: "24 Abril",
      iconBackground: const Color(0xFF00D09E),
      category: "Alimentos | Mantimentos | -R\$100,00",
    ),
    NotificationData(
      icon: Icons.notifications_active_outlined,
      title: "Alerta!",
      description: "Configure sua poupança automática para atingir sua meta de economia...",
      time: "17:00",
      date: "23 Abril",
      iconBackground: const Color(0xFF00D09E),
    ),
    NotificationData(
      icon: Icons.trending_down,
      title: "Recorde De Despesas",
      description: "Configure sua poupança automática para atingir sua meta de economia...",
      time: "17:00",
      date: "22 Abril",
      iconBackground: const Color(0xFF00D09E),
    ),
    NotificationData(
      icon: Icons.attach_money,
      title: "Transações",
      description: "Uma nova transação foi registrada",
      time: "17:00",
      date: "22 Abril",
      iconBackground: const Color(0xFF00D09E),
      category: "Alimentos | Mantimentos | -R\$100,00",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00D09E),
      body: Column(
        children: [
          const DefaultHeader(
            title: "Notificações",
            isBackButtonVisible: true,
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: ListView(
                padding: const EdgeInsets.all(15),
                children: [
                  const Text(
                    "Hoje",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...notifications
                      .where((n) => n.date == "24 Abril")
                      .map((n) => NotificationItem(data: n)),
                  const SizedBox(height: 24),
                  const Text(
                    "Ontem",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...notifications
                      .where((n) => n.date == "23 Abril")
                      .map((n) => NotificationItem(data: n)),
                  const SizedBox(height: 24),
                  const Text(
                    "Esta Semana",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...notifications
                      .where((n) => n.date == "22 Abril")
                      .map((n) => NotificationItem(data: n)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
