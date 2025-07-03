import 'package:flutter/material.dart';
import 'package:flutter_2fa/flutter_2fa.dart';
import 'custom_2fa_implementation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 2FA Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        // Add custom theme data to help with layout issues
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        // Add dialog theme to help with package layout issues
        dialogTheme: const DialogThemeData(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
        ),
      ),
      home: const HomePage(),
      // Add builder to wrap the app with MediaQuery override if needed
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: MediaQuery.of(context).textScaler.clamp(
              minScaleFactor: 0.8,
              maxScaleFactor: 1.2,
            ),
          ),
          child: child!,
        );
      },
    );
  }
}

class TwoFactorAuthPage extends StatefulWidget {
  const TwoFactorAuthPage({super.key});

  @override
  State<TwoFactorAuthPage> createState() => _TwoFactorAuthPageState();
}

class _TwoFactorAuthPageState extends State<TwoFactorAuthPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _appNameController = TextEditingController(
    text: 'Flutter 2FA Demo',
  );
  bool _isAuthenticated = false;
  String _statusMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _appNameController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _activateTwoFactor() async {
    if (_emailController.text.trim().isEmpty ||
        _appNameController.text.trim().isEmpty) {
      _showSnackBar(
        'Please enter both email and app name',
        backgroundColor: Colors.red,
      );
      return;
    }

    try {
      setState(() {
        _statusMessage = 'Activating 2FA...';
      });

      // Use post-frame callback to avoid calling navigation during build
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        try {
          // Show loading indicator
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          );

          await Flutter2FA().activate(
            context: context,
            appName: _appNameController.text.trim(),
            email: _emailController.text.trim(),
          );

          // Hide loading indicator
          Navigator.of(context).pop();

          if (mounted) {
            setState(() {
              _statusMessage =
                  '2FA activated successfully! You can now verify your authentication.';
            });

            _showSnackBar(
              '2FA has been activated! Check your authenticator app.',
              backgroundColor: Colors.green,
            );
          }
        } catch (e) {
          // Hide loading indicator if still showing
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
          
          if (mounted) {
            setState(() {
              _statusMessage = 'Failed to activate 2FA: ${e.toString()}';
            });
            _showSnackBar(
              'Error activating 2FA: ${e.toString()}',
              backgroundColor: Colors.red,
            );
          }
        }
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Failed to activate 2FA: ${e.toString()}';
      });
      _showSnackBar(
        'Error activating 2FA: ${e.toString()}',
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> _verifyTwoFactor() async {
    try {
      setState(() {
        _statusMessage = 'Verifying 2FA...';
      });

      // Create a success page to navigate to after successful verification
      final successPage = SuccessPage(
        onSuccess: () {
          setState(() {
            _isAuthenticated = true;
            _statusMessage =
                'Authentication successful! You are now logged in.';
          });
          _showSnackBar(
            'Authentication successful!',
            backgroundColor: Colors.green,
          );
        },
      );

      // Use post-frame callback to avoid calling navigation during build
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        try {
          await Flutter2FA().verify(context: context, page: successPage);
        } catch (e) {
          if (mounted) {
            setState(() {
              _isAuthenticated = false;
              _statusMessage = 'Authentication failed: ${e.toString()}';
            });
            _showSnackBar(
              'Authentication failed: ${e.toString()}',
              backgroundColor: Colors.red,
            );
          }
        }
      });
    } catch (e) {
      setState(() {
        _isAuthenticated = false;
        _statusMessage = 'Authentication failed: ${e.toString()}';
      });
      _showSnackBar(
        'Authentication failed: ${e.toString()}',
        backgroundColor: Colors.red,
      );
    }
  }

  void _logout() {
    setState(() {
      _isAuthenticated = false;
      _statusMessage = 'Logged out successfully';
    });
    _showSnackBar('Logged out successfully', backgroundColor: Colors.blue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter 2FA Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // App Header
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Icon(Icons.security, size: 64, color: Colors.blue),
                    const SizedBox(height: 16),
                    Text(
                      'Two-Factor Authentication',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Secure your account with 2FA using an authenticator app',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Authentication Status
            if (_isAuthenticated)
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 48,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Authenticated',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'You have successfully authenticated using 2FA!',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _logout,
                        icon: const Icon(Icons.logout),
                        label: const Text('Logout'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Column(
                children: [
                  // Setup Form
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Setup 2FA',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _appNameController,
                            decoration: const InputDecoration(
                              labelText: 'App Name',
                              hintText: 'Enter your app name',
                              prefixIcon: Icon(Icons.apps),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              hintText: 'Enter your email address',
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _activateTwoFactor,
                              icon: const Icon(Icons.qr_code),
                              label: const Text('Activate 2FA'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Verify Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Verify Authentication',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'After setting up 2FA, use this to verify your authentication code from your authenticator app.',
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _verifyTwoFactor,
                              icon: const Icon(Icons.verified_user),
                              label: const Text('Verify 2FA Code'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 24),

            // Status Message
            if (_statusMessage.isNotEmpty)
              Card(
                color: Colors.grey.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Status',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(_statusMessage),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // Instructions
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Instructions',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '1. Enter your app name and email address\n'
                      '2. Tap "Activate 2FA" to generate a QR code\n'
                      '3. Scan the QR code with your authenticator app (Google Authenticator, Authy, etc.)\n'
                      '4. Use "Verify 2FA Code" to test authentication\n'
                      '5. Enter the 6-digit code from your authenticator app',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SuccessPage extends StatelessWidget {
  final VoidCallback onSuccess;

  const SuccessPage({super.key, required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('2FA Verification Success'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 100),
              const SizedBox(height: 24),
              Text(
                'Authentication Successful!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'You have successfully verified your 2FA code.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  onSuccess();
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.home),
                label: const Text('Continue to App'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter 2FA Demo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Icon(Icons.security, size: 80, color: Colors.blue),
                    const SizedBox(height: 16),
                    Text(
                      'Choose 2FA Implementation',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Select which 2FA implementation you\'d like to try',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TwoFactorAuthPage(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.extension),
                        label: const Text('Flutter 2FA Package'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Custom2FAPage(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.build),
                        label: const Text('Custom 2FA Implementation'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• Flutter 2FA Package: Uses the official flutter_2fa package\n'
                      '• Custom Implementation: A robust custom TOTP implementation\n'
                      '• Both support QR code generation and authenticator apps\n'
                      '• Compatible with Google Authenticator, Authy, and other TOTP apps',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
