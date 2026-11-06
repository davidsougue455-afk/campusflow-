import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/title_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
void main() {
  runApp(const ProviderScope(child: MyApp()));}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusFlow',
      theme: AppTheme.light,
      home: const TitleScreen(),
    );
  }
}