import 'package:flutter/material.dart';
import '../widgets/future_info_widget.dart';
import '../widgets/task_status_widget.dart';
import '../widgets/task_controls_widget.dart';
import '../controllers/future_controller.dart';

/// Main screen that demonstrates Future cancellation techniques
class FutureCancelScreen extends StatefulWidget {
  const FutureCancelScreen({super.key});

  @override
  State<FutureCancelScreen> createState() => _FutureCancelScreenState();
}

class _FutureCancelScreenState extends State<FutureCancelScreen> {
  late final FutureController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FutureController();
    _controller.addListener(_onControllerUpdate);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    super.dispose();
  }

  void _onControllerUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Future Cancellation Example'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Information about Futures
            const FutureInfoWidget(),
            
            const SizedBox(height: 20),
            
            // Status display
            TaskStatusWidget(taskState: _controller.taskState),
            
            const SizedBox(height: 20),
            
            // Control buttons
            TaskControlsWidget(
              isLoading: _controller.taskState.isLoading,
              onStartTask: _controller.startTask,
              onCancelTask: _controller.cancelTask,
              onNetworkRequest: _controller.makeNetworkRequest,
            ),
          ],
        ),
      ),
    );
  }
}
