import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/preferences_service.dart';

/// Profile page demonstrating user data storage
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _username = '';
  String _email = '';
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  /// Load user data from SharedPreferences
  _loadUserData() async {
    String username = await PreferencesService.getUsername();
    String email = await PreferencesService.getEmail();
    setState(() {
      _username = username;
      _email = email;
      _usernameController.text = username;
      _emailController.text = email;
    });
  }

  /// Save user data to SharedPreferences
  _saveUserData() async {
    setState(() {
      _username = _usernameController.text;
      _email = _emailController.text;
    });
    await PreferencesService.setUsername(_username);
    await PreferencesService.setEmail(_email);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Profile saved!')));
  }

  /// Clear user data from SharedPreferences
  _clearUserData() async {
    await PreferencesService.removeUsername();
    await PreferencesService.removeEmail();
    setState(() {
      _username = '';
      _email = '';
      _usernameController.clear();
      _emailController.clear();
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Profile cleared!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'User Profile',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _saveUserData,
                  child: const Text('Save Profile'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _clearUserData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Clear Profile'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Profile data is saved using SharedPreferences\nand will persist across app restarts.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
