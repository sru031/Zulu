import '../domain/pet/trait.dart';
import 'json_reader.dart';

/// Where a goal sits in the day's list.
enum GoalSection {
  startOfDay('start_day'),
  anyTime('any_time'),
  endOfDay('end_day');

  const GoalSection(this.id);

  final String id;

  static GoalSection? tryParse(String id) {
    for (final s in values) {
      if (s.id == id) return s;
    }
    return null;
  }
}

class FocusArea {
  const FocusArea({required this.id, required this.label, required this.icon, required this.trait});

  final String id;
  final String label;
  final String icon;

  /// The trait that grows when the user completes goals in this area.
  final Trait trait;
}

/// A curated goal the user can add. User goals copy these fields, so later
/// edits to the library never change someone's existing goals.
class GoalTemplate {
  const GoalTemplate({
    required this.id,
    required this.title,
    required this.icon,
    required this.area,
    required this.section,
    required this.essential,
    required this.starter,
    required this.tags,
  });

  final String id;
  final String title;

  /// An emoji.
  final String icon;
  final String area;
  final GoalSection section;

  /// Shown on low-energy days.
  final bool essential;

  /// Offered first when building a starter plan for this area.
  final bool starter;
  final List<String> tags;
}

class GoalLibrary {
  GoalLibrary({required this.areas, required this.goals})
      : _goalsById = {for (final g in goals) g.id: g},
        _areasById = {for (final a in areas) a.id: a};

  static const fileName = 'assets/content/goal_library.json';

  final List<FocusArea> areas;
  final List<GoalTemplate> goals;
  final Map<String, GoalTemplate> _goalsById;
  final Map<String, FocusArea> _areasById;

  GoalTemplate? byId(String id) => _goalsById[id];

  FocusArea? area(String id) => _areasById[id];

  List<GoalTemplate> inArea(String areaId) => [for (final g in goals) if (g.area == areaId) g];

  List<GoalTemplate> startersIn(String areaId) =>
      [for (final g in goals) if (g.area == areaId && g.starter) g];

  factory GoalLibrary.fromJson(JsonReader r) {
    final areas = <FocusArea>[];
    final areaIds = <String>{};
    for (final a in r.list('areas')) {
      final id = a.string('id');
      if (!areaIds.add(id)) a.field('id').fail('duplicate area id "$id"');
      final traitField = a.field('trait');
      final trait = Trait.values.asNameMap()[traitField.asString()] ??
          traitField.fail('unknown trait "${traitField.asString()}"');
      areas.add(FocusArea(id: id, label: a.string('label'), icon: a.string('icon'), trait: trait));
    }

    final goals = <GoalTemplate>[];
    final goalIds = <String>{};
    for (final g in r.list('goals')) {
      final id = g.string('id');
      if (!goalIds.add(id)) g.field('id').fail('duplicate goal id "$id"');
      final area = g.string('area');
      if (!areaIds.contains(area)) g.field('area').fail('unknown area "$area"');
      final section = GoalSection.tryParse(g.string('section')) ??
          g.field('section').fail('expected start_day, any_time or end_day');
      goals.add(GoalTemplate(
        id: id,
        title: g.string('title'),
        icon: g.string('icon'),
        area: area,
        section: section,
        essential: g.boolean('essential', orElse: false),
        starter: g.boolean('starter', orElse: false),
        tags: g.optStrings('tags'),
      ));
    }
    return GoalLibrary(areas: areas, goals: goals);
  }
}
