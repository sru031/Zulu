import '../domain/onboarding/answers.dart';
import '../domain/pet/trait.dart';
import '../domain/text/template.dart';
import '../theme_kit/pet_manifest.dart';
import 'json_reader.dart';

enum StepType {
  egg('egg'),
  hatch('hatch'),
  text('text'),
  single('single'),
  multi('multi'),
  time('time'),
  talk('talk'),
  talkChoice('talk_choice'),
  permission('permission');

  const StepType(this.id);

  final String id;

  bool get hasOptions => this == single || this == multi || this == talkChoice;

  static StepType? tryParse(String id) {
    for (final t in values) {
      if (t.id == id) return t;
    }
    return null;
  }
}

/// Where a step's answer goes when onboarding finishes. Other answers stay
/// only in the answers table.
enum SaveTo {
  petEggColor('pet.eggColor'),
  petName('pet.name'),
  petPronouns('pet.pronouns'),
  petTrait('pet.trait'),
  userName('profile.userName'),
  wakeTime('profile.wakeTime'),
  bedTime('profile.bedTime');

  const SaveTo(this.id);

  final String id;

  static SaveTo? tryParse(String id) {
    for (final s in values) {
      if (s.id == id) return s;
    }
    return null;
  }
}

enum ConditionOp { equals, includes, includesAny }

/// A test on an earlier answer, used by `showIf` and plan rules. A missing
/// answer never matches (so `not` of a missing answer does).
class Condition {
  const Condition({required this.question, required this.op, required this.values, this.negate = false});

  final String question;
  final ConditionOp op;
  final List<String> values;
  final bool negate;

  bool matches(Answers answers) {
    final v = answers[question];
    final hit = switch (op) {
      ConditionOp.equals => v is String && v == values.first,
      ConditionOp.includes => v is List<String> && v.contains(values.first),
      ConditionOp.includesAny => v is List<String> && values.any(v.contains),
    };
    return hit != negate;
  }

  factory Condition.fromJson(JsonReader r) {
    final question = r.string('question');
    final negate = r.boolean('not', orElse: false);
    if (r.has('equals')) {
      return Condition(question: question, op: ConditionOp.equals, values: [r.string('equals')], negate: negate);
    }
    if (r.has('includes')) {
      return Condition(question: question, op: ConditionOp.includes, values: [r.string('includes')], negate: negate);
    }
    if (r.has('includesAny')) {
      final values = r.strings('includesAny');
      if (values.isEmpty) r.field('includesAny').fail('needs at least one value');
      return Condition(question: question, op: ConditionOp.includesAny, values: values, negate: negate);
    }
    r.fail('needs one of equals, includes or includesAny');
  }
}

class StepOption {
  const StepOption({required this.id, required this.label, this.icon, this.trait, this.nudge = 1});

  final String id;
  final String label;

  /// An emoji.
  final String? icon;

  /// For talk-choice replies: the trait this reply nudges, by [nudge].
  final Trait? trait;
  final double nudge;
}

class OnboardingStep {
  const OnboardingStep({
    required this.id,
    required this.type,
    required this.prompt,
    this.petPose = PetPose.curious,
    this.section,
    this.options = const [],
    this.showIf,
    this.minSelect = 1,
    this.skippable = false,
    this.saveTo,
    this.placeholder,
    this.suggestions = const [],
    this.defaultValue,
    this.preview,
    this.button,
  });

  final String id;
  final StepType type;

  /// Said by the pet. May use template placeholders.
  final String prompt;
  final PetPose petPose;

  /// Quiz section id; steps with a section show the progress bar.
  final String? section;
  final List<StepOption> options;
  final Condition? showIf;
  final int minSelect;
  final bool skippable;
  final SaveTo? saveTo;
  final String? placeholder;

  /// Names offered by the shuffle button on text steps.
  final List<String> suggestions;

  /// Starting value for time steps (`HH:mm`).
  final String? defaultValue;

  /// Example notification shown on the permission step.
  final String? preview;

  /// Label of the main button, where the step has one.
  final String? button;

  StepOption? option(String id) {
    for (final o in options) {
      if (o.id == id) return o;
    }
    return null;
  }
}

class Section {
  const Section({required this.id, required this.label});

  final String id;
  final String label;
}

/// "If the answers match [when], add [add] to the plan, explaining [reason]."
class PlanRule {
  const PlanRule({required this.when, required this.add, required this.reason});

  final Condition when;
  final List<String> add;
  final String reason;
}

/// The whole onboarding flow (`assets/content/onboarding.json`).
class OnboardingScript {
  OnboardingScript({
    required this.sections,
    required this.steps,
    required this.foundationGoals,
    required this.foundationReason,
    required this.focusQuestion,
    required this.planRules,
  }) : _byId = {for (final s in steps) s.id: s};

  static const fileName = 'assets/content/onboarding.json';

  final List<Section> sections;
  final List<OnboardingStep> steps;

  /// Goal ids every plan starts with.
  final List<String> foundationGoals;
  final String foundationReason;

  /// The multi step whose answers are focus-area ids.
  final String focusQuestion;
  final List<PlanRule> planRules;
  final Map<String, OnboardingStep> _byId;

  OnboardingStep? step(String id) => _byId[id];

  int indexOf(String id) => steps.indexWhere((s) => s.id == id);

  /// Every string shown to the user, with where it lives, for checks.
  List<(String, String)> get texts => [
        for (final s in steps) ...[
          ('step "${s.id}" prompt', s.prompt),
          for (final o in s.options) ('step "${s.id}" option "${o.id}"', o.label),
          if (s.preview != null) ('step "${s.id}" preview', s.preview!),
          if (s.placeholder != null) ('step "${s.id}" placeholder', s.placeholder!),
          if (s.button != null) ('step "${s.id}" button', s.button!),
        ],
        ('foundationReason', foundationReason),
        for (final (i, r) in planRules.indexed) ('planRules[$i] reason', r.reason),
      ];

  factory OnboardingScript.fromJson(JsonReader r) {
    final sections = [for (final s in r.list('sections')) Section(id: s.string('id'), label: s.string('label'))];
    final sectionIds = {for (final s in sections) s.id};
    final steps = <OnboardingStep>[];
    final byId = <String, OnboardingStep>{};

    for (final s in r.list('steps')) {
      final id = s.string('id');
      if (byId.containsKey(id)) s.field('id').fail('duplicate step id "$id"');
      final type = StepType.tryParse(s.string('type')) ?? s.field('type').fail('unknown step type');
      final section = s.optString('section');
      if (section != null && !sectionIds.contains(section)) s.field('section').fail('unknown section "$section"');

      final options = <StepOption>[];
      final optionIds = <String>{};
      for (final o in s.optional('options')?.asList() ?? const <JsonReader>[]) {
        final optionId = o.string('id');
        if (!optionIds.add(optionId)) o.field('id').fail('duplicate option id "$optionId"');
        final traitName = o.optString('trait');
        final trait = traitName == null
            ? null
            : (Trait.values.asNameMap()[traitName] ?? o.field('trait').fail('unknown trait "$traitName"'));
        options.add(StepOption(
          id: optionId,
          label: o.string('label'),
          icon: o.optString('icon'),
          trait: trait,
          nudge: o.optNumber('nudge') ?? 1,
        ));
      }
      if (type.hasOptions && options.length < 2) s.field('type').fail('${type.id} steps need at least 2 options');

      final showIfJson = s.optional('showIf');
      final showIf = showIfJson == null ? null : _condition(showIfJson, byId);

      final saveToId = s.optString('saveTo');
      final saveTo = saveToId == null ? null : (SaveTo.tryParse(saveToId) ?? s.field('saveTo').fail('unknown target "$saveToId"'));
      if (saveTo != null) _checkSaveTo(s, saveTo, type, optionIds);

      final defaultValue = s.optString('default');
      if (type == StepType.time && defaultValue != null && !_timePattern.hasMatch(defaultValue)) {
        s.field('default').fail('expected HH:mm');
      }

      final poseName = s.optString('petPose');
      final pose = poseName == null
          ? PetPose.curious
          : (PetPose.values.asNameMap()[poseName] ?? s.field('petPose').fail('unknown pose "$poseName"'));

      final step = OnboardingStep(
        id: id,
        type: type,
        prompt: s.string('prompt'),
        petPose: pose,
        section: section,
        options: options,
        showIf: showIf,
        minSelect: s.optInt('minSelect') ?? 1,
        skippable: s.boolean('skippable', orElse: false),
        saveTo: saveTo,
        placeholder: s.optString('placeholder'),
        suggestions: s.optStrings('suggestions'),
        defaultValue: defaultValue,
        preview: s.optString('preview'),
        button: s.optString('button'),
      );
      steps.add(step);
      byId[id] = step;
    }

    final focus = r.string('focusQuestion');
    if (byId[focus]?.type != StepType.multi) r.field('focusQuestion').fail('must name a multi step');

    final rules = [
      for (final p in r.list('planRules'))
        PlanRule(when: _condition(p.field('when'), byId), add: p.strings('add'), reason: p.string('reason')),
    ];

    return OnboardingScript(
      sections: sections,
      steps: steps,
      foundationGoals: r.strings('foundationGoals'),
      foundationReason: r.string('foundationReason'),
      focusQuestion: focus,
      planRules: rules,
    );
  }
}

final _timePattern = RegExp(r'^([01]\d|2[0-3]):[0-5]\d$');

/// Parses a condition whose question must be one of [known] (the steps
/// read so far), with values that are options of that step.
Condition _condition(JsonReader r, Map<String, OnboardingStep> known) {
  final c = Condition.fromJson(r);
  final target = known[c.question] ?? r.field('question').fail('must name an earlier step, got "${c.question}"');
  if (target.options.isNotEmpty) {
    for (final v in c.values) {
      if (target.option(v) == null) r.fail('"$v" is not an option of "${c.question}"');
    }
  }
  if (c.op != ConditionOp.equals && target.type != StepType.multi) {
    r.fail('includes and includesAny need a multi step');
  }
  if (c.op == ConditionOp.equals && target.type == StepType.multi) {
    r.fail('equals needs a single-answer step');
  }
  return c;
}

void _checkSaveTo(JsonReader s, SaveTo saveTo, StepType type, Set<String> optionIds) {
  final expected = switch (saveTo) {
    SaveTo.petEggColor => StepType.egg,
    SaveTo.petName || SaveTo.userName => StepType.text,
    SaveTo.petPronouns || SaveTo.petTrait => StepType.single,
    SaveTo.wakeTime || SaveTo.bedTime => StepType.time,
  };
  if (type != expected) s.field('saveTo').fail('${saveTo.id} needs a ${expected.id} step');
  final allowed = switch (saveTo) {
    SaveTo.petPronouns => {for (final p in Pronouns.values) p.name},
    SaveTo.petTrait => {for (final t in Trait.values) t.name},
    _ => null,
  };
  if (allowed != null && !optionIds.every(allowed.contains)) {
    s.field('options').fail('options must be ${allowed.join(', ')}');
  }
}
