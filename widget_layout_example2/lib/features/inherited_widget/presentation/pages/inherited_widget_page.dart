import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.inheritedWidget)
class InheritedWidgetPage extends StatefulWidget {
  const InheritedWidgetPage({super.key});

  @override
  State<InheritedWidgetPage> createState() => _InheritedWidgetPageState();
}

class _InheritedWidgetPageState extends State<InheritedWidgetPage> {
  static const List<Color> _palette = <Color>[
    Color(0xFF0F766E),
    Color(0xFF1D4ED8),
    Color(0xFFB45309),
    Color(0xFFBE123C),
    Color(0xFF4338CA),
  ];

  final Random _random = Random();

  int _count = 1;
  Color _accentColor = _palette.first;

  void _increment() {
    setState(() {
      _count += 1;
    });
  }

  void _changeColor() {
    setState(() {
      _accentColor = _palette[_random.nextInt(_palette.length)];
    });
  }

  void _reset() {
    setState(() {
      _count = 1;
      _accentColor = _palette.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedCounterScope(
      count: _count,
      accentColor: _accentColor,
      increment: _increment,
      changeColor: _changeColor,
      reset: _reset,
      child: Scaffold(
        appBar: AppBar(title: const Text('InheritedWidget Module')),
        body: SelectionArea(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: const <Widget>[
              Text(
                'InheritedWidget lets an ancestor share data with any descendant without passing values through every constructor. Descendants that call of(context) register a dependency and rebuild automatically when updateShouldNotify returns true.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20),
              _ScopeControlCard(),
              SizedBox(height: 16),
              _ScopeTreeCard(),
              SizedBox(height: 16),
              _RebuildBehaviorCard(),
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

class _InheritedCounterScope extends InheritedWidget {
  const _InheritedCounterScope({
    required this.count,
    required this.accentColor,
    required this.increment,
    required this.changeColor,
    required this.reset,
    required super.child,
  });

  final int count;
  final Color accentColor;
  final VoidCallback increment;
  final VoidCallback changeColor;
  final VoidCallback reset;

  static _InheritedCounterScope of(BuildContext context) {
    final _InheritedCounterScope? scope = context
        .dependOnInheritedWidgetOfExactType<_InheritedCounterScope>();
    assert(scope != null, 'No _InheritedCounterScope found in context');
    return scope!;
  }

  static _InheritedCounterScope read(BuildContext context) {
    final InheritedElement? element = context
        .getElementForInheritedWidgetOfExactType<_InheritedCounterScope>();
    final _InheritedCounterScope? scope =
        element?.widget as _InheritedCounterScope?;
    assert(scope != null, 'No _InheritedCounterScope found in context');
    return scope!;
  }

  @override
  bool updateShouldNotify(_InheritedCounterScope oldWidget) {
    return count != oldWidget.count || accentColor != oldWidget.accentColor;
  }
}

class _ScopeControlCard extends StatelessWidget {
  const _ScopeControlCard();

  @override
  Widget build(BuildContext context) {
    final _InheritedCounterScope scope = _InheritedCounterScope.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Ancestor Provides Shared Data',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'The page-level State owns the source of truth. _InheritedCounterScope exposes count, accentColor, and actions to the whole subtree.',
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                Chip(
                  label: Text('Shared count: ${scope.count}'),
                  avatar: Icon(Icons.countertops, color: scope.accentColor),
                ),
                Chip(
                  label: const Text('Accent color shared downward'),
                  backgroundColor: scope.accentColor.withValues(alpha: 0.14),
                  side: BorderSide(
                    color: scope.accentColor.withValues(alpha: 0.3),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                FilledButton(
                  onPressed: scope.increment,
                  child: const Text('Increment from ancestor'),
                ),
                OutlinedButton(
                  onPressed: scope.changeColor,
                  child: const Text('Change shared color'),
                ),
                TextButton(onPressed: scope.reset, child: const Text('Reset')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ScopeTreeCard extends StatelessWidget {
  const _ScopeTreeCard();

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
              'Descendants Read Without Prop Drilling',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'These widgets are nested several levels deep, but none of the intermediate widgets need count or color constructor parameters.',
            ),
            const SizedBox(height: 16),
            const _BranchBox(
              depthLabel: 'Level 1 Container',
              child: _BranchBox(
                depthLabel: 'Level 2 Container',
                child: _BranchBox(
                  depthLabel: 'Level 3 Consumer',
                  child: _DeepConsumerPanel(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BranchBox extends StatelessWidget {
  const _BranchBox({required this.depthLabel, required this.child});

  final String depthLabel;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            depthLabel,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _DeepConsumerPanel extends StatelessWidget {
  const _DeepConsumerPanel();

  @override
  Widget build(BuildContext context) {
    final _InheritedCounterScope scope = _InheritedCounterScope.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scope.accentColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Deep child reads shared count = ${scope.count}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: scope.accentColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Because this child called of(context), it will rebuild whenever the InheritedWidget notifies dependents.',
            ),
            const SizedBox(height: 12),
            FilledButton.tonalIcon(
              onPressed: scope.increment,
              icon: const Icon(Icons.add),
              label: const Text('Increment from deep child'),
            ),
          ],
        ),
      ),
    );
  }
}

class _RebuildBehaviorCard extends StatelessWidget {
  const _RebuildBehaviorCard();

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
              'Dependency Registration Matters',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'The left panel uses of(context) and rebuilds automatically. The right panel uses read(context), so it can fetch the scope on demand without subscribing.',
            ),
            const SizedBox(height: 16),
            const Wrap(
              spacing: 16,
              runSpacing: 16,
              children: <Widget>[
                SizedBox(width: 320, child: _DependentRebuildPanel()),
                SizedBox(width: 320, child: _ManualReadPanel()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DependentRebuildPanel extends StatefulWidget {
  const _DependentRebuildPanel();

  @override
  State<_DependentRebuildPanel> createState() => _DependentRebuildPanelState();
}

class _DependentRebuildPanelState extends State<_DependentRebuildPanel> {
  int _dependencyChanges = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _InheritedCounterScope.of(context);
    _dependencyChanges += 1;
  }

  @override
  Widget build(BuildContext context) {
    final _InheritedCounterScope scope = _InheritedCounterScope.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: scope.accentColor.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Auto rebuild consumer',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text('Current shared count: ${scope.count}'),
            Text('didChangeDependencies calls: $_dependencyChanges'),
            const SizedBox(height: 8),
            const Text(
              'Press increment or change color above. This panel updates because it depends on the inherited scope.',
            ),
          ],
        ),
      ),
    );
  }
}

class _ManualReadPanel extends StatefulWidget {
  const _ManualReadPanel();

  @override
  State<_ManualReadPanel> createState() => _ManualReadPanelState();
}

class _ManualReadPanelState extends State<_ManualReadPanel> {
  int? _capturedCount;
  Color? _capturedColor;

  void _captureScope() {
    final _InheritedCounterScope scope = _InheritedCounterScope.read(context);
    setState(() {
      _capturedCount = scope.count;
      _capturedColor = scope.accentColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color borderColor = _capturedColor ?? Theme.of(context).dividerColor;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Manual read consumer',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              _capturedCount == null
                  ? 'No snapshot captured yet.'
                  : 'Snapshot count: $_capturedCount',
            ),
            const SizedBox(height: 8),
            const Text(
              'This panel does not subscribe to updates. It only changes when you press the button below and read the scope manually.',
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _captureScope,
              child: const Text('Capture current scope'),
            ),
          ],
        ),
      ),
    );
  }
}
