import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';

/// Interactive example page that allows toggling SafeArea on/off
class InteractiveExample extends StatefulWidget {
  const InteractiveExample({super.key});

  @override
  State<InteractiveExample> createState() => _InteractiveExampleState();
}

class _InteractiveExampleState extends State<InteractiveExample> {
  bool _useSafeArea = true;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    final content = Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _useSafeArea
              ? AppConstants.interactiveSafeGradient
              : AppConstants.interactiveUnsafeGradient,
        ),
      ),
      child: Stack(
        children: [
          // Corner content that shows overlap issues
          _buildCornerContent(),
          // Center content
          _buildCenterContent(),
        ],
      ),
    );

    return Scaffold(
      body: _useSafeArea ? SafeArea(child: content) : content,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        child: const Icon(Icons.arrow_back),
      ),
    );
  }

  Widget _buildCornerContent() {
    return const Stack(
      children: [
        Positioned(
          top: AppConstants.smallPadding,
          left: AppConstants.smallPadding,
          child: const Text('TOP LEFT', style: AppConstants.cornerTextStyle),
        ),
        Positioned(
          top: AppConstants.smallPadding,
          right: AppConstants.smallPadding,
          child: const Text('TOP RIGHT', style: AppConstants.cornerTextStyle),
        ),
        Positioned(
          bottom: AppConstants.smallPadding,
          left: AppConstants.smallPadding,
          child: const Text('BOTTOM LEFT', style: AppConstants.cornerTextStyle),
        ),
        Positioned(
          bottom: AppConstants.smallPadding,
          right: AppConstants.smallPadding,
          child: const Text(
            'BOTTOM RIGHT',
            style: AppConstants.cornerTextStyle,
          ),
        ),
      ],
    );
  }

  Widget _buildCenterContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _useSafeArea ? Icons.shield : Icons.warning,
            size: AppConstants.largeIconSize,
            color: Colors.white,
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          Text(
            _useSafeArea ? 'SafeArea ON' : 'SafeArea OFF',
            style: AppConstants.interactiveTitleStyle,
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          Text(
            _useSafeArea
                ? 'Content is protected from\nsystem UI overlap'
                : 'Content may be hidden behind\nstatus bar, notch, or home indicator',
            textAlign: TextAlign.center,
            style: AppConstants.interactiveSubtitleStyle,
          ),
          const SizedBox(height: AppConstants.largePadding),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _useSafeArea = !_useSafeArea;
              });
            },
            icon: Icon(_useSafeArea ? Icons.toggle_on : Icons.toggle_off),
            label: const Text('Toggle SafeArea'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              padding: AppConstants.buttonPadding,
              textStyle: AppConstants.buttonTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
