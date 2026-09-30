import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/main.dart';

void main() {
  testWidgets('the placeholder app shows its name', (tester) async {
    await tester.pumpWidget(const ZuluPlaceholderApp());
    expect(find.text('Zulu'), findsOneWidget);
  });
}
