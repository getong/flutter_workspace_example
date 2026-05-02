import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_event_bus/flutter_bloc_event_bus.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.flutterBlocEventBus)
class FlutterBlocEventBusPage extends StatelessWidget {
  const FlutterBlocEventBusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<_AuthBusCubit>(create: (_) => _AuthBusCubit()),
        BlocProvider<_CartBridgeCubit>(create: (_) => _CartBridgeCubit()),
        BlocProvider<_EventAuditCubit>(create: (_) => _EventAuditCubit()),
        BlocProvider<_PulsePublisherBloc>(create: (_) => _PulsePublisherBloc()),
        BlocProvider<_PulseAuditObserverBloc>(
          create: (_) => _PulseAuditObserverBloc(),
        ),
        BlocProvider<_BusStatusBridgeBloc>(
          create: (_) => _BusStatusBridgeBloc(),
        ),
      ],
      child: const _FlutterBlocEventBusView(),
    );
  }
}

class _FlutterBlocEventBusView extends StatelessWidget {
  const _FlutterBlocEventBusView();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('flutter_bloc_event_bus Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'flutter_bloc_event_bus adds a global event bus on top of '
              'flutter_bloc so Cubits and Blocs can react to each other '
              'without direct references.',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This page demonstrates the real primitives in the package: '
              '`Event`, `eventBus.send(...)`, `BusPublisherCubit`, '
              '`BusObserverCubit`, `BusBridgeCubit`, `BusPublisherBloc`, '
              '`BusObserverBloc`, and `BusBridgeBloc`.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: const <Widget>[
                _KeywordChip(label: 'Event'),
                _KeywordChip(label: 'eventBus.send'),
                _KeywordChip(label: 'BusPublisherCubit'),
                _KeywordChip(label: 'BusObserverCubit'),
                _KeywordChip(label: 'BusBridgeCubit'),
                _KeywordChip(label: 'BusPublisherBloc'),
                _KeywordChip(label: 'BusObserverBloc'),
                _KeywordChip(label: 'BusBridgeBloc'),
              ],
            ),
            const SizedBox(height: 24),
            const _CodeSampleCard(),
            const SizedBox(height: 16),
            _SectionCard(
              title: '1. Cubit Publisher + Observer + Bridge',
              subtitle:
                  'Auth publishes login events, Cart bridges logout cleanup, '
                  'and Audit observes the shared bus.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const _CubitControlRow(),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                          final bool useColumn = constraints.maxWidth < 900;
                          final List<Widget> cards = <Widget>[
                            const Expanded(child: _AuthPublisherCard()),
                            const SizedBox(width: 16, height: 16),
                            const Expanded(child: _CartBridgeCard()),
                            const SizedBox(width: 16, height: 16),
                            const Expanded(child: _EventAuditCard()),
                          ];

                          if (useColumn) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                const _AuthPublisherCard(),
                                const SizedBox(height: 16),
                                const _CartBridgeCard(),
                                const SizedBox(height: 16),
                                const _EventAuditCard(),
                              ],
                            );
                          }

                          return Row(children: cards);
                        },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: '2. Bloc Publisher + Observer + Bridge',
              subtitle:
                  'A Bloc publishes pulse states, a second Bloc records them, '
                  'and a bridge Bloc summarizes cross-feature bus traffic.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const _PulseActionRow(),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                          if (constraints.maxWidth < 900) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: const <Widget>[
                                _PulsePublisherCard(),
                                SizedBox(height: 16),
                                _PulseAuditCard(),
                                SizedBox(height: 16),
                                _BusStatusBridgeCard(),
                              ],
                            );
                          }

                          return const Row(
                            children: <Widget>[
                              Expanded(child: _PulsePublisherCard()),
                              SizedBox(width: 16),
                              Expanded(child: _PulseAuditCard()),
                              SizedBox(width: 16),
                              Expanded(child: _BusStatusBridgeCard()),
                            ],
                          );
                        },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: '3. Raw EventBus Stream',
              subtitle:
                  'The package also exposes `eventBus.stream` and '
                  '`eventBus.send(...)` if you need lower-level access.',
              child: StreamBuilder<Event>(
                stream: eventBus.stream,
                builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
                  final Event? event = snapshot.data;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: <Widget>[
                          FilledButton.icon(
                            onPressed: () {
                              eventBus.send(
                                _BusMessageEvent(
                                  kind: 'manual',
                                  message:
                                      'Sent directly with eventBus.send(...)',
                                  createdAt: DateTime.now(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.send),
                            label: const Text('Send Manual Event'),
                          ),
                          OutlinedButton.icon(
                            onPressed: () {
                              context.read<_AuthBusCubit>().loginDemoUser();
                            },
                            icon: const Icon(Icons.person_add_alt_1),
                            label: const Text('Trigger Auth Event'),
                          ),
                          OutlinedButton.icon(
                            onPressed: () {
                              context.read<_PulsePublisherBloc>().add(
                                const _PulseIncrementPressed(),
                              );
                            },
                            icon: const Icon(Icons.bolt),
                            label: const Text('Trigger Bloc Event'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withValues(
                            alpha: 0.55,
                          ),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: colorScheme.outlineVariant),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Latest event on the global bus',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (event == null)
                              Text(
                                'No event received yet on this page session.',
                                style: theme.textTheme.bodyMedium,
                              )
                            else ...<Widget>[
                              Text(
                                event.runtimeType.toString(),
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(_describeEvent(event)),
                            ],
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            const _SectionCard(
              title: '4. Practical Notes',
              subtitle: 'When this package works well and where to be careful.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _BulletLine(
                    text:
                        'Use publishers for feature states that should be observed across the app.',
                  ),
                  _BulletLine(
                    text:
                        'Use observers for passive reactions like analytics, notifications, or cache cleanup.',
                  ),
                  _BulletLine(
                    text:
                        'Use bridges when a component must both publish its own state and react to outside events.',
                  ),
                  _BulletLine(
                    text:
                        'Keep event payloads explicit because the bus is global and type-based.',
                  ),
                  _BulletLine(
                    text:
                        'Avoid circular reactions where one bus event immediately emits another equivalent bus event forever.',
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
  }
}

class _CubitControlRow extends StatelessWidget {
  const _CubitControlRow();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: <Widget>[
        FilledButton.icon(
          onPressed: () => context.read<_AuthBusCubit>().loginDemoUser(),
          icon: const Icon(Icons.login),
          label: const Text('Login Demo User'),
        ),
        OutlinedButton.icon(
          onPressed: () => context.read<_AuthBusCubit>().logout(),
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
        ),
        OutlinedButton.icon(
          onPressed: () => context.read<_CartBridgeCubit>().addRandomItem(),
          icon: const Icon(Icons.add_shopping_cart),
          label: const Text('Add Cart Item'),
        ),
        OutlinedButton.icon(
          onPressed: () {
            eventBus.send(
              _BusMessageEvent(
                kind: 'notice',
                message: 'Manual notice broadcast from the Cubit section.',
                createdAt: DateTime.now(),
              ),
            );
          },
          icon: const Icon(Icons.campaign_outlined),
          label: const Text('Broadcast Notice'),
        ),
      ],
    );
  }
}

class _PulseActionRow extends StatelessWidget {
  const _PulseActionRow();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: <Widget>[
        FilledButton.icon(
          onPressed: () => context.read<_PulsePublisherBloc>().add(
            const _PulseIncrementPressed(),
          ),
          icon: const Icon(Icons.add),
          label: const Text('Increment Pulse'),
        ),
        OutlinedButton.icon(
          onPressed: () => context.read<_PulsePublisherBloc>().add(
            const _PulseDecrementPressed(),
          ),
          icon: const Icon(Icons.remove),
          label: const Text('Decrement Pulse'),
        ),
        OutlinedButton.icon(
          onPressed: () => context.read<_PulsePublisherBloc>().add(
            const _PulseResetPressed(),
          ),
          icon: const Icon(Icons.restart_alt),
          label: const Text('Reset Pulse'),
        ),
      ],
    );
  }
}

class _AuthPublisherCard extends StatelessWidget {
  const _AuthPublisherCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<_AuthBusCubit, _AuthBusState>(
      builder: (BuildContext context, _AuthBusState state) {
        return _DemoCard(
          title: 'BusPublisherCubit<AuthState>',
          subtitle:
              'Publishes authentication state changes whenever login/logout emits a new state.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: state.isLoggedIn
                        ? Colors.green.withValues(alpha: 0.16)
                        : Colors.grey.withValues(alpha: 0.16),
                    foregroundColor: state.isLoggedIn
                        ? Colors.green.shade700
                        : Colors.grey,
                    child: Icon(
                      state.isLoggedIn ? Icons.verified_user : Icons.person_off,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      state.isLoggedIn
                          ? 'Logged in as ${state.userName}'
                          : 'No active user session',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: <Widget>[
                  FilledButton(
                    onPressed: () =>
                        context.read<_AuthBusCubit>().loginDemoUser(),
                    child: const Text('Emit Login State'),
                  ),
                  OutlinedButton(
                    onPressed: () => context.read<_AuthBusCubit>().logout(),
                    child: const Text('Emit Logout State'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CartBridgeCard extends StatelessWidget {
  const _CartBridgeCard();

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn = context.select<_AuthBusCubit, bool>(
      (_AuthBusCubit cubit) => cubit.state.isLoggedIn,
    );

    return BlocBuilder<_CartBridgeCubit, _CartBusState>(
      builder: (BuildContext context, _CartBusState state) {
        return _DemoCard(
          title: 'BusBridgeCubit<CartState>',
          subtitle:
              'Publishes cart state and also observes auth events to clear itself on logout.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Owner: ${state.ownerLabel}\n'
                'Items: ${state.items.isEmpty ? 'none' : state.items.join(', ')}',
              ),
              const SizedBox(height: 12),
              Text(
                state.lastReason,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: <Widget>[
                  FilledButton.tonal(
                    onPressed: isLoggedIn
                        ? () => context.read<_CartBridgeCubit>().addRandomItem()
                        : null,
                    child: const Text('Add Item'),
                  ),
                  OutlinedButton(
                    onPressed: () => context.read<_CartBridgeCubit>().clear(),
                    child: const Text('Clear Manually'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EventAuditCard extends StatelessWidget {
  const _EventAuditCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<_EventAuditCubit, List<String>>(
      builder: (BuildContext context, List<String> logs) {
        return _DemoCard(
          title: 'BusObserverCubit<List<String>>',
          subtitle:
              'Observes every event bus emission and converts it into a UI-friendly audit trail.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (logs.isEmpty)
                const Text('No observed bus events yet.')
              else
                ...logs
                    .take(6)
                    .map(
                      (String line) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(line),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}

class _PulsePublisherCard extends StatelessWidget {
  const _PulsePublisherCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<_PulsePublisherBloc, _PulseBusState>(
      builder: (BuildContext context, _PulseBusState state) {
        final Color accent = state.value >= 0
            ? Colors.indigo
            : Colors.deepOrange;
        return _DemoCard(
          title: 'BusPublisherBloc<PulseEvent, PulseState>',
          subtitle:
              'Publishes state emitted by a standard Bloc that still uses events to change state.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Pulse value: ${state.value}',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 6),
                    Text(state.label),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: <Widget>[
                  FilledButton(
                    onPressed: () => context.read<_PulsePublisherBloc>().add(
                      const _PulseIncrementPressed(),
                    ),
                    child: const Text('Emit +1'),
                  ),
                  OutlinedButton(
                    onPressed: () => context.read<_PulsePublisherBloc>().add(
                      const _PulseDecrementPressed(),
                    ),
                    child: const Text('Emit -1'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PulseAuditCard extends StatelessWidget {
  const _PulseAuditCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<_PulseAuditObserverBloc, List<String>>(
      builder: (BuildContext context, List<String> lines) {
        return _DemoCard(
          title: 'BusObserverBloc<AuditEvent, List<String>>',
          subtitle:
              'Receives pulse events from the bus inside `observe(...)`, then dispatches internal Bloc events to update state.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (lines.isEmpty)
                const Text('No pulse events observed yet.')
              else
                ...lines
                    .take(6)
                    .map(
                      (String line) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(line),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}

class _BusStatusBridgeCard extends StatelessWidget {
  const _BusStatusBridgeCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<_BusStatusBridgeBloc, _BusStatusState>(
      builder: (BuildContext context, _BusStatusState state) {
        return _DemoCard(
          title: 'BusBridgeBloc<BridgeEvent, BridgeState>',
          subtitle:
              'Aggregates events from multiple publishers and emits its own summary state back onto the bus.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _MetricRow(label: 'Pulse events', value: '${state.pulseEvents}'),
              const SizedBox(height: 8),
              _MetricRow(
                label: 'Forced cart clears',
                value: '${state.logoutClears}',
              ),
              const SizedBox(height: 8),
              _MetricRow(
                label: 'Manual notices',
                value: '${state.manualNotices}',
              ),
              const SizedBox(height: 12),
              Text(state.summary),
            ],
          ),
        );
      },
    );
  }
}

class _CodeSampleCard extends StatelessWidget {
  const _CodeSampleCard();

  @override
  Widget build(BuildContext context) {
    return const _SectionCard(
      title: 'Core API Shape',
      subtitle:
          'These snippets match the installed package API in this project.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _SnippetBlock(
            code:
                'class AuthState implements Event {\n'
                '  const AuthState({this.userName});\n'
                '  final String? userName;\n'
                '\n'
                '  @override\n'
                '  AuthState copyWith({String? userName}) {\n'
                '    return AuthState(userName: userName ?? this.userName);\n'
                '  }\n'
                '}',
          ),
          SizedBox(height: 12),
          _SnippetBlock(
            code:
                'class AuthCubit extends BusPublisherCubit<AuthState> {\n'
                '  AuthCubit() : super(const AuthState());\n'
                '\n'
                '  void login(String name) => emit(AuthState(userName: name));\n'
                '  void logout() => emit(const AuthState());\n'
                '}',
          ),
          SizedBox(height: 12),
          _SnippetBlock(
            code:
                'class AuditCubit extends BusObserverCubit<List<String>> {\n'
                '  AuditCubit() : super(const <String>[]);\n'
                '\n'
                '  @override\n'
                '  void observe(Object event) {\n'
                "    if (event is AuthState) emit(<String>['auth changed', ...state]);\n"
                '  }\n'
                '}',
          ),
          SizedBox(height: 12),
          _SnippetBlock(
            code:
                'eventBus.send(\n'
                "  BusMessageEvent(kind: 'manual', message: 'sent directly'),\n"
                ');',
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(subtitle, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _DemoCard extends StatelessWidget {
  const _DemoCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
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
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(subtitle),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _KeywordChip extends StatelessWidget {
  const _KeywordChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      avatar: const Icon(Icons.memory_outlined, size: 18),
    );
  }
}

class _SnippetBlock extends StatelessWidget {
  const _SnippetBlock({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        code,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(fontFamily: 'monospace', height: 1.45),
      ),
    );
  }
}

class _BulletLine extends StatelessWidget {
  const _BulletLine({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 8),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Text(label)),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}

String _describeEvent(Event event) {
  return switch (event) {
    _AuthBusState() =>
      event.isLoggedIn
          ? 'Auth state for ${event.userName}'
          : 'Auth state representing logout',
    _CartBusState() => 'Cart updated with ${event.items.length} item(s)',
    _BusMessageEvent() => '${event.kind} message: ${event.message}',
    _PulseBusState() => 'Pulse state changed to ${event.value}',
    _BusStatusState() => event.summary,
    _ => 'Unhandled event type ${event.runtimeType}',
  };
}

class _AuthBusState implements Event {
  const _AuthBusState({this.userName});

  final String? userName;

  bool get isLoggedIn => userName != null;

  @override
  _AuthBusState copyWith({String? userName}) {
    return _AuthBusState(userName: userName ?? this.userName);
  }
}

class _CartBusState implements Event {
  const _CartBusState({
    this.items = const <String>[],
    this.ownerLabel = 'Guest cart',
    this.lastReason = 'Waiting for cart activity.',
  });

  final List<String> items;
  final String ownerLabel;
  final String lastReason;

  @override
  _CartBusState copyWith({
    List<String>? items,
    String? ownerLabel,
    String? lastReason,
  }) {
    return _CartBusState(
      items: items ?? this.items,
      ownerLabel: ownerLabel ?? this.ownerLabel,
      lastReason: lastReason ?? this.lastReason,
    );
  }
}

class _BusMessageEvent implements Event {
  const _BusMessageEvent({
    required this.kind,
    required this.message,
    required this.createdAt,
  });

  final String kind;
  final String message;
  final DateTime createdAt;

  @override
  _BusMessageEvent copyWith({
    String? kind,
    String? message,
    DateTime? createdAt,
  }) {
    return _BusMessageEvent(
      kind: kind ?? this.kind,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class _PulseBusState implements Event {
  const _PulseBusState({required this.value, required this.label});

  final int value;
  final String label;

  @override
  _PulseBusState copyWith({int? value, String? label}) {
    return _PulseBusState(
      value: value ?? this.value,
      label: label ?? this.label,
    );
  }
}

class _BusStatusState implements Event {
  const _BusStatusState({
    this.pulseEvents = 0,
    this.logoutClears = 0,
    this.manualNotices = 0,
    this.summary = 'Waiting for bus traffic.',
  });

  final int pulseEvents;
  final int logoutClears;
  final int manualNotices;
  final String summary;

  @override
  _BusStatusState copyWith({
    int? pulseEvents,
    int? logoutClears,
    int? manualNotices,
    String? summary,
  }) {
    return _BusStatusState(
      pulseEvents: pulseEvents ?? this.pulseEvents,
      logoutClears: logoutClears ?? this.logoutClears,
      manualNotices: manualNotices ?? this.manualNotices,
      summary: summary ?? this.summary,
    );
  }
}

class _AuthBusCubit extends BusPublisherCubit<_AuthBusState> {
  _AuthBusCubit() : super(const _AuthBusState());

  static const List<String> _demoUsers = <String>[
    'Avery',
    'Blair',
    'Casey',
    'Devon',
  ];

  int _nextUserIndex = 0;

  void loginDemoUser() {
    final String nextUser = _demoUsers[_nextUserIndex % _demoUsers.length];
    _nextUserIndex += 1;
    emit(_AuthBusState(userName: nextUser));
  }

  void logout() => emit(const _AuthBusState());
}

class _CartBridgeCubit extends BusBridgeCubit<_CartBusState> {
  _CartBridgeCubit() : super(const _CartBusState());

  int _nextItem = 1;

  void addRandomItem() {
    emit(
      state.copyWith(
        items: <String>[...state.items, 'Widget $_nextItem'],
        lastReason: 'Added Widget $_nextItem from the bridge cubit.',
      ),
    );
    _nextItem += 1;
  }

  void clear() {
    emit(
      state.copyWith(
        items: const <String>[],
        lastReason: 'Cart cleared manually from the page controls.',
      ),
    );
  }

  @override
  void observe(Object event) {
    if (event is _AuthBusState) {
      if (event.isLoggedIn) {
        emit(
          state.copyWith(
            ownerLabel: '${event.userName} cart',
            lastReason:
                'Observed login event and rebound the cart to ${event.userName}.',
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          items: const <String>[],
          ownerLabel: 'Guest cart',
          lastReason:
              'Observed logout event and emptied the cart automatically.',
        ),
      );
    }
  }
}

class _EventAuditCubit extends BusObserverCubit<List<String>> {
  _EventAuditCubit() : super(const <String>[]);

  @override
  void observe(Object event) {
    if (event is! Event || event is InitialEvent) {
      return;
    }

    final String timestamp = _formatTimestamp(DateTime.now());
    final String summary = switch (event) {
      _AuthBusState() =>
        event.isLoggedIn ? 'auth login for ${event.userName}' : 'auth logout',
      _CartBusState() => 'cart update (${event.items.length} item(s))',
      _PulseBusState() => 'pulse update ${event.value}',
      _BusMessageEvent() => '${event.kind} "${event.message}"',
      _BusStatusState() => 'bridge summary updated',
      _ => event.runtimeType.toString(),
    };

    emit(<String>['$timestamp  $summary', ...state].take(12).toList());
  }
}

abstract class _PulseBlocEvent {
  const _PulseBlocEvent();
}

class _PulseIncrementPressed extends _PulseBlocEvent {
  const _PulseIncrementPressed();
}

class _PulseDecrementPressed extends _PulseBlocEvent {
  const _PulseDecrementPressed();
}

class _PulseResetPressed extends _PulseBlocEvent {
  const _PulseResetPressed();
}

class _PulsePublisherBloc
    extends BusPublisherBloc<_PulseBlocEvent, _PulseBusState> {
  _PulsePublisherBloc()
    : super(
        const _PulseBusState(value: 0, label: 'Waiting for pulse events.'),
      ) {
    on<_PulseIncrementPressed>(_onIncrementPressed);
    on<_PulseDecrementPressed>(_onDecrementPressed);
    on<_PulseResetPressed>(_onResetPressed);
  }

  void _onIncrementPressed(
    _PulseIncrementPressed event,
    Emitter<_PulseBusState> emit,
  ) {
    emit(
      _PulseBusState(
        value: state.value + 1,
        label: 'Increment event emitted from a publisher Bloc.',
      ),
    );
  }

  void _onDecrementPressed(
    _PulseDecrementPressed event,
    Emitter<_PulseBusState> emit,
  ) {
    emit(
      _PulseBusState(
        value: state.value - 1,
        label: 'Decrement event emitted from a publisher Bloc.',
      ),
    );
  }

  void _onResetPressed(_PulseResetPressed event, Emitter<_PulseBusState> emit) {
    emit(
      const _PulseBusState(
        value: 0,
        label: 'Reset event emitted from a publisher Bloc.',
      ),
    );
  }
}

abstract class _PulseAuditEvent {
  const _PulseAuditEvent();
}

class _PulseAuditEntryAdded extends _PulseAuditEvent {
  const _PulseAuditEntryAdded(this.message);

  final String message;
}

class _PulseAuditObserverBloc
    extends BusObserverBloc<_PulseAuditEvent, List<String>> {
  _PulseAuditObserverBloc() : super(const <String>[]) {
    on<_PulseAuditEntryAdded>(_onEntryAdded);
  }

  void _onEntryAdded(_PulseAuditEntryAdded event, Emitter<List<String>> emit) {
    emit(<String>[event.message, ...state].take(12).toList());
  }

  @override
  void observe(Object event) {
    if (event is _PulseBusState) {
      add(
        _PulseAuditEntryAdded(
          '${_formatTimestamp(DateTime.now())}  pulse publisher emitted ${event.value}',
        ),
      );
    }
  }
}

abstract class _BusStatusEvent {
  const _BusStatusEvent();
}

class _BusStatusPulseCounted extends _BusStatusEvent {
  const _BusStatusPulseCounted();
}

class _BusStatusLogoutClearCounted extends _BusStatusEvent {
  const _BusStatusLogoutClearCounted();
}

class _BusStatusManualNoticeCounted extends _BusStatusEvent {
  const _BusStatusManualNoticeCounted(this.message);

  final String message;
}

class _BusStatusBridgeBloc
    extends BusBridgeBloc<_BusStatusEvent, _BusStatusState> {
  _BusStatusBridgeBloc() : super(const _BusStatusState()) {
    on<_BusStatusPulseCounted>(_onPulseCounted);
    on<_BusStatusLogoutClearCounted>(_onLogoutClearCounted);
    on<_BusStatusManualNoticeCounted>(_onManualNoticeCounted);
  }

  void _onPulseCounted(
    _BusStatusPulseCounted event,
    Emitter<_BusStatusState> emit,
  ) {
    final int nextPulseEvents = state.pulseEvents + 1;
    emit(
      state.copyWith(
        pulseEvents: nextPulseEvents,
        summary: 'Bridge saw $nextPulseEvents pulse event(s) so far.',
      ),
    );
  }

  void _onLogoutClearCounted(
    _BusStatusLogoutClearCounted event,
    Emitter<_BusStatusState> emit,
  ) {
    final int nextLogoutClears = state.logoutClears + 1;
    emit(
      state.copyWith(
        logoutClears: nextLogoutClears,
        summary:
            'Bridge observed logout-driven cart cleanup $nextLogoutClears time(s).',
      ),
    );
  }

  void _onManualNoticeCounted(
    _BusStatusManualNoticeCounted event,
    Emitter<_BusStatusState> emit,
  ) {
    final int nextManualNotices = state.manualNotices + 1;
    emit(
      state.copyWith(
        manualNotices: nextManualNotices,
        summary:
            'Bridge captured $nextManualNotices manual notice event(s); latest: ${event.message}',
      ),
    );
  }

  @override
  void observe(Object event) {
    if (event is _PulseBusState) {
      add(const _BusStatusPulseCounted());
      return;
    }

    if (event is _AuthBusState && !event.isLoggedIn) {
      add(const _BusStatusLogoutClearCounted());
      return;
    }

    if (event is _BusMessageEvent) {
      add(_BusStatusManualNoticeCounted(event.message));
    }
  }
}

String _formatTimestamp(DateTime value) {
  final String hour = value.hour.toString().padLeft(2, '0');
  final String minute = value.minute.toString().padLeft(2, '0');
  final String second = value.second.toString().padLeft(2, '0');
  return '$hour:$minute:$second';
}
