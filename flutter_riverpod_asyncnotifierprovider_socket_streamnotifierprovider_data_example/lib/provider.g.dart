// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$serverAddressHash() => r'b2570a97b6c05c85cf577613f14056ed6f0af996';

/// See also [serverAddress].
@ProviderFor(serverAddress)
final serverAddressProvider = AutoDisposeProvider<String>.internal(
  serverAddress,
  name: r'serverAddressProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$serverAddressHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ServerAddressRef = AutoDisposeProviderRef<String>;
String _$serverPortHash() => r'e6877d70ff7aa5fe6b74f900e90399a54f7f056d';

/// See also [serverPort].
@ProviderFor(serverPort)
final serverPortProvider = AutoDisposeProvider<int>.internal(
  serverPort,
  name: r'serverPortProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$serverPortHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ServerPortRef = AutoDisposeProviderRef<int>;
String _$listNotifierHash() => r'5cc4f1cccecb033fc9b1dfc12d645088a0dc7d61';

/// See also [ListNotifier].
@ProviderFor(ListNotifier)
final listNotifierProvider =
    AutoDisposeStreamNotifierProvider<ListNotifier, List<int>>.internal(
  ListNotifier.new,
  name: r'listNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$listNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ListNotifier = AutoDisposeStreamNotifier<List<int>>;
String _$tcpClientNotifierHash() => r'52b7fd3ceef74e81842a8c82ebe302b988eb3836';

/// See also [TcpClientNotifier].
@ProviderFor(TcpClientNotifier)
final tcpClientNotifierProvider =
    AutoDisposeAsyncNotifierProvider<TcpClientNotifier, TcpClient>.internal(
  TcpClientNotifier.new,
  name: r'tcpClientNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tcpClientNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TcpClientNotifier = AutoDisposeAsyncNotifier<TcpClient>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
