import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.tdesignFlutter)
class TdesignFlutterPage extends StatefulWidget {
  const TdesignFlutterPage({super.key});

  @override
  State<TdesignFlutterPage> createState() => _TdesignFlutterPageState();
}

class _TdesignFlutterPageState extends State<TdesignFlutterPage> {
  static const String _assetPath = 'assets/images/image_module_demo.png';

  final TextEditingController _projectController = TextEditingController(
    text: 'Widget Layout Lab',
  );
  final TextEditingController _budgetController = TextEditingController(
    text: '1200',
  );
  final TextEditingController _noteController = TextEditingController(
    text: 'TDesign widgets are wired into the content tab with auto_route.',
  );

  bool _notificationsEnabled = true;
  bool _reviewMode = false;
  bool _showClosableTag = true;
  int _unreadCount = 12;
  String _searchQuery = '';
  String _statusMessage = 'Ready to explore TDesign Flutter widgets.';

  @override
  void dispose() {
    _projectController.dispose();
    _budgetController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('tdesign_flutter Module')),
      body: TDTheme(
        data: TDTheme.defaultData(),
        child: SelectionArea(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: <Widget>[
              const Text(
                'tdesign_flutter brings Tencent Design System components to '
                'Flutter. This page combines multiple widgets into a compact '
                'workspace-style demo instead of showing only isolated one-line '
                'samples.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              _SectionCard(
                title: 'Navigation + Search',
                description:
                    'A small header mockup built from TDNavBar and TDSearchBar.',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: DecoratedBox(
                        decoration: const BoxDecoration(color: Colors.white),
                        child: TDNavBar(
                          height: 56,
                          screenAdaptation: false,
                          useDefaultBack: false,
                          centerTitle: false,
                          titleMargin: 0,
                          titleWidget: TDSearchBar(
                            needCancel: false,
                            autoHeight: true,
                            mediumStyle: true,
                            style: TDSearchStyle.round,
                            padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                            placeHolder: 'Search widgets or demos',
                            onTextChanged: (String value) {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
                          ),
                          rightBarItems: <TDNavBarItem>[
                            TDNavBarItem(
                              icon: TDIcons.home,
                              action: () {
                                setState(() {
                                  _statusMessage =
                                      'TDNavBar home action tapped.';
                                });
                              },
                            ),
                            TDNavBarItem(
                              icon: TDIcons.ellipsis,
                              action: () {
                                setState(() {
                                  _statusMessage =
                                      'TDNavBar overflow action tapped.';
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _searchQuery.isEmpty
                          ? 'The search bar updates local page state as you type.'
                          : 'Current search query: $_searchQuery',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: 'Buttons',
                description:
                    'Different button types, themes, icons, and a full-width action.',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: <Widget>[
                        SizedBox(
                          width: 180,
                          child: TDButton(
                            text: 'Primary',
                            isBlock: true,
                            theme: TDButtonTheme.primary,
                            onTap: () {
                              setState(() {
                                _statusMessage = 'Primary fill button pressed.';
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 180,
                          child: TDButton(
                            text: 'Outline',
                            isBlock: true,
                            type: TDButtonType.outline,
                            theme: TDButtonTheme.primary,
                            icon: TDIcons.home,
                            onTap: () {
                              setState(() {
                                _statusMessage = 'Outline button pressed.';
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 180,
                          child: TDButton(
                            text: 'Text Button',
                            isBlock: true,
                            type: TDButtonType.text,
                            theme: TDButtonTheme.defaultTheme,
                            onTap: () {
                              setState(() {
                                _statusMessage = 'Text button pressed.';
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 180,
                          child: TDButton(
                            text: 'Ghost',
                            isBlock: true,
                            type: TDButtonType.ghost,
                            theme: TDButtonTheme.primary,
                            onTap: () {
                              setState(() {
                                _statusMessage = 'Ghost button pressed.';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TDButton(
                      text: 'Save Preset',
                      size: TDButtonSize.large,
                      isBlock: true,
                      theme: TDButtonTheme.primary,
                      icon: TDIcons.check,
                      onTap: () {
                        setState(() {
                          _unreadCount += 1;
                          _statusMessage =
                              'Preset saved at ${TimeOfDay.now().format(context)}.';
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: 'Tags + Badges',
                description:
                    'Tags are useful for status labels while badges highlight counts and alerts.',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: <Widget>[
                        const TDTag('Default'),
                        const TDTag('Primary', theme: TDTagTheme.primary),
                        const TDTag(
                          'Outline',
                          theme: TDTagTheme.success,
                          isOutline: true,
                          shape: TDTagShape.round,
                        ),
                        const TDTag(
                          'Warning',
                          theme: TDTagTheme.warning,
                          isLight: true,
                        ),
                        if (_showClosableTag)
                          TDTag(
                            'Closable',
                            theme: TDTagTheme.danger,
                            isLight: true,
                            needCloseIcon: true,
                            onCloseTap: () {
                              setState(() {
                                _showClosableTag = false;
                                _statusMessage = 'Closable tag dismissed.';
                              });
                            },
                          )
                        else
                          TDButton(
                            text: 'Show Tag',
                            type: TDButtonType.text,
                            theme: TDButtonTheme.primary,
                            onTap: () {
                              setState(() {
                                _showClosableTag = true;
                                _statusMessage = 'Closable tag restored.';
                              });
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: <Widget>[
                        _BadgePreview(
                          title: 'Messages',
                          badge: TDBadge(
                            TDBadgeType.message,
                            count: '$_unreadCount',
                            size: TDBadgeSize.large,
                          ),
                          child: const Icon(
                            Icons.mail_outline,
                            size: 30,
                            color: Color(0xFF0052D9),
                          ),
                        ),
                        const _BadgePreview(
                          title: 'Dot Status',
                          badge: TDBadge(TDBadgeType.redPoint),
                          child: TDAvatar(
                            type: TDAvatarType.icon,
                            size: TDAvatarSize.medium,
                            icon: TDIcons.user,
                          ),
                        ),
                        const _BadgePreview(
                          title: 'Bubble',
                          badge: TDBadge(TDBadgeType.bubble, message: 'NEW'),
                          child: Icon(
                            Icons.local_offer_outlined,
                            size: 30,
                            color: Color(0xFF2A7A2A),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: 'Inputs',
                description:
                    'The input widgets support labels, helper text, clear actions, suffix widgets, and card-style layouts.',
                child: Column(
                  children: <Widget>[
                    TDInput(
                      leftLabel: 'Project',
                      required: true,
                      controller: _projectController,
                      hintText: 'Enter a showcase name',
                      backgroundColor: Colors.white,
                      additionInfo:
                          'Updates the summary chips below in real time.',
                      onChanged: (_) {
                        setState(() {});
                      },
                      onClearTap: () {
                        _projectController.clear();
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 12),
                    TDInput(
                      type: TDInputType.special,
                      leftLabel: 'Budget',
                      controller: _budgetController,
                      hintText: '1200',
                      backgroundColor: Colors.white,
                      rightWidget: const Text('pts'),
                      onChanged: (_) {
                        setState(() {});
                      },
                      onClearTap: () {
                        _budgetController.clear();
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 12),
                    LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                            return TDInput(
                              type: TDInputType.cardStyle,
                              width: constraints.maxWidth,
                              controller: _noteController,
                              hintText: 'Add a short release note',
                              backgroundColor: Colors.white,
                              cardStyleTopText: 'Release Note',
                              cardStyleBottomText:
                                  'Card style inputs require an explicit width.',
                              onChanged: (_) {
                                setState(() {});
                              },
                              onClearTap: () {
                                _noteController.clear();
                                setState(() {});
                              },
                            );
                          },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: 'Switches',
                description:
                    'This package supports fill, text, icon, and loading switch states.',
                child: Column(
                  children: <Widget>[
                    _ControlRow(
                      label: 'Push Notifications',
                      description:
                          'A default switch controlled by external page state.',
                      control: TDSwitch(
                        isOn: _notificationsEnabled,
                        onChanged: (bool value) {
                          setState(() {
                            _notificationsEnabled = value;
                            _statusMessage = value
                                ? 'Notifications enabled.'
                                : 'Notifications paused.';
                          });
                          return true;
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    _ControlRow(
                      label: 'Review Mode',
                      description:
                          'Text labels make the state readable without extra copy.',
                      control: TDSwitch(
                        isOn: _reviewMode,
                        type: TDSwitchType.text,
                        openText: 'On',
                        closeText: 'Off',
                        onChanged: (bool value) {
                          setState(() {
                            _reviewMode = value;
                            _statusMessage = value
                                ? 'Review mode enabled.'
                                : 'Review mode disabled.';
                          });
                          return true;
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    const _ControlRow(
                      label: 'Icon Switch',
                      description:
                          'An icon variant can convey state without text.',
                      control: TDSwitch(
                        isOn: true,
                        size: TDSwitchSize.large,
                        type: TDSwitchType.icon,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const _ControlRow(
                      label: 'Loading Switch',
                      description:
                          'Useful when a setting is waiting for a backend confirmation.',
                      control: TDSwitch(isOn: true, type: TDSwitchType.loading),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: 'Avatars + Loading',
                description:
                    'Avatars, loaders, and status chips work well together in dashboard-style layouts.',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        const TDAvatar(
                          type: TDAvatarType.icon,
                          size: TDAvatarSize.large,
                          icon: TDIcons.user,
                        ),
                        const TDAvatar(
                          type: TDAvatarType.customText,
                          size: TDAvatarSize.large,
                          text: 'TD',
                          backgroundColor: Color(0xFF0052D9),
                        ),
                        const TDAvatar(
                          type: TDAvatarType.normal,
                          size: TDAvatarSize.large,
                          defaultUrl: _assetPath,
                        ),
                        TDAvatar(
                          type: TDAvatarType.operation,
                          size: TDAvatarSize.small,
                          avatarDisplayListAsset: const <String>[
                            _assetPath,
                            _assetPath,
                          ],
                          onTap: () {
                            setState(() {
                              _statusMessage =
                                  'Operation avatar action tapped.';
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: const <Widget>[
                        TDLoading(
                          size: TDLoadingSize.small,
                          icon: TDLoadingIcon.circle,
                          text: 'Syncing',
                        ),
                        TDLoading(
                          size: TDLoadingSize.medium,
                          icon: TDLoadingIcon.point,
                          text: 'Uploading',
                        ),
                        TDLoading(
                          size: TDLoadingSize.large,
                          icon: TDLoadingIcon.activity,
                          text: 'Deploying',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: 'Live Summary',
                description:
                    'This section reflects the current state from the TDesign widgets above.',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: <Widget>[
                        _SummaryChip(
                          label: 'Project',
                          value: _projectController.text.isEmpty
                              ? 'Empty'
                              : _projectController.text,
                        ),
                        _SummaryChip(
                          label: 'Budget',
                          value: _budgetController.text.isEmpty
                              ? 'Unset'
                              : '${_budgetController.text} pts',
                        ),
                        _SummaryChip(label: 'Unread', value: '$_unreadCount'),
                        _SummaryChip(
                          label: 'Notifications',
                          value: _notificationsEnabled ? 'On' : 'Off',
                        ),
                        _SummaryChip(
                          label: 'Review',
                          value: _reviewMode ? 'On' : 'Off',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _statusMessage,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
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

class _SectionCard extends StatelessWidget {
  const _SectionCard({
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

class _BadgePreview extends StatelessWidget {
  const _BadgePreview({
    required this.title,
    required this.child,
    required this.badge,
  });

  final String title;
  final Widget child;
  final Widget badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              child,
              Positioned(top: -6, right: -12, child: badge),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _ControlRow extends StatelessWidget {
  const _ControlRow({
    required this.label,
    required this.description,
    required this.control,
  });

  final String label;
  final String description;
  final Widget control;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(description),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Padding(padding: const EdgeInsets.only(top: 4), child: control),
      ],
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(14),
      ),
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyMedium,
          children: <InlineSpan>[
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
