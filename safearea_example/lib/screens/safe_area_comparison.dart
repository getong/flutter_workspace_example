import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/grid_painter.dart';
import '../screens/interactive_example.dart';
import '../constants/app_constants.dart';

/// Main screen that shows side-by-side comparison of SafeArea ON vs OFF
class SafeAreaComparison extends StatelessWidget {
  const SafeAreaComparison({super.key});

  @override
  Widget build(BuildContext context) {
    // Make the app fullscreen to better show SafeArea effects
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Top half - WITHOUT SafeArea
          _buildWithoutSafeArea(),
          // Divider
          _buildDivider(),
          // Bottom half - WITH SafeArea
          _buildWithSafeArea(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const InteractiveExample()),
          );
        },
        icon: const Icon(Icons.play_arrow),
        label: const Text('Interactive Demo'),
        backgroundColor: Colors.purple,
      ),
    );
  }

  Widget _buildWithoutSafeArea() {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppConstants.unsafeGradient,
          ),
        ),
        child: Stack(
          children: [
            // Background pattern to show overlap clearly
            Positioned.fill(
              child: CustomPaint(
                painter: GridPainter(
                  Colors.white.withOpacity(AppConstants.gridOpacity),
                ),
              ),
            ),
            // Content that will be hidden behind system UI
            Positioned(
              top: AppConstants.defaultPadding,
              left: AppConstants.defaultPadding,
              right: AppConstants.defaultPadding,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('❌ WITHOUT SafeArea', style: AppConstants.titleStyle),
                  SizedBox(height: AppConstants.smallPadding),
                  Text(
                    'This text might be hidden behind the status bar or notch!',
                    style: AppConstants.subtitleStyle,
                  ),
                ],
              ),
            ),
            // Corner indicators
            const Positioned(
              top: 0,
              left: 0,
              child: Icon(
                Icons.arrow_upward,
                color: Colors.white,
                size: AppConstants.smallIconSize,
              ),
            ),
            const Positioned(
              top: 0,
              right: 0,
              child: Icon(
                Icons.arrow_upward,
                color: Colors.white,
                size: AppConstants.smallIconSize,
              ),
            ),
            // Center content
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning,
                    size: AppConstants.mediumIconSize,
                    color: Colors.white,
                  ),
                  SizedBox(height: AppConstants.defaultPadding),
                  Text(
                    'Content may be\nhidden by system UI',
                    textAlign: TextAlign.center,
                    style: AppConstants.centerTitleStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: AppConstants.dividerHeight,
      color: Colors.white,
      child: Center(
        child: Container(
          width: AppConstants.dividerIndicatorWidth,
          height: AppConstants.dividerIndicatorHeight,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildWithSafeArea() {
    return Expanded(
      child: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: AppConstants.safeGradient,
            ),
          ),
          child: Stack(
            children: [
              // Background pattern
              Positioned.fill(
                child: CustomPaint(
                  painter: GridPainter(
                    Colors.white.withOpacity(AppConstants.gridOpacity),
                  ),
                ),
              ),
              // Content that is safely positioned
              Positioned(
                top: AppConstants.defaultPadding,
                left: AppConstants.defaultPadding,
                right: AppConstants.defaultPadding,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('✅ WITH SafeArea', style: AppConstants.titleStyle),
                    SizedBox(height: AppConstants.smallPadding),
                    Text(
                      'This text is always visible and safe from system UI!',
                      style: AppConstants.subtitleStyle,
                    ),
                  ],
                ),
              ),
              // Center content
              const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: AppConstants.mediumIconSize,
                      color: Colors.white,
                    ),
                    SizedBox(height: AppConstants.defaultPadding),
                    Text(
                      'Content is protected\nfrom system UI overlap',
                      textAlign: TextAlign.center,
                      style: AppConstants.centerTitleStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
