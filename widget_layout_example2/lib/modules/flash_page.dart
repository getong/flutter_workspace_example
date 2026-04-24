import 'package:auto_route/auto_route.dart';
import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.flash)
class FlashPage extends StatefulWidget {
  const FlashPage({super.key});

  @override
  State<FlashPage> createState() => _FlashPageState();
}

class _FlashPageState extends State<FlashPage> {
  final List<String> _eventLog = <String>[];
  String _latestResult = 'No flash interaction yet.';

  void _record(String message) {
    final DateTime now = DateTime.now();
    final String timestamp =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

    setState(() {
      _latestResult = message;
      _eventLog.insert(0, '$timestamp  $message');
      if (_eventLog.length > 10) {
        _eventLog.removeRange(10, _eventLog.length);
      }
    });
  }

  Future<void> _showQueuedToasts() async {
    _record('Queued two toast messages.');
    await context.showToast(
      const Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.notifications_active_outlined),
          SizedBox(width: 10),
          Text('Toast uses the global overlay wrapper.'),
        ],
      ),
    );
    if (!mounted) {
      return;
    }
    await context.showToast(
      const Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.schedule_outlined),
          SizedBox(width: 10),
          Text('Queued toasts wait for the previous one to finish.'),
        ],
      ),
      queue: true,
    );
  }

  Future<void> _showStyledToast() async {
    _record('Displayed a centered styled toast.');
    await context.showToast(
      const Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.palette_outlined),
          SizedBox(width: 10),
          Text('Custom shape, alignment, and colors.'),
        ],
      ),
      alignment: const Alignment(0, -0.25),
      backgroundColor: const Color(0xFF0F172A),
      iconColor: Colors.white,
      textStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 10,
      queue: false,
    );
  }

  Future<void> _showBottomFlashBar() async {
    final bool? approved = await context.showFlash<bool>(
      builder: (BuildContext context, FlashController<bool> controller) {
        return FlashBar<bool>(
          controller: controller,
          indicatorColor: const Color(0xFF2563EB),
          icon: const Icon(Icons.tips_and_updates_outlined),
          title: const Text('Review changes'),
          content: const Text(
            'FlashBar combines alert content, actions, and animated presentation in one widget.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: controller.dismiss,
              child: const Text('Later'),
            ),
            FilledButton(
              onPressed: () => controller.dismiss(true),
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );

    _record(
      approved == true
          ? 'Bottom FlashBar resolved with Apply.'
          : 'Bottom FlashBar dismissed without approval.',
    );
  }

  Future<void> _showTopTimedFlashBar() async {
    _record('Opened a top-positioned floating FlashBar.');
    await context.showFlash<void>(
      duration: const Duration(seconds: 3),
      barrierDismissible: true,
      onRemoveFromRoute: () => _record('Timed FlashBar removed from route.'),
      builder: (BuildContext context, FlashController<void> controller) {
        return FlashBar<void>(
          controller: controller,
          position: FlashPosition.top,
          behavior: FlashBehavior.floating,
          margin: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFFD1D5DB)),
          ),
          clipBehavior: Clip.antiAlias,
          indicatorColor: const Color(0xFF16A34A),
          icon: const Icon(Icons.done_all_outlined),
          title: const Text('Synced'),
          content: const Text(
            'Position, behavior, duration, and barrier dismissal can all be adjusted.',
          ),
        );
      },
    );
  }

  Future<void> _showInputFlashBar() async {
    final TextEditingController textController = TextEditingController();

    final String? value = await context.showFlash<String>(
      persistent: false,
      barrierDismissible: true,
      barrierColor: Colors.black45,
      builder: (BuildContext context, FlashController<String> controller) {
        return FlashBar<String>(
          controller: controller,
          indicatorColor: const Color(0xFFF59E0B),
          icon: const Icon(Icons.edit_note_outlined),
          title: const Text('Return a value from FlashBar'),
          content: TextField(
            controller: textController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Type a short note',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          primaryAction: IconButton(
            onPressed: () => controller.dismiss(textController.text.trim()),
            icon: const Icon(Icons.send_outlined),
          ),
        );
      },
    );

    textController.dispose();

    if (!mounted) {
      return;
    }

    final String trimmedValue = value?.trim() ?? '';
    if (trimmedValue.isEmpty) {
      _record('Input FlashBar closed without text.');
      await context.showErrorBar(
        position: FlashPosition.top,
        content: const Text('No text entered.'),
      );
      return;
    }

    _record('Input FlashBar returned "$trimmedValue".');
    await context.showSuccessBar(
      position: FlashPosition.top,
      content: Text('Captured: $trimmedValue'),
    );
  }

  Future<void> _showHelperBars() async {
    _record('Triggered helper shortcuts for info, success, and error bars.');
    await context.showInfoBar(
      position: FlashPosition.top,
      content: const Text('showInfoBar builds a preconfigured FlashBar.'),
    );
    if (!mounted) {
      return;
    }
    await context.showSuccessBar(
      content: const Text('showSuccessBar is useful for brief confirmations.'),
    );
    if (!mounted) {
      return;
    }
    await context.showErrorBar(
      content: const Text(
        'showErrorBar works well for retry or failure states.',
      ),
      primaryActionBuilder:
          (BuildContext context, FlashController<void> controller) {
            return IconButton(
              onPressed: controller.dismiss,
              icon: const Icon(Icons.refresh_outlined),
            );
          },
    );
  }

  Future<void> _showModalDialogFlash() async {
    _record('Opened a modal flash dialog.');
    final bool? confirmed = await context.showModalFlash<bool>(
      barrierBlur: 6,
      builder: (BuildContext context, FlashController<bool> controller) {
        return FadeTransition(
          opacity: controller.controller,
          child: AlertDialog(
            title: const Text('Modal flash dialog'),
            content: const Text(
              'showModalFlash pushes a modal route while still using the flash controller lifecycle.',
            ),
            actions: <Widget>[
              TextButton(
                onPressed: controller.dismiss,
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => controller.dismiss(true),
                child: const Text('Continue'),
              ),
            ],
          ),
        );
      },
    );

    _record(
      confirmed == true
          ? 'Modal flash dialog confirmed.'
          : 'Modal flash dialog dismissed.',
    );
  }

  Future<void> _showCustomFlashDrawer() async {
    _record('Opened a custom Flash drawer built from the base Flash widget.');
    await context.showModalFlash<void>(
      barrierColor: Colors.black54,
      builder: (BuildContext context, FlashController<void> controller) {
        return Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Flash<void>(
            controller: controller,
            dismissDirections: const <FlashDismissDirection>[
              FlashDismissDirection.endToStart,
            ],
            slideAnimationCreator:
                (
                  BuildContext context,
                  FlashPosition? position,
                  Animation<double> parent,
                  Curve curve,
                  Curve? reverseCurve,
                ) {
                  final Animation<double> animation = CurvedAnimation(
                    parent: parent,
                    curve: curve,
                    reverseCurve: reverseCurve,
                  );
                  final double beginX =
                      Directionality.of(context) == TextDirection.ltr ? 1 : -1;
                  return Tween<Offset>(
                    begin: Offset(beginX, 0),
                    end: Offset.zero,
                  ).animate(animation);
                },
            child: FractionallySizedBox(
              widthFactor: 0.88,
              child: Material(
                clipBehavior: Clip.antiAlias,
                elevation: 20,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(28),
                ),
                color: Theme.of(context).colorScheme.surface,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Custom Flash drawer',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Use Flash directly when you need custom layout, custom animation, or a non-bar presentation.',
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: <Widget>[
                            Chip(
                              avatar: const Icon(Icons.swipe_outlined),
                              label: const Text('Swipe to dismiss'),
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.10),
                            ),
                            Chip(
                              avatar: const Icon(Icons.tune_outlined),
                              label: const Text('Custom transition'),
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.secondary.withValues(alpha: 0.12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Align(
                          alignment: Alignment.centerRight,
                          child: FilledButton.icon(
                            onPressed: controller.dismiss,
                            icon: const Icon(Icons.close),
                            label: const Text('Close'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('flash Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'flash provides layered in-app messaging primitives for toast-style notices, action bars, modal alerts, and fully custom overlay surfaces.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            const _FlashInfoCard(
              title: 'Core widgets and helpers',
              description:
                  'Toast handles queued lightweight notices, FlashBar is the ready-made alert surface, Flash is the lower-level animated container, and flash_helper adds BuildContext shortcuts such as showFlash, showModalFlash, showInfoBar, showSuccessBar, and showErrorBar.',
            ),
            const SizedBox(height: 16),
            const _FlashCodeCard(
              title: 'App-level setup',
              code: '''
Toast(
  navigatorKey: appRouter.navigatorKey,
  child: MaterialApp.router(...),
)
''',
            ),
            const SizedBox(height: 16),
            const _FlashCodeCard(
              title: 'Typical FlashBar usage',
              code: '''
context.showFlash<bool>(
  builder: (context, controller) => FlashBar(
    controller: controller,
    title: const Text('Flash Title'),
    content: const Text('This is a flash bar.'),
    actions: <Widget>[
      TextButton(onPressed: controller.dismiss, child: const Text('Cancel')),
      FilledButton(
        onPressed: () => controller.dismiss(true),
        child: const Text('Apply'),
      ),
    ],
  ),
);
''',
            ),
            const SizedBox(height: 24),
            _FlashExampleCard(
              title: 'Toast examples',
              description:
                  'These shortcuts use the global Toast wrapper and are good for transient, low-friction feedback.',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  FilledButton.icon(
                    onPressed: _showQueuedToasts,
                    icon: const Icon(Icons.queue_outlined),
                    label: const Text('Queue two toasts'),
                  ),
                  OutlinedButton.icon(
                    onPressed: _showStyledToast,
                    icon: const Icon(Icons.design_services_outlined),
                    label: const Text('Styled toast'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _FlashExampleCard(
              title: 'FlashBar examples',
              description:
                  'FlashBar exposes actions, title/content regions, placement controls, and return values.',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  FilledButton.icon(
                    onPressed: _showBottomFlashBar,
                    icon: const Icon(Icons.vertical_align_bottom_outlined),
                    label: const Text('Bottom action bar'),
                  ),
                  OutlinedButton.icon(
                    onPressed: _showTopTimedFlashBar,
                    icon: const Icon(Icons.vertical_align_top_outlined),
                    label: const Text('Top timed bar'),
                  ),
                  OutlinedButton.icon(
                    onPressed: _showInputFlashBar,
                    icon: const Icon(Icons.keyboard_outlined),
                    label: const Text('Input flash bar'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _FlashExampleCard(
              title: 'Helper shortcuts',
              description:
                  'Prebuilt info, success, and error helpers reduce boilerplate when you only need standard variants.',
              child: FilledButton.tonalIcon(
                onPressed: _showHelperBars,
                icon: const Icon(Icons.auto_awesome_outlined),
                label: const Text('Show helper bars'),
              ),
            ),
            const SizedBox(height: 16),
            _FlashExampleCard(
              title: 'Modal and custom Flash',
              description:
                  'Modal flash routes work for dialogs, while the base Flash widget lets you design a completely custom animated surface.',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  FilledButton.icon(
                    onPressed: _showModalDialogFlash,
                    icon: const Icon(Icons.open_in_new_outlined),
                    label: const Text('Modal dialog flash'),
                  ),
                  OutlinedButton.icon(
                    onPressed: _showCustomFlashDrawer,
                    icon: const Icon(Icons.space_dashboard_outlined),
                    label: const Text('Custom flash drawer'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _FlashExampleCard(
              title: 'Latest result',
              description:
                  'Interactive examples update this status so you can see what the route returned.',
              child: Text(
                _latestResult,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 16),
            _FlashExampleCard(
              title: 'Recent event log',
              description:
                  'A simple in-page log helps verify dismissal callbacks and return values while testing.',
              child: _eventLog.isEmpty
                  ? const Text('No events yet.')
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _eventLog
                          .map(
                            (String entry) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(entry),
                            ),
                          )
                          .toList(growable: false),
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
  }
}

class _FlashExampleCard extends StatelessWidget {
  const _FlashExampleCard({
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

class _FlashInfoCard extends StatelessWidget {
  const _FlashInfoCard({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.18),
        ),
      ),
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

class _FlashCodeCard extends StatelessWidget {
  const _FlashCodeCard({required this.title, required this.code});

  final String title;
  final String code;

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
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                code,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'monospace',
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
