import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:widget_layout_example2/app_navigation.dart';

const List<_DeviceProfile> _deviceProfiles = <_DeviceProfile>[
  _DeviceProfile(
    label: 'Compact',
    size: Size(320, 568),
    accentColor: Color(0xFF2563EB),
  ),
  _DeviceProfile(
    label: 'Phone',
    size: Size(390, 844),
    accentColor: Color(0xFF0F766E),
  ),
  _DeviceProfile(
    label: 'Tablet',
    size: Size(768, 1024),
    accentColor: Color(0xFF7C3AED),
  ),
];

@RoutePage(name: RouteName.flutterScreenutil)
class FlutterScreenutilPage extends StatefulWidget {
  const FlutterScreenutilPage({super.key});

  @override
  State<FlutterScreenutilPage> createState() => _FlutterScreenutilPageState();
}

class _FlutterScreenutilPageState extends State<FlutterScreenutilPage> {
  _DeviceProfile _selectedProfile = _deviceProfiles[1];
  bool _landscape = false;

  Size get _simulatedSize {
    return _landscape
        ? Size(_selectedProfile.size.height, _selectedProfile.size.width)
        : _selectedProfile.size;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('flutter_screenutil Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'flutter_screenutil scales spacing, sizes, radius, and typography from a design draft so the same UI stays proportionate across different screen sizes.',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This page demonstrates the recommended `ScreenUtil` widget, '
              '`context.w/h/sp/r/i`, the static `ScreenUtil.*` helpers, '
              'different `ScreenUtilOptions`, and the experimental singleton '
              'syntax behind `18.w` and `16.sp`.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            const _ScreenutilCodeCard(
              title: 'Recommended setup',
              code: '''
ScreenUtil(
  options: const ScreenUtilOptions(
    designSize: Size(360, 800),
  ),
  child: MaterialApp(...),
)
''',
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Simulated Device Controls',
              description:
                  'This package scales from the current screen size, so the '
                  'demo uses a simulated MediaQuery to preview compact phone, '
                  'regular phone, tablet, and landscape values without '
                  'changing the whole app.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _deviceProfiles
                        .map((_DeviceProfile profile) {
                          final bool selected = profile == _selectedProfile;
                          return ChoiceChip(
                            label: Text(profile.label),
                            selected: selected,
                            onSelected: (bool value) {
                              if (!value) {
                                return;
                              }
                              setState(() {
                                _selectedProfile = profile;
                              });
                            },
                          );
                        })
                        .toList(growable: false),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Landscape preview'),
                    subtitle: const Text(
                      'Useful with `flipSizeWhenLandscape` or wide layouts.',
                    ),
                    value: _landscape,
                    onChanged: (bool value) {
                      setState(() {
                        _landscape = value;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Simulated size: '
                    '${_simulatedSize.width.toStringAsFixed(0)} x '
                    '${_simulatedSize.height.toStringAsFixed(0)}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'ScreenUtil + BuildContext Extensions',
              description:
                  'This is the recommended v6 pattern. The preview uses '
                  '`context.w`, `context.h`, `context.sp`, `context.r`, and '
                  '`context.i` inside a local ScreenUtil zone.',
              child: _PreviewShell(
                profile: _selectedProfile,
                simulatedSize: _simulatedSize,
                child: ScreenUtil(
                  options: const ScreenUtilOptions(designSize: Size(360, 800)),
                  child: const _ContextExtensionsPreview(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Static ScreenUtil Helpers',
              description:
                  'If extension methods are not a good fit, you can call '
                  '`ScreenUtil.w(context, ...)`, `ScreenUtil.h(...)`, and '
                  '`ScreenUtil.sp(...)` directly.',
              child: _PreviewShell(
                profile: _selectedProfile,
                simulatedSize: _simulatedSize,
                child: ScreenUtil(
                  options: const ScreenUtilOptions(
                    designSize: Size(360, 800),
                    fontScaleStrategy: ScreenUtilScaleStrategy.both,
                  ),
                  child: const _StaticHelpersPreview(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Comparing ScreenUtilOptions',
              description:
                  'Different design baselines and scale strategies can produce '
                  'very different typography and spacing. Compare a phone '
                  'design draft to a tablet-oriented one.',
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: <Widget>[
                  SizedBox(
                    width: 280,
                    child: _PreviewShell(
                      profile: _selectedProfile,
                      simulatedSize: _simulatedSize,
                      child: ScreenUtil(
                        options: const ScreenUtilOptions(
                          designSize: Size(360, 800),
                        ),
                        child: const _OptionsComparisonPreview(
                          title: 'Phone design draft',
                          caption: 'designSize: 360 x 800',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 280,
                    child: _PreviewShell(
                      profile: _selectedProfile,
                      simulatedSize: _simulatedSize,
                      child: ScreenUtil(
                        options: const ScreenUtilOptions(
                          designSize: Size(768, 1024),
                          fontScaleStrategy: ScreenUtilScaleStrategy.both,
                          paddingScaleStrategy: ScreenUtilScaleStrategy.both,
                          flipSizeWhenLandscape: true,
                        ),
                        child: const _OptionsComparisonPreview(
                          title: 'Tablet-oriented draft',
                          caption: 'designSize: 768 x 1024 + both strategies',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _ExampleCard(
              title: 'Experimental Singleton Extensions',
              description:
                  'The familiar `18.w`, `16.sp`, and `12.r` syntax still works '
                  'through `ScreenUtilSingleton`, but the package README marks '
                  'this approach as experimental. This section keeps that API '
                  'isolated to its own demo.',
              child: _PreviewShell(
                profile: _selectedProfile,
                simulatedSize: _simulatedSize,
                child: ScreenUtilSingleton(
                  options: const ScreenUtilOptions(designSize: Size(360, 800)),
                  child: const _SingletonPreview(),
                ),
              ),
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

class _DeviceProfile {
  const _DeviceProfile({
    required this.label,
    required this.size,
    required this.accentColor,
  });

  final String label;
  final Size size;
  final Color accentColor;
}

class _PreviewShell extends StatelessWidget {
  const _PreviewShell({
    required this.profile,
    required this.simulatedSize,
    required this.child,
  });

  final _DeviceProfile profile;
  final Size simulatedSize;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData data = MediaQuery.of(context);
    final double aspectRatio = simulatedSize.width / simulatedSize.height;
    final double frameWidth = aspectRatio > 1 ? 360 : 250;

    return Container(
      width: frameWidth,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: <Widget>[
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: profile.accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${profile.label}  '
                  '${simulatedSize.width.toStringAsFixed(0)} x '
                  '${simulatedSize.height.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          AspectRatio(
            aspectRatio: aspectRatio,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: MediaQuery(
                data: data.copyWith(
                  size: simulatedSize,
                  padding: EdgeInsets.zero,
                  viewPadding: EdgeInsets.zero,
                  viewInsets: EdgeInsets.zero,
                ),
                child: Material(color: const Color(0xFFF8FAFC), child: child),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContextExtensionsPreview extends StatelessWidget {
  const _ContextExtensionsPreview();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compactHeight = constraints.maxHeight < 470;
        final bool compactWidth = constraints.maxWidth < 210;
        final double verticalGap = compactHeight ? context.h(8) : context.h(14);
        final String helperText = compactHeight
            ? 'Recommended for local, context-aware scaling.'
            : 'Recommended when your widget tree already has access to '
                  'BuildContext and you want the package to rebuild only the '
                  'dependent subtree.';

        return SingleChildScrollView(
          padding: EdgeInsets.all(context.i(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(
                  compactHeight ? context.i(12) : context.i(14),
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: <Color>[Color(0xFF1D4ED8), Color(0xFF0F766E)],
                  ),
                  borderRadius: BorderRadius.circular(context.r(20)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'context.* API',
                      style: TextStyle(
                        fontSize: compactHeight
                            ? context.sp(17)
                            : context.sp(19),
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: compactHeight ? context.h(6) : context.h(8),
                    ),
                    Text(
                      'Padding, radius, text, and block height all come from ScreenUtil scale values.',
                      style: TextStyle(
                        fontSize: compactHeight
                            ? context.sp(11)
                            : context.sp(12),
                        color: Colors.white.withValues(alpha: 0.92),
                        height: 1.35,
                      ),
                    ),
                    SizedBox(height: verticalGap),
                    compactWidth
                        ? Column(
                            children: <Widget>[
                              _MetricTile(
                                label: 'Hero height',
                                value: context.h(120).toStringAsFixed(0),
                              ),
                              SizedBox(height: context.h(8)),
                              _MetricTile(
                                label: 'Radius',
                                value: context.r(20).toStringAsFixed(1),
                              ),
                            ],
                          )
                        : Row(
                            children: <Widget>[
                              Expanded(
                                child: _MetricTile(
                                  label: 'Hero height',
                                  value: context.h(120).toStringAsFixed(0),
                                ),
                              ),
                              SizedBox(width: context.w(10)),
                              Expanded(
                                child: _MetricTile(
                                  label: 'Radius',
                                  value: context.r(20).toStringAsFixed(1),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
              SizedBox(height: verticalGap),
              Wrap(
                spacing: context.w(8),
                runSpacing: compactHeight ? context.h(6) : context.h(8),
                children: <Widget>[
                  _TokenChip(label: '16.i padding'),
                  _TokenChip(label: '19.sp title'),
                  _TokenChip(label: '20.r corners'),
                  _TokenChip(label: '120.h hero'),
                ],
              ),
              SizedBox(height: compactHeight ? context.h(8) : context.h(12)),
              Text(
                helperText,
                style: TextStyle(
                  fontSize: compactHeight ? context.sp(11) : context.sp(12),
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StaticHelpersPreview extends StatelessWidget {
  const _StaticHelpersPreview();

  @override
  Widget build(BuildContext context) {
    final double panelWidth = ScreenUtil.w(context, 132);
    final double panelHeight = ScreenUtil.h(context, 92);
    final double radius = ScreenUtil.r(context, 18);
    final double titleSize = ScreenUtil.sp(context, 18);

    return Padding(
      padding: EdgeInsets.all(ScreenUtil.i(context, 16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Static helper calls',
            style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: ScreenUtil.h(context, 10)),
          Text(
            'These values are computed with ScreenUtil.w/h/sp/r/i instead of extension methods.',
            style: TextStyle(fontSize: ScreenUtil.sp(context, 12)),
          ),
          SizedBox(height: ScreenUtil.h(context, 14)),
          Wrap(
            spacing: ScreenUtil.w(context, 10),
            runSpacing: ScreenUtil.h(context, 10),
            children: <Widget>[
              _StaticValueCard(
                title: 'Width',
                value: panelWidth.toStringAsFixed(0),
                color: const Color(0xFF2563EB),
                width: panelWidth,
                height: panelHeight,
                radius: radius,
              ),
              _StaticValueCard(
                title: 'Font',
                value: titleSize.toStringAsFixed(1),
                color: const Color(0xFFEA580C),
                width: panelWidth,
                height: panelHeight,
                radius: radius,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OptionsComparisonPreview extends StatelessWidget {
  const _OptionsComparisonPreview({required this.title, required this.caption});

  final String title;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.i(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: context.sp(18),
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: context.h(6)),
          Text(caption, style: TextStyle(fontSize: context.sp(11))),
          SizedBox(height: context.h(12)),
          Container(
            width: context.w(170),
            height: context.h(88),
            padding: EdgeInsets.all(context.i(12)),
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(context.r(18)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Button block',
                  style: TextStyle(
                    fontSize: context.sp(15),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: context.h(8)),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF1D4ED8),
                            borderRadius: BorderRadius.circular(context.r(12)),
                          ),
                        ),
                      ),
                      SizedBox(width: context.w(8)),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F766E),
                            borderRadius: BorderRadius.circular(context.r(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SingletonPreview extends StatelessWidget {
  const _SingletonPreview();

  @override
  Widget build(BuildContext context) {
    context.su();

    return Padding(
      padding: EdgeInsets.all(16.i),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Singleton numeric syntax',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 8.h),
          Text(
            'This preview uses `18.sp`, `16.i`, `14.r`, `120.w`, and `64.h`.',
            style: TextStyle(fontSize: 12.sp),
          ),
          SizedBox(height: 14.h),
          Row(
            children: <Widget>[
              Container(
                width: 120.w,
                height: 64.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Container(
                  height: 64.h,
                  padding: EdgeInsets.all(12.i),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDE68A),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Text(
                    'Readable shorthand, but experimental in v6.',
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.i(10)),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(context.r(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              fontSize: context.sp(11),
              color: Colors.white.withValues(alpha: 0.88),
            ),
          ),
          SizedBox(height: context.h(4)),
          Text(
            value,
            style: TextStyle(
              fontSize: context.sp(18),
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _TokenChip extends StatelessWidget {
  const _TokenChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(10),
        vertical: context.h(6),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(context.r(999)),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: context.sp(11), fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _StaticValueCard extends StatelessWidget {
  const _StaticValueCard({
    required this.title,
    required this.value,
    required this.color,
    required this.width,
    required this.height,
    required this.radius,
  });

  final String title;
  final String value;
  final Color color;
  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(ScreenUtil.i(context, 12)),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: ScreenUtil.sp(context, 13),
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: ScreenUtil.sp(context, 20),
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
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

class _ScreenutilCodeCard extends StatelessWidget {
  const _ScreenutilCodeCard({required this.title, required this.code});

  final String title;
  final String code;

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
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                code,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'monospace',
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
