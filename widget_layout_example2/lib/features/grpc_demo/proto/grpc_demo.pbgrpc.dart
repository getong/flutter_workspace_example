//
//  Generated code. Do not modify.
//  source: grpc_demo.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'grpc_demo.pb.dart' as $0;

export 'grpc_demo.pb.dart';

@$pb.GrpcServiceName('widget_layout_example2.grpc_demo.GrpcDemoService')
class GrpcDemoServiceClient extends $grpc.Client {
  static final _$unaryProfile =
      $grpc.ClientMethod<$0.ProfileRequest, $0.ProfileReply>(
          '/widget_layout_example2.grpc_demo.GrpcDemoService/UnaryProfile',
          ($0.ProfileRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.ProfileReply.fromBuffer(value));
  static final _$watchBuild =
      $grpc.ClientMethod<$0.BuildRequest, $0.BuildEvent>(
          '/widget_layout_example2.grpc_demo.GrpcDemoService/WatchBuild',
          ($0.BuildRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.BuildEvent.fromBuffer(value));

  GrpcDemoServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.ProfileReply> unaryProfile($0.ProfileRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$unaryProfile, request, options: options);
  }

  $grpc.ResponseStream<$0.BuildEvent> watchBuild($0.BuildRequest request,
      {$grpc.CallOptions? options}) {
    return $createStreamingCall(
        _$watchBuild, $async.Stream.fromIterable([request]),
        options: options);
  }
}

@$pb.GrpcServiceName('widget_layout_example2.grpc_demo.GrpcDemoService')
abstract class GrpcDemoServiceBase extends $grpc.Service {
  $core.String get $name => 'widget_layout_example2.grpc_demo.GrpcDemoService';

  GrpcDemoServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ProfileRequest, $0.ProfileReply>(
        'UnaryProfile',
        unaryProfile_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ProfileRequest.fromBuffer(value),
        ($0.ProfileReply value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.BuildRequest, $0.BuildEvent>(
        'WatchBuild',
        watchBuild_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.BuildRequest.fromBuffer(value),
        ($0.BuildEvent value) => value.writeToBuffer()));
  }

  $async.Future<$0.ProfileReply> unaryProfile_Pre(
      $grpc.ServiceCall call, $async.Future<$0.ProfileRequest> request) async {
    return unaryProfile(call, await request);
  }

  $async.Stream<$0.BuildEvent> watchBuild_Pre(
      $grpc.ServiceCall call, $async.Future<$0.BuildRequest> request) async* {
    yield* watchBuild(call, await request);
  }

  $async.Future<$0.ProfileReply> unaryProfile(
      $grpc.ServiceCall call, $0.ProfileRequest request);
  $async.Stream<$0.BuildEvent> watchBuild(
      $grpc.ServiceCall call, $0.BuildRequest request);
}
