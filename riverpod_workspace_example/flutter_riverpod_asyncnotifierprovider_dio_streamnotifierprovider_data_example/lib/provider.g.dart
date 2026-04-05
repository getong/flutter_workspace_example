// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$urlAddressHash() => r'e39874e79505eb48251932dca28ccc21c87fd023';

/// See also [urlAddress].
@ProviderFor(urlAddress)
final urlAddressProvider = AutoDisposeProvider<String>.internal(
  urlAddress,
  name: r'urlAddressProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$urlAddressHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UrlAddressRef = AutoDisposeProviderRef<String>;
String _$listNotifierHash() => r'ce87fa5922094c7d45ee08a2d3b184a94f37004f';

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
String _$dioClientNotifierHash() => r'a7b7adc51238a25df9853ebe3ae4e8e7cc7d0ddc';

/// See also [DioClientNotifier].
@ProviderFor(DioClientNotifier)
final dioClientNotifierProvider =
    AutoDisposeAsyncNotifierProvider<DioClientNotifier, DioClient>.internal(
  DioClientNotifier.new,
  name: r'dioClientNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dioClientNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DioClientNotifier = AutoDisposeAsyncNotifier<DioClient>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
