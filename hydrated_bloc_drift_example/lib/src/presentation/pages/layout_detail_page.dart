import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/layout_item.dart';
import '../layout_catalog_bloc.dart';

class LayoutDetailPage extends StatelessWidget {
  const LayoutDetailPage({required this.slug, super.key});

  final String slug;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LayoutCatalogBloc, LayoutCatalogState>(
      builder: (BuildContext context, LayoutCatalogState state) {
        final LayoutItem? item = context.read<LayoutCatalogBloc>().findBySlug(
          slug,
        );

        if (item == null && state.status == LayoutCatalogStatus.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (item == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Layout not found')),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('No layout found for slug: $slug'),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () => context.read<LayoutCatalogBloc>().add(
                      const LayoutCatalogRefreshRequested(),
                    ),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Fetch from Dio'),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(title: Text(item.title)),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Dynamic route: /layouts/${item.slug}'),
                const SizedBox(height: 16),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _kindColor(item.kind).withAlpha(26),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _kindColor(item.kind),
                        width: 2,
                      ),
                    ),
                    child: item.kind == LayoutKind.row
                        ? _buildRowPreview(item)
                        : _buildColumnPreview(item),
                  ),
                ),
                const SizedBox(height: 12),
                Text(item.message),
              ],
            ),
          ),
          persistentFooterButtons: <Widget>[
            TextButton.icon(
              onPressed: () => context.go('/'),
              icon: const Icon(Icons.home),
              label: const Text('Back Home'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRowPreview(LayoutItem item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        _tile(Colors.red.shade400, 50),
        _tile(Colors.orange.shade400, 70),
        _tile(Colors.green.shade400, 90),
        _tile(Colors.blue.shade400, 110),
      ],
    );
  }

  Widget _buildColumnPreview(LayoutItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: Container(
            alignment: Alignment.center,
            color: Colors.teal.shade100,
            child: const Text('Top Section'),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            color: Colors.teal.shade200,
            child: const Text('Middle Section'),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            color: Colors.teal.shade300,
            child: const Text('Bottom Section'),
          ),
        ),
      ],
    );
  }

  Widget _tile(Color color, double height) {
    return Container(width: 52, height: height, color: color);
  }

  Color _kindColor(LayoutKind kind) {
    return kind == LayoutKind.row ? Colors.orange : Colors.teal;
  }
}
