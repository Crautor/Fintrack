import 'package:flutter/material.dart';

class CategoryIcon {
  final int id;
  final IconData icon;
  final String label;

  const CategoryIcon({
    required this.id,
    required this.icon,
    required this.label,
  });
}

const List<CategoryIcon> categoryIcons = [
  CategoryIcon(id: 1, icon: Icons.restaurant, label: "Comida"),
  CategoryIcon(id: 2, icon: Icons.directions_bus, label: "Transporte"),
  CategoryIcon(id: 3, icon: Icons.health_and_safety, label: "Saúde"),
  CategoryIcon(id: 4, icon: Icons.local_grocery_store, label: "Alimentos"),
  CategoryIcon(id: 5, icon: Icons.vpn_key, label: "Aluguel"),
  CategoryIcon(id: 6, icon: Icons.card_giftcard, label: "Presentes"),
  CategoryIcon(id: 7, icon: Icons.savings, label: "Poupança"),
  CategoryIcon(id: 8, icon: Icons.movie, label: "Entretenimento"),
  CategoryIcon(id: 9, icon: Icons.shopping_bag, label: "Compras"),
  CategoryIcon(id: 10, icon: Icons.school, label: "Educação"),
  CategoryIcon(id: 11, icon: Icons.flight_takeoff, label: "Viagens"),
  CategoryIcon(id: 12, icon: Icons.trending_up, label: "Investimentos"),
  CategoryIcon(id: 13, icon: Icons.directions_car, label: "Carro"),
  CategoryIcon(id: 14, icon: Icons.pets, label: "Animais"),
  CategoryIcon(id: 15, icon: Icons.devices, label: "Tecnologia"),
];

CategoryIcon? getCategoryIconById(int id) {
  return categoryIcons.firstWhere(
    (element) => element.id == id,
    orElse:
        () => CategoryIcon(
          id: 0,
          icon: Icons.help_outline,
          label: "Desconhecido",
        ),
  );
}

CategoryIcon? getCategoryIconByStringId(String id) {
  return categoryIcons.firstWhere(
    (element) => element.id.toString() == id,
    orElse:
        () => CategoryIcon(
          id: 0,
          icon: Icons.help_outline,
          label: "Desconhecido",
        ),
  );
}
