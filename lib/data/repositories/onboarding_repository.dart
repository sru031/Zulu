import 'dart:convert';

import 'package:drift/drift.dart';

import '../../core/clock.dart';
import '../../domain/onboarding/answers.dart';
import '../db/database.dart';

/// Onboarding answers, saved one by one so the quiz can resume.
class OnboardingRepository {
  OnboardingRepository(this._db, this._clock);

  final AppDatabase _db;
  final Clock _clock;

  Future<Answers> answers() async {
    final rows = await _db.select(_db.onboardingAnswers).get();
    return {for (final r in rows) r.questionId: _decode(r.value)};
  }

  /// [value] is a `String` or a `List<String>`.
  Future<void> saveAnswer(String questionId, Object value) async {
    assert(value is String || value is List<String>, 'answers are strings or string lists');
    await _db.into(_db.onboardingAnswers).insertOnConflictUpdate(OnboardingAnswersCompanion.insert(
          questionId: questionId,
          value: jsonEncode(value),
          answeredAt: _clock.now(),
        ));
  }

  Future<void> removeAnswers(Iterable<String> questionIds) async {
    final ids = questionIds.toList();
    if (ids.isEmpty) return;
    await (_db.delete(_db.onboardingAnswers)..where((a) => a.questionId.isIn(ids))).go();
  }

  static Object _decode(String json) {
    final value = jsonDecode(json);
    return value is List ? [for (final e in value) e as String] : value as String;
  }
}
