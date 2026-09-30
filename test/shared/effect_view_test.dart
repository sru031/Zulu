import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';
import 'package:material_ui/material_ui.dart';
import 'package:zulu/shared/widgets/effect_view.dart';
import 'package:zulu/theme_kit/effect_registry.dart';
import 'package:zulu/theme_kit/theme_kit.dart';

import '../helpers/read_file.dart';
import '../helpers/test_app.dart';

void main() {
  late ThemeKit kit;

  setUpAll(() async => kit = await loadThemeKit(readFile));

  const fallback = Key('effect-fallback');

  testWidgets('plays the registered Lottie file', (tester) async {
    await pumpInApp(tester, const EffectView(EffectName.goalDone), kit: kit);
    expect(find.byType(LottieBuilder), findsOneWidget);
    expect(find.byKey(fallback), findsNothing);
  });

  testWidgets('uses the built-in animation when no file is registered', (tester) async {
    final noEffects = ThemeKit(
      theme: kit.theme,
      pet: kit.pet,
      items: kit.items,
      rooms: kit.rooms,
      effects: const EffectRegistry({}),
    );
    await pumpInApp(tester, const EffectView(EffectName.goalDone), kit: noEffects);
    expect(find.byKey(fallback), findsOneWidget);
    expect(find.byType(LottieBuilder), findsNothing);
  });

  testWidgets('uses the calm fallback when the system asks to reduce motion', (tester) async {
    await pumpInApp(
      tester,
      const MediaQuery(data: MediaQueryData(disableAnimations: true), child: EffectView(EffectName.goalDone)),
      kit: kit,
    );
    expect(find.byKey(fallback), findsOneWidget);
  });
}
