// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.9.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'package:freezed_annotation/freezed_annotation.dart' hide protected;
part 'simple.freezed.dart';

// These functions are ignored because they are not marked as `pub`: `confirm_vote`, `from`, `handle_ballot`, `store_ballot`, `store_vote`

Future<Election> createElection(
        {required String filepath,
        required String urls,
        required String lwdUrl,
        required String key}) =>
    RustLib.instance.api.crateApiSimpleCreateElection(
        filepath: filepath, urls: urls, lwdUrl: lwdUrl, key: key);

Future<Election> getElection({required String filepath}) =>
    RustLib.instance.api.crateApiSimpleGetElection(filepath: filepath);

Stream<int> download({required String filepath}) =>
    RustLib.instance.api.crateApiSimpleDownload(filepath: filepath);

Future<BigInt> getBalance({required String filepath}) =>
    RustLib.instance.api.crateApiSimpleGetBalance(filepath: filepath);

Future<String> vote(
        {required String filepath,
        required String address,
        required BigInt amount}) =>
    RustLib.instance.api.crateApiSimpleVote(
        filepath: filepath, address: address, amount: amount);

Future<void> synchronize({required String filepath}) =>
    RustLib.instance.api.crateApiSimpleSynchronize(filepath: filepath);

Future<List<Vote>> listVotes({required String filepath}) =>
    RustLib.instance.api.crateApiSimpleListVotes(filepath: filepath);

@freezed
class Choice with _$Choice {
  const factory Choice({
    required String choice,
    required String address,
  }) = _Choice;
}

@freezed
class Election with _$Election {
  const factory Election({
    required String name,
    required int startHeight,
    required int endHeight,
    required String question,
    required List<Choice> candidates,
    required bool signatureRequired,
    required bool downloaded,
  }) = _Election;
}

@freezed
class Vote with _$Vote {
  const factory Vote({
    required String hash,
    required String address,
    required BigInt amount,
    int? height,
  }) = _Vote;
}
