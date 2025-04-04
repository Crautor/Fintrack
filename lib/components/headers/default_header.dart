import 'package:flutter/material.dart';

class DefaultHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool isBackButtonVisible;

  const DefaultHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.isBackButtonVisible = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 125,
      decoration: BoxDecoration(
        color: const Color(0xFF00D09E),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isBackButtonVisible)
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                else
                  SizedBox(width: 20),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment:
                        isBackButtonVisible
                            ? CrossAxisAlignment.center
                            : CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        textAlign:
                            isBackButtonVisible
                                ? TextAlign.center
                                : TextAlign.left,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0E3E3E),
                        ),
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: 4),
                        Text(
                          subtitle!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF0E3E3E),
                            height: 0.1,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFDFF7E2),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.notifications, color: Color(0xFF093030)),
                    onPressed: () {
                      // notificações
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
