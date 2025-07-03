import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp/otp.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class Custom2FAManager {
  static const String _secretKey = 'totp_secret_key';
  static const String _isSetupKey = 'is_2fa_setup';

  // Generate a random secret key for TOTP
  static String generateSecretKey() {
    final random = Random.secure();
    final bytes = List<int>.generate(20, (i) => random.nextInt(256));
    return base32Encode(bytes);
  }

  // Base32 encoding for the secret key
  static String base32Encode(List<int> bytes) {
    const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
    String output = '';
    int bits = 0;
    int value = 0;

    for (int byte in bytes) {
      value = (value << 8) | byte;
      bits += 8;

      while (bits >= 5) {
        output += alphabet[(value >> (bits - 5)) & 31];
        bits -= 5;
      }
    }

    if (bits > 0) {
      output += alphabet[(value << (5 - bits)) & 31];
    }

    return output;
  }

  // Save the secret key
  static Future<void> saveSecretKey(String secret) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_secretKey, secret);
    await prefs.setBool(_isSetupKey, true);
  }

  // Get the saved secret key
  static Future<String?> getSecretKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_secretKey);
  }

  // Check if 2FA is set up
  static Future<bool> isSetup() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isSetupKey) ?? false;
  }

  // Generate TOTP code
  static Future<String> generateTOTP() async {
    final secret = await getSecretKey();
    if (secret == null) return '';

    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return OTP.generateTOTPCodeString(secret, now, length: 6, interval: 30);
  }

  // Verify TOTP code
  static Future<bool> verifyTOTP(String code) async {
    final secret = await getSecretKey();
    if (secret == null) return false;

    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final generatedCode = OTP.generateTOTPCodeString(
      secret,
      now,
      length: 6,
      interval: 30,
    );

    return code == generatedCode;
  }

  // Generate QR code data
  static Future<String> generateQRCodeData(String appName, String email) async {
    final secret = await getSecretKey();
    if (secret == null) return '';

    return 'otpauth://totp/$appName:$email?secret=$secret&issuer=$appName';
  }

  // Reset 2FA setup
  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_secretKey);
    await prefs.remove(_isSetupKey);
  }
}

class Custom2FAPage extends StatefulWidget {
  const Custom2FAPage({super.key});

  @override
  State<Custom2FAPage> createState() => _Custom2FAPageState();
}

class _Custom2FAPageState extends State<Custom2FAPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _appNameController = TextEditingController(
    text: 'Flutter 2FA Demo',
  );
  final TextEditingController _codeController = TextEditingController();

  bool _isSetup = false;
  bool _isAuthenticated = false;
  String _qrCodeData = '';
  String _secretKey = '';
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    _checkSetupStatus();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _appNameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _checkSetupStatus() async {
    final isSetup = await Custom2FAManager.isSetup();
    final secret = await Custom2FAManager.getSecretKey();

    setState(() {
      _isSetup = isSetup;
      _secretKey = secret ?? '';
    });

    if (isSetup && secret != null) {
      await _generateQRCode();
    }
  }

  Future<void> _setupTwoFactor() async {
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
        _statusMessage = 'Setting up 2FA...';
      });

      // Generate new secret key
      final secret = Custom2FAManager.generateSecretKey();
      await Custom2FAManager.saveSecretKey(secret);

      // Generate QR code
      await _generateQRCode();

      setState(() {
        _isSetup = true;
        _secretKey = secret;
        _statusMessage =
            '2FA setup complete! Scan the QR code with your authenticator app.';
      });

      _showSnackBar(
        '2FA has been set up successfully!',
        backgroundColor: Colors.green,
      );
    } catch (e) {
      setState(() {
        _statusMessage = 'Failed to setup 2FA: ${e.toString()}';
      });
      _showSnackBar(
        'Error setting up 2FA: ${e.toString()}',
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> _generateQRCode() async {
    if (_emailController.text.trim().isEmpty ||
        _appNameController.text.trim().isEmpty) {
      return;
    }

    final qrData = await Custom2FAManager.generateQRCodeData(
      _appNameController.text.trim(),
      _emailController.text.trim(),
    );

    setState(() {
      _qrCodeData = qrData;
    });
  }

  Future<void> _verifyCode() async {
    if (_codeController.text.trim().length != 6) {
      _showSnackBar('Please enter a 6-digit code', backgroundColor: Colors.red);
      return;
    }

    try {
      setState(() {
        _statusMessage = 'Verifying code...';
      });

      final isValid = await Custom2FAManager.verifyTOTP(
        _codeController.text.trim(),
      );

      if (isValid) {
        setState(() {
          _isAuthenticated = true;
          _statusMessage = 'Authentication successful!';
        });
        _showSnackBar(
          'Authentication successful!',
          backgroundColor: Colors.green,
        );
      } else {
        setState(() {
          _isAuthenticated = false;
          _statusMessage = 'Invalid code. Please try again.';
        });
        _showSnackBar(
          'Invalid code. Please try again.',
          backgroundColor: Colors.red,
        );
      }

      _codeController.clear();
    } catch (e) {
      setState(() {
        _statusMessage = 'Verification failed: ${e.toString()}';
      });
      _showSnackBar(
        'Verification failed: ${e.toString()}',
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> _reset() async {
    await Custom2FAManager.reset();
    setState(() {
      _isSetup = false;
      _isAuthenticated = false;
      _qrCodeData = '';
      _secretKey = '';
      _statusMessage = '2FA has been reset';
    });
    _showSnackBar('2FA has been reset', backgroundColor: Colors.blue);
  }

  void _logout() {
    setState(() {
      _isAuthenticated = false;
      _statusMessage = 'Logged out successfully';
    });
    _showSnackBar('Logged out successfully', backgroundColor: Colors.blue);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom 2FA Implementation'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          if (_isSetup)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _reset,
              tooltip: 'Reset 2FA',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Icon(Icons.security, size: 64, color: Colors.blue),
                    const SizedBox(height: 16),
                    Text(
                      'Custom Two-Factor Authentication',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'A robust 2FA implementation using TOTP',
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
                  if (!_isSetup)
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
                                onPressed: _setupTwoFactor,
                                icon: const Icon(Icons.qr_code),
                                label: const Text('Setup 2FA'),
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

                  // QR Code Display
                  if (_isSetup && _qrCodeData.isNotEmpty)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'QR Code',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: QrImageView(
                                data: _qrCodeData,
                                version: QrVersions.auto,
                                size: 200.0,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Secret Key: $_secretKey',
                              style: Theme.of(context).textTheme.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(text: _secretKey),
                                );
                                _showSnackBar(
                                  'Secret key copied to clipboard',
                                  backgroundColor: Colors.green,
                                );
                              },
                              icon: const Icon(Icons.copy),
                              label: const Text('Copy Secret Key'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  if (_isSetup) const SizedBox(height: 16),

                  // Verification Form
                  if (_isSetup)
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
                            const SizedBox(height: 16),
                            TextField(
                              controller: _codeController,
                              decoration: const InputDecoration(
                                labelText: 'Authentication Code',
                                hintText: 'Enter 6-digit code',
                                prefixIcon: Icon(Icons.pin),
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _verifyCode,
                                icon: const Icon(Icons.verified_user),
                                label: const Text('Verify Code'),
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
          ],
        ),
      ),
    );
  }
}
