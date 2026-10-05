import '../domain/pet/pet_stage.dart';
import 'json_reader.dart';

/// A short vignette the pet brings back from an adventure.
class Story {
  const Story({required this.id, required this.place, required this.text, required this.stages});

  final String id;
  final String place;

  /// May use template placeholders such as `{petName}` and `{they}`.
  final String text;

  /// Stages this story suits; empty means any stage.
  final List<PetStage> stages;
}

/// All adventure stories (`assets/content/stories.json`).
class StoryBook {
  StoryBook(this.stories) : _byId = {for (final s in stories) s.id: s};

  static const fileName = 'assets/content/stories.json';

  final List<Story> stories;
  final Map<String, Story> _byId;

  Story? byId(String id) => _byId[id];

  /// A story for a pet at [stage], chosen by [seed] so the same day always
  /// tells the same story.
  Story pick({required int seed, required PetStage stage}) {
    final suitable = [
      for (final s in stories)
        if (s.stages.isEmpty || s.stages.contains(stage)) s,
    ];
    final pool = suitable.isEmpty ? stories : suitable;
    return pool[seed.abs() % pool.length];
  }

  factory StoryBook.fromJson(JsonReader r) {
    final stories = <Story>[];
    final ids = <String>{};
    for (final s in r.list('stories')) {
      final id = s.string('id');
      if (!ids.add(id)) s.field('id').fail('duplicate story id "$id"');
      final stages = <PetStage>[];
      for (final name in s.optStrings('stages')) {
        stages.add(PetStage.values.asNameMap()[name] ?? s.field('stages').fail('unknown stage "$name"'));
      }
      stories.add(Story(id: id, place: s.string('place'), text: s.string('text'), stages: stages));
    }
    if (stories.isEmpty) r.field('stories').fail('needs at least one story');
    return StoryBook(stories);
  }
}
