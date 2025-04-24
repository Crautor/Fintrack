import 'package:flutter/material.dart';
import '../components/notifications/notification_section.dart';
import '../components/notifications/notification_card.dart';
import 'package:fintrack/components/custom_nav_bar.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9FFF9),
      appBar: AppBar(
        title: const Text("Notificações"),
        centerTitle: true,
        backgroundColor: const Color(0xFF00D09E),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      bottomNavigationBar: const CustomNavBar(currentIndex: -1), 
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          NotificationSection(
            title: "Hoje",
            cards: [
              NotificationCard(
                icon: Icons.notifications,
                title: "Alerta!",
                description: "Configure sua poupança automática para atingir sua meta de economia…",
                time: "17:00 - 24 Abril",
                iconColor: Colors.black,
              ),
              NotificationCard(
                icon: Icons.star,
                title: "Nova Atualização",
                description: "Configure sua poupança automática para atingir sua meta de economia…",
                time: "17:00 - 24 Abril",
                iconColor: Colors.black,
              ),
            ],
          ),
          NotificationSection(
            title: "Ontem",
            cards: [
              NotificationCard(
                icon: Icons.attach_money,
                title: "Transações",
                description: "Alimentos | Mantimentos | -R\$100,00",
                time: "17:00 - 24 Abril",
                iconColor: Colors.black,
              ),
            ],
          ),
          NotificationSection(
            title: "Esta Semana",
            cards: [
              NotificationCard(
                icon: Icons.arrow_downward,
                title: "Recorde de Despesas",
                description: "Configure sua poupança automática para atingir sua meta de economia…",
                time: "17:00 - 24 Abril",
                iconColor: Colors.black,
              ),
              NotificationCard(
                icon: Icons.attach_money,
                title: "Transações",
                description: "Alimentos | Mantimentos | -R\$70,40",
                time: "17:00 - 24 Abril",
                iconColor: Colors.black,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
