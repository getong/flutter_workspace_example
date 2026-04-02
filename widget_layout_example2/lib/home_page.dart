import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

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
                    onPressed: () => context.router.pushPath('/center-box'),
                    child: const Text('Center Box Module'),
                  ),

                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.router.pushPath('/constrained-box'),
                    child: const Text('Constrained Box Module'),
                  ),

                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.router.pushPath('/row-expand-page'),
                    child: const Text('Row Expanded Module'),
                  ),

                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.router.pushPath('/gesturedector-page'),
                    child: const Text('gesturedector Module'),
                  ),

                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.router.pushPath('/column-page'),
                    child: const Text('Column Module'),
                  ),

                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.router.pushPath('/column-saved-page'),
                    child: const Text('Column Saved Module'),
                  ),

                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.router.pushPath('/padding-page'),
                    child: const Text('Padding Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.router.pushPath('/positioned-page'),
                    child: const Text('Positioned Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.router.pushPath('/align-page'),
                    child: const Text('Align Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.router.pushPath('/table-page'),
                    child: const Text('Table Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.router.pushPath('/intl-page'),
                    child: const Text('Intl Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.router.pushPath('/media-query-page'),
                    child: const Text('MediaQuery Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.router.pushPath('/text-rich-page'),
                    child: const Text('Text.rich Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.router.pushPath(
                      '/single-child-scroll-view-page',
                    ),
                    child: const Text('SingleChildScrollView Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.router.pushPath('/sliver-widgets-page'),
                    child: const Text(
                      'SliverToBoxAdapter + SliverList + SliverPadding + SliverFillRemaining Module',
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.router.pushPath('/scrollbar-page'),
                    child: const Text('Scrollbar Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.router.pushPath('/filled-button-page'),
                    child: const Text('FilledButton Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.router.pushPath('/decorated-box-page'),
                    child: const Text('DecoratedBox Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.router.pushPath('/semantics-page'),
                    child: const Text('Semantics Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.router.pushPath('/exclude-semantics-page'),
                    child: const Text('ExcludeSemantics Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.router.pushPath('/merge-semantics-page'),
                    child: const Text('MergeSemantics Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.router.pushPath('/shared-preferences-page'),
                    child: const Text('shared_preferences Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.router.pushPath('/text-field-controller-page'),
                    child: const Text(
                      'TextField + TextEditingController Module',
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.router.pushPath('/data-table-page'),
                    child: const Text('DataTable + PaginatedDataTable Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.router.pushPath('/fl-chart-page'),
                    child: const Text('fl_chart Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.router.pushPath('/animated-switcher-page'),
                    child: const Text('AnimatedSwitcher Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.router.pushPath(
                      '/animated-default-text-style-page',
                    ),
                    child: const Text('AnimatedDefaultTextStyle Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.router.pushPath('/custom-paint-page'),
                    child: const Text('CustomPaint Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.router.pushPath(
                      '/tween-animation-builder-page',
                    ),
                    child: const Text('TweenAnimationBuilder Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.router.pushPath('/animation-controller-page'),
                    child: const Text('AnimationController Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.router.pushPath(
                      '/single-ticker-provider-state-mixin-page',
                    ),
                    child: const Text('SingleTickerProviderStateMixin Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.router.pushPath('/tween-page'),
                    child: const Text('Tween Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.router.pushPath(
                      '/tween-sequence-interval-page',
                    ),
                    child: const Text('TweenSequence + Interval Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.router.pushPath('/font-awesome-flutter-page'),
                    child: const Text('font_awesome_flutter Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.router.pushPath('/flutter-svg-page'),
                    child: const Text('flutter_svg Module'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.router.pushPath('/image-widget-page'),
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
