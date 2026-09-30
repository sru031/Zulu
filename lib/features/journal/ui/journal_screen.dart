import 'package:material_ui/material_ui.dart';

import '../../../shared/widgets/placeholder_screen.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const PlaceholderScreen(title: 'Journal', message: 'Your days, moods and reflections will show up here.');
}
