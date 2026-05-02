import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:widget_layout_example2/app_navigation.dart';

@RoutePage(name: RouteName.mobileScanner)
class MobileScannerPage extends StatelessWidget {
  const MobileScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('mobile_scanner Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'mobile_scanner',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'mobile_scanner is a universal barcode/QR-code scanner for '
              'Flutter. It supports Android, iOS, macOS, Linux, and Web. '
              'It uses ML Kit on Android/iOS for fast multi-format detection.',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 24),

            // ── 1. Basic live scanner ──────────────────────────────────────
            _SectionHeader(title: '1. Live QR / Barcode Scanner'),
            const Text(
              'The camera preview is shown inside a bounded Container. '
              'Detected barcodes appear below the preview.',
            ),
            const SizedBox(height: 12),
            const _BasicScannerDemo(),
            const SizedBox(height: 24),

            // ── 2. Scanner with overlay ────────────────────────────────────
            _SectionHeader(title: '2. Scanner + Scan-Window Overlay'),
            const Text(
              'scanWindow clips detection to a rect; a custom overlay '
              'highlights the scanning region with a coloured border.',
            ),
            const SizedBox(height: 12),
            const _OverlayScannerDemo(),
            const SizedBox(height: 24),

            // ── 3. Controller features ─────────────────────────────────────
            _SectionHeader(title: '3. Controller Features'),
            const Text(
              'MobileScannerController exposes start(), stop(), '
              'switchCamera() and toggleTorch().',
            ),
            const SizedBox(height: 12),
            const _ControllerDemo(),
            const SizedBox(height: 24),

            // ── 4. Detect specific formats ─────────────────────────────────
            _SectionHeader(title: '4. Restrict to Specific Formats'),
            const Text(
              'Pass a list of BarcodeFormat values to ignore everything else.',
            ),
            const SizedBox(height: 12),
            const _FormatFilterDemo(),
            const SizedBox(height: 24),

            // ── 5. Image picker scanning ───────────────────────────────────
            _SectionHeader(title: '5. Code Overview — analyzeImage()'),
            const Text(
              'analyzeImage() lets you decode barcodes from a static image '
              'path instead of the live camera feed.',
            ),
            const SizedBox(height: 8),
            _CodeBlock(
              code:
                  '// Scan an image from the gallery\n'
                  'final MobileScannerController controller =\n'
                  '    MobileScannerController();\n\n'
                  'final bool found =\n'
                  '    await controller.analyzeImage(imagePath);\n\n'
                  '// Results arrive via the barcodes stream:\n'
                  'controller.barcodes.listen((BarcodeCapture capture) {\n'
                  '  for (final Barcode b in capture.barcodes) {\n'
                  '    print(b.displayValue);\n'
                  '  }\n'
                  '});',
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.replacePath('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 1. Basic live scanner demo
// ─────────────────────────────────────────────────────────────────────────────
class _BasicScannerDemo extends StatefulWidget {
  const _BasicScannerDemo();

  @override
  State<_BasicScannerDemo> createState() => _BasicScannerDemoState();
}

class _BasicScannerDemoState extends State<_BasicScannerDemo> {
  final MobileScannerController _controller = MobileScannerController();
  String? _lastValue;
  BarcodeFormat? _lastFormat;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    for (final Barcode barcode in capture.barcodes) {
      if (barcode.displayValue != null) {
        setState(() {
          _lastValue = barcode.displayValue;
          _lastFormat = barcode.format;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 240,
            child: MobileScanner(controller: _controller, onDetect: _onDetect),
          ),
        ),
        const SizedBox(height: 8),
        if (_lastValue != null)
          Card(
            color: Colors.green.shade50,
            child: ListTile(
              leading: const Icon(Icons.qr_code_2, color: Colors.green),
              title: Text(
                _lastValue!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Format: ${_lastFormat?.name ?? "unknown"}',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          )
        else
          const Text(
            'Point the camera at a QR code or barcode…',
            style: TextStyle(color: Colors.grey),
          ),
        const SizedBox(height: 8),
        _CodeBlock(
          code:
              'MobileScanner(\n'
              '  controller: MobileScannerController(),\n'
              '  onDetect: (BarcodeCapture capture) {\n'
              '    for (final b in capture.barcodes) {\n'
              '      print(b.displayValue);\n'
              '    }\n'
              '  },\n'
              ')',
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. Overlay scanner demo
// ─────────────────────────────────────────────────────────────────────────────
class _OverlayScannerDemo extends StatefulWidget {
  const _OverlayScannerDemo();

  @override
  State<_OverlayScannerDemo> createState() => _OverlayScannerDemoState();
}

class _OverlayScannerDemoState extends State<_OverlayScannerDemo> {
  final MobileScannerController _controller = MobileScannerController();
  String? _result;

  static const double _previewHeight = 260.0;
  static const double _windowSize = 180.0;

  Rect get _scanWindow {
    const double cx = 160.0; // horizontal centre
    const double cy = _previewHeight / 2;
    return Rect.fromCenter(
      center: const Offset(cx, cy),
      width: _windowSize,
      height: _windowSize,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: _previewHeight,
            child: Stack(
              children: <Widget>[
                MobileScanner(
                  controller: _controller,
                  scanWindow: _scanWindow,
                  onDetect: (BarcodeCapture capture) {
                    for (final Barcode b in capture.barcodes) {
                      if (b.displayValue != null) {
                        setState(() => _result = b.displayValue);
                      }
                    }
                  },
                ),
                // Dimmed overlay outside scan window
                CustomPaint(
                  painter: _ScanOverlayPainter(scanWindow: _scanWindow),
                  child: const SizedBox.expand(),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _result != null ? 'Scanned: $_result' : 'Scan window active…',
          style: TextStyle(
            color: _result != null ? Colors.green : Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        _CodeBlock(
          code:
              'MobileScanner(\n'
              '  scanWindow: Rect.fromCenter(\n'
              '    center: Offset(cx, cy),\n'
              '    width: 180, height: 180,\n'
              '  ),\n'
              '  onDetect: ...,\n'
              ')',
        ),
      ],
    );
  }
}

/// Draws a semi-transparent overlay with a transparent hole for the scan window.
class _ScanOverlayPainter extends CustomPainter {
  const _ScanOverlayPainter({required this.scanWindow});

  final Rect scanWindow;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint dimPaint = Paint()..color = Colors.black54;
    final Path path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRect(scanWindow)
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(path, dimPaint);

    final Paint borderPaint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    canvas.drawRect(scanWindow, borderPaint);
  }

  @override
  bool shouldRepaint(_ScanOverlayPainter oldDelegate) =>
      oldDelegate.scanWindow != scanWindow;
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. Controller demo
// ─────────────────────────────────────────────────────────────────────────────
class _ControllerDemo extends StatefulWidget {
  const _ControllerDemo();

  @override
  State<_ControllerDemo> createState() => _ControllerDemoState();
}

class _ControllerDemoState extends State<_ControllerDemo> {
  final MobileScannerController _controller = MobileScannerController();
  bool _running = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 200,
            child: _running
                ? MobileScanner(controller: _controller, onDetect: (_) {})
                : Container(
                    color: Colors.black,
                    alignment: Alignment.center,
                    child: const Text(
                      'Camera stopped',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: <Widget>[
            ElevatedButton.icon(
              onPressed: () async {
                if (_running) {
                  await _controller.stop();
                } else {
                  await _controller.start();
                }
                setState(() => _running = !_running);
              },
              icon: Icon(_running ? Icons.stop : Icons.play_arrow),
              label: Text(_running ? 'Stop' : 'Start'),
            ),
            ElevatedButton.icon(
              onPressed: () => _controller.switchCamera(),
              icon: const Icon(Icons.flip_camera_ios),
              label: const Text('Flip Camera'),
            ),
            ElevatedButton.icon(
              onPressed: () => _controller.toggleTorch(),
              icon: const Icon(Icons.flashlight_on),
              label: const Text('Torch'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _CodeBlock(
          code:
              'final ctrl = MobileScannerController();\n\n'
              'await ctrl.start();         // start preview\n'
              'await ctrl.stop();          // pause preview\n'
              'ctrl.switchCamera();        // front ↔ back\n'
              'ctrl.toggleTorch();         // torch on/off\n'
              'ctrl.dispose();             // free resources',
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 4. Format filter demo
// ─────────────────────────────────────────────────────────────────────────────
class _FormatFilterDemo extends StatefulWidget {
  const _FormatFilterDemo();

  @override
  State<_FormatFilterDemo> createState() => _FormatFilterDemoState();
}

class _FormatFilterDemoState extends State<_FormatFilterDemo> {
  static const List<BarcodeFormat> _formats = <BarcodeFormat>[
    BarcodeFormat.qrCode,
    BarcodeFormat.ean13,
    BarcodeFormat.code128,
    BarcodeFormat.dataMatrix,
  ];

  final Set<BarcodeFormat> _selected = <BarcodeFormat>{BarcodeFormat.qrCode};
  late MobileScannerController _controller;
  String? _result;

  @override
  void initState() {
    super.initState();
    _buildController();
  }

  void _buildController() {
    _controller = MobileScannerController(formats: _selected.toList());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _rebuildController() async {
    await _controller.dispose();
    _buildController();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Wrap(
          spacing: 6,
          children: _formats.map((BarcodeFormat f) {
            return FilterChip(
              label: Text(f.name),
              selected: _selected.contains(f),
              onSelected: (bool v) async {
                setState(() {
                  if (v) {
                    _selected.add(f);
                  } else {
                    _selected.remove(f);
                  }
                });
                await _rebuildController();
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 200,
            child: MobileScanner(
              controller: _controller,
              onDetect: (BarcodeCapture capture) {
                for (final Barcode b in capture.barcodes) {
                  if (b.displayValue != null) {
                    setState(
                      () => _result = '${b.format.name}: ${b.displayValue}',
                    );
                  }
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _result ?? 'No scan yet…',
          style: TextStyle(color: _result != null ? Colors.green : Colors.grey),
        ),
        const SizedBox(height: 8),
        _CodeBlock(
          code:
              'MobileScannerController(\n'
              '  formats: [\n'
              '    BarcodeFormat.qrCode,\n'
              '    BarcodeFormat.ean13,\n'
              '  ],\n'
              ')',
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared helpers
// ─────────────────────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        code,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 12,
          color: Colors.greenAccent,
        ),
      ),
    );
  }
}
