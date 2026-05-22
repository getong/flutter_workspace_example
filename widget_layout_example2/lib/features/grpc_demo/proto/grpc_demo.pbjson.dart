//
//  Generated code. Do not modify.
//  source: grpc_demo.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use profileRequestDescriptor instead')
const ProfileRequest$json = {
  '1': 'ProfileRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'preferred_role', '3': 2, '4': 1, '5': 9, '10': 'preferredRole'},
  ],
};

/// Descriptor for `ProfileRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List profileRequestDescriptor = $convert.base64Decode(
    'Cg5Qcm9maWxlUmVxdWVzdBIXCgd1c2VyX2lkGAEgASgJUgZ1c2VySWQSJQoOcHJlZmVycmVkX3'
    'JvbGUYAiABKAlSDXByZWZlcnJlZFJvbGU=');

@$core.Deprecated('Use profileReplyDescriptor instead')
const ProfileReply$json = {
  '1': 'ProfileReply',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'display_name', '3': 2, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'role', '3': 3, '4': 1, '5': 9, '10': 'role'},
    {'1': 'server_time_iso', '3': 4, '4': 1, '5': 9, '10': 'serverTimeIso'},
    {'1': 'capabilities', '3': 5, '4': 3, '5': 9, '10': 'capabilities'},
  ],
};

/// Descriptor for `ProfileReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List profileReplyDescriptor = $convert.base64Decode(
    'CgxQcm9maWxlUmVwbHkSFwoHdXNlcl9pZBgBIAEoCVIGdXNlcklkEiEKDGRpc3BsYXlfbmFtZR'
    'gCIAEoCVILZGlzcGxheU5hbWUSEgoEcm9sZRgDIAEoCVIEcm9sZRImCg9zZXJ2ZXJfdGltZV9p'
    'c28YBCABKAlSDXNlcnZlclRpbWVJc28SIgoMY2FwYWJpbGl0aWVzGAUgAygJUgxjYXBhYmlsaX'
    'RpZXM=');

@$core.Deprecated('Use buildRequestDescriptor instead')
const BuildRequest$json = {
  '1': 'BuildRequest',
  '2': [
    {'1': 'target', '3': 1, '4': 1, '5': 9, '10': 'target'},
    {'1': 'steps', '3': 2, '4': 1, '5': 5, '10': 'steps'},
  ],
};

/// Descriptor for `BuildRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List buildRequestDescriptor = $convert.base64Decode(
    'CgxCdWlsZFJlcXVlc3QSFgoGdGFyZ2V0GAEgASgJUgZ0YXJnZXQSFAoFc3RlcHMYAiABKAVSBX'
    'N0ZXBz');

@$core.Deprecated('Use buildEventDescriptor instead')
const BuildEvent$json = {
  '1': 'BuildEvent',
  '2': [
    {'1': 'step', '3': 1, '4': 1, '5': 5, '10': 'step'},
    {'1': 'phase', '3': 2, '4': 1, '5': 9, '10': 'phase'},
    {'1': 'detail', '3': 3, '4': 1, '5': 9, '10': 'detail'},
    {'1': 'done', '3': 4, '4': 1, '5': 8, '10': 'done'},
  ],
};

/// Descriptor for `BuildEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List buildEventDescriptor = $convert.base64Decode(
    'CgpCdWlsZEV2ZW50EhIKBHN0ZXAYASABKAVSBHN0ZXASFAoFcGhhc2UYAiABKAlSBXBoYXNlEh'
    'YKBmRldGFpbBgDIAEoCVIGZGV0YWlsEhIKBGRvbmUYBCABKAhSBGRvbmU=');
