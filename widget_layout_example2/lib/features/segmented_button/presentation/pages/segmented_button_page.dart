import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widget_layout_example2/app_navigation.dart';
import 'package:widget_layout_example2/features/segmented_button/data/repositories/in_memory_segmented_button_repository.dart';
import 'package:widget_layout_example2/features/segmented_button/domain/entities/segmented_button_demo_snapshot.dart';
import 'package:widget_layout_example2/features/segmented_button/domain/repositories/segmented_button_repository.dart';
import 'package:widget_layout_example2/features/segmented_button/presentation/cubit/segmented_button_cubit.dart';
import 'package:widget_layout_example2/features/segmented_button/presentation/cubit/segmented_button_state.dart';

@RoutePage(name: RouteName.segmentedButton)
class SegmentedButtonPage extends StatefulWidget {
  const SegmentedButtonPage({super.key});

  @override
  State<SegmentedButtonPage> createState() => _SegmentedButtonPageState();
}

class _SegmentedButtonPageState extends State<SegmentedButtonPage> {
  late final SegmentedButtonRepository _repository =
      InMemorySegmentedButtonRepository();
  late final SegmentedButtonCubit _cubit = SegmentedButtonCubit(
    repository: _repository,
  );

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<SegmentedButtonRepository>.value(
      value: _repository,
      child: BlocProvider<SegmentedButtonCubit>.value(
        value: _cubit,
        child: const _SegmentedButtonView(),
      ),
    );
  }
}

class _SegmentedButtonView extends StatelessWidget {
  const _SegmentedButtonView();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return BlocBuilder<SegmentedButtonCubit, SegmentedButtonDemoState>(
      builder: (BuildContext context, SegmentedButtonDemoState state) {
        return Scaffold(
          appBar: AppBar(title: const Text('SegmentedButton Module')),
          body: SelectionArea(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: <Widget>[
                Text(
                  'SegmentedButton groups a small set of related options into '
                  'one compact control, so users can see every state and the '
                  'current selection at a glance.',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                _SectionCard(
                  title: 'What It Is Good For',
                  description:
                      'Use it when the choices are few, always visible, and '
                      'closely related. It is most effective for mode '
                      'switching, view toggles, lightweight filters, and '
                      'settings that should not hide inside a menu.',
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: const <Widget>[
                      _InfoChip(label: 'Compact alternative to many buttons'),
                      _InfoChip(label: 'Clear current selection'),
                      _InfoChip(label: 'Works for single or multi-select'),
                      _InfoChip(label: 'Good for quick filter changes'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'Single Selection Demo',
                  description:
                      'Exactly one calendar mode is active. This is the common '
                      'pattern when the user should switch context without '
                      'losing visibility of the available modes.',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SegmentedButton<CalendarView>(
                          key: const Key('segmentedButton.single'),
                          segments: <ButtonSegment<CalendarView>>[
                            for (final CalendarView view in CalendarView.values)
                              ButtonSegment<CalendarView>(
                                value: view,
                                label: Text(_calendarLabel(view)),
                                icon: Icon(_calendarIcon(view)),
                              ),
                          ],
                          selected: <CalendarView>{state.calendarView},
                          onSelectionChanged: context
                              .read<SegmentedButtonCubit>()
                              .selectCalendarView,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _SummaryPanel(
                        key: const Key('segmentedButton.summary.calendar'),
                        label: 'Active calendar view',
                        value: _calendarLabel(state.calendarView),
                        supportingText:
                            'Effect: the current mode stays obvious without '
                            'taking the user away from the page.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'Multiple Selection Demo',
                  description:
                      'Enable multi-selection when several related filters can '
                      'stay active together. This keeps filtering direct and '
                      'avoids an extra dialog or dropdown.',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SegmentedButton<ApparelSize>(
                          key: const Key('segmentedButton.multi'),
                          segments: <ButtonSegment<ApparelSize>>[
                            for (final ApparelSize size in ApparelSize.values)
                              ButtonSegment<ApparelSize>(
                                value: size,
                                label: Text(_sizeLabel(size)),
                              ),
                          ],
                          selected: state.selectedSizes,
                          multiSelectionEnabled: true,
                          emptySelectionAllowed: true,
                          onSelectionChanged: context
                              .read<SegmentedButtonCubit>()
                              .selectSizes,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _SummaryPanel(
                        key: const Key('segmentedButton.summary.sizes'),
                        label: 'Selected size filters',
                        value: _formatSizes(state.selectedSizes),
                        supportingText:
                            'Effect: users can combine or clear filters with '
                            'one tap while keeping the active set visible.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'Key API Points',
                  description:
                      'These are the core properties you normally configure '
                      'when you add a SegmentedButton.',
                  child: const Column(
                    children: <Widget>[
                      _ApiRow(
                        label: 'segments',
                        detail:
                            'Defines each option, including its value, text, '
                            'and optional icon.',
                      ),
                      SizedBox(height: 10),
                      _ApiRow(
                        label: 'selected',
                        detail:
                            'A Set of the currently active value or values.',
                      ),
                      SizedBox(height: 10),
                      _ApiRow(
                        label: 'onSelectionChanged',
                        detail:
                            'Receives the next selected Set whenever the user '
                            'changes the control.',
                      ),
                      SizedBox(height: 10),
                      _ApiRow(
                        label: 'multiSelectionEnabled',
                        detail: 'Allows multiple segments to stay selected.',
                      ),
                      SizedBox(height: 10),
                      _ApiRow(
                        label: 'emptySelectionAllowed',
                        detail:
                            'Lets the user clear every segment in multi-select '
                            'mode.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'Clean Architecture In This Module',
                  description:
                      'The demo keeps domain data, in-memory storage, and UI '
                      'state separate so the example stays easy to extend or '
                      'replace with a real data source later.',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _LayerRow(
                        label: 'Domain',
                        detail:
                            'CalendarView, ApparelSize, '
                            'SegmentedButtonDemoSnapshot, and '
                            'SegmentedButtonRepository.',
                      ),
                      const SizedBox(height: 8),
                      _LayerRow(
                        label: 'Data',
                        detail:
                            'InMemorySegmentedButtonRepository acts as the '
                            'single source of truth for demo selections.',
                      ),
                      const SizedBox(height: 8),
                      _LayerRow(
                        label: 'Presentation',
                        detail:
                            'SegmentedButtonCubit transforms repository data '
                            'into UI state, and this page renders the demos.',
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: OutlinedButton.icon(
                          key: const Key('segmentedButton.reset'),
                          onPressed: context.read<SegmentedButtonCubit>().reset,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reset Demo State'),
                        ),
                      ),
                    ],
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
        );
      },
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

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
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      avatar: const Icon(Icons.check_circle_outline, size: 18),
    );
  }
}

class _SummaryPanel extends StatelessWidget {
  const _SummaryPanel({
    super.key,
    required this.label,
    required this.value,
    required this.supportingText,
  });

  final String label;
  final String value;
  final String supportingText;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(supportingText),
        ],
      ),
    );
  }
}

class _ApiRow extends StatelessWidget {
  const _ApiRow({required this.label, required this.detail});

  final String label;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 160,
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(detail)),
      ],
    );
  }
}

class _LayerRow extends StatelessWidget {
  const _LayerRow({required this.label, required this.detail});

  final String label;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(detail)),
      ],
    );
  }
}

String _calendarLabel(CalendarView view) => switch (view) {
  CalendarView.day => 'Day',
  CalendarView.week => 'Week',
  CalendarView.month => 'Month',
  CalendarView.year => 'Year',
};

IconData _calendarIcon(CalendarView view) => switch (view) {
  CalendarView.day => Icons.calendar_view_day,
  CalendarView.week => Icons.calendar_view_week,
  CalendarView.month => Icons.calendar_view_month,
  CalendarView.year => Icons.calendar_today,
};

String _sizeLabel(ApparelSize size) => switch (size) {
  ApparelSize.extraSmall => 'XS',
  ApparelSize.small => 'S',
  ApparelSize.medium => 'M',
  ApparelSize.large => 'L',
  ApparelSize.extraLarge => 'XL',
};

String _formatSizes(Set<ApparelSize> sizes) {
  if (sizes.isEmpty) {
    return 'No size filter selected';
  }

  return ApparelSize.values.where(sizes.contains).map(_sizeLabel).join(', ');
}
