import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

void logError(Object error, StackTrace? stack) {
  debugPrint('Zulu error: $error');
  if (stack != null) debugPrint('$stack');
}

/// Sends uncaught errors to the log, and in release builds replaces
/// Flutter's red error box with a calm message.
void installErrorHandlers() {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    logError(details.exception, details.stack);
  };
  WidgetsBinding.instance.platformDispatcher.onError = (error, stack) {
    logError(error, stack);
    return true;
  };
  if (kReleaseMode) {
    ErrorWidget.builder = (details) => const Material(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text('Something went wrong here. Please go back and try again.', textAlign: TextAlign.center),
            ),
          ),
        );
  }
}

/// Shown when the app can't start at all, e.g. unreadable bundled content.
class StartupErrorApp extends StatelessWidget {
  const StartupErrorApp({super.key, required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Zulu couldn't start", style: TextStyle(fontSize: 22)),
                const SizedBox(height: 12),
                const Text('Please close Zulu and open it again.', textAlign: TextAlign.center),
                if (kDebugMode) ...[
                  const SizedBox(height: 24),
                  Text('$error', style: const TextStyle(fontSize: 12)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
