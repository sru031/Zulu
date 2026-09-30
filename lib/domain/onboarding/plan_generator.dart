import '../../content/goal_library.dart';
import '../../content/onboarding_script.dart';
import 'answers.dart';

class PlannedGoal {
  const PlannedGoal(this.goal, this.reason);

  final GoalTemplate goal;

  /// Why this goal is in the plan, mirroring the user's own answer.
  final String reason;
}

/// Turns onboarding answers into a starter plan (spec §6.4):
/// 1. the foundation goals, then
/// 2. goals from matching plan rules, then
/// 3. starter goals from each chosen focus area, one area at a time,
/// with no duplicates, up to [maxGoals].
class PlanGenerator {
  const PlanGenerator({required this.script, required this.library, this.maxGoals = 7});

  final OnboardingScript script;
  final GoalLibrary library;
  final int maxGoals;

  List<PlannedGoal> generate(Answers answers) {
    final plan = <PlannedGoal>[];
    final used = <String>{};

    void add(String id, String reason) {
      if (plan.length >= maxGoals || used.contains(id)) return;
      final goal = library.byId(id);
      if (goal == null) return;
      used.add(id);
      plan.add(PlannedGoal(goal, reason));
    }

    for (final id in script.foundationGoals) {
      add(id, script.foundationReason);
    }
    for (final rule in script.planRules) {
      if (!rule.when.matches(answers)) continue;
      for (final id in rule.add) {
        add(id, rule.reason);
      }
    }

    final chosen = answers[script.focusQuestion];
    final areas = chosen is List<String> ? chosen : const <String>[];
    final starters = [for (final a in areas) library.startersIn(a)];
    for (var round = 0; plan.length < maxGoals; round++) {
      var any = false;
      for (final (i, list) in starters.indexed) {
        if (round >= list.length) continue;
        any = true;
        add(list[round].id, 'you picked ${library.area(areas[i])!.label.toLowerCase()}');
      }
      if (!any) break;
    }
    return plan;
  }

  List<GoalTemplate> alternativesFor(String goalId, List<PlannedGoal> plan) {
    final goal = library.byId(goalId);
    if (goal == null) return const [];
    final inPlan = {for (final p in plan) p.goal.id};
    return [
      for (final g in library.inArea(goal.area))
        if (!inPlan.contains(g.id)) g,
    ];
  }
}
