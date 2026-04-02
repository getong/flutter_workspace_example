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
                    onPressed: () => context.go('/positioned-page'),
                    child: const Text('Positioned Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/align-page'),
                    child: const Text('Align Module'),
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
                    onPressed: () => context.go('/media-query-page'),
                    child: const Text('MediaQuery Module'),
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
                    onPressed: () => context.go('/sliver-widgets-page'),
                    child: const Text(
                      'SliverToBoxAdapter + SliverList + SliverPadding + SliverFillRemaining Module',
                    ),
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
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/text-field-controller-page'),
                    child: const Text(
                      'TextField + TextEditingController Module',
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/data-table-page'),
                    child: const Text('DataTable + PaginatedDataTable Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/fl-chart-page'),
                    child: const Text('fl_chart Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/animated-switcher-page'),
                    child: const Text('AnimatedSwitcher Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.go('/animated-default-text-style-page'),
                    child: const Text('AnimatedDefaultTextStyle Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/custom-paint-page'),
                    child: const Text('CustomPaint Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.go('/tween-animation-builder-page'),
                    child: const Text('TweenAnimationBuilder Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/animation-controller-page'),
                    child: const Text('AnimationController Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.go('/single-ticker-provider-state-mixin-page'),
                    child: const Text('SingleTickerProviderStateMixin Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/tween-page'),
                    child: const Text('Tween Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.go('/tween-sequence-interval-page'),
                    child: const Text('TweenSequence + Interval Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/font-awesome-flutter-page'),
                    child: const Text('font_awesome_flutter Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/flutter-svg-page'),
                    child: const Text('flutter_svg Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/image-widget-page'),
                    child: const Text('Image Module'),
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
