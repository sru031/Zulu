import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'app/app.dart';
import 'app/bootstrap.dart';
import 'app/error_handling.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  installErrorHandlers();
  try {
    final overrides = await bootstrap();
    runApp(ProviderScope(overrides: overrides, child: const ZuluApp()));
  } catch (error, stack) {
    logError(error, stack);
    runApp(StartupErrorApp(error: error));
  }
}
