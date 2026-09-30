import '../../content/onboarding_script.dart';
import '../pet/trait.dart';
import '../text/template.dart';
import 'answers.dart';

/// What onboarding decided: the pet and the profile basics, read from the
/// answers with sensible fallbacks for anything skipped.
class OnboardingOutcome {
  const OnboardingOutcome({
    required this.petName,
    required this.pronouns,
    required this.eggColor,
    required this.trait,
    required this.traitStats,
    required this.userName,
    required this.wakeTime,
    required this.bedTime,
  });

  final String petName;
  final Pronouns pronouns;
  final String eggColor;
  final Trait trait;
  final Map<Trait, double> traitStats;
  final String userName;
  final String wakeTime;
  final String bedTime;

  factory OnboardingOutcome.from({
    required OnboardingScript script,
    required Answers answers,
    required double startingBonus,
    required String fallbackEgg,
  }) {
    OnboardingStep? stepFor(SaveTo target) {
      for (final s in script.steps) {
        if (s.saveTo == target) return s;
      }
      return null;
    }

    String? saved(SaveTo target) {
      final step = stepFor(target);
      final value = step == null ? null : answers[step.id];
      return value is String && value.trim().isNotEmpty ? value.trim() : null;
    }

    final trait = Trait.values.asNameMap()[saved(SaveTo.petTrait)] ?? Trait.curiosity;
    final stats = <Trait, double>{trait: startingBonus};
    for (final s in script.steps) {
      if (s.type != StepType.talkChoice) continue;
      final value = answers[s.id];
      final option = value is String ? s.option(value) : null;
      final nudged = option?.trait;
      if (option != null && nudged != null) stats[nudged] = (stats[nudged] ?? 0) + option.nudge;
    }

    return OnboardingOutcome(
      petName: saved(SaveTo.petName) ?? stepFor(SaveTo.petName)?.suggestions.firstOrNull ?? 'Pip',
      pronouns: Pronouns.fromId(saved(SaveTo.petPronouns) ?? 'they'),
      eggColor: saved(SaveTo.petEggColor) ?? fallbackEgg,
      trait: trait,
      traitStats: stats,
      userName: saved(SaveTo.userName) ?? '',
      wakeTime: saved(SaveTo.wakeTime) ?? stepFor(SaveTo.wakeTime)?.defaultValue ?? '07:30',
      bedTime: saved(SaveTo.bedTime) ?? stepFor(SaveTo.bedTime)?.defaultValue ?? '23:00',
    );
  }
}
