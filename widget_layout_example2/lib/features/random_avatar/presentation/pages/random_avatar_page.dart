import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.randomAvatar)
class RandomAvatarPage extends StatefulWidget {
  const RandomAvatarPage({super.key});

  @override
  State<RandomAvatarPage> createState() => _RandomAvatarPageState();
}

class _RandomAvatarPageState extends State<RandomAvatarPage> {
  final TextEditingController _seedController = TextEditingController(
    text: 'flutter-clean-architecture',
  );

  static const List<String> _teamSeeds = <String>[
    'alice-product',
    'bob-design',
    'charlie-flutter',
    'dora-backend',
    'eva-qa',
    'frank-devops',
  ];

  @override
  void dispose() {
    _seedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final String currentSeed = _seedController.text.trim().isEmpty
        ? 'flutter-clean-architecture'
        : _seedController.text.trim();
    final String svgCode = RandomAvatarString(currentSeed);
    final String compactSvgPreview = svgCode.length <= 160
        ? svgCode
        : '${svgCode.substring(0, 160)}...';

    return Scaffold(
      appBar: AppBar(title: const Text('random_avatar Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'random_avatar can deterministically generate a unique SVG avatar from a string seed, which is useful for default user avatars, member lists, comments, and placeholders before a real profile photo exists.',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This page demonstrates the package effect and purpose: same seed gives the same avatar, different seeds give different avatars, transparent background fits overlays, and `RandomAvatarString` can be stored or sent as SVG text.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Interactive seed demo',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Enter any string. The avatar is generated from the seed, so the same user id, email, or username can always map to the same visual identity.',
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _seedController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Seed string',
                        hintText: 'e.g. user_1024 or alice@example.com',
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        _AvatarPreviewTile(
                          label: 'Default background',
                          subtitle: currentSeed,
                          child: RandomAvatar(
                            currentSeed,
                            width: 108,
                            height: 108,
                          ),
                        ),
                        _AvatarPreviewTile(
                          label: 'Transparent background',
                          subtitle: 'Good for colored cards',
                          child: Container(
                            width: 108,
                            height: 108,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: const LinearGradient(
                                colors: <Color>[
                                  Color(0xFF0F766E),
                                  Color(0xFF22C55E),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: RandomAvatar(
                              currentSeed,
                              trBackground: true,
                              width: 90,
                              height: 90,
                            ),
                          ),
                        ),
                        _AvatarPreviewTile(
                          label: 'Same seed again',
                          subtitle: 'Result stays stable',
                          child: RandomAvatar(
                            currentSeed,
                            width: 108,
                            height: 108,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Why it is useful',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: const <Widget>[
                        _UseCaseChip(
                          icon: Icons.person_outline,
                          label: 'Default profile avatar',
                        ),
                        _UseCaseChip(
                          icon: Icons.forum_outlined,
                          label: 'Comments and chat users',
                        ),
                        _UseCaseChip(
                          icon: Icons.groups_outlined,
                          label: 'Team member list',
                        ),
                        _UseCaseChip(
                          icon: Icons.image_not_supported_outlined,
                          label: 'Fallback when no photo exists',
                        ),
                        _UseCaseChip(
                          icon: Icons.fingerprint,
                          label: 'Stable visual identity by user id',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Current seed',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SelectableText(
                            currentSeed,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontFamily: 'monospace',
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'SVG string preview',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SelectableText(
                            compactSvgPreview,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontFamily: 'monospace',
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'You can use `RandomAvatarString(seed)` when you want raw SVG text for storage, caching, transport, or rendering in other places.',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Different seeds, different avatars',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This is the common app usage: assign a deterministic avatar to each user without uploading profile images.',
                    ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _teamSeeds.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 2.4,
                          ),
                      itemBuilder: (BuildContext context, int index) {
                        final String seed = _teamSeeds[index];
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: colorScheme.outlineVariant,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: <Widget>[
                                RandomAvatar(seed, width: 52, height: 52),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        seed.split('-').first,
                                        style: theme.textTheme.titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w800,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        seed,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
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

class _AvatarPreviewTile extends StatelessWidget {
  const _AvatarPreviewTile({
    required this.label,
    required this.subtitle,
    required this.child,
  });

  final String label;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(child: child),
          const SizedBox(height: 12),
          Text(
            label,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _UseCaseChip extends StatelessWidget {
  const _UseCaseChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(avatar: Icon(icon, size: 18), label: Text(label));
  }
}
