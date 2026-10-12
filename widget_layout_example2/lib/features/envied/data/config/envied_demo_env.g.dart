// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'envied_demo_env.dart';

// **************************************************************************
// EnviedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// generated_from: env/envied_demo.env, env/envied_demo.staging.env
final class _EnviedDemoDevEnv implements EnviedDemoEnv {
  @override
  final String apiHost = 'https://api.widget.dev';

  @override
  final int apiPort = 443;

  @override
  final bool useTls = true;

  @override
  final double timeoutSeconds = 2.5;

  @override
  final Uri apiBaseUrl = Uri.parse('https://api.widget.dev/v1');

  @override
  final DateTime releaseDate = DateTime.parse('2026-10-12T00:00:00Z');

  @override
  final EnviedDemoLogLevel logLevel = EnviedDemoLogLevel.values.byName('info');

  @override
  final String greeting = 'hello widget world';

  @override
  final int retryCount = 3;

  @override
  final String? sentryDsn = null;

  static const List<int> _enviedkeyapiKey = <int>[
    3438421575,
    3415951129,
    1402208069,
    2085922480,
    924505327,
    1837502187,
    3594034169,
    2976765512,
    3133426254,
    1993974882,
    1135437455,
    1376881640,
    788413383,
    1447345760,
    3548188911,
    632877348,
    570341855,
    2232778662,
    137378225,
    3085212838,
    2085268368,
    2853192968,
    475342300,
    2688095393,
  ];

  static const List<int> _envieddataapiKey = <int>[
    3438421556,
    3415951218,
    1402208026,
    2085922516,
    924505226,
    1837502086,
    3594034070,
    2976765463,
    3133426297,
    1993974788,
    1135437500,
    1376881545,
    788413438,
    1447345667,
    3548188893,
    632877333,
    570341818,
    2232778642,
    137378259,
    3085212830,
    2085268388,
    2853193068,
    475342316,
    2688095427,
  ];

  @override
  final String apiKey = String.fromCharCodes(
    List<int>.generate(
      _envieddataapiKey.length,
      (int i) => i,
      growable: false,
    ).map((int i) => _envieddataapiKey[i] ^ _enviedkeyapiKey[i]),
  );
}

final class _EnviedDemoStagingEnv implements EnviedDemoEnv {
  @override
  final String apiHost = 'http://staging.widget.dev';

  @override
  final int apiPort = 8080;

  @override
  final bool useTls = false;

  @override
  final double timeoutSeconds = 2.5;

  @override
  final Uri apiBaseUrl = Uri.parse('http://staging.widget.dev/v1');

  @override
  final DateTime releaseDate = DateTime.parse('2026-10-12T00:00:00Z');

  @override
  final EnviedDemoLogLevel logLevel = EnviedDemoLogLevel.values.byName('debug');

  @override
  final String greeting = 'hello widget world';

  @override
  final int retryCount = 3;

  @override
  final String? sentryDsn = null;

  static const List<int> _enviedkeyapiKey = <int>[
    2218266437,
    1490472575,
    855732900,
    3881607835,
    3287287578,
    592151725,
    3990672353,
    63698892,
    588669823,
    3698331569,
    2607827737,
    3765512163,
    519362207,
    3844990005,
    1924921968,
    751520813,
    670773313,
    2132933565,
    1231878920,
    2514552361,
    4291620772,
    4148747857,
    2944166627,
    514771568,
    3544568510,
    363866816,
    2125353951,
  ];

  static const List<int> _envieddataapiKey = <int>[
    2218266422,
    1490472468,
    855732987,
    3881607912,
    3287287662,
    592151756,
    3990672262,
    63698853,
    588669713,
    3698331606,
    2607827782,
    3765512150,
    519362222,
    3844990033,
    1924921920,
    751520840,
    670773369,
    2132933596,
    1231878975,
    2514552394,
    4291620759,
    4148747831,
    2944166618,
    514771524,
    3544568540,
    363866870,
    2125353965,
  ];

  @override
  final String apiKey = String.fromCharCodes(
    List<int>.generate(
      _envieddataapiKey.length,
      (int i) => i,
      growable: false,
    ).map((int i) => _envieddataapiKey[i] ^ _enviedkeyapiKey[i]),
  );
}

// coverage:ignore-file
// ignore_for_file: type=lint
// generated_from: env/envied_demo.env
final class _EnviedDemoBuildInfo {
  static const String buildLabel = 'envied-demo';
}
