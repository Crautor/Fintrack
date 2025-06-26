import 'package:flutter/material.dart';

class DefaultHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool isBackButtonVisible;
  final Widget? child;
  final VoidCallback? onBack;
  final List<Widget>? extraActions; // ✅ apenas ícones adicionais

  const DefaultHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.isBackButtonVisible = false,
    this.child,
    this.onBack,
    this.extraActions,
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
              Stack(
                alignment: Alignment.center,
                children: [
                  if (isBackButtonVisible)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: onBack ?? () => Navigator.pop(context),
                      ),
                    ),

                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.center,
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

                  if (extraActions != null)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: extraActions!,
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
