import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Página Inicial')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // children: [
          //   ElevatedButton(
          //     onPressed: () {
          //       Navigator.pushNamed(context, AppRoutes.profile);
          //     },
          //     child: const Text('Ir para Perfil'),
          //   ),
          //   ElevatedButton(
          //     onPressed: () {
          //       Navigator.pushNamed(context, AppRoutes.settings);
          //     },
          //     child: const Text('Ir para Configurações'),
          //   ),
          // ],
        ),
      ),
    );
  }
}
