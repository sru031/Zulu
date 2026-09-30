import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/providers.dart';
import '../../../content/onboarding_script.dart';
import '../../../domain/pet/pet_stage.dart';
import '../../../domain/text/template.dart';
import '../../../shared/services/reminder_permission.dart';
import '../../../shared/widgets/effect_view.dart';
import '../../../shared/widgets/pet_view.dart';
import '../../../theme_kit/effect_registry.dart';
import '../../../theme_kit/pet_manifest.dart';
import '../../../theme_kit/theme_kit.dart';

/// How long a single-choice highlight shows before moving on.
const autoAdvanceDelay = Duration(milliseconds: 250);

/// How long the hatching effect plays before the pet appears.
const hatchDelay = Duration(milliseconds: 1500);

/// Shows one onboarding step. Every step ends by calling [onAnswer] with
/// a `String` or a `List<String>`.
class StepView extends StatelessWidget {
  const StepView({super.key, required this.step, required this.vars, this.initial, required this.onAnswer});

  final OnboardingStep step;
  final Map<String, String> vars;
  final Object? initial;
  final ValueChanged<Object> onAnswer;

  @override
  Widget build(BuildContext context) {
    final prompt = fillTemplate(step.prompt, vars);
    return switch (step.type) {
      StepType.talk => _TalkStep(step: step, prompt: prompt, vars: vars, onAnswer: onAnswer),
      StepType.single || StepType.talkChoice => _SingleStep(step: step, prompt: prompt, vars: vars, initial: initial, onAnswer: onAnswer),
      StepType.multi => _MultiStep(step: step, prompt: prompt, vars: vars, initial: initial, onAnswer: onAnswer),
      StepType.text => _TextStep(step: step, prompt: prompt, initial: initial, onAnswer: onAnswer),
      StepType.time => _TimeStep(step: step, prompt: prompt, initial: initial, onAnswer: onAnswer),
      StepType.egg => _EggStep(step: step, prompt: prompt, initial: initial, onAnswer: onAnswer),
      StepType.hatch => _HatchStep(step: step, prompt: prompt, onAnswer: onAnswer),
      StepType.permission => _PermissionStep(step: step, prompt: prompt, vars: vars, onAnswer: onAnswer),
    };
  }
}

/// The pet with its line in a speech bubble.
class _PetSays extends StatelessWidget {
  const _PetSays({required this.pose, required this.text, this.petSize = 140});

  final PetPose pose;
  final String text;
  final double petSize;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(color: scheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(text, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
          ),
        ),
        const SizedBox(height: 12),
        PetView(stage: PetStage.baby, pose: pose, size: petSize, semanticLabel: 'Your pet'),
      ],
    );
  }
}

/// Scrollable content with a pinned action area at the bottom.
class _StepLayout extends StatelessWidget {
  const _StepLayout({required this.body, this.actions = const []});

  final List<Widget> body;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(padding: const EdgeInsets.fromLTRB(20, 8, 20, 20), children: body),
        ),
        if (actions.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: actions),
          ),
      ],
    );
  }
}

class _TalkStep extends StatelessWidget {
  const _TalkStep({required this.step, required this.prompt, required this.vars, required this.onAnswer});

  final OnboardingStep step;
  final String prompt;
  final Map<String, String> vars;
  final ValueChanged<Object> onAnswer;

  @override
  Widget build(BuildContext context) => _StepLayout(
        body: [const SizedBox(height: 40), _PetSays(pose: step.petPose, text: prompt, petSize: 180)],
        actions: [FilledButton(onPressed: () => onAnswer('ok'), child: Text(fillTemplate(step.button ?? 'Continue', vars)))],
      );
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({required this.option, required this.selected, required this.onTap, this.multi = false});

  final StepOption option;
  final bool selected;
  final VoidCallback onTap;
  final bool multi;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Semantics(
        selected: selected,
        button: true,
        child: Material(
          color: selected ? scheme.primaryContainer : scheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: selected ? scheme.primary : scheme.outlineVariant, width: selected ? 2 : 1),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onTap,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 56),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    if (option.icon != null) ...[
                      ExcludeSemantics(child: Text(option.icon!, style: const TextStyle(fontSize: 24))),
                      const SizedBox(width: 12),
                    ],
                    Expanded(child: Text(option.label, style: Theme.of(context).textTheme.bodyLarge)),
                    if (multi) Icon(selected ? Icons.check_circle : Icons.add_circle_outline, color: scheme.primary),
                    if (!multi && selected) Icon(Icons.check_circle, color: scheme.primary),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SingleStep extends StatefulWidget {
  const _SingleStep({required this.step, required this.prompt, required this.vars, this.initial, required this.onAnswer});

  final OnboardingStep step;
  final String prompt;
  final Map<String, String> vars;
  final Object? initial;
  final ValueChanged<Object> onAnswer;

  @override
  State<_SingleStep> createState() => _SingleStepState();
}

class _SingleStepState extends State<_SingleStep> {
  late String? _selected = widget.initial is String ? widget.initial! as String : null;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _pick(String id) {
    setState(() => _selected = id);
    _timer?.cancel();
    _timer = Timer(autoAdvanceDelay, () => widget.onAnswer(id));
  }

  @override
  Widget build(BuildContext context) => _StepLayout(
        body: [
          _PetSays(pose: widget.step.petPose, text: widget.prompt),
          const SizedBox(height: 20),
          for (final o in widget.step.options)
            _OptionCard(option: o.withLabel(fillTemplate(o.label, widget.vars)), selected: _selected == o.id, onTap: () => _pick(o.id)),
        ],
      );
}

class _MultiStep extends StatefulWidget {
  const _MultiStep({required this.step, required this.prompt, required this.vars, this.initial, required this.onAnswer});

  final OnboardingStep step;
  final String prompt;
  final Map<String, String> vars;
  final Object? initial;
  final ValueChanged<Object> onAnswer;

  @override
  State<_MultiStep> createState() => _MultiStepState();
}

class _MultiStepState extends State<_MultiStep> {
  late final Set<String> _selected = {...?(widget.initial is List<String> ? widget.initial! as List<String> : null)};

  @override
  Widget build(BuildContext context) {
    final enough = _selected.length >= widget.step.minSelect;
    return _StepLayout(
      body: [
        _PetSays(pose: widget.step.petPose, text: widget.prompt),
        const SizedBox(height: 20),
        for (final o in widget.step.options)
          _OptionCard(
            option: o.withLabel(fillTemplate(o.label, widget.vars)),
            multi: true,
            selected: _selected.contains(o.id),
            onTap: () => setState(() => _selected.contains(o.id) ? _selected.remove(o.id) : _selected.add(o.id)),
          ),
      ],
      actions: [
        FilledButton(
          onPressed: enough
              ? () => widget.onAnswer([for (final o in widget.step.options) if (_selected.contains(o.id)) o.id])
              : null,
          child: const Text('Next'),
        ),
      ],
    );
  }
}

class _TextStep extends StatefulWidget {
  const _TextStep({required this.step, required this.prompt, this.initial, required this.onAnswer});

  final OnboardingStep step;
  final String prompt;
  final Object? initial;
  final ValueChanged<Object> onAnswer;

  @override
  State<_TextStep> createState() => _TextStepState();
}

class _TextStepState extends State<_TextStep> {
  late final _controller = TextEditingController(text: widget.initial is String ? widget.initial! as String : '');
  var _suggestion = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _shuffle() {
    final suggestions = widget.step.suggestions;
    setState(() {
      _controller.text = suggestions[_suggestion % suggestions.length];
      _suggestion++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final value = _controller.text.trim();
    return _StepLayout(
      body: [
        _PetSays(pose: widget.step.petPose, text: widget.prompt),
        const SizedBox(height: 20),
        TextField(
          controller: _controller,
          maxLength: 24,
          textCapitalization: TextCapitalization.words,
          onChanged: (_) => setState(() {}),
          onSubmitted: (_) {
            if (value.isNotEmpty) widget.onAnswer(value);
          },
          decoration: InputDecoration(
            labelText: widget.step.placeholder,
            border: const OutlineInputBorder(),
            suffixIcon: widget.step.suggestions.isEmpty
                ? null
                : IconButton(tooltip: 'Suggest a name', icon: const Icon(Icons.casino_outlined), onPressed: _shuffle),
          ),
        ),
      ],
      actions: [
        FilledButton(onPressed: value.isEmpty ? null : () => widget.onAnswer(value), child: const Text('Next')),
        if (widget.step.skippable) TextButton(onPressed: () => widget.onAnswer(''), child: const Text('Skip')),
      ],
    );
  }
}

class _TimeStep extends StatefulWidget {
  const _TimeStep({required this.step, required this.prompt, this.initial, required this.onAnswer});

  final OnboardingStep step;
  final String prompt;
  final Object? initial;
  final ValueChanged<Object> onAnswer;

  @override
  State<_TimeStep> createState() => _TimeStepState();
}

class _TimeStepState extends State<_TimeStep> {
  late TimeOfDay _time = _parse(widget.initial is String ? widget.initial! as String : widget.step.defaultValue ?? '07:30');

  static TimeOfDay _parse(String hhmm) {
    final parts = hhmm.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  String get _value => '${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}';

  Future<void> _change() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked != null) setState(() => _time = picked);
  }

  @override
  Widget build(BuildContext context) => _StepLayout(
        body: [
          _PetSays(pose: widget.step.petPose, text: widget.prompt),
          const SizedBox(height: 28),
          Center(child: Text(_time.format(context), style: Theme.of(context).textTheme.displaySmall)),
          Center(child: TextButton(onPressed: _change, child: const Text('Change time'))),
        ],
        actions: [FilledButton(onPressed: () => widget.onAnswer(_value), child: const Text('Continue'))],
      );
}

class _EggStep extends ConsumerStatefulWidget {
  const _EggStep({required this.step, required this.prompt, this.initial, required this.onAnswer});

  final OnboardingStep step;
  final String prompt;
  final Object? initial;
  final ValueChanged<Object> onAnswer;

  @override
  ConsumerState<_EggStep> createState() => _EggStepState();
}

class _EggStepState extends ConsumerState<_EggStep> {
  late String? _selected = widget.initial is String ? widget.initial! as String : null;

  @override
  Widget build(BuildContext context) {
    final eggs = ref.watch(themeKitProvider).pet.eggs;
    final scheme = Theme.of(context).colorScheme;
    return _StepLayout(
      body: [
        Text(widget.prompt, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 24),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 16,
          runSpacing: 16,
          children: [
            for (final egg in eggs)
              Semantics(
                label: '${egg.id} egg',
                selected: _selected == egg.id,
                button: true,
                child: GestureDetector(
                  onTap: () => setState(() => _selected = egg.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _selected == egg.id ? scheme.primary : Colors.transparent, width: 3),
                    ),
                    child: ExcludeSemantics(child: Image.asset(ThemeKit.assetPath(egg.image), width: 80, height: 100)),
                  ),
                ),
              ),
          ],
        ),
      ],
      actions: [
        FilledButton(
          onPressed: _selected == null ? null : () => widget.onAnswer(_selected!),
          child: Text(widget.step.button ?? 'Hatch this egg'),
        ),
      ],
    );
  }
}

class _HatchStep extends StatefulWidget {
  const _HatchStep({required this.step, required this.prompt, required this.onAnswer});

  final OnboardingStep step;
  final String prompt;
  final ValueChanged<Object> onAnswer;

  @override
  State<_HatchStep> createState() => _HatchStepState();
}

class _HatchStepState extends State<_HatchStep> {
  var _hatched = false;
  late final Timer _timer = Timer(hatchDelay, () => setState(() => _hatched = true));

  @override
  void initState() {
    super.initState();
    _timer;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _StepLayout(
        body: [
          const SizedBox(height: 40),
          Text(widget.prompt, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 24),
          SizedBox(
            height: 220,
            child: Center(
              child: _hatched
                  ? const PetView(stage: PetStage.baby, pose: PetPose.happy, size: 200, semanticLabel: 'Your new pet')
                  : const EffectView(EffectName.hatchCrack, size: 200, repeat: true),
            ),
          ),
        ],
        actions: [
          if (_hatched) FilledButton(onPressed: () => widget.onAnswer('ok'), child: Text(widget.step.button ?? 'Continue')),
        ],
      );
}

class _PermissionStep extends ConsumerStatefulWidget {
  const _PermissionStep({required this.step, required this.prompt, required this.vars, required this.onAnswer});

  final OnboardingStep step;
  final String prompt;
  final Map<String, String> vars;
  final ValueChanged<Object> onAnswer;

  @override
  ConsumerState<_PermissionStep> createState() => _PermissionStepState();
}

class _PermissionStepState extends ConsumerState<_PermissionStep> {
  var _asking = false;

  Future<void> _turnOn() async {
    setState(() => _asking = true);
    final ReminderPermission permission = ref.read(reminderPermissionProvider);
    final granted = await permission.request();
    if (mounted) widget.onAnswer(granted ? 'granted' : 'declined');
  }

  @override
  Widget build(BuildContext context) {
    final preview = widget.step.preview;
    return _StepLayout(
      body: [
        _PetSays(pose: widget.step.petPose, text: widget.prompt),
        if (preview != null) ...[
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: Text(fillTemplate(preview, widget.vars)),
            ),
          ),
        ],
      ],
      actions: [
        FilledButton(onPressed: _asking ? null : _turnOn, child: const Text('Turn on reminders')),
        TextButton(onPressed: _asking ? null : () => widget.onAnswer('later'), child: const Text('Maybe later')),
      ],
    );
  }
}
