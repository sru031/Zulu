import 'package:material_ui/material_ui.dart';

import '../../../domain/onboarding/question_flow.dart';

/// One segment per quiz section: finished sections are full, the current
/// one fills as the user goes, and the section name sits underneath.
class SectionProgressBar extends StatelessWidget {
  const SectionProgressBar(this.progress, {super.key});

  final SectionProgress progress;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            for (var i = 0; i < progress.sectionCount; i++) ...[
              if (i > 0) const SizedBox(width: 6),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    minHeight: 6,
                    value: i < progress.sectionIndex
                        ? 1
                        : i == progress.sectionIndex
                            ? progress.withinSection
                            : 0,
                    backgroundColor: scheme.surfaceContainerHighest,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Text(progress.label, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}
