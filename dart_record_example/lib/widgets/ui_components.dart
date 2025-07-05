import 'package:flutter/material.dart';

class TimingDisplayWidget extends StatelessWidget {
  final int gapStart;
  final int gapCount;
  final int gapClose;
  final int gapDone;

  const TimingDisplayWidget({
    super.key,
    required this.gapStart,
    required this.gapCount,
    required this.gapClose,
    required this.gapDone,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Start time gap: $gapStart ms'),
        Text('Processing time gap: $gapCount ms'),
        Text('End time gap: $gapClose ms'),
        Text('Post-processing time gap: $gapDone ms'),
      ],
    );
  }
}

class ProgressIndicatorWidget extends StatelessWidget {
  final double progress;

  const ProgressIndicatorWidget({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: LinearProgressIndicator(value: progress),
    );
  }
}

class DownloadButtonWidget extends StatelessWidget {
  final bool canDownload;
  final VoidCallback? onPressed;

  const DownloadButtonWidget({
    super.key,
    required this.canDownload,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: canDownload ? onPressed : null,
      child: const Text('Start Download (Check Console!)'),
    );
  }
}
