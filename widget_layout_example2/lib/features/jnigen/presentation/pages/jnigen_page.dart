import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

@RoutePage(name: RouteName.jnigen)
class JnigenPage extends StatefulWidget {
  const JnigenPage({super.key});

  @override
  State<JnigenPage> createState() => _JnigenPageState();
}

class _JnigenPageState extends State<JnigenPage> {
  late final TextEditingController _javaClassController;
  late final TextEditingController _packageController;
  late final TextEditingController _jarController;

  bool _includeStaticMethod = true;
  bool _includeInstanceMethod = true;

  @override
  void initState() {
    super.initState();
    _javaClassController = TextEditingController(text: 'DeviceBridge');
    _packageController = TextEditingController(
      text: 'com.example.widget_layout_example2',
    );
    _jarController = TextEditingController(
      text: 'android/app/libs/device_bridge.jar',
    );
  }

  @override
  void dispose() {
    _javaClassController.dispose();
    _packageController.dispose();
    _jarController.dispose();
    super.dispose();
  }

  String get _javaClass => _javaClassController.text.trim().isEmpty
      ? 'DeviceBridge'
      : _javaClassController.text.trim();

  String get _javaPackage => _packageController.text.trim().isEmpty
      ? 'com.example.widget_layout_example2'
      : _packageController.text.trim();

  String get _jarPath => _jarController.text.trim().isEmpty
      ? 'android/app/libs/device_bridge.jar'
      : _jarController.text.trim();

  String get _javaSourceCode {
    final String staticMethod = _includeStaticMethod
        ? '''

  public static String sdkName() {
    return "Android";
  }'''
        : '';

    final String instanceMethod = _includeInstanceMethod
        ? '''

  public int batteryPercent() {
    return 87;
  }'''
        : '';

    return '''
package $_javaPackage;

public class $_javaClass {
  public $_javaClass() {}

  public String deviceId() {
    return "emulator-5554";
  }$staticMethod$instanceMethod
}
''';
  }

  String get _configCode {
    final String className = '$_javaPackage.$_javaClass';

    return '''
output:
  bindings: lib/core/generated/jnigen/
  symbols: lib/core/generated/jnigen_symbols/

classes:
  - $className

source_path:
  - android/app/src/main/java

classpath:
  - $_jarPath

android_sdk_config:
  add_gradle_deps: true
''';
  }

  String get _generatorCommand => 'dart run jnigen --config jnigen.yaml';

  String get _dartUsageCode {
    final String staticCall = _includeStaticMethod
        ? '''
  final String sdk = $_javaClass.sdkName();
  debugPrint('sdk: \$sdk');
'''
        : '';

    final String instanceCall = _includeInstanceMethod
        ? '''
  final int battery = bridge.batteryPercent();
  debugPrint('battery: \$battery');
'''
        : '';

    return '''
import 'package:jni/jni.dart';
import 'package:widget_layout_example2/core/generated/jnigen/${_javaClass.snakeCase}.dart';
import 'package:widget_layout_example2/core/config/router/app_navigation.dart';

void runJnigenDemo() {
  Jni.spawn();

  final $_javaClass bridge = $_javaClass();
  final String id = bridge.deviceId();
  debugPrint('deviceId: \$id');
$staticCall$instanceCall
}
''';
  }

  String get _androidUsageCode =>
      '''
dependencies {
  implementation files('libs/${_jarPath.split('/').last}')
}

// jnigen generates Dart wrappers from Java/Kotlin class metadata.
// The Java class still lives in the Android app or an included JAR/AAR.
''';

  String get _notesCode =>
      '''
Java/Kotlin source of truth:
  $_javaPackage.$_javaClass

Generated Dart wrapper output:
  lib/core/generated/jnigen/

Typical workflow:
  1. Define or update the Java/Kotlin API.
  2. Run `dart run jnigen --config jnigen.yaml`.
  3. Import generated Dart wrappers.
  4. Use them through `package:jni` on Android or other supported JVM setups.
''';

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('jnigen Module')),
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
                      'Use `jnigen` to generate Dart wrappers for Java and Kotlin APIs through JNI.',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'This module demonstrates a typical JNI bridge workflow: define a Java API, point `jnigen` at the classes or JARs, generate Dart wrappers, then call the resulting bindings from Flutter code using `package:jni`.',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: const <Widget>[
                        Chip(label: Text('jnigen.yaml')),
                        Chip(label: Text('classpath')),
                        Chip(label: Text('classes')),
                        Chip(label: Text('package:jni')),
                        Chip(label: Text('generated JVM wrappers')),
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
                      'Wrapper Setup',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _javaClassController,
                      decoration: const InputDecoration(
                        labelText: 'Java class name',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _packageController,
                      decoration: const InputDecoration(
                        labelText: 'Java package',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _jarController,
                      decoration: const InputDecoration(
                        labelText: 'Classpath JAR or AAR path',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      value: _includeStaticMethod,
                      title: const Text('Include static Java method'),
                      subtitle: const Text(
                        'Shows how generated wrappers expose static members.',
                      ),
                      onChanged: (bool value) {
                        setState(() => _includeStaticMethod = value);
                      },
                    ),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      value: _includeInstanceMethod,
                      title: const Text('Include instance Java method'),
                      subtitle: const Text(
                        'Shows how generated wrappers call methods on created objects.',
                      ),
                      onChanged: (bool value) {
                        setState(() => _includeInstanceMethod = value);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _CodeCard(
              title: 'Java API',
              description:
                  'This is the source class that `jnigen` reads to generate Dart wrappers for Java or Kotlin types.',
              code: _javaSourceCode,
            ),
            const SizedBox(height: 16),
            _CodeCard(
              title: 'jnigen Config',
              description:
                  'Point `jnigen` at the JVM classes you want to wrap and at the source path or JARs that contain them.',
              code: _configCode,
            ),
            const SizedBox(height: 16),
            _CodeCard(
              title: 'Generator Command',
              description:
                  'Run the generator after Java/Kotlin signature changes so Dart wrappers stay in sync.',
              code: _generatorCommand,
            ),
            const SizedBox(height: 16),
            _CodeCard(
              title: 'Generated Dart Usage',
              description:
                  'The Flutter side imports the generated wrappers and calls JVM objects with regular-looking Dart APIs.',
              code: _dartUsageCode,
            ),
            const SizedBox(height: 16),
            _CodeCard(
              title: 'Android Classpath Setup',
              description:
                  'Your JVM classes must still be packaged into the Android build through source sets or included libraries.',
              code: _androidUsageCode,
            ),
            const SizedBox(height: 16),
            _CodeCard(
              title: 'Workflow Notes',
              description:
                  'Keep Java/Kotlin classes and generated Dart wrappers aligned as part of your build pipeline.',
              code: _notesCode,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'When To Use jnigen',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const _UsageBullet(
                      text:
                          'Use `jnigen` when Flutter needs generated wrappers over existing Java or Kotlin APIs instead of building every call by hand with low-level JNI.',
                    ),
                    const _UsageBullet(
                      text:
                          'It is especially useful when you already own JVM-side libraries or need broad access to Android or Java ecosystems from Dart.',
                    ),
                    const _UsageBullet(
                      text:
                          'Prefer it when a Java/Kotlin API surface is large enough that manual JNI wrappers would become repetitive and fragile.',
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

extension on String {
  String get snakeCase {
    final StringBuffer buffer = StringBuffer();
    for (int index = 0; index < length; index++) {
      final String char = this[index];
      final bool isUpper =
          char.toUpperCase() == char && char != char.toLowerCase();
      if (index > 0 && isUpper) {
        buffer.write('_');
      }
      buffer.write(char.toLowerCase());
    }
    return buffer.toString();
  }
}
