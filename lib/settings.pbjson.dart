//
//  Generated code. Do not modify.
//  source: settings.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use appSettingsDescriptor instead')
const AppSettings$json = {
  '1': 'AppSettings',
  '2': [
    {'1': 'anchor_offset', '3': 1, '4': 1, '5': 13, '10': 'anchorOffset'},
    {'1': 'noget_tx', '3': 2, '4': 1, '5': 8, '10': 'nogetTx'},
    {'1': 'rows_per_page', '3': 3, '4': 1, '5': 13, '10': 'rowsPerPage'},
    {'1': 'show_confirmations', '3': 4, '4': 1, '5': 8, '10': 'showConfirmations'},
    {'1': 'currency', '3': 5, '4': 1, '5': 9, '10': 'currency'},
    {'1': 'chart_range', '3': 6, '4': 1, '5': 9, '10': 'chartRange'},
    {'1': 'auto_hide', '3': 7, '4': 1, '5': 13, '10': 'autoHide'},
    {'1': 'include_reply_to', '3': 8, '4': 1, '5': 13, '10': 'includeReplyTo'},
    {'1': 'message_view', '3': 9, '4': 1, '5': 13, '10': 'messageView'},
    {'1': 'note_view', '3': 10, '4': 1, '5': 13, '10': 'noteView'},
    {'1': 'tx_view', '3': 11, '4': 1, '5': 13, '10': 'txView'},
    {'1': 'protect_send', '3': 12, '4': 1, '5': 8, '10': 'protectSend'},
    {'1': 'protect_open', '3': 13, '4': 1, '5': 8, '10': 'protectOpen'},
    {'1': 'noqr_offline', '3': 14, '4': 1, '5': 8, '10': 'noqrOffline'},
    {'1': 'full_prec', '3': 15, '4': 1, '5': 8, '10': 'fullPrec'},
    {'1': 'ua_type', '3': 16, '4': 1, '5': 13, '10': 'uaType'},
    {'1': 'backup_enc_key', '3': 17, '4': 1, '5': 9, '10': 'backupEncKey'},
    {'1': 'developer_mode', '3': 18, '4': 1, '5': 13, '10': 'developerMode'},
    {'1': 'min_privacy_level', '3': 19, '4': 1, '5': 13, '10': 'minPrivacyLevel'},
    {'1': 'sound', '3': 20, '4': 1, '5': 8, '10': 'sound'},
    {'1': 'db_passwd', '3': 21, '4': 1, '5': 9, '10': 'dbPasswd'},
    {'1': 'advanced', '3': 22, '4': 1, '5': 8, '10': 'advanced'},
    {'1': 'reply_ua', '3': 23, '4': 1, '5': 13, '10': 'replyUa'},
    {'1': 'memo', '3': 24, '4': 1, '5': 9, '10': 'memo'},
  ],
};

/// Descriptor for `AppSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appSettingsDescriptor = $convert.base64Decode(
    'CgtBcHBTZXR0aW5ncxIjCg1hbmNob3Jfb2Zmc2V0GAEgASgNUgxhbmNob3JPZmZzZXQSGQoIbm'
    '9nZXRfdHgYAiABKAhSB25vZ2V0VHgSIgoNcm93c19wZXJfcGFnZRgDIAEoDVILcm93c1BlclBh'
    'Z2USLQoSc2hvd19jb25maXJtYXRpb25zGAQgASgIUhFzaG93Q29uZmlybWF0aW9ucxIaCghjdX'
    'JyZW5jeRgFIAEoCVIIY3VycmVuY3kSHwoLY2hhcnRfcmFuZ2UYBiABKAlSCmNoYXJ0UmFuZ2US'
    'GwoJYXV0b19oaWRlGAcgASgNUghhdXRvSGlkZRIoChBpbmNsdWRlX3JlcGx5X3RvGAggASgNUg'
    '5pbmNsdWRlUmVwbHlUbxIhCgxtZXNzYWdlX3ZpZXcYCSABKA1SC21lc3NhZ2VWaWV3EhsKCW5v'
    'dGVfdmlldxgKIAEoDVIIbm90ZVZpZXcSFwoHdHhfdmlldxgLIAEoDVIGdHhWaWV3EiEKDHByb3'
    'RlY3Rfc2VuZBgMIAEoCFILcHJvdGVjdFNlbmQSIQoMcHJvdGVjdF9vcGVuGA0gASgIUgtwcm90'
    'ZWN0T3BlbhIhCgxub3FyX29mZmxpbmUYDiABKAhSC25vcXJPZmZsaW5lEhsKCWZ1bGxfcHJlYx'
    'gPIAEoCFIIZnVsbFByZWMSFwoHdWFfdHlwZRgQIAEoDVIGdWFUeXBlEiQKDmJhY2t1cF9lbmNf'
    'a2V5GBEgASgJUgxiYWNrdXBFbmNLZXkSJQoOZGV2ZWxvcGVyX21vZGUYEiABKA1SDWRldmVsb3'
    'Blck1vZGUSKgoRbWluX3ByaXZhY3lfbGV2ZWwYEyABKA1SD21pblByaXZhY3lMZXZlbBIUCgVz'
    'b3VuZBgUIAEoCFIFc291bmQSGwoJZGJfcGFzc3dkGBUgASgJUghkYlBhc3N3ZBIaCghhZHZhbm'
    'NlZBgWIAEoCFIIYWR2YW5jZWQSGQoIcmVwbHlfdWEYFyABKA1SB3JlcGx5VWESEgoEbWVtbxgY'
    'IAEoCVIEbWVtbw==');

@$core.Deprecated('Use coinSettingsDescriptor instead')
const CoinSettings$json = {
  '1': 'CoinSettings',
  '2': [
    {'1': 'coin', '3': 1, '4': 1, '5': 13, '10': 'coin'},
    {'1': 'lwd', '3': 2, '4': 1, '5': 11, '6': '.pb.ServerURL', '10': 'lwd'},
    {'1': 'explorer', '3': 3, '4': 1, '5': 11, '6': '.pb.ServerURL', '10': 'explorer'},
    {'1': 'manual_fee', '3': 4, '4': 1, '5': 8, '10': 'manualFee'},
    {'1': 'fee', '3': 5, '4': 1, '5': 4, '10': 'fee'},
    {'1': 'spam_filter', '3': 6, '4': 1, '5': 8, '10': 'spamFilter'},
  ],
};

/// Descriptor for `CoinSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List coinSettingsDescriptor = $convert.base64Decode(
    'CgxDb2luU2V0dGluZ3MSEgoEY29pbhgBIAEoDVIEY29pbhIfCgNsd2QYAiABKAsyDS5wYi5TZX'
    'J2ZXJVUkxSA2x3ZBIpCghleHBsb3JlchgDIAEoCzINLnBiLlNlcnZlclVSTFIIZXhwbG9yZXIS'
    'HQoKbWFudWFsX2ZlZRgEIAEoCFIJbWFudWFsRmVlEhAKA2ZlZRgFIAEoBFIDZmVlEh8KC3NwYW'
    '1fZmlsdGVyGAYgASgIUgpzcGFtRmlsdGVy');

@$core.Deprecated('Use serverURLDescriptor instead')
const ServerURL$json = {
  '1': 'ServerURL',
  '2': [
    {'1': 'index', '3': 1, '4': 1, '5': 17, '10': 'index'},
    {'1': 'custom_URL', '3': 2, '4': 1, '5': 9, '10': 'customURL'},
  ],
};

/// Descriptor for `ServerURL`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serverURLDescriptor = $convert.base64Decode(
    'CglTZXJ2ZXJVUkwSFAoFaW5kZXgYASABKBFSBWluZGV4Eh0KCmN1c3RvbV9VUkwYAiABKAlSCW'
    'N1c3RvbVVSTA==');

