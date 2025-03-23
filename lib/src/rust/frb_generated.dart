// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.9.0.

// ignore_for_file: unused_import, unused_element, unnecessary_import, duplicate_ignore, invalid_use_of_internal_member, annotate_overrides, non_constant_identifier_names, curly_braces_in_flow_control_structures, prefer_const_literals_to_create_immutables, unused_field

import 'api/simple.dart';
import 'dart:async';
import 'dart:convert';
import 'frb_generated.dart';
import 'frb_generated.io.dart'
    if (dart.library.js_interop) 'frb_generated.web.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

/// Main entrypoint of the Rust API
class RustLib extends BaseEntrypoint<RustLibApi, RustLibApiImpl, RustLibWire> {
  @internal
  static final instance = RustLib._();

  RustLib._();

  /// Initialize flutter_rust_bridge
  static Future<void> init({
    RustLibApi? api,
    BaseHandler? handler,
    ExternalLibrary? externalLibrary,
  }) async {
    await instance.initImpl(
      api: api,
      handler: handler,
      externalLibrary: externalLibrary,
    );
  }

  /// Initialize flutter_rust_bridge in mock mode.
  /// No libraries for FFI are loaded.
  static void initMock({
    required RustLibApi api,
  }) {
    instance.initMockImpl(
      api: api,
    );
  }

  /// Dispose flutter_rust_bridge
  ///
  /// The call to this function is optional, since flutter_rust_bridge (and everything else)
  /// is automatically disposed when the app stops.
  static void dispose() => instance.disposeImpl();

  @override
  ApiImplConstructor<RustLibApiImpl, RustLibWire> get apiImplConstructor =>
      RustLibApiImpl.new;

  @override
  WireConstructor<RustLibWire> get wireConstructor =>
      RustLibWire.fromExternalLibrary;

  @override
  Future<void> executeRustInitializers() async {
    await api.crateApiSimpleInitApp();
  }

  @override
  ExternalLibraryLoaderConfig get defaultExternalLibraryLoaderConfig =>
      kDefaultExternalLibraryLoaderConfig;

  @override
  String get codegenVersion => '2.9.0';

  @override
  int get rustContentHash => -1968354222;

  static const kDefaultExternalLibraryLoaderConfig =
      ExternalLibraryLoaderConfig(
    stem: 'rust_lib_YWallet',
    ioDirectory: 'rust/target/release/',
    webPrefix: 'pkg/',
  );
}

abstract class RustLibApi extends BaseApi {
  Future<Election> crateApiSimpleCreateElection(
      {required String filepath,
      required String urls,
      required String lwdUrl,
      required String key});

  Stream<int> crateApiSimpleDownload({required String filepath});

  Future<BigInt> crateApiSimpleGetBalance({required String filepath});

  Future<Election> crateApiSimpleGetElection({required String filepath});

  Future<void> crateApiSimpleInitApp();

  Future<List<Vote>> crateApiSimpleListVotes({required String filepath});

  Future<void> crateApiSimpleSynchronize({required String filepath});

  Future<String> crateApiSimpleVote(
      {required String filepath,
      required String address,
      required BigInt amount});
}

class RustLibApiImpl extends RustLibApiImplPlatform implements RustLibApi {
  RustLibApiImpl({
    required super.handler,
    required super.wire,
    required super.generalizedFrbRustBinding,
    required super.portManager,
  });

  @override
  Future<Election> crateApiSimpleCreateElection(
      {required String filepath,
      required String urls,
      required String lwdUrl,
      required String key}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_String(filepath, serializer);
        sse_encode_String(urls, serializer);
        sse_encode_String(lwdUrl, serializer);
        sse_encode_String(key, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 1, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_election,
        decodeErrorData: sse_decode_AnyhowException,
      ),
      constMeta: kCrateApiSimpleCreateElectionConstMeta,
      argValues: [filepath, urls, lwdUrl, key],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiSimpleCreateElectionConstMeta =>
      const TaskConstMeta(
        debugName: "create_election",
        argNames: ["filepath", "urls", "lwdUrl", "key"],
      );

  @override
  Stream<int> crateApiSimpleDownload({required String filepath}) {
    final height = RustStreamSink<int>();
    unawaited(handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_String(filepath, serializer);
        sse_encode_StreamSink_u_32_Sse(height, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 2, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: sse_decode_AnyhowException,
      ),
      constMeta: kCrateApiSimpleDownloadConstMeta,
      argValues: [filepath, height],
      apiImpl: this,
    )));
    return height.stream;
  }

  TaskConstMeta get kCrateApiSimpleDownloadConstMeta => const TaskConstMeta(
        debugName: "download",
        argNames: ["filepath", "height"],
      );

  @override
  Future<BigInt> crateApiSimpleGetBalance({required String filepath}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_String(filepath, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 3, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_u_64,
        decodeErrorData: sse_decode_AnyhowException,
      ),
      constMeta: kCrateApiSimpleGetBalanceConstMeta,
      argValues: [filepath],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiSimpleGetBalanceConstMeta => const TaskConstMeta(
        debugName: "get_balance",
        argNames: ["filepath"],
      );

  @override
  Future<Election> crateApiSimpleGetElection({required String filepath}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_String(filepath, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 4, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_election,
        decodeErrorData: sse_decode_AnyhowException,
      ),
      constMeta: kCrateApiSimpleGetElectionConstMeta,
      argValues: [filepath],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiSimpleGetElectionConstMeta => const TaskConstMeta(
        debugName: "get_election",
        argNames: ["filepath"],
      );

  @override
  Future<void> crateApiSimpleInitApp() {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 5, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: null,
      ),
      constMeta: kCrateApiSimpleInitAppConstMeta,
      argValues: [],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiSimpleInitAppConstMeta => const TaskConstMeta(
        debugName: "init_app",
        argNames: [],
      );

  @override
  Future<List<Vote>> crateApiSimpleListVotes({required String filepath}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_String(filepath, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 6, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_list_vote,
        decodeErrorData: sse_decode_AnyhowException,
      ),
      constMeta: kCrateApiSimpleListVotesConstMeta,
      argValues: [filepath],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiSimpleListVotesConstMeta => const TaskConstMeta(
        debugName: "list_votes",
        argNames: ["filepath"],
      );

  @override
  Future<void> crateApiSimpleSynchronize({required String filepath}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_String(filepath, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 7, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: sse_decode_AnyhowException,
      ),
      constMeta: kCrateApiSimpleSynchronizeConstMeta,
      argValues: [filepath],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiSimpleSynchronizeConstMeta => const TaskConstMeta(
        debugName: "synchronize",
        argNames: ["filepath"],
      );

  @override
  Future<String> crateApiSimpleVote(
      {required String filepath,
      required String address,
      required BigInt amount}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_String(filepath, serializer);
        sse_encode_String(address, serializer);
        sse_encode_u_64(amount, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 8, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_String,
        decodeErrorData: sse_decode_AnyhowException,
      ),
      constMeta: kCrateApiSimpleVoteConstMeta,
      argValues: [filepath, address, amount],
      apiImpl: this,
    ));
  }

  TaskConstMeta get kCrateApiSimpleVoteConstMeta => const TaskConstMeta(
        debugName: "vote",
        argNames: ["filepath", "address", "amount"],
      );

  @protected
  AnyhowException dco_decode_AnyhowException(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return AnyhowException(raw as String);
  }

  @protected
  RustStreamSink<int> dco_decode_StreamSink_u_32_Sse(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    throw UnimplementedError();
  }

  @protected
  String dco_decode_String(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as String;
  }

  @protected
  bool dco_decode_bool(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as bool;
  }

  @protected
  int dco_decode_box_autoadd_u_32(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as int;
  }

  @protected
  Choice dco_decode_choice(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    final arr = raw as List<dynamic>;
    if (arr.length != 2)
      throw Exception('unexpected arr length: expect 2 but see ${arr.length}');
    return Choice(
      choice: dco_decode_String(arr[0]),
      address: dco_decode_String(arr[1]),
    );
  }

  @protected
  Election dco_decode_election(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    final arr = raw as List<dynamic>;
    if (arr.length != 8)
      throw Exception('unexpected arr length: expect 8 but see ${arr.length}');
    return Election(
      name: dco_decode_String(arr[0]),
      startHeight: dco_decode_u_32(arr[1]),
      endHeight: dco_decode_u_32(arr[2]),
      question: dco_decode_String(arr[3]),
      candidates: dco_decode_list_choice(arr[4]),
      signatureRequired: dco_decode_bool(arr[5]),
      address: dco_decode_String(arr[6]),
      downloaded: dco_decode_bool(arr[7]),
    );
  }

  @protected
  List<Choice> dco_decode_list_choice(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return (raw as List<dynamic>).map(dco_decode_choice).toList();
  }

  @protected
  Uint8List dco_decode_list_prim_u_8_strict(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as Uint8List;
  }

  @protected
  List<Vote> dco_decode_list_vote(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return (raw as List<dynamic>).map(dco_decode_vote).toList();
  }

  @protected
  int? dco_decode_opt_box_autoadd_u_32(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw == null ? null : dco_decode_box_autoadd_u_32(raw);
  }

  @protected
  int dco_decode_u_32(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as int;
  }

  @protected
  BigInt dco_decode_u_64(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return dcoDecodeU64(raw);
  }

  @protected
  int dco_decode_u_8(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as int;
  }

  @protected
  void dco_decode_unit(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return;
  }

  @protected
  Vote dco_decode_vote(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    final arr = raw as List<dynamic>;
    if (arr.length != 4)
      throw Exception('unexpected arr length: expect 4 but see ${arr.length}');
    return Vote(
      hash: dco_decode_String(arr[0]),
      address: dco_decode_String(arr[1]),
      amount: dco_decode_u_64(arr[2]),
      height: dco_decode_opt_box_autoadd_u_32(arr[3]),
    );
  }

  @protected
  AnyhowException sse_decode_AnyhowException(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var inner = sse_decode_String(deserializer);
    return AnyhowException(inner);
  }

  @protected
  RustStreamSink<int> sse_decode_StreamSink_u_32_Sse(
      SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    throw UnimplementedError('Unreachable ()');
  }

  @protected
  String sse_decode_String(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var inner = sse_decode_list_prim_u_8_strict(deserializer);
    return utf8.decoder.convert(inner);
  }

  @protected
  bool sse_decode_bool(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getUint8() != 0;
  }

  @protected
  int sse_decode_box_autoadd_u_32(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return (sse_decode_u_32(deserializer));
  }

  @protected
  Choice sse_decode_choice(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var var_choice = sse_decode_String(deserializer);
    var var_address = sse_decode_String(deserializer);
    return Choice(choice: var_choice, address: var_address);
  }

  @protected
  Election sse_decode_election(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var var_name = sse_decode_String(deserializer);
    var var_startHeight = sse_decode_u_32(deserializer);
    var var_endHeight = sse_decode_u_32(deserializer);
    var var_question = sse_decode_String(deserializer);
    var var_candidates = sse_decode_list_choice(deserializer);
    var var_signatureRequired = sse_decode_bool(deserializer);
    var var_address = sse_decode_String(deserializer);
    var var_downloaded = sse_decode_bool(deserializer);
    return Election(
        name: var_name,
        startHeight: var_startHeight,
        endHeight: var_endHeight,
        question: var_question,
        candidates: var_candidates,
        signatureRequired: var_signatureRequired,
        address: var_address,
        downloaded: var_downloaded);
  }

  @protected
  List<Choice> sse_decode_list_choice(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs

    var len_ = sse_decode_i_32(deserializer);
    var ans_ = <Choice>[];
    for (var idx_ = 0; idx_ < len_; ++idx_) {
      ans_.add(sse_decode_choice(deserializer));
    }
    return ans_;
  }

  @protected
  Uint8List sse_decode_list_prim_u_8_strict(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var len_ = sse_decode_i_32(deserializer);
    return deserializer.buffer.getUint8List(len_);
  }

  @protected
  List<Vote> sse_decode_list_vote(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs

    var len_ = sse_decode_i_32(deserializer);
    var ans_ = <Vote>[];
    for (var idx_ = 0; idx_ < len_; ++idx_) {
      ans_.add(sse_decode_vote(deserializer));
    }
    return ans_;
  }

  @protected
  int? sse_decode_opt_box_autoadd_u_32(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs

    if (sse_decode_bool(deserializer)) {
      return (sse_decode_box_autoadd_u_32(deserializer));
    } else {
      return null;
    }
  }

  @protected
  int sse_decode_u_32(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getUint32();
  }

  @protected
  BigInt sse_decode_u_64(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getBigUint64();
  }

  @protected
  int sse_decode_u_8(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getUint8();
  }

  @protected
  void sse_decode_unit(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
  }

  @protected
  Vote sse_decode_vote(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var var_hash = sse_decode_String(deserializer);
    var var_address = sse_decode_String(deserializer);
    var var_amount = sse_decode_u_64(deserializer);
    var var_height = sse_decode_opt_box_autoadd_u_32(deserializer);
    return Vote(
        hash: var_hash,
        address: var_address,
        amount: var_amount,
        height: var_height);
  }

  @protected
  int sse_decode_i_32(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getInt32();
  }

  @protected
  void sse_encode_AnyhowException(
      AnyhowException self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_String(self.message, serializer);
  }

  @protected
  void sse_encode_StreamSink_u_32_Sse(
      RustStreamSink<int> self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_String(
        self.setupAndSerialize(
            codec: SseCodec(
          decodeSuccessData: sse_decode_u_32,
          decodeErrorData: sse_decode_AnyhowException,
        )),
        serializer);
  }

  @protected
  void sse_encode_String(String self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_list_prim_u_8_strict(utf8.encoder.convert(self), serializer);
  }

  @protected
  void sse_encode_bool(bool self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putUint8(self ? 1 : 0);
  }

  @protected
  void sse_encode_box_autoadd_u_32(int self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_u_32(self, serializer);
  }

  @protected
  void sse_encode_choice(Choice self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_String(self.choice, serializer);
    sse_encode_String(self.address, serializer);
  }

  @protected
  void sse_encode_election(Election self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_String(self.name, serializer);
    sse_encode_u_32(self.startHeight, serializer);
    sse_encode_u_32(self.endHeight, serializer);
    sse_encode_String(self.question, serializer);
    sse_encode_list_choice(self.candidates, serializer);
    sse_encode_bool(self.signatureRequired, serializer);
    sse_encode_String(self.address, serializer);
    sse_encode_bool(self.downloaded, serializer);
  }

  @protected
  void sse_encode_list_choice(List<Choice> self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_i_32(self.length, serializer);
    for (final item in self) {
      sse_encode_choice(item, serializer);
    }
  }

  @protected
  void sse_encode_list_prim_u_8_strict(
      Uint8List self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_i_32(self.length, serializer);
    serializer.buffer.putUint8List(self);
  }

  @protected
  void sse_encode_list_vote(List<Vote> self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_i_32(self.length, serializer);
    for (final item in self) {
      sse_encode_vote(item, serializer);
    }
  }

  @protected
  void sse_encode_opt_box_autoadd_u_32(int? self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs

    sse_encode_bool(self != null, serializer);
    if (self != null) {
      sse_encode_box_autoadd_u_32(self, serializer);
    }
  }

  @protected
  void sse_encode_u_32(int self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putUint32(self);
  }

  @protected
  void sse_encode_u_64(BigInt self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putBigUint64(self);
  }

  @protected
  void sse_encode_u_8(int self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putUint8(self);
  }

  @protected
  void sse_encode_unit(void self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
  }

  @protected
  void sse_encode_vote(Vote self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_String(self.hash, serializer);
    sse_encode_String(self.address, serializer);
    sse_encode_u_64(self.amount, serializer);
    sse_encode_opt_box_autoadd_u_32(self.height, serializer);
  }

  @protected
  void sse_encode_i_32(int self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putInt32(self);
  }
}
