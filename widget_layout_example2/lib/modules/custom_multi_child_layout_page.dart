import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class CustomMultiChildLayoutPage extends StatelessWidget {
  const CustomMultiChildLayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CustomMultiChildLayout Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'CustomMultiChildLayout lets a delegate measure and position named children with full control. It is useful when Row, Column, Stack, and Align do not express a specific layout relationship clearly enough.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            const _CustomLayoutExampleCard(
              title: 'Profile Header Delegate',
              description:
                  'This layout positions an avatar, title, subtitle, status chip, and trailing button in a deliberate header composition.',
              api:
                  'Uses: CustomMultiChildLayout + LayoutId + MultiChildLayoutDelegate',
              child: SizedBox(height: 120, child: _ProfileHeaderLayout()),
            ),
            const SizedBox(height: 16),
            const _CustomLayoutExampleCard(
              title: 'Media Controls Delegate',
              description:
                  'A playback card can place artwork, titles, a seek bar, and transport controls with pixel-level intent.',
              api: 'Uses: delegate-controlled sizing and placement',
              child: SizedBox(height: 132, child: _MediaControlsLayout()),
            ),
            const SizedBox(height: 16),
            const _CustomLayoutExampleCard(
              title: 'Boarding Pass Delegate',
              description:
                  'Named slots are helpful when different areas of a ticket or dashboard panel need exact anchors.',
              api: 'Uses: reusable slots for top, middle, and footer regions',
              child: SizedBox(height: 150, child: _BoardingPassLayout()),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.replacePath('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}

enum _ProfileHeaderSlot { avatar, title, subtitle, status, button }

class _ProfileHeaderLayout extends StatelessWidget {
  const _ProfileHeaderLayout();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.blueGrey.shade100),
      ),
      child: CustomMultiChildLayout(
        delegate: _ProfileHeaderDelegate(),
        children: <Widget>[
          LayoutId(
            id: _ProfileHeaderSlot.avatar,
            child: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.indigo,
              child: Text(
                'AL',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          LayoutId(
            id: _ProfileHeaderSlot.title,
            child: Text(
              'Alicia Lee',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          LayoutId(
            id: _ProfileHeaderSlot.subtitle,
            child: Text('Operations Manager'),
          ),
          LayoutId(
            id: _ProfileHeaderSlot.status,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                'Available',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          LayoutId(
            id: _ProfileHeaderSlot.button,
            child: Icon(Icons.more_horiz_rounded),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeaderDelegate extends MultiChildLayoutDelegate {
  @override
  void performLayout(Size size) {
    const double padding = 16;
    const double gap = 12;

    final Size avatarSize = layoutChild(
      _ProfileHeaderSlot.avatar,
      const BoxConstraints.tightFor(width: 56, height: 56),
    );
    positionChild(_ProfileHeaderSlot.avatar, const Offset(padding, 16));

    final Size buttonSize = layoutChild(
      _ProfileHeaderSlot.button,
      BoxConstraints.loose(const Size(32, 32)),
    );
    positionChild(
      _ProfileHeaderSlot.button,
      Offset(size.width - padding - buttonSize.width, 18),
    );

    final double textX = padding + avatarSize.width + gap;
    final double textWidth =
        size.width - textX - buttonSize.width - gap - padding;

    final Size titleSize = layoutChild(
      _ProfileHeaderSlot.title,
      BoxConstraints.tightFor(width: textWidth),
    );
    positionChild(_ProfileHeaderSlot.title, Offset(textX, 18));

    layoutChild(
      _ProfileHeaderSlot.subtitle,
      BoxConstraints.tightFor(width: textWidth),
    );
    positionChild(
      _ProfileHeaderSlot.subtitle,
      Offset(textX, 18 + titleSize.height + 4),
    );

    final Size statusSize = layoutChild(
      _ProfileHeaderSlot.status,
      BoxConstraints.loose(const Size(120, 32)),
    );
    positionChild(
      _ProfileHeaderSlot.status,
      Offset(textX, size.height - padding - statusSize.height),
    );
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) => false;
}

enum _MediaControlsSlot { cover, title, subtitle, slider, previous, play, next }

class _MediaControlsLayout extends StatelessWidget {
  const _MediaControlsLayout();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[Colors.purple.shade50, Colors.pink.shade50],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: CustomMultiChildLayout(
        delegate: _MediaControlsDelegate(),
        children: <Widget>[
          LayoutId(
            id: _MediaControlsSlot.cover,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: <Color>[Color(0xFF7C3AED), Color(0xFFF472B6)],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.music_note_rounded, color: Colors.white),
            ),
          ),
          LayoutId(
            id: _MediaControlsSlot.title,
            child: Text(
              'Midnight Transit',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          LayoutId(
            id: _MediaControlsSlot.subtitle,
            child: Text('Lena Carter • 03:24'),
          ),
          LayoutId(
            id: _MediaControlsSlot.slider,
            child: LinearProgressIndicator(value: 0.46, minHeight: 8),
          ),
          LayoutId(
            id: _MediaControlsSlot.previous,
            child: Icon(Icons.skip_previous_rounded),
          ),
          LayoutId(
            id: _MediaControlsSlot.play,
            child: CircleAvatar(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              child: Icon(Icons.play_arrow_rounded),
            ),
          ),
          LayoutId(
            id: _MediaControlsSlot.next,
            child: Icon(Icons.skip_next_rounded),
          ),
        ],
      ),
    );
  }
}

class _MediaControlsDelegate extends MultiChildLayoutDelegate {
  @override
  void performLayout(Size size) {
    const double padding = 16;
    const double coverSize = 56;
    const double gap = 12;

    layoutChild(
      _MediaControlsSlot.cover,
      const BoxConstraints.tightFor(width: coverSize, height: coverSize),
    );
    positionChild(_MediaControlsSlot.cover, const Offset(padding, 16));

    final double contentX = padding + coverSize + gap;
    final double contentWidth = size.width - contentX - padding;

    final Size titleSize = layoutChild(
      _MediaControlsSlot.title,
      BoxConstraints.tightFor(width: contentWidth),
    );
    positionChild(_MediaControlsSlot.title, Offset(contentX, 16));

    layoutChild(
      _MediaControlsSlot.subtitle,
      BoxConstraints.tightFor(width: contentWidth),
    );
    positionChild(
      _MediaControlsSlot.subtitle,
      Offset(contentX, 16 + titleSize.height + 4),
    );

    layoutChild(
      _MediaControlsSlot.slider,
      BoxConstraints.tightFor(width: size.width - padding * 2),
    );
    positionChild(_MediaControlsSlot.slider, const Offset(padding, 80));

    final Size previousSize = layoutChild(
      _MediaControlsSlot.previous,
      BoxConstraints.loose(const Size(24, 24)),
    );
    final Size playSize = layoutChild(
      _MediaControlsSlot.play,
      const BoxConstraints.tightFor(width: 40, height: 40),
    );
    final Size nextSize = layoutChild(
      _MediaControlsSlot.next,
      BoxConstraints.loose(const Size(24, 24)),
    );

    final double centerX = size.width / 2;
    positionChild(
      _MediaControlsSlot.play,
      Offset(centerX - playSize.width / 2, size.height - 16 - playSize.height),
    );
    positionChild(
      _MediaControlsSlot.previous,
      Offset(
        centerX - playSize.width / 2 - 40,
        size.height - 24 - previousSize.height,
      ),
    );
    positionChild(
      _MediaControlsSlot.next,
      Offset(
        centerX + playSize.width / 2 + 16,
        size.height - 24 - nextSize.height,
      ),
    );
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) => false;
}

enum _BoardingPassSlot { route, code, time, gate, barcode }

class _BoardingPassLayout extends StatelessWidget {
  const _BoardingPassLayout();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[Colors.orange.shade50, Colors.amber.shade50],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.orange.shade100),
      ),
      child: CustomMultiChildLayout(
        delegate: _BoardingPassDelegate(),
        children: <Widget>[
          LayoutId(
            id: _BoardingPassSlot.route,
            child: Text(
              'PVG  →  HND',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          LayoutId(
            id: _BoardingPassSlot.code,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                'SQ 830',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          LayoutId(id: _BoardingPassSlot.time, child: Text('Boarding 18:45')),
          LayoutId(
            id: _BoardingPassSlot.gate,
            child: Text(
              'Gate A12',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          LayoutId(
            id: _BoardingPassSlot.barcode,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List<Widget>.generate(
                18,
                (int index) => Container(
                  width: index.isEven ? 3 : 2,
                  height: 28 + (index % 3) * 6,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BoardingPassDelegate extends MultiChildLayoutDelegate {
  @override
  void performLayout(Size size) {
    const double padding = 16;

    final Size routeSize = layoutChild(
      _BoardingPassSlot.route,
      BoxConstraints.tightFor(width: size.width - 140),
    );
    positionChild(_BoardingPassSlot.route, const Offset(padding, 16));

    final Size codeSize = layoutChild(
      _BoardingPassSlot.code,
      BoxConstraints.loose(const Size(90, 32)),
    );
    positionChild(
      _BoardingPassSlot.code,
      Offset(size.width - padding - codeSize.width, 18),
    );

    layoutChild(
      _BoardingPassSlot.time,
      BoxConstraints.loose(const Size(140, 24)),
    );
    positionChild(
      _BoardingPassSlot.time,
      Offset(padding, 16 + routeSize.height + 14),
    );

    final Size gateSize = layoutChild(
      _BoardingPassSlot.gate,
      BoxConstraints.loose(const Size(100, 24)),
    );
    positionChild(
      _BoardingPassSlot.gate,
      Offset(size.width - padding - gateSize.width, 16 + routeSize.height + 14),
    );

    layoutChild(
      _BoardingPassSlot.barcode,
      BoxConstraints.tightFor(width: size.width - padding * 2, height: 50),
    );
    positionChild(_BoardingPassSlot.barcode, Offset(padding, size.height - 62));
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) => false;
}

class _CustomLayoutExampleCard extends StatelessWidget {
  const _CustomLayoutExampleCard({
    required this.title,
    required this.description,
    required this.api,
    required this.child,
  });

  final String title;
  final String description;
  final String api;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 16),
            child,
            const SizedBox(height: 12),
            Text(
              api,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.blueGrey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}
