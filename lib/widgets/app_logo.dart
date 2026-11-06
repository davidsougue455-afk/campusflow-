import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double height;

  const AppLogo({super.key, this.height = 96});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(height * 0.2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.2),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Image.asset('assets/images/logo.png', height: height),
    );
  }
}