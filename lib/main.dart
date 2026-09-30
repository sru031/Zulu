import 'package:material_ui/material_ui.dart';

void main() => runApp(const ZuluPlaceholderApp());

/// Temporary app used until the real shell lands in Task 12.
class ZuluPlaceholderApp extends StatelessWidget {
  const ZuluPlaceholderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: Text('Zulu'))),
    );
  }
}
