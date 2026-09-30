import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/content/content_bundle.dart';
import 'package:zulu/content/onboarding_script.dart';

import '../helpers/read_file.dart';

void main() {
  late ContentBundle content;

  setUpAll(() async => content = await loadContent(readFile));

  test('the flow starts with the welcome, the egg and hatching', () {
    expect(content.onboarding.steps.take(3).map((s) => s.type), [StepType.talk, StepType.egg, StepType.hatch]);
  });

  test('has the four quiz sections', () {
    expect(content.onboarding.sections.map((s) => s.label), ['About you', 'Energy', "How's life", 'Support']);
  });

  test('every focus area has exactly one follow-up question', () {
    final script = content.onboarding;
    for (final area in content.goals.areas) {
      final followUps = script.steps.where((s) => s.showIf?.question == script.focusQuestion && s.showIf!.values.contains(area.id));
      expect(followUps, hasLength(1), reason: area.id);
    }
  });

  test('every saveTo target is filled by exactly one step', () {
    for (final target in SaveTo.values) {
      expect(content.onboarding.steps.where((s) => s.saveTo == target), hasLength(1), reason: target.id);
    }
  });

  test('asks no diagnosis, gender or age questions', () {
    final banned = RegExp(r'gender|how old|\bage\b|diagnos|ptsd|bipolar|ocd|adhd|depression', caseSensitive: false);
    for (final (where, text) in content.onboarding.texts) {
      expect(banned.hasMatch(text), isFalse, reason: where);
    }
    expect(File('assets/content/onboarding.json').readAsStringSync().contains('streak'), isFalse);
  });
}
