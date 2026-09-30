import 'package:go_router/go_router.dart';

import '../features/bag/ui/bag_screen.dart';
import '../features/home/ui/home_screen.dart';
import '../features/journal/ui/journal_screen.dart';
import '../features/me/ui/me_screen.dart';
import '../features/shop/ui/shop_screen.dart';
import 'zulu_shell.dart';

GoRouter buildRouter() => GoRouter(
      initialLocation: '/home',
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, shell) => ZuluShell(shell: shell),
          branches: [
            StatefulShellBranch(routes: [GoRoute(path: '/home', builder: (context, state) => const HomeScreen())]),
            StatefulShellBranch(routes: [GoRoute(path: '/shop', builder: (context, state) => const ShopScreen())]),
            StatefulShellBranch(routes: [GoRoute(path: '/bag', builder: (context, state) => const BagScreen())]),
            StatefulShellBranch(routes: [GoRoute(path: '/journal', builder: (context, state) => const JournalScreen())]),
            StatefulShellBranch(routes: [GoRoute(path: '/me', builder: (context, state) => const MeScreen())]),
          ],
        ),
      ],
    );
