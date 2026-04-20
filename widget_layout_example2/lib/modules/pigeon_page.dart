import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class PigeonPage extends StatefulWidget {
  const PigeonPage({super.key});

  @override
  State<PigeonPage> createState() => _PigeonPageState();
}

class _PigeonPageState extends State<PigeonPage> {
  late final TextEditingController _apiNameController;
  late final TextEditingController _channelSuffixController;
  late final TextEditingController _kotlinPackageController;

  bool _includeAsyncMethod = true;
  bool _includeEventClass = true;

  @override
  void initState() {
    super.initState();
    _apiNameController = TextEditingController(text: 'DeviceInfoApi');
    _channelSuffixController = TextEditingController(text: 'device_info');
    _kotlinPackageController = TextEditingController(
      text: 'com.example.widget_layout_example2',
    );
  }

  @override
  void dispose() {
    _apiNameController.dispose();
    _channelSuffixController.dispose();
    _kotlinPackageController.dispose();
    super.dispose();
  }

  String get _apiName => _apiNameController.text.trim().isEmpty
      ? 'DeviceInfoApi'
      : _apiNameController.text.trim();

  String get _channelSuffix => _channelSuffixController.text.trim().isEmpty
      ? 'device_info'
      : _channelSuffixController.text.trim();

  String get _kotlinPackage => _kotlinPackageController.text.trim().isEmpty
      ? 'com.example.widget_layout_example2'
      : _kotlinPackageController.text.trim();

  String get _contractCode {
    final String eventClass = _includeEventClass
        ? '''

class DeviceStatusEvent {
  String? phase;
  int? batteryLevel;
  bool? charging;
}
'''
        : '';

    final String asyncMethod = _includeAsyncMethod
        ? '''
  @async
  DeviceStatusEvent fetchStatus(DeviceRequest request);
'''
        : '''
  DeviceStatusEvent fetchStatus(DeviceRequest request);
''';

    return '''
import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/pigeon/${_channelSuffix}_messages.g.dart',
    kotlinOut: 'android/app/src/main/kotlin/${_kotlinPackage.replaceAll('.', '/')}/${_channelSuffix}_messages.g.kt',
    kotlinPackage: '$_kotlinPackage',
    swiftOut: 'ios/Runner/${_channelSuffix}_messages.g.swift',
    dartOptions: DartOptions(),
  ),
)

class DeviceRequest {
  String? deviceId;
  bool? includeBattery;
}
$eventClass
@HostApi()
abstract class $_apiName {$asyncMethod
}
''';
  }

  String get _generatorCommand =>
      '''
dart run pigeon \\
  --input pigeons/$_channelSuffix.dart \\
  --dart_out lib/pigeon/${_channelSuffix}_messages.g.dart \\
  --kotlin_out android/app/src/main/kotlin/${_kotlinPackage.replaceAll('.', '/')}/${_channelSuffix}_messages.g.kt \\
  --kotlin_package $_kotlinPackage \\
  --swift_out ios/Runner/${_channelSuffix}_messages.g.swift
''';

  String get _dartClientCode {
    final String resultType = _includeEventClass
        ? 'DeviceStatusEvent'
        : 'Object';

    return '''
import 'package:widget_layout_example2/pigeon/${_channelSuffix}_messages.g.dart';

final $_apiName api = $_apiName();

Future<$resultType> loadDeviceStatus() async {
  final DeviceRequest request = DeviceRequest()
    ..deviceId = 'emulator-5554'
    ..includeBattery = true;

  final ${_includeAsyncMethod ? resultType : 'DeviceStatusEvent'} result =
      ${_includeAsyncMethod ? 'await ' : ''}api.fetchStatus(request);
  return result;
}
''';
  }

  String get _androidImplementationCode {
    final String resultHandling = _includeAsyncMethod
        ? '''
  override fun fetchStatus(
      request: DeviceRequest,
      callback: (Result<DeviceStatusEvent>) -> Unit
  ) {
    val event = DeviceStatusEvent(
      phase = "connected",
      batteryLevel = 87,
      charging = true,
    )
    callback(Result.success(event))
  }'''
        : '''
  override fun fetchStatus(request: DeviceRequest): DeviceStatusEvent {
    return DeviceStatusEvent(
      phase = "connected",
      batteryLevel = 87,
      charging = true,
    )
  }''';

    return '''
class ${_apiName}Impl : $_apiName {
$resultHandling
}

override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
  super.configureFlutterEngine(flutterEngine)
  $_apiName.setUp(flutterEngine.dartExecutor.binaryMessenger, ${_apiName}Impl())
}
''';
  }

  String get _swiftImplementationCode {
    final String methodBody = _includeAsyncMethod
        ? '''
  func fetchStatus(
    request: DeviceRequest,
    completion: @escaping (Result<DeviceStatusEvent, Error>) -> Void
  ) {
    let event = DeviceStatusEvent(
      phase: "connected",
      batteryLevel: 87,
      charging: true
    )
    completion(.success(event))
  }'''
        : '''
  func fetchStatus(request: DeviceRequest) throws -> DeviceStatusEvent {
    DeviceStatusEvent(
      phase: "connected",
      batteryLevel: 87,
      charging: true
    )
  }''';

    return '''
final class ${_apiName}Impl: $_apiName {
$methodBody
}

override func application(
  _ application: UIApplication,
  didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
) -> Bool {
  let controller = window?.rootViewController as! FlutterViewController
  ${_apiName}Setup.setUp(binaryMessenger: controller.binaryMessenger, api: ${_apiName}Impl())
  return super.application(application, didFinishLaunchingWithOptions: launchOptions)
}
''';
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('pigeon Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Use `pigeon` to generate type-safe platform channel APIs for Flutter, Android, and iOS.',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'This module demonstrates a realistic Pigeon workflow: define a contract file, run the generator, call the generated Dart API, and implement the generated host interface on Android and iOS.',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: const <Widget>[
                        Chip(label: Text('@HostApi')),
                        Chip(label: Text('@ConfigurePigeon')),
                        Chip(label: Text('dartOut')),
                        Chip(label: Text('kotlinOut')),
                        Chip(label: Text('swiftOut')),
                        Chip(label: Text('type-safe channels')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Contract Builder',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _apiNameController,
                      decoration: const InputDecoration(
                        labelText: 'Host API class name',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _channelSuffixController,
                      decoration: const InputDecoration(
                        labelText: 'File / channel suffix',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _kotlinPackageController,
                      decoration: const InputDecoration(
                        labelText: 'Android Kotlin package',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      value: _includeAsyncMethod,
                      title: const Text('Generate async host method'),
                      subtitle: const Text(
                        'Adds `@async` and shows callback-style host code.',
                      ),
                      onChanged: (bool value) {
                        setState(() => _includeAsyncMethod = value);
                      },
                    ),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      value: _includeEventClass,
                      title: const Text('Include typed event payload'),
                      subtitle: const Text(
                        'Shows how custom request/response classes travel through generated code.',
                      ),
                      onChanged: (bool value) {
                        setState(() => _includeEventClass = value);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _CodeCard(
              title: 'Pigeon Contract File',
              description:
                  'Place this in `pigeons/$_channelSuffix.dart` and use it as the source of truth for generated channel code.',
              code: _contractCode,
            ),
            const SizedBox(height: 16),
            _CodeCard(
              title: 'Generator Command',
              description:
                  'Run the generator whenever the Pigeon contract changes so Dart and native stubs stay in sync.',
              code: _generatorCommand,
            ),
            const SizedBox(height: 16),
            _CodeCard(
              title: 'Generated Dart Client Usage',
              description:
                  'The Flutter side calls the generated API like a typed service instead of manually encoding channel arguments.',
              code: _dartClientCode,
            ),
            const SizedBox(height: 16),
            _CodeCard(
              title: 'Android Host Implementation',
              description:
                  'Implement the generated Kotlin interface, then register it with the Flutter binary messenger.',
              code: _androidImplementationCode,
            ),
            const SizedBox(height: 16),
            _CodeCard(
              title: 'iOS Host Implementation',
              description:
                  'Implement the generated Swift protocol and wire it up during app startup.',
              code: _swiftImplementationCode,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'When To Use Pigeon',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const _UsageBullet(
                      text:
                          'Prefer Pigeon when your platform channel has multiple request/response types and you want generated, compile-time checked APIs.',
                    ),
                    const _UsageBullet(
                      text:
                          'Use it instead of raw `MethodChannel` when keeping Dart, Kotlin, and Swift payload shapes aligned would otherwise become tedious or error-prone.',
                    ),
                    const _UsageBullet(
                      text:
                          'Keep the Pigeon definition in a dedicated `pigeons/` file and treat generated files as build artifacts, not hand-written business logic.',
                    ),
                    const _UsageBullet(
                      text:
                          'Regenerate outputs whenever fields, nullability, enums, or method signatures change.',
                    ),
                  ],
                ),
              ),
            ),
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

class _CodeCard extends StatelessWidget {
  const _CodeCard({
    required this.title,
    required this.description,
    required this.code,
  });

  final String title;
  final String description;
  final String code;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.45,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                code,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontFamily: 'monospace',
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UsageBullet extends StatelessWidget {
  const _UsageBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Icon(Icons.arrow_right, size: 18),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
