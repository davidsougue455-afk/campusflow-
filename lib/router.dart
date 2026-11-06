import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/app_shell.dart';
import 'screens/deadlines_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/form_screen.dart';
import 'screens/title_screen.dart';

Widget _placeholder(String titre) => Scaffold(
  appBar: AppBar(title: Text(titre)),
  body: Center(child: Text('$titre : bientôt disponible')),
);

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const TitleScreen()),
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/echeances',
          builder: (context, state) => const DeadlinesScreen(),
          routes: [
            GoRoute(
              path: 'nouvelle',
              builder: (context, state) => const FormScreen(),
            ),
            GoRoute(
              path: ':id',
              builder: (context, state) =>
                  DetailScreen(id: state.pathParameters['id']!),
            ),
          ],
        ),
        GoRoute(path: '/cours', builder: (context, state) => _placeholder('Cours')),
        GoRoute(path: '/profil', builder: (context, state) => _placeholder('Profil')),
      ],
    ),
  ],
);