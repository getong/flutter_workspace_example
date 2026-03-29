import 'package:flutter/material.dart';

import 'transform_catalog.dart';

class TransformHomePage extends StatelessWidget {
  const TransformHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Transform')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: transformPages.length,
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 12);
        },
        itemBuilder: (BuildContext context, int index) {
          final TransformPageSpec page = transformPages[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: page.color.withAlpha(32),
                child: Icon(page.icon, color: page.color),
              ),
              title: Text(page.title),
              subtitle: Text('/transforms/${page.slug}'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () =>
                  Navigator.of(context).pushNamed('/transforms/${page.slug}'),
            ),
          );
        },
      ),
    );
  }
}
