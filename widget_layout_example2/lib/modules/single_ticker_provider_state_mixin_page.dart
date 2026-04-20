import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.singleTickerProviderStateMixin)
class SingleTickerProviderStateMixinPage extends StatefulWidget {
  const SingleTickerProviderStateMixinPage({super.key});

  @override
  State<SingleTickerProviderStateMixinPage> createState() =>
      _SingleTickerProviderStateMixinPageState();
}

class _SingleTickerProviderStateMixinPageState
    extends State<SingleTickerProviderStateMixinPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      lowerBound: 0.85,
      upperBound: 1.15,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SingleTickerProviderStateMixin Module'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          const SelectableText(
            'SingleTickerProviderStateMixin provides a `vsync` for one AnimationController, which keeps animations efficient by ticking only when needed.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Pulse With One Controller',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const SelectableText(
                    'This page focuses on the mixin itself: one controller, one ticker, and a repeating pulse animation.',
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ScaleTransition(
                      scale: _controller,
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEF5350),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'vsync',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SelectableText(
                    'Use this mixin when one State object manages a single ticker-based animation.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.replacePath('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}
