import '../../content/onboarding_script.dart';
import 'answers.dart';

/// Where a quiz step sits: which section, and how much of that section is
/// already behind the user (0 = just started).
class SectionProgress {
  const SectionProgress({
    required this.sectionIndex,
    required this.sectionCount,
    required this.label,
    required this.withinSection,
  });

  final int sectionIndex;
  final int sectionCount;
  final String label;
  final double withinSection;
}

/// Walks the onboarding script: which steps are visible for the current
/// answers, what comes next, and which answers no longer apply.
class QuestionFlow {
  const QuestionFlow(this.script);

  final OnboardingScript script;

  bool isVisible(OnboardingStep step, Answers answers) => step.showIf?.matches(answers) ?? true;

  List<OnboardingStep> visibleSteps(Answers answers) => [
        for (final s in script.steps)
          if (isVisible(s, answers)) s,
      ];

  OnboardingStep? next(String currentId, Answers answers) {
    for (var i = script.indexOf(currentId) + 1; i < script.steps.length; i++) {
      if (isVisible(script.steps[i], answers)) return script.steps[i];
    }
    return null;
  }

  OnboardingStep? previous(String currentId, Answers answers) {
    for (var i = script.indexOf(currentId) - 1; i >= 0; i--) {
      if (isVisible(script.steps[i], answers)) return script.steps[i];
    }
    return null;
  }

  SectionProgress? progress(String stepId, Answers answers) {
    final step = script.step(stepId);
    final section = step?.section;
    if (step == null || section == null) return null;
    final inSection = [
      for (final s in visibleSteps(answers))
        if (s.section == section) s.id,
    ];
    final index = script.sections.indexWhere((s) => s.id == section);
    return SectionProgress(
      sectionIndex: index,
      sectionCount: script.sections.length,
      label: script.sections[index].label,
      withinSection: inSection.indexOf(stepId) / inSection.length,
    );
  }

  /// Removes answers whose step is hidden or gone. Repeats because hiding
  /// one step can hide steps that depend on it.
  Answers prune(Answers answers) {
    var current = Map<String, Object>.of(answers);
    while (true) {
      final kept = {
        for (final e in current.entries)
          if (script.step(e.key) case final step? when isVisible(step, current)) e.key: e.value,
      };
      if (kept.length == current.length) return kept;
      current = kept;
    }
  }

  OnboardingStep? resumeAt(Answers answers) {
    for (final s in visibleSteps(answers)) {
      if (!answers.containsKey(s.id)) return s;
    }
    return null;
  }
}
