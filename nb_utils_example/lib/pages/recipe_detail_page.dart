import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';

import '../models/demo_recipe.dart';

class RecipeDetailPage extends StatelessWidget {
  const RecipeDetailPage({required this.recipe, super.key});

  final DemoRecipe recipe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe.title)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          _Header(recipe: recipe),
          20.height,
          Text('Highlights', style: boldTextStyle(size: 18)),
          12.height,
          HorizontalList(
            itemCount: recipe.highlights.length,
            padding: EdgeInsets.zero,
            spacing: 10,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: recipe.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  recipe.highlights[index],
                  style: boldTextStyle(color: recipe.accent, size: 13),
                ),
              );
            },
          ),
          20.height,
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _Preview(recipe: recipe),
            ),
          ),
          16.height,
          AppButton(
            text: 'Show route message',
            color: recipe.accent,
            textColor: Colors.white,
            onTap: () =>
                toasty(context, recipe.message, gravity: ToastGravity.BOTTOM),
          ),
          12.height,
          AppButton(
            text: 'Back Home',
            color: Theme.of(context).colorScheme.surface,
            textColor: Theme.of(context).colorScheme.primary,
            onTap: () => context.go('/'),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.recipe});

  final DemoRecipe recipe;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: recipe.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: recipe.accent.withValues(alpha: 0.24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            radius: 24,
            backgroundColor: recipe.accent,
            child: Icon(recipe.icon, color: Colors.white),
          ),
          16.height,
          Text(recipe.title, style: boldTextStyle(size: 24)),
          8.height,
          Text(recipe.summary, style: secondaryTextStyle(size: 14)),
          12.height,
          Text(
            'Dynamic route: ${recipe.routeLabel}',
            style: secondaryTextStyle(color: recipe.accent, size: 13),
          ),
        ],
      ),
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview({required this.recipe});

  final DemoRecipe recipe;

  @override
  Widget build(BuildContext context) {
    switch (recipe.slug) {
      case 'starter-kit':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Starter layout preview', style: boldTextStyle(size: 18)),
            16.height,
            Row(
              children: <Widget>[
                Expanded(
                  child: _MetricCard(title: 'Visitors', value: '12.4k'),
                ),
                12.width,
                Expanded(
                  child: _MetricCard(title: 'Trials', value: '284'),
                ),
              ],
            ),
            12.height,
            Row(
              children: <Widget>[
                Expanded(
                  child: AppButton(
                    text: 'Primary CTA',
                    color: recipe.accent,
                    textColor: Colors.white,
                    onTap: () {},
                  ),
                ),
                12.width,
                Expanded(
                  child: AppButton(
                    text: 'Secondary CTA',
                    color: recipe.accent.withValues(alpha: 0.12),
                    textColor: recipe.accent,
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ],
        );
      case 'team-handoff':
        return Column(
          children: <Widget>[
            SettingItemWidget(
              title: 'QA checklist',
              subTitle: 'Owner: Maya Chen',
              leading: Icon(recipe.icon, color: recipe.accent),
              trailing: _StatusPill(label: 'In review', color: recipe.accent),
            ),
            const Divider(height: 20),
            SettingItemWidget(
              title: 'Release notes',
              subTitle: 'Owner: Jordan Smith',
              leading: Icon(Icons.description_outlined, color: recipe.accent),
              trailing: _StatusPill(
                label: 'Ready',
                color: Colors.green.shade700,
              ),
            ),
            const Divider(height: 20),
            SettingItemWidget(
              title: 'Stakeholder update',
              subTitle: 'Owner: Ana Flores',
              leading: Icon(Icons.send_outlined, color: recipe.accent),
              trailing: _StatusPill(
                label: 'Draft',
                color: Colors.orange.shade800,
              ),
            ),
          ],
        );
      case 'launch-plan':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Launch timeline', style: boldTextStyle(size: 18)),
            16.height,
            const _TimelineRow(
              title: 'Content freeze',
              subtitle: 'Finalize screenshots and copy',
            ),
            12.height,
            const _TimelineRow(
              title: 'Store submission',
              subtitle: 'Push signed build to review',
            ),
            12.height,
            const _TimelineRow(
              title: 'Release monitoring',
              subtitle: 'Watch crash-free sessions and support inbox',
            ),
          ],
        );
      default:
        return Text(recipe.summary, style: secondaryTextStyle());
    }
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: secondaryTextStyle(size: 13)),
          8.height,
          Text(value, style: boldTextStyle(size: 22)),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: boldTextStyle(color: color, size: 12)),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 12,
          height: 12,
          margin: const EdgeInsets.only(top: 6),
          decoration: const BoxDecoration(
            color: Color(0xFFB45309),
            shape: BoxShape.circle,
          ),
        ),
        12.width,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: boldTextStyle()),
              4.height,
              Text(subtitle, style: secondaryTextStyle(size: 13)),
            ],
          ),
        ),
      ],
    );
  }
}
