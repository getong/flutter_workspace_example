import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/material.dart';

import '../story_catalog.dart';
import '../widgets/demo_scaffold.dart';

class StoryDetailPage extends StatelessWidget {
  const StoryDetailPage({required this.story, super.key});

  final StorySpec story;

  @override
  Widget build(BuildContext context) {
    return DemoPageScaffold(
      title: story.title,
      subtitle: '${story.subtitle} Dynamic route: /stories/${story.slug}',
      accent: story.color,
      children: <Widget>[
        DemoSection(
          title: 'Pattern summary',
          description:
              'Each story page comes from the same `go_router` route '
              'and swaps in a different preview based on the slug.',
          child: SideBySide(
            gaps: const <double>[12, 12],
            minEndChildWidth: 120,
            children: <Widget>[
              Box(
                color: story.color.withValues(alpha: 0.14),
                padding: const Pad(all: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(story.icon, color: story.color),
                    const SizedBox(width: 12),
                    Text(
                      story.title,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              Box(
                color: const Color(0xFFF8FAFC),
                padding: const Pad(all: 16),
                child: Text(story.subtitle),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  story.slug,
                  style: TextStyle(
                    color: story.color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Preview',
          description:
              'This section switches layout composition based on the '
              'dynamic slug.',
          child: _buildStoryPreview(),
        ),
      ],
    );
  }

  Widget _buildStoryPreview() {
    switch (story.slug) {
      case 'release-dashboard':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RowSuper(
              innerDistance: 12,
              fill: true,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _kpi('Builds', '26'),
                _kpi('Failures', '2'),
                _kpi('Approvals', '9'),
              ],
            ),
            const SizedBox(height: 16),
            Box(
              color: const Color(0xFFF0FDFA),
              padding: const Pad(all: 16),
              child: SideBySide(
                gaps: const <double>[12, 12],
                minEndChildWidth: 120,
                children: const <Widget>[
                  Text(
                    'Release 7.4 candidate',
                    textWidthBasis: TextWidthBasis.longestLine,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'Staging passed',
                    textWidthBasis: TextWidthBasis.longestLine,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Ship tomorrow',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      case 'message-composer':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const FitHorizontally(
              shrinkLimit: 0.55,
              alignment: Alignment.centerLeft,
              child: Text(
                'A very long subject line that still behaves in a narrow composer',
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.fade,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 16),
            WrapSuper(
              wrapType: WrapType.balanced,
              wrapFit: WrapFit.larger,
              spacing: 10,
              lineSpacing: 10,
              children: <Widget>[
                _tag('Customer update'),
                _tag('Needs approval'),
                _tag('High priority'),
                _tag('Email'),
              ],
            ),
          ],
        );
      case 'delivery-timeline':
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: ColumnSuper(
              innerDistance: -16,
              invert: true,
              children: <Widget>[
                _deliveryTile('Pickup confirmed', const Color(0xFFF3E8FF)),
                _deliveryTile('Sorting facility', const Color(0xFFE9D5FF)),
                _deliveryTile('Out for delivery', const Color(0xFFD8B4FE)),
              ],
            ),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _kpi(String label, String value) {
    return Box(
      color: const Color(0xFFF0FDFA),
      padding: const Pad(all: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

  Widget _tag(String label) {
    return Box(
      color: const Color(0xFFFFEDD5),
      padding: const Pad(horizontal: 14, vertical: 10),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  Widget _deliveryTile(String label, Color color) {
    return Box(
      color: color,
      padding: const Pad(all: 18),
      child: Row(
        children: <Widget>[
          const Icon(Icons.check_circle, color: Color(0xFF7C3AED)),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
