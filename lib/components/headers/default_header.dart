import 'package:flutter/material.dart';
import 'package:fintrack/screens/notification_page.dart';

class DefaultHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool isBackButtonVisible;
  final Widget? child;

  const DefaultHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.isBackButtonVisible = false,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF00D09E),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                isBackButtonVisible
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (isBackButtonVisible)
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    )
                  else
                    const SizedBox(width: 20),
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
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0E3E3E),
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            subtitle!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
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
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.notifications_none,
                        color: Color(0xFF093030),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/notifications');
                      },
                      splashRadius: 20,
                    ),
                  ),
                ],
              ),
              if (child != null) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00D09E),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: child!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
