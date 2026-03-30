import 'package:flutter/material.dart';

import 'package:forui/forui.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool notificationsEnabled = true;
  bool reviewMode = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 24),
      children: <Widget>[
        FCard(
          title: const Text('Workspace Profile'),
          subtitle: const Text(
            'A lightweight form page using local Forui controls rather than the default Flutter counter template.',
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FTextFormField(
                control: const FTextFieldControl.managed(
                  initial: TextEditingValue(text: 'Design Systems'),
                ),
                label: const Text('Workspace name'),
                description: const Text(
                  'Shown in header, release notes, and internal dashboards.',
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              FTextFormField(
                control: const FTextFieldControl.managed(
                  initial: TextEditingValue(text: 'ops@example.com'),
                ),
                label: const Text('Contact email'),
                description: const Text(
                  'Used for incident updates and deploy approvals.',
                ),
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 20),
              FSwitch(
                label: const Text('Release notifications'),
                description: const Text(
                  'Send summaries when new builds enter review.',
                ),
                value: notificationsEnabled,
                onChange: (bool value) {
                  setState(() {
                    notificationsEnabled = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              FCheckbox(
                label: const Text('Require manual review'),
                description: const Text(
                  'Keep a human checkpoint before production rollout.',
                ),
                value: reviewMode,
                onChange: (bool value) {
                  setState(() {
                    reviewMode = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  FButton(
                    onPress: null,
                    child: const Text('Saved via local state demo'),
                  ),
                  FButton(
                    variant: .outline,
                    onPress: null,
                    child: const Text('Wire to API later'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
