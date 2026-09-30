import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'providers.dart';
import 'router.dart';
import 'zulu_theme.dart';

class ZuluApp extends ConsumerStatefulWidget {
  const ZuluApp({super.key});

  @override
  ConsumerState<ZuluApp> createState() => _ZuluAppState();
}

class _ZuluAppState extends ConsumerState<ZuluApp> {
  late final ValueNotifier<bool> _onboarded = ValueNotifier(ref.read(initialOnboardedProvider));
  late final GoRouter _router = buildRouter(_onboarded);

  @override
  void dispose() {
    _router.dispose();
    _onboarded.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(profileProvider, (previous, next) {
      final done = next.value?.onboardingDoneAt != null;
      if (next.hasValue && done != _onboarded.value) _onboarded.value = done;
    });
    final theme = ref.watch(themeKitProvider).theme;
    return MaterialApp.router(
      title: theme.appName,
      debugShowCheckedModeBanner: false,
      theme: buildZuluTheme(theme.light, Brightness.light),
      darkTheme: buildZuluTheme(theme.dark, Brightness.dark),
      routerConfig: _router,
    );
  }
}
