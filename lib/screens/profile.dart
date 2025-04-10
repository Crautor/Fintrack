import 'package:flutter/material.dart';
import 'home.dart';
import 'package:fintrack/components/custom_nav_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text('Perfil')),
      bottomNavigationBar: CustomNavBar(currentIndex: 4),
    );
  }
}

