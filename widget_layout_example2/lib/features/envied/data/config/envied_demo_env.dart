import 'package:envied/envied.dart';

part 'envied_demo_env.g.dart';

enum EnviedDemoFlavor { dev, staging }

enum EnviedDemoLogLevel { debug, info, warning, error }

/// Typed configuration generated from `env/envied_demo*.env` at build time.
///
/// Two `@Envied` annotations generate `_EnviedDemoDevEnv` and
/// `_EnviedDemoStagingEnv`, which both implement this class. The staging file
/// inherits every key it does not override from the dev file.
@Envied(
  name: 'EnviedDemoDevEnv',
  path: 'env/envied_demo.env',
  requireEnvFile: true,
  useConstantCase: true,
)
@Envied(
  name: 'EnviedDemoStagingEnv',
  path: 'env/envied_demo.staging.env',
  inheritFrom: <String>['env/envied_demo.env'],
  requireEnvFile: true,
  useConstantCase: true,
)
abstract final class EnviedDemoEnv {
  factory EnviedDemoEnv(EnviedDemoFlavor flavor) => switch (flavor) {
    EnviedDemoFlavor.dev => _EnviedDemoDevEnv(),
    EnviedDemoFlavor.staging => _EnviedDemoStagingEnv(),
  };

  @EnviedField()
  abstract final String apiHost;

  @EnviedField()
  abstract final int apiPort;

  @EnviedField()
  abstract final bool useTls;

  @EnviedField()
  abstract final double timeoutSeconds;

  /// `${API_HOST}/v1` is interpolated by the generator.
  @EnviedField()
  abstract final Uri apiBaseUrl;

  @EnviedField()
  abstract final DateTime releaseDate;

  @EnviedField()
  abstract final EnviedDemoLogLevel logLevel;

  @EnviedField()
  abstract final String greeting;

  /// Not present in either file, so the default value is compiled in.
  @EnviedField(defaultValue: 3)
  abstract final int retryCount;

  /// Not present in either file and nullable, so it compiles to `null`.
  @EnviedField(optional: true)
  abstract final String? sentryDsn;

  /// Stored XOR-encrypted in the generated code instead of as a literal.
  @EnviedField(obfuscate: true)
  abstract final String apiKey;
}

/// Single-file usage: `static const` fields can be used in const contexts and
/// are tree-shaken like any other constant.
@Envied(path: 'env/envied_demo.env', requireEnvFile: true)
abstract final class EnviedDemoBuildInfo {
  @EnviedField(varName: 'BUILD_LABEL')
  static const String buildLabel = _EnviedDemoBuildInfo.buildLabel;
}
