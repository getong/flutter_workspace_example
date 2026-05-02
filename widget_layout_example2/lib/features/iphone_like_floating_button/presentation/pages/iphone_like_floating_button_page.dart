import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.iPhoneLikeFloatingButton)
class IPhoneLikeFloatingButtonPage extends StatefulWidget {
  const IPhoneLikeFloatingButtonPage({super.key});

  @override
  State<IPhoneLikeFloatingButtonPage> createState() =>
      _IPhoneLikeFloatingButtonPageState();
}

class _IPhoneLikeFloatingButtonPageState
    extends State<IPhoneLikeFloatingButtonPage> {
  static const Color _iosPink = Color(0xFFFF2D55);
  int _composeCount = 1;
  bool _expanded = false;
  bool _muted = false;
  bool _favorite = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('iPhone-like Floating Button Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const Text(
              'This module builds a custom iPhone-like floating button with glass styling, soft shadows, rounded geometry, and compact action variants instead of using the default Material FAB appearance.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            _ExampleCard(
              title: 'Floating Compose Button',
              description:
                  'A circular glass button works well for the primary action in chat, notes, camera, or quick-create interfaces.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _PreviewCanvas(
                    child: Stack(
                      children: <Widget>[
                        const Positioned(
                          left: 20,
                          top: 20,
                          right: 20,
                          child: _PreviewHeader(
                            title: 'Messages',
                            subtitle: 'Recent conversations',
                          ),
                        ),
                        Positioned(
                          right: 20,
                          bottom: 20,
                          child: IPhoneFloatingButton(
                            icon: cupertino.CupertinoIcons.square_pencil,
                            badgeCount: _composeCount,
                            backgroundOpacity: 0.34,
                            onPressed: () {
                              setState(() {
                                _composeCount++;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Compose badge count: $_composeCount'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Expanded Capsule Action',
              description:
                  'The same widget can switch to a wider capsule shape for actions that need a label, status, and richer feedback.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _PreviewCanvas(
                    child: Stack(
                      children: <Widget>[
                        const Positioned(
                          left: 20,
                          top: 20,
                          right: 20,
                          child: _PreviewHeader(
                            title: 'Voice Notes',
                            subtitle: 'Capture and organize ideas',
                          ),
                        ),
                        Positioned(
                          left: 20,
                          right: 20,
                          bottom: 20,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: IPhoneFloatingButton(
                              icon: _muted
                                  ? cupertino.CupertinoIcons.mic_slash
                                  : cupertino.CupertinoIcons.mic_fill,
                              label: _muted ? 'Muted' : 'Record note',
                              expanded: true,
                              backgroundOpacity: 0.32,
                              accentColor: _muted
                                  ? Colors.grey.shade700
                                  : const Color(0xFF0A84FF),
                              onPressed: () {
                                setState(() {
                                  _muted = !_muted;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(_muted ? 'Mic state: muted' : 'Mic state: ready'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Floating Action Cluster',
              description:
                  'You can also use the iPhone-like button as part of a small expandable action cluster for favorites, share, and quick tools.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _PreviewCanvas(
                    child: Stack(
                      children: <Widget>[
                        const Positioned(
                          left: 20,
                          top: 20,
                          right: 20,
                          child: _PreviewHeader(
                            title: 'Photo Viewer',
                            subtitle: 'Preview overlay controls',
                          ),
                        ),
                        Positioned(
                          right: 20,
                          bottom: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 220),
                                child: _expanded
                                    ? Column(
                                        key: const ValueKey<String>('open'),
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          IPhoneFloatingButton(
                                            icon: _favorite
                                                ? cupertino
                                                      .CupertinoIcons
                                                      .heart_fill
                                                : cupertino
                                                      .CupertinoIcons
                                                      .heart,
                                            small: true,
                                            backgroundOpacity: 0.28,
                                            accentColor: _iosPink,
                                            onPressed: () {
                                              setState(() {
                                                _favorite = !_favorite;
                                              });
                                            },
                                          ),
                                          const SizedBox(height: 12),
                                          IPhoneFloatingButton(
                                            icon:
                                                cupertino.CupertinoIcons.share,
                                            small: true,
                                            backgroundOpacity: 0.28,
                                            accentColor: Colors.teal,
                                            onPressed: () {},
                                          ),
                                          const SizedBox(height: 12),
                                        ],
                                      )
                                    : const SizedBox.shrink(
                                        key: ValueKey<String>('closed'),
                                      ),
                              ),
                              IPhoneFloatingButton(
                                icon: _expanded
                                    ? cupertino.CupertinoIcons.xmark
                                    : cupertino.CupertinoIcons.ellipsis,
                                backgroundOpacity: 0.34,
                                onPressed: () {
                                  setState(() {
                                    _expanded = !_expanded;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Cluster state: ${_expanded ? 'expanded' : 'collapsed'}, favorite: ${_favorite ? 'on' : 'off'}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const _ExampleCard(
              title: 'Transparent and Draggable Overlay',
              description:
                  'This example uses a more transparent floating button and allows dragging it to any position inside the preview area.',
              child: _DraggableIPhoneFloatingPreview(),
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

class IPhoneFloatingButton extends StatefulWidget {
  const IPhoneFloatingButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.label,
    this.badgeCount,
    this.expanded = false,
    this.small = false,
    this.accentColor = const Color(0xFF111216),
    this.backgroundOpacity = 0.42,
    this.blurSigma = 18,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String? label;
  final int? badgeCount;
  final bool expanded;
  final bool small;
  final Color accentColor;
  final double backgroundOpacity;
  final double blurSigma;

  @override
  State<IPhoneFloatingButton> createState() => _IPhoneFloatingButtonState();
}

class _IPhoneFloatingButtonState extends State<IPhoneFloatingButton> {
  static const Color _iosRed = Color(0xFFFF3B30);
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final double height = widget.small ? 46 : 58;
    final double width = widget.expanded ? 176 : height;
    final BorderRadius radius = BorderRadius.circular(
      widget.expanded ? 24 : 999,
    );

    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _pressed = true;
        });
      },
      onTapCancel: () {
        setState(() {
          _pressed = false;
        });
      },
      onTapUp: (_) {
        setState(() {
          _pressed = false;
        });
        widget.onPressed();
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: _pressed ? 0.96 : 1,
        child: ClipRRect(
          borderRadius: radius,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: widget.blurSigma,
              sigmaY: widget.blurSigma,
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: width,
              height: height,
              padding: EdgeInsets.symmetric(
                horizontal: widget.expanded ? 18 : 0,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Colors.white.withValues(alpha: 0.24),
                    Colors.white.withValues(alpha: 0.08),
                  ],
                ),
                color: widget.accentColor.withValues(
                  alpha: _pressed
                      ? (widget.backgroundOpacity + 0.10).clamp(0.0, 1.0)
                      : widget.backgroundOpacity,
                ),
                borderRadius: radius,
                border: Border.all(color: Colors.white.withValues(alpha: 0.32)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 20,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(widget.icon, color: Colors.white, size: 22),
                        if (widget.expanded &&
                            widget.label != null) ...<Widget>[
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              widget.label!,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.1,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if ((widget.badgeCount ?? 0) > 0)
                    Positioned(
                      right: widget.expanded ? -8 : -2,
                      top: -8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: _iosRed,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                        child: Text(
                          '${widget.badgeCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DraggableIPhoneFloatingPreview extends StatefulWidget {
  const _DraggableIPhoneFloatingPreview();

  @override
  State<_DraggableIPhoneFloatingPreview> createState() =>
      _DraggableIPhoneFloatingPreviewState();
}

class _DraggableIPhoneFloatingPreviewState
    extends State<_DraggableIPhoneFloatingPreview> {
  Offset _offset = const Offset(210, 164);
  int _dragCount = 0;

  static const double _buttonSize = 58;

  void _updateOffset(DragUpdateDetails details, Size bounds) {
    setState(() {
      _offset = Offset(
        (_offset.dx + details.delta.dx).clamp(0.0, bounds.width - _buttonSize),
        (_offset.dy + details.delta.dy).clamp(
          70.0,
          bounds.height - _buttonSize,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 260,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final Size bounds = Size(
                constraints.maxWidth,
                constraints.maxHeight,
              );
              return _PreviewCanvas(
                child: Stack(
                  children: <Widget>[
                    const Positioned(
                      left: 20,
                      top: 20,
                      right: 20,
                      child: _PreviewHeader(
                        title: 'Floating utility',
                        subtitle: 'Drag the button anywhere in the preview',
                      ),
                    ),
                    Positioned(
                      left: _offset.dx,
                      top: _offset.dy,
                      child: GestureDetector(
                        onPanUpdate: (DragUpdateDetails details) {
                          _updateOffset(details, bounds);
                        },
                        onDoubleTap: () {
                          setState(() {
                            _dragCount++;
                          });
                        },
                        child: IPhoneFloatingButton(
                          icon: cupertino.CupertinoIcons.sparkles,
                          badgeCount: _dragCount == 0 ? null : _dragCount,
                          backgroundOpacity: 0.24,
                          blurSigma: 24,
                          accentColor: const Color(0xCC1C1C1E),
                          onPressed: () {
                            setState(() {
                              _dragCount++;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Text('Position: x=${_offset.dx.round()}, y=${_offset.dy.round()}'),
        const SizedBox(height: 4),
        Text('Tap or double tap count: $_dragCount'),
      ],
    );
  }
}

class _PreviewCanvas extends StatelessWidget {
  const _PreviewCanvas({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[Color(0xFFF3F5F8), Color(0xFFE1E6EE)],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(28), child: child),
    );
  }
}

class _PreviewHeader extends StatelessWidget {
  const _PreviewHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.black.withValues(alpha: 0.62),
          ),
        ),
      ],
    );
  }
}

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
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
          ],
        ),
      ),
    );
  }
}
