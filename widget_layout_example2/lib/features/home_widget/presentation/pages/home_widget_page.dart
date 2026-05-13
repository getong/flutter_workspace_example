import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widget_layout_example2/app_navigation.dart';
import 'package:widget_layout_example2/features/home_widget/domain/entities/home_widget_demo_snapshot.dart';
import 'package:widget_layout_example2/features/home_widget/domain/entities/installed_home_widget.dart';
import 'package:widget_layout_example2/features/home_widget/presentation/bloc/home_widget_demo_bloc.dart';
import 'package:widget_layout_example2/features/home_widget/presentation/bloc/home_widget_demo_event.dart';
import 'package:widget_layout_example2/features/home_widget/presentation/bloc/home_widget_demo_state.dart';

@RoutePage(name: RouteName.homeWidget)
class HomeWidgetPage extends StatefulWidget {
  const HomeWidgetPage({super.key});

  @override
  State<HomeWidgetPage> createState() => _HomeWidgetPageState();
}

class _HomeWidgetPageState extends State<HomeWidgetPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    final HomeWidgetDemoSnapshot snapshot = context
        .read<HomeWidgetDemoBloc>()
        .state
        .snapshot;
    _titleController = TextEditingController(text: snapshot.widgetTitle);
    _messageController = TextEditingController(text: snapshot.widgetMessage);
    context.read<HomeWidgetDemoBloc>().add(
      const HomeWidgetDemoInitializeRequested(),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _syncDraft(BuildContext context) {
    context.read<HomeWidgetDemoBloc>().add(
      HomeWidgetDemoDraftChanged(
        title: _titleController.text,
        message: _messageController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('home_widget Module')),
      body: SelectionArea(
        child: BlocConsumer<HomeWidgetDemoBloc, HomeWidgetDemoState>(
          listenWhen:
              (HomeWidgetDemoState previous, HomeWidgetDemoState current) =>
                  previous.snapshot.widgetTitle !=
                      current.snapshot.widgetTitle ||
                  previous.snapshot.widgetMessage !=
                      current.snapshot.widgetMessage,
          listener: (BuildContext context, HomeWidgetDemoState state) {
            if (_titleController.text != state.snapshot.widgetTitle) {
              _titleController.text = state.snapshot.widgetTitle;
            }
            if (_messageController.text != state.snapshot.widgetMessage) {
              _messageController.text = state.snapshot.widgetMessage;
            }
          },
          builder: (BuildContext context, HomeWidgetDemoState state) {
            final HomeWidgetDemoSnapshot snapshot = state.snapshot;
            return ListView(
              padding: const EdgeInsets.all(24),
              children: <Widget>[
                const Text(
                  'home_widget lets Flutter write data into the native widget container, trigger widget refresh, inspect installed widgets, and react to widget clicks. The actual home screen widget is still rendered with native Android/iOS code.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                const _InfoCard(
                  title: 'What This Demo Shows',
                  description:
                      '1. Flutter writes title/message into shared widget storage.\n2. Flutter requests native widget refresh.\n3. Android AppWidgetProvider reads those values and redraws the home screen widget.\n4. Widget clicks can relaunch Flutter or trigger a Dart callback via home_widget background interactivity.',
                ),
                const SizedBox(height: 16),
                const _InfoCard(
                  title: 'Clean Architecture Shape',
                  description:
                      'Presentation -> HomeWidgetDemoBloc + this page\nDomain -> HomeWidgetRepository + HomeWidgetDemoSnapshot\nData -> HomeWidgetDemoRepository + HomeWidgetDemoRuntime\nNative boundary -> Android AppWidgetProvider / widget XML layout',
                ),
                const SizedBox(height: 16),
                const _CodeCard(
                  title: 'Push Data From Flutter',
                  code: '''
await HomeWidget.saveWidgetData<String>('title', title);
await HomeWidget.saveWidgetData<String>('message', message);
await HomeWidget.updateWidget(
  qualifiedAndroidName:
      'com.example.widget_layout_example2.WidgetLayoutExampleHomeWidgetProvider',
);
''',
                ),
                const SizedBox(height: 16),
                const _CodeCard(
                  title: 'Render A Flutter Widget To An Image',
                  code: '''
await HomeWidget.renderFlutterWidget(
  const Icon(Icons.widgets_rounded),
  key: 'flutterIcon',
  logicalSize: const Size(180, 180),
);
''',
                ),
                const SizedBox(height: 16),
                const _CodeCard(
                  title: 'Native Widget Reads Shared Storage',
                  code: '''
setTextViewText(
  R.id.widget_title,
  widgetData.getString("title", null) ?: "No Title Set",
)
''',
                ),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Draft Data',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Widget Title',
                          ),
                          onChanged: (_) => _syncDraft(context),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Widget Message',
                          ),
                          onChanged: (_) => _syncDraft(context),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Live State',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 12),
                        _StatusPanel(
                          title: 'Platform',
                          value: snapshot.platformLabel,
                        ),
                        const SizedBox(height: 12),
                        _StatusPanel(
                          title: 'Supported',
                          value: '${snapshot.isSupported}',
                        ),
                        const SizedBox(height: 12),
                        _StatusPanel(
                          title: 'Configured',
                          value: '${snapshot.isConfigured}',
                        ),
                        const SizedBox(height: 12),
                        _StatusPanel(
                          title: 'Pin Supported',
                          value: '${snapshot.isPinSupported}',
                        ),
                        const SizedBox(height: 12),
                        _StatusPanel(
                          title: 'Widget Launch',
                          value: snapshot.widgetLaunchSummary,
                        ),
                        const SizedBox(height: 12),
                        _StatusPanel(
                          title: 'Rendered Image',
                          value:
                              snapshot.renderedImagePath ?? 'Not rendered yet.',
                        ),
                        const SizedBox(height: 12),
                        _StatusPanel(
                          title: 'Status',
                          value: snapshot.statusMessage,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const _SectionTitle(
                  title: 'Widget Actions',
                  subtitle:
                      'Use these actions to write data, refresh the native widget, inspect what is installed, and trigger launcher pinning when available.',
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: <Widget>[
                    FilledButton.icon(
                      onPressed: state.isBusy
                          ? null
                          : () => context.read<HomeWidgetDemoBloc>().add(
                              const HomeWidgetDemoPushRequested(),
                            ),
                      icon: const Icon(Icons.cloud_upload_outlined),
                      label: const Text('Save + Refresh Widget'),
                    ),
                    OutlinedButton.icon(
                      onPressed: state.isBusy
                          ? null
                          : () => context.read<HomeWidgetDemoBloc>().add(
                              const HomeWidgetDemoReadRequested(),
                            ),
                      icon: const Icon(Icons.download_outlined),
                      label: const Text('Read Widget Data'),
                    ),
                    OutlinedButton.icon(
                      onPressed: state.isBusy
                          ? null
                          : () => context.read<HomeWidgetDemoBloc>().add(
                              const HomeWidgetDemoRenderImageRequested(),
                            ),
                      icon: const Icon(Icons.image_outlined),
                      label: const Text('Render Flutter Image'),
                    ),
                    OutlinedButton.icon(
                      onPressed: !snapshot.isSupported || state.isBusy
                          ? null
                          : () => context.read<HomeWidgetDemoBloc>().add(
                              const HomeWidgetDemoInstalledWidgetsRequested(),
                            ),
                      icon: const Icon(Icons.widgets_outlined),
                      label: const Text('Installed Widgets'),
                    ),
                    OutlinedButton.icon(
                      onPressed: !snapshot.isSupported || state.isBusy
                          ? null
                          : () => context.read<HomeWidgetDemoBloc>().add(
                              const HomeWidgetDemoRequestPinRequested(),
                            ),
                      icon: const Icon(Icons.push_pin_outlined),
                      label: const Text('Request Pin Widget'),
                    ),
                    OutlinedButton.icon(
                      onPressed: state.isBusy
                          ? null
                          : () => context.read<HomeWidgetDemoBloc>().add(
                              const HomeWidgetDemoRefreshRequested(),
                            ),
                      icon: const Icon(Icons.refresh_outlined),
                      label: const Text('Refresh State'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const _InfoCard(
                  title: 'Platform Notes',
                  description:
                      'Android: this demo includes a real AppWidgetProvider and layout resources, so the launcher can pin and render a home screen widget.\n\niOS: the Flutter-side API is wired, but a production iOS WidgetKit extension still needs separate native target setup in Xcode.\n\nKey constraint: home_widget does not render the home screen UI in Flutter directly; Flutter only supplies data and optional rendered images.',
                ),
                const SizedBox(height: 24),
                Card(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Installed Widget Metadata',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 12),
                        if (snapshot.installedWidgets.isEmpty)
                          const Text(
                            'No installed widget metadata loaded yet. Tap "Installed Widgets" after pinning the widget on the launcher.',
                          )
                        else
                          ...snapshot.installedWidgets.map(
                            (InstalledHomeWidget widget) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(widget.summary),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Event Log',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 12),
                        if (snapshot.logEntries.isEmpty)
                          const Text('No widget events recorded yet.')
                        else
                          ...snapshot.logEntries.map(
                            (String entry) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(entry),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
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
          ],
        ),
      ),
    );
  }
}

class _CodeCard extends StatelessWidget {
  const _CodeCard({required this.title, required this.code});

  final String title;
  final String code;

  @override
  Widget build(BuildContext context) {
    return Card(
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
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                code.trim(),
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontFamily: 'monospace'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(subtitle),
      ],
    );
  }
}

class _StatusPanel extends StatelessWidget {
  const _StatusPanel({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(value),
      ],
    );
  }
}
