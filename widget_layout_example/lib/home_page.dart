import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Widget Layout Modules')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () => context.go('/center-box'),
                    child: const Text('Center Box Module'),
                  ),

                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/constrained-box'),
                    child: const Text('Constrained Box Module'),
                  ),

                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/row-expand-page'),
                    child: const Text('Row Expanded Module'),
                  ),

                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/gesturedector-page'),
                    child: const Text('gesturedector Module'),
                  ),

                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/column-page'),
                    child: const Text('Column Module'),
                  ),

                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/column-saved-page'),
                    child: const Text('Column Saved Module'),
                  ),

                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/padding-page'),
                    child: const Text('Padding Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/table-page'),
                    child: const Text('Table Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/intl-page'),
                    child: const Text('Intl Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/text-rich-page'),
                    child: const Text('Text.rich Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.go('/single-child-scroll-view-page'),
                    child: const Text('SingleChildScrollView Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/scrollbar-page'),
                    child: const Text('Scrollbar Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/filled-button-page'),
                    child: const Text('FilledButton Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/decorated-box-page'),
                    child: const Text('DecoratedBox Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/semantics-page'),
                    child: const Text('Semantics Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/exclude-semantics-page'),
                    child: const Text('ExcludeSemantics Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/merge-semantics-page'),
                    child: const Text('MergeSemantics Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/shared-preferences-page'),
                    child: const Text('shared_preferences Module'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
