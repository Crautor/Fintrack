import 'package:flutter/material.dart';
import 'notification_data.dart';

class NotificationItem extends StatelessWidget {
  final NotificationData data;

  const NotificationItem({super.key, required this.data});

  bool get isTransaction => data.title.toLowerCase().contains('transa');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ícone com fundo verde
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF00D09E), // Cor verde
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  data.icon,
                  color: Colors.black,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título
                    Text(
                      data.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Descrição
                    Text(
                      data.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    // Categoria (se for transação)
                    if (isTransaction && data.category != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        data.category!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF0077B6), // Azul
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                    // Data e hora no canto inferior direito
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "${data.time} - ${data.date}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF0077B6),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Linha verde abaixo
        Container(
          height: 1,
          color: const Color(0xFF00D09E),
        ),
      ],
    );
  }
}



