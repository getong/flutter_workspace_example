import 'package:flutter/material.dart';

import '../models/demo_models.dart';
import '../state/demo_app_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _bioController = TextEditingController();
  bool _editing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = DemoScope.of(context).user;
    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
      _bioController.text = user.bio;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _cancel(DemoUser user) {
    setState(() {
      _editing = false;
      _nameController.text = user.name;
      _emailController.text = user.email;
      _bioController.text = user.bio;
    });
  }

  void _save() {
    final controller = DemoScope.of(context);
    controller.updateProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      bio: _bioController.text.trim(),
    );
    setState(() => _editing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = DemoScope.of(context);
    final user = controller.user;

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => controller.goToLogin(),
      );
      return const SizedBox.shrink();
    }

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                    onPressed: controller.goToChat,
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: const Text('Back to Chat'),
                  ),
                  const SizedBox(height: 18),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Profile',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 24),
                          Center(
                            child: Column(
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    ConversationAvatar(
                                      initials: user.initials,
                                      colors: user.palette,
                                      size: 128,
                                    ),
                                    Container(
                                      width: 128,
                                      height: 128,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(
                                          alpha: 0.28,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt_outlined,
                                        color: Colors.white,
                                        size: 34,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 18),
                                if (!_editing)
                                  GradientButton(
                                    label: 'Edit Profile',
                                    onPressed: () =>
                                        setState(() => _editing = true),
                                    compact: true,
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 28),
                          LabeledField(
                            label: 'Full Name',
                            child: TextField(
                              controller: _nameController,
                              enabled: _editing,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.person_outline_rounded),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          LabeledField(
                            label: 'Email',
                            child: TextField(
                              controller: _emailController,
                              enabled: _editing,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.mail_outline_rounded),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          LabeledField(
                            label: 'Bio',
                            child: TextField(
                              controller: _bioController,
                              enabled: _editing,
                              maxLines: 4,
                              decoration: const InputDecoration(
                                hintText: 'Tell us about yourself...',
                                alignLabelWithHint: true,
                              ),
                            ),
                          ),
                          if (_editing) ...[
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: GradientButton(
                                    label: 'Save Changes',
                                    onPressed: _save,
                                    icon: Icons.check_rounded,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => _cancel(user),
                                    style: OutlinedButton.styleFrom(
                                      minimumSize: const Size.fromHeight(56),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                    ),
                                    child: const Text('Cancel'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 28),
                          const Divider(),
                          const SizedBox(height: 22),
                          const Row(
                            children: [
                              Expanded(
                                child: ProfileStatTile(
                                  value: '127',
                                  label: 'Messages',
                                  color: AppColors.purple500,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: ProfileStatTile(
                                  value: '42',
                                  label: 'Contacts',
                                  color: AppColors.blue500,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: ProfileStatTile(
                                  value: '8',
                                  label: 'Groups',
                                  color: AppColors.pink500,
                                ),
                              ),
                            ],
                          ),
                        ],
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
