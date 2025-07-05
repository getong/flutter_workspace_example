import 'package:flutter/material.dart';
import 'widgets/ui_components.dart';
import 'managers/download_manager.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Records vs Tuples Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _rate = 0.0;
  bool _canDownload = true;

  int _gapStart = 0;
  int _gapCount = 0;
  int _gapClose = 0;
  int _gapDone = 0;

  void _startDownloading(String url) async {
    setState(() => _canDownload = false);

    await DownloadManager.startDownload(
      url: url,
      onProgressUpdate: (progress) => setState(() => _rate = progress),
      onGapStartUpdate: (gap) => setState(() => _gapStart = gap),
      onGapCountUpdate: (gap) => setState(() => _gapCount = gap),
      onGapCloseUpdate: (gap) => setState(() => _gapClose = gap),
      onGapDoneUpdate: (gap) => setState(() => _gapDone = gap),
      onDownloadComplete: () => setState(() => _canDownload = true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Records vs Tuples Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Records vs Tuples Comparison',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            DownloadButtonWidget(
              canDownload: _canDownload,
              onPressed: () => _startDownloading('test'),
            ),
            const SizedBox(height: 20),
            ProgressIndicatorWidget(progress: _rate),
            const SizedBox(height: 32),
            TimingDisplayWidget(
              gapStart: _gapStart,
              gapCount: _gapCount,
              gapClose: _gapClose,
              gapDone: _gapDone,
            ),
            const SizedBox(height: 20),
            const Text(
              'Check the console output for\nRecords vs Alternatives comparison!',
              textAlign: TextAlign.center,
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
