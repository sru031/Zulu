import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/providers.dart';
import '../../app/zulu_theme.dart';
import '../../theme_kit/effect_registry.dart';
import '../../theme_kit/theme_kit.dart';

/// Plays a celebration effect from the theme. With no file, or when the
/// system asks to reduce motion, shows a simple fade instead (spec §4.5).
class EffectView extends ConsumerWidget {
  const EffectView(this.effect, {super.key, this.size = 160, this.repeat = false});

  final EffectName effect;
  final double size;
  final bool repeat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final path = ref.watch(themeKitProvider).effects.fileFor(effect);
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final Widget child = path == null || reduceMotion
        ? const _FadeFallback(key: Key('effect-fallback'))
        : Lottie.asset(
            ThemeKit.assetPath(path),
            repeat: repeat,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stack) => const _FadeFallback(key: Key('effect-fallback')),
          );
    return ExcludeSemantics(child: SizedBox.square(dimension: size, child: child));
  }
}

class _FadeFallback extends StatelessWidget {
  const _FadeFallback({super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 300),
      builder: (context, t, _) => Opacity(
        opacity: 1 - t * 0.6,
        child: Center(
          child: FractionallySizedBox(
            widthFactor: 0.3 + 0.2 * t,
            heightFactor: 0.3 + 0.2 * t,
            child: DecoratedBox(
              decoration: BoxDecoration(color: context.zuluColors.energy, shape: BoxShape.circle),
            ),
          ),
        ),
      ),
    );
  }
}
