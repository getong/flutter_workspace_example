import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/advice.dart';
import '../../domain/repositories/advice_repository.dart';

@RoutePage()
class AdviceHistoryTabPage extends StatelessWidget {
  const AdviceHistoryTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = context.read<AdviceRepository>();

    return StreamBuilder<List<Advice>>(
      stream: repository.watchSavedAdvice(),
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

            return Card(
              child: ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
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
