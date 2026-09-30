import '../domain/rules/game_rules.dart';
import 'goal_library.dart';
import 'json_reader.dart';

/// All bundled content, loaded once at startup. Later plans add onboarding,
/// dialogue, stories and the rest.
class ContentBundle {
  const ContentBundle({required this.rules, required this.goals});

  final GameRules rules;
  final GoalLibrary goals;
}

Future<ContentBundle> loadContent(ReadText read) async {
  Future<JsonReader> open(String path) async => JsonReader.decode(path, await read(path));
  return ContentBundle(
    rules: GameRules.fromJson(await open(GameRules.fileName)),
    goals: GoalLibrary.fromJson(await open(GoalLibrary.fileName)),
  );
}
