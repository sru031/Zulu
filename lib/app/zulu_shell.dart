import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// The bottom navigation around the five main tabs. The tab order never
/// changes (spec principle 7).
class ZuluShell extends StatelessWidget {
  const ZuluShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  static const _tabs = [
    (Icons.home_outlined, Icons.home, 'Home'),
    (Icons.storefront_outlined, Icons.storefront, 'Shop'),
    (Icons.backpack_outlined, Icons.backpack, 'Bag'),
    (Icons.menu_book_outlined, Icons.menu_book, 'Journal'),
    (Icons.person_outline, Icons.person, 'Me'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (i) => shell.goBranch(i, initialLocation: i == shell.currentIndex),
        destinations: [
          for (final (icon, selectedIcon, label) in _tabs)
            NavigationDestination(icon: Icon(icon), selectedIcon: Icon(selectedIcon), label: label),
        ],
      ),
    );
  }
}
