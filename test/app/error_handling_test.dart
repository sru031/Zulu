import 'package:flutter_test/flutter_test.dart';
import 'package:zulu/app/error_handling.dart';

void main() {
  testWidgets('the startup error screen is calm and shows details in debug', (tester) async {
    await tester.pumpWidget(StartupErrorApp(error: StateError('broken content')));
    expect(find.text("Zulu couldn't start"), findsOneWidget);
    expect(find.textContaining('close Zulu and open it again'), findsOneWidget);
    expect(find.textContaining('broken content'), findsOneWidget);
  });
}
