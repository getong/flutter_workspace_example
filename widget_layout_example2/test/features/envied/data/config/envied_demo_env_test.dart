import 'package:flutter_test/flutter_test.dart';
import 'package:widget_layout_example2/features/envied/data/config/envied_demo_env.dart';

void main() {
  group('EnviedDemoEnv', () {
    test('dev flavor reads typed values from env/envied_demo.env', () {
      final EnviedDemoEnv env = EnviedDemoEnv(EnviedDemoFlavor.dev);

      expect(env.apiHost, 'https://api.widget.dev');
      expect(env.apiPort, 443);
      expect(env.useTls, isTrue);
      expect(env.timeoutSeconds, 2.5);
      expect(env.apiBaseUrl, Uri.parse('https://api.widget.dev/v1'));
      expect(env.releaseDate, DateTime.utc(2026, 10, 12));
      expect(env.logLevel, EnviedDemoLogLevel.info);
      expect(env.greeting, 'hello widget world');
      expect(env.apiKey, 'sk_demo_7f3a9c21e4b84d0b');
    });

    test('staging flavor overrides some keys and inherits the rest', () {
      final EnviedDemoEnv env = EnviedDemoEnv(EnviedDemoFlavor.staging);

      expect(env.apiHost, 'http://staging.widget.dev');
      expect(env.apiPort, 8080);
      expect(env.useTls, isFalse);
      expect(env.apiBaseUrl, Uri.parse('http://staging.widget.dev/v1'));
      expect(env.logLevel, EnviedDemoLogLevel.debug);
      expect(env.apiKey, 'sk_staging_51d0e8a7c3f94b62');
      // Inherited from the dev file.
      expect(env.timeoutSeconds, 2.5);
      expect(env.greeting, 'hello widget world');
    });

    test('missing keys fall back to defaultValue or null', () {
      for (final EnviedDemoFlavor flavor in EnviedDemoFlavor.values) {
        final EnviedDemoEnv env = EnviedDemoEnv(flavor);

        expect(env.retryCount, 3);
        expect(env.sentryDsn, isNull);
      }
    });

    test('static const fields are available without an instance', () {
      expect(EnviedDemoBuildInfo.buildLabel, 'envied-demo');
    });
  });
}
