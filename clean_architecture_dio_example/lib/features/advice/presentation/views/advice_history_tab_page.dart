import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/advice.dart';
import '../../domain/repositories/advice_repository.dart';

@RoutePage()
class AdviceHistoryTabPage extends StatefulWidget {
  const AdviceHistoryTabPage({super.key});

  @override
  State<AdviceHistoryTabPage> createState() => _AdviceHistoryTabPageState();
}

class _AdviceHistoryTabPageState extends State<AdviceHistoryTabPage>
    with AutoRouteAwareStateMixin<AdviceHistoryTabPage> {
  late Future<List<Advice>> _savedAdviceFuture;

  @override
  void initState() {
    super.initState();
    _refreshSavedAdvice();
  }

  @override
  void didInitTabRoute(TabPageRoute? previousRoute) {
    _refreshSavedAdvice();
  }

  @override
  void didChangeTabRoute(TabPageRoute previousRoute) {
    _refreshSavedAdvice();
  }

  void _refreshSavedAdvice() {
    _savedAdviceFuture = context.read<AdviceRepository>().getSavedAdvice();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Advice>>(
      future: _savedAdviceFuture,
      builder: (context, snapshot) {
        final items = snapshot.data ?? const <Advice>[];

        if (snapshot.connectionState == ConnectionState.waiting &&
            items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (items.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Fetched advice will appear here after it is stored in Drift.',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final advice = items[index];
            final displayNumber = items.length - index;

            return Card(
              child: ListTile(
                leading: CircleAvatar(child: Text('$displayNumber')),
                title: Text(advice.message),
                subtitle: Text(
                  advice.author == null
                      ? 'Source: ${advice.source} • #${advice.id}'
                      : 'Source: ${advice.source} • ${advice.author} • #${advice.id}',
                ),
                isThreeLine: advice.author != null,
              ),
            );
          },
        );
      },
    );
  }
}
