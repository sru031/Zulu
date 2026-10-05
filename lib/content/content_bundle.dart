import '../domain/rules/game_rules.dart';
import 'goal_library.dart';
import 'json_reader.dart';
import 'onboarding_script.dart';
import 'story_book.dart';

/// All bundled content, loaded once at startup.
class ContentBundle {
  const ContentBundle({required this.rules, required this.goals, required this.onboarding, required this.stories});

  final GameRules rules;
  final GoalLibrary goals;
  final OnboardingScript onboarding;
  final StoryBook stories;
}

Future<ContentBundle> loadContent(ReadText read) async {
  Future<JsonReader> open(String path) async => JsonReader.decode(path, await read(path));
  return ContentBundle(
    rules: GameRules.fromJson(await open(GameRules.fileName)),
    goals: GoalLibrary.fromJson(await open(GoalLibrary.fileName)),
    onboarding: OnboardingScript.fromJson(await open(OnboardingScript.fileName)),
    stories: StoryBook.fromJson(await open(StoryBook.fileName)),
  );
}
