import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

enum _PopScopeDemoMode { confirmExit, doubleBack, stepFlow }

@RoutePage(name: 'PopScopeRoute')
class PopScopePage extends StatefulWidget {
  const PopScopePage({super.key});

  @override
  State<PopScopePage> createState() => _PopScopePageState();
}

class _PopScopePageState extends State<PopScopePage> {
  static const List<String> _stepTitles = <String>[
    'Profile',
    'Preferences',
    'Review',
  ];

  final TextEditingController _notesController = TextEditingController(
    text: 'Draft changes live here.',
  );
  final List<String> _eventLog = <String>[];

  _PopScopeDemoMode _demoMode = _PopScopeDemoMode.confirmExit;
  bool _hasUnsavedChanges = true;
  bool _allowDirectPop = false;
  DateTime? _lastBackAttemptAt;
  int _currentStepIndex = 0;

  bool get _canPop {
    switch (_demoMode) {
      case _PopScopeDemoMode.confirmExit:
        return _allowDirectPop || !_hasUnsavedChanges;
      case _PopScopeDemoMode.doubleBack:
        return _allowDirectPop;
      case _PopScopeDemoMode.stepFlow:
        return _allowDirectPop || _currentStepIndex == 0;
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _pushLog(String message) {
    final DateTime now = DateTime.now();
    final String timestamp =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    _eventLog.insert(0, '$timestamp  $message');
    if (_eventLog.length > 12) {
      _eventLog.removeRange(12, _eventLog.length);
    }
  }

  String _modeLabel(_PopScopeDemoMode mode) {
    switch (mode) {
      case _PopScopeDemoMode.confirmExit:
        return 'Confirm Exit';
      case _PopScopeDemoMode.doubleBack:
        return 'Double Back';
      case _PopScopeDemoMode.stepFlow:
        return 'Step Flow';
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _setDemoMode(_PopScopeDemoMode mode) {
    setState(() {
      _demoMode = mode;
      _allowDirectPop = false;
      _lastBackAttemptAt = null;
    });
    _pushLog('Switched to ${_modeLabel(mode)} mode.');
  }

  Future<void> _handlePopInvoked(bool didPop, Object? result) async {
    _pushLog(
      'onPopInvokedWithResult(didPop: $didPop, result: ${result ?? 'null'})',
    );

    if (didPop) {
      return;
    }

    switch (_demoMode) {
      case _PopScopeDemoMode.confirmExit:
        await _handleConfirmExitBlockedPop();
      case _PopScopeDemoMode.doubleBack:
        _handleDoubleBackBlockedPop();
      case _PopScopeDemoMode.stepFlow:
        _handleStepFlowBlockedPop();
    }
  }

  Future<void> _handleConfirmExitBlockedPop() async {
    final bool shouldLeave =
        await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Discard draft changes?'),
              content: const Text(
                'This PopScope example blocks the route pop while the editor is dirty. '
                'Choose Leave to allow the page to pop.',
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Stay'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Leave'),
                ),
              ],
            );
          },
        ) ??
        false;

    if (!mounted) {
      return;
    }

    if (!shouldLeave) {
      _showMessage('Stayed on the page. The route remains blocked.');
      _pushLog('Blocked pop kept the editor open.');
      return;
    }

    setState(() {
      _allowDirectPop = true;
    });
    _pushLog('User confirmed exit, allowing the route to pop.');
    Navigator.of(context).pop('discarded');
  }

  void _handleDoubleBackBlockedPop() {
    final DateTime now = DateTime.now();
    final bool secondAttempt =
        _lastBackAttemptAt != null &&
        now.difference(_lastBackAttemptAt!) < const Duration(seconds: 2);

    if (secondAttempt) {
      setState(() {
        _allowDirectPop = true;
      });
      _pushLog('Second back attempt detected, allowing route pop.');
      Navigator.of(context).pop('double-back');
      return;
    }

    setState(() {
      _lastBackAttemptAt = now;
    });
    _showMessage('Press back again within 2 seconds to leave.');
    _pushLog('First back attempt captured in double-back mode.');
  }

  void _handleStepFlowBlockedPop() {
    if (_currentStepIndex <= 0) {
      return;
    }

    setState(() {
      _currentStepIndex -= 1;
    });
    _showMessage(
      'Moved back to ${_stepTitles[_currentStepIndex]} instead of leaving the route.',
    );
    _pushLog('Blocked pop changed the local step to $_currentStepIndex.');
  }

  Future<void> _attemptMaybePop() async {
    final bool didPop = await Navigator.of(context).maybePop();
    _pushLog('Navigator.maybePop() completed with $didPop.');
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<Object?>(
      canPop: _canPop,
      onPopInvokedWithResult: _handlePopInvoked,
      child: Scaffold(
        appBar: AppBar(title: const Text('PopScope Module')),
        body: SelectionArea(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: <Widget>[
              Text(
                'PopScope lets a route intercept back navigation, decide whether the route can pop, and react when a pop attempt happens.',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Text(
                'This module demonstrates three practical patterns: a dirty-form confirmation guard, a double-back-to-exit flow, and a local multi-step flow that uses back presses to move between steps before the route can close.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Choose a PopScope pattern',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 16),
                      SegmentedButton<_PopScopeDemoMode>(
                        segments: const <ButtonSegment<_PopScopeDemoMode>>[
                          ButtonSegment<_PopScopeDemoMode>(
                            value: _PopScopeDemoMode.confirmExit,
                            label: Text('Confirm Exit'),
                            icon: Icon(Icons.warning_amber_rounded),
                          ),
                          ButtonSegment<_PopScopeDemoMode>(
                            value: _PopScopeDemoMode.doubleBack,
                            label: Text('Double Back'),
                            icon: Icon(Icons.keyboard_return),
                          ),
                          ButtonSegment<_PopScopeDemoMode>(
                            value: _PopScopeDemoMode.stepFlow,
                            label: Text('Step Flow'),
                            icon: Icon(Icons.rule_folder_outlined),
                          ),
                        ],
                        selected: <_PopScopeDemoMode>{_demoMode},
                        onSelectionChanged:
                            (Set<_PopScopeDemoMode> selection) =>
                                _setDemoMode(selection.first),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: <Widget>[
                          _StatusChip(
                            label: 'Active mode',
                            value: _modeLabel(_demoMode),
                            color: Colors.indigo,
                          ),
                          _StatusChip(
                            label: 'canPop',
                            value: '$_canPop',
                            color: _canPop ? Colors.green : Colors.orange,
                          ),
                          _StatusChip(
                            label: 'Unsaved changes',
                            value: '$_hasUnsavedChanges',
                            color: _hasUnsavedChanges
                                ? Colors.deepOrange
                                : Colors.blueGrey,
                          ),
                          _StatusChip(
                            label: 'Current step',
                            value:
                                '${_currentStepIndex + 1}/${_stepTitles.length}',
                            color: Colors.teal,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: <Widget>[
                          FilledButton.icon(
                            onPressed: _attemptMaybePop,
                            icon: const Icon(Icons.arrow_back),
                            label: const Text('Call maybePop()'),
                          ),
                          OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                _allowDirectPop = false;
                                _lastBackAttemptAt = null;
                              });
                              _pushLog('Reset transient PopScope state.');
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Reset demo state'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              switch (_demoMode) {
                _PopScopeDemoMode.confirmExit => _ConfirmExitExampleCard(
                  controller: _notesController,
                  hasUnsavedChanges: _hasUnsavedChanges,
                  onDirtyChanged: (bool value) {
                    setState(() {
                      _hasUnsavedChanges = value;
                      _allowDirectPop = false;
                    });
                    _pushLog('Dirty editor flag changed to $value.');
                  },
                  onSaved: () {
                    setState(() {
                      _hasUnsavedChanges = false;
                    });
                    _showMessage(
                      'Draft saved. Back navigation is now allowed.',
                    );
                    _pushLog('Draft saved, route can pop again.');
                  },
                ),
                _PopScopeDemoMode.doubleBack => _DoubleBackExampleCard(
                  lastBackAttemptAt: _lastBackAttemptAt,
                  onArmPressed: () {
                    setState(() {
                      _lastBackAttemptAt = DateTime.now();
                      _allowDirectPop = false;
                    });
                    _showMessage(
                      'First back attempt recorded. Try maybePop() again.',
                    );
                    _pushLog('Double-back mode manually armed.');
                  },
                ),
                _PopScopeDemoMode.stepFlow => _StepFlowExampleCard(
                  stepTitles: _stepTitles,
                  currentStepIndex: _currentStepIndex,
                  onNextStep: _currentStepIndex < _stepTitles.length - 1
                      ? () {
                          setState(() {
                            _currentStepIndex += 1;
                            _allowDirectPop = false;
                          });
                          _pushLog(
                            'Advanced to step $_currentStepIndex in step-flow mode.',
                          );
                        }
                      : null,
                  onPreviousStep: _currentStepIndex > 0
                      ? () {
                          setState(() {
                            _currentStepIndex -= 1;
                          });
                          _pushLog(
                            'Moved back to step $_currentStepIndex using UI controls.',
                          );
                        }
                      : null,
                ),
              },
              const SizedBox(height: 16),
              Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'API Surface Used Here',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Uses `PopScope(canPop: ..., onPopInvokedWithResult: ...)` together with `Navigator.maybePop()` and normal `Navigator.pop(...)` calls. The active example changes what happens when a pop is blocked.',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Pop Event Log',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 12),
                      if (_eventLog.isEmpty)
                        const Text('No pop attempts yet.')
                      else
                        ..._eventLog.map(
                          (String event) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(event),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.router.replacePath('/'),
          icon: const Icon(Icons.home),
          label: const Text('Home'),
        ),
      ),
    );
  }
}

class _ConfirmExitExampleCard extends StatelessWidget {
  const _ConfirmExitExampleCard({
    required this.controller,
    required this.hasUnsavedChanges,
    required this.onDirtyChanged,
    required this.onSaved,
  });

  final TextEditingController controller;
  final bool hasUnsavedChanges;
  final ValueChanged<bool> onDirtyChanged;
  final VoidCallback onSaved;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '1. Dirty Form Confirmation',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'When `canPop` is false, back presses stay on the route and `onPopInvokedWithResult` can open a confirmation dialog before allowing the route to leave.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Draft notes',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => onDirtyChanged(true),
            ),
            const SizedBox(height: 12),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              value: hasUnsavedChanges,
              onChanged: onDirtyChanged,
              title: const Text('Block back while dirty'),
              subtitle: const Text(
                'Turn this off to let the route pop immediately.',
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                FilledButton.icon(
                  onPressed: onSaved,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Draft'),
                ),
                OutlinedButton.icon(
                  onPressed: () => onDirtyChanged(true),
                  icon: const Icon(Icons.edit),
                  label: const Text('Mark Dirty'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DoubleBackExampleCard extends StatelessWidget {
  const _DoubleBackExampleCard({
    required this.lastBackAttemptAt,
    required this.onArmPressed,
  });

  final DateTime? lastBackAttemptAt;
  final VoidCallback onArmPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '2. Double Back To Exit',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'This pattern keeps `canPop` false, captures the first blocked back attempt, and only allows the second back press within a short time window to actually leave the route.',
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                lastBackAttemptAt == null
                    ? 'No back attempt recorded yet.'
                    : 'Last back attempt: ${lastBackAttemptAt!.hour.toString().padLeft(2, '0')}:${lastBackAttemptAt!.minute.toString().padLeft(2, '0')}:${lastBackAttemptAt!.second.toString().padLeft(2, '0')}',
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onArmPressed,
              icon: const Icon(Icons.timer),
              label: const Text('Record First Back Attempt'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepFlowExampleCard extends StatelessWidget {
  const _StepFlowExampleCard({
    required this.stepTitles,
    required this.currentStepIndex,
    required this.onNextStep,
    required this.onPreviousStep,
  });

  final List<String> stepTitles;
  final int currentStepIndex;
  final VoidCallback? onNextStep;
  final VoidCallback? onPreviousStep;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '3. Step Flow Back Handling',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'A wizard can use PopScope to move backward through local steps first. The route only becomes poppable when the flow returns to step one.',
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List<Widget>.generate(stepTitles.length, (int index) {
                final bool active = index == currentStepIndex;
                final bool complete = index < currentStepIndex;
                final Color color = active
                    ? Colors.teal
                    : complete
                    ? Colors.green
                    : Colors.blueGrey;

                return Chip(
                  avatar: CircleAvatar(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    child: Text('${index + 1}'),
                  ),
                  label: Text(stepTitles[index]),
                  backgroundColor: color.withValues(alpha: 0.10),
                );
              }),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Current local step: ${stepTitles[currentStepIndex]}. While this is not the first step, a back press is converted into step navigation instead of popping the route.',
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                OutlinedButton.icon(
                  onPressed: onPreviousStep,
                  icon: const Icon(Icons.chevron_left),
                  label: const Text('Previous Step'),
                ),
                FilledButton.icon(
                  onPressed: onNextStep,
                  icon: const Icon(Icons.chevron_right),
                  label: const Text('Next Step'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
