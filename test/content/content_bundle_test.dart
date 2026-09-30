import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/content/content_bundle.dart';

import '../helpers/read_file.dart';

void main() {
  test('loads the shipped content', () async {
    final content = await loadContent(readFile);
    expect(content.rules.energyTarget, 15);
    expect(content.goals.goals, isNotEmpty);
  });
}
