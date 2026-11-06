import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  static const _paths = ['/echeances', '/cours', '/profil'];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final index = _paths.indexWhere((p) => location.startsWith(p));
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index < 0 ? 0 : index,
        onDestinationSelected: (i) => context.go(_paths[i]),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.event), label: 'Échéances'),
          NavigationDestination(icon: Icon(Icons.school), label: 'Cours'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}