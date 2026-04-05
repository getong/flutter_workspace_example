import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/navigation_service.dart';

/// Fullscreen overlay page demonstrating _rootNavigatorKey usage
///
/// This page shows how _rootNavigatorKey enables:
/// - Modal fullscreen overlays
/// - Global overlay management
/// - Navigation outside of shell context
class FullscreenOverlayPage extends StatefulWidget {
  const FullscreenOverlayPage({super.key});

  @override
  State<FullscreenOverlayPage> createState() => _FullscreenOverlayPageState();
}

class _FullscreenOverlayPageState extends State<FullscreenOverlayPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final _navigationService = NavigationService();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Scaffold(
            backgroundColor: Colors.black87,
            body: SafeArea(
              child: Column(
                children: [
                  // Custom app bar - fixed height
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: _closeOverlay,
                          icon: const Icon(Icons.close, color: Colors.white),
                        ),
                        const Expanded(
                          child: Text(
                            'Fullscreen Overlay',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 48), // Balance the close button
                      ],
                    ),
                  ),

                  // Main content - scrollable to prevent overflow
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.fullscreen,
                            size: 100, // Reduced from 120
                            color: Colors.white,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Fullscreen Overlay Demo',
                            style: TextStyle(
                              fontSize: 24, // Reduced from 28
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'This overlay demonstrates:\n'
                            '• Full-screen navigation using _rootNavigatorKey\n'
                            '• Modal presentation outside shell context\n'
                            '• Global overlay management\n'
                            '• Animation and gesture handling',
                            style: TextStyle(
                              fontSize: 14, // Reduced from 16
                              color: Colors.white70,
                              height: 1.4, // Reduced from 1.5
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 30),

                          // Action buttons - responsive layout
                          LayoutBuilder(
                            builder: (context, constraints) {
                              // Use column layout for narrow screens
                              if (constraints.maxWidth < 600) {
                                return Column(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton.icon(
                                        onPressed: _showAnotherOverlay,
                                        icon: const Icon(Icons.layers),
                                        label: const Text(
                                          'Stack Another Overlay',
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton.icon(
                                        onPressed: _navigateToAuth,
                                        icon: const Icon(Icons.login),
                                        label: const Text(
                                          'Global Auth Navigation',
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton.icon(
                                        onPressed: _showGlobalDialog,
                                        icon: const Icon(Icons.info),
                                        label: const Text('Global Dialog'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.orange,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                              // Use wrap layout for wider screens
                              return Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                alignment: WrapAlignment.center,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: _showAnotherOverlay,
                                    icon: const Icon(Icons.layers),
                                    label: const Text('Stack Overlay'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: _navigateToAuth,
                                    icon: const Icon(Icons.login),
                                    label: const Text('Global Auth'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: _showGlobalDialog,
                                    icon: const Icon(Icons.info),
                                    label: const Text('Global Dialog'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),

                          const SizedBox(height: 30),
                          Container(
                            padding: const EdgeInsets.all(
                              12,
                            ), // Reduced padding
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Swipe down or tap close to dismiss',
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 12, // Reduced font size
                              ),
                            ),
                          ),
                          // Add bottom padding to ensure content is not cut off
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _closeOverlay() async {
    await _animationController.reverse();
    if (mounted) {
      context.pop();
    }
  }

  void _showAnotherOverlay() {
    _navigationService.showGlobalDialog(
      dialog: Dialog(
        backgroundColor: Colors.purple.shade900,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.layers, size: 60, color: Colors.white),
              const SizedBox(height: 16),
              const Text(
                'Stacked Overlay',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'This demonstrates multiple overlays using _rootNavigatorKey',
                style: TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToAuth() {
    _navigationService.navigateToLogin();
  }

  void _showGlobalDialog() {
    _navigationService.showGlobalDialog(
      dialog: AlertDialog(
        title: const Text('Global Navigation Info'),
        content: const Text(
          '_rootNavigatorKey allows this overlay to:\n\n'
          '• Display over all other content\n'
          '• Access global navigation context\n'
          '• Show dialogs and snackbars globally\n'
          '• Handle deep links and redirects\n'
          '• Manage authentication flows',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
