import 'package:material_ui/material_ui.dart';

import '../../../shared/widgets/placeholder_screen.dart';

class MeScreen extends StatelessWidget {
  const MeScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const PlaceholderScreen(title: 'Me', message: "Your pet's profile and settings will live here.");
}
