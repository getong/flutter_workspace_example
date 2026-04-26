import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/advice_bloc.dart';

class AdviceView extends StatelessWidget {
  const AdviceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Advice Generator')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: BlocBuilder<AdviceBloc, AdviceState>(
            builder: (context, state) {
              return switch (state) {
                AdviceLoading() => const CircularProgressIndicator(),
                AdviceRefreshing() => _AdviceCard(
                  adviceId: state.advice.id,
                  message: state.advice.message,
                  source: state.advice.source,
                  author: state.advice.author,
                  isRefreshing: true,
                ),
                AdviceLoaded() => _AdviceCard(
                  adviceId: state.advice.id,
                  message: state.advice.message,
                  source: state.advice.source,
                  author: state.advice.author,
                ),
                AdviceError() => _AdviceStatus(message: state.message),
                _ => const _AdviceStatus(
                  message: 'Tap the button to fetch advice from the API.',
                ),
              };
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: stateIsBusy(context)
            ? null
            : () {
                context.read<AdviceBloc>().add(const FetchAdviceEvent());
              },
        icon: _FabIcon(isBusy: stateIsBusy(context)),
        label: Text(stateIsBusy(context) ? 'Refreshing' : 'Fetch Advice'),
      ),
    );
  }

  bool stateIsBusy(BuildContext context) {
    final state = context.watch<AdviceBloc>().state;
    return state is AdviceLoading || state is AdviceRefreshing;
  }
}

class _AdviceCard extends StatelessWidget {
  final int adviceId;
  final String message;
  final String source;
  final String? author;
  final bool isRefreshing;

  const _AdviceCard({
    required this.adviceId,
    required this.message,
    required this.source,
    this.author,
    this.isRefreshing = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      alignment: Alignment.topRight,
      children: [
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Advice #$adviceId', style: theme.textTheme.labelLarge),
                const SizedBox(height: 16),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                Text(
                  author == null
                      ? 'Source: $source'
                      : 'Source: $source • $author',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        if (isRefreshing)
          const Positioned(
            top: 12,
            right: 12,
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
          ),
      ],
    );
  }
}

class _FabIcon extends StatelessWidget {
  final bool isBusy;

  const _FabIcon({required this.isBusy});

  @override
  Widget build(BuildContext context) {
    if (!isBusy) {
      return const Icon(Icons.tips_and_updates_outlined);
    }

    return const SizedBox(
      width: 18,
      height: 18,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }
}

class _AdviceStatus extends StatelessWidget {
  final String message;

  const _AdviceStatus({required this.message});

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }
}
