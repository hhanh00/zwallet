//
//  Generated code. Do not modify.
//  source: settings.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

class AppSettings extends $pb.GeneratedMessage {
  factory AppSettings({
    $core.int? anchorOffset,
    $core.bool? nogetTx,
    $core.int? rowsPerPage,
    $core.bool? showConfirmations,
    $core.String? currency,
    $core.String? chartRange,
    $core.int? autoHide,
    $core.int? includeReplyTo,
    $core.int? messageView,
    $core.int? noteView,
    $core.int? txView,
    $core.bool? protectSend,
    $core.bool? protectOpen,
    $core.bool? noqrOffline,
    $core.bool? fullPrec,
    $core.int? uaType,
    $core.String? backupEncKey,
    $core.int? developerMode,
    $core.int? minPrivacyLevel,
    $core.bool? sound,
    $core.String? dbPasswd,
    $core.bool? advanced,
  }) {
    final $result = create();
    if (anchorOffset != null) {
      $result.anchorOffset = anchorOffset;
    }
    if (nogetTx != null) {
      $result.nogetTx = nogetTx;
    }
    if (rowsPerPage != null) {
      $result.rowsPerPage = rowsPerPage;
    }
    if (showConfirmations != null) {
      $result.showConfirmations = showConfirmations;
    }
    if (currency != null) {
      $result.currency = currency;
    }
    if (chartRange != null) {
      $result.chartRange = chartRange;
    }
    if (autoHide != null) {
      $result.autoHide = autoHide;
    }
    if (includeReplyTo != null) {
      $result.includeReplyTo = includeReplyTo;
    }
    if (messageView != null) {
      $result.messageView = messageView;
    }
    if (noteView != null) {
      $result.noteView = noteView;
    }
    if (txView != null) {
      $result.txView = txView;
    }
    if (protectSend != null) {
      $result.protectSend = protectSend;
    }
    if (protectOpen != null) {
      $result.protectOpen = protectOpen;
    }
    if (noqrOffline != null) {
      $result.noqrOffline = noqrOffline;
    }
    if (fullPrec != null) {
      $result.fullPrec = fullPrec;
    }
    if (uaType != null) {
      $result.uaType = uaType;
    }
    if (backupEncKey != null) {
      $result.backupEncKey = backupEncKey;
    }
    if (developerMode != null) {
      $result.developerMode = developerMode;
    }
    if (minPrivacyLevel != null) {
      $result.minPrivacyLevel = minPrivacyLevel;
    }
    if (sound != null) {
      $result.sound = sound;
    }
    if (dbPasswd != null) {
      $result.dbPasswd = dbPasswd;
    }
    if (advanced != null) {
      $result.advanced = advanced;
    }
    return $result;
  }
  AppSettings._() : super();
  factory AppSettings.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AppSettings.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AppSettings', package: const $pb.PackageName(_omitMessageNames ? '' : 'pb'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'anchorOffset', $pb.PbFieldType.OU3)
    ..aOB(2, _omitFieldNames ? '' : 'nogetTx')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'rowsPerPage', $pb.PbFieldType.OU3)
    ..aOB(4, _omitFieldNames ? '' : 'showConfirmations')
    ..aOS(5, _omitFieldNames ? '' : 'currency')
    ..aOS(6, _omitFieldNames ? '' : 'chartRange')
    ..a<$core.int>(7, _omitFieldNames ? '' : 'autoHide', $pb.PbFieldType.OU3)
    ..a<$core.int>(8, _omitFieldNames ? '' : 'includeReplyTo', $pb.PbFieldType.OU3)
    ..a<$core.int>(9, _omitFieldNames ? '' : 'messageView', $pb.PbFieldType.OU3)
    ..a<$core.int>(10, _omitFieldNames ? '' : 'noteView', $pb.PbFieldType.OU3)
    ..a<$core.int>(11, _omitFieldNames ? '' : 'txView', $pb.PbFieldType.OU3)
    ..aOB(12, _omitFieldNames ? '' : 'protectSend')
    ..aOB(13, _omitFieldNames ? '' : 'protectOpen')
    ..aOB(14, _omitFieldNames ? '' : 'noqrOffline')
    ..aOB(15, _omitFieldNames ? '' : 'fullPrec')
    ..a<$core.int>(16, _omitFieldNames ? '' : 'uaType', $pb.PbFieldType.OU3)
    ..aOS(17, _omitFieldNames ? '' : 'backupEncKey')
    ..a<$core.int>(18, _omitFieldNames ? '' : 'developerMode', $pb.PbFieldType.OU3)
    ..a<$core.int>(19, _omitFieldNames ? '' : 'minPrivacyLevel', $pb.PbFieldType.OU3)
    ..aOB(20, _omitFieldNames ? '' : 'sound')
    ..aOS(21, _omitFieldNames ? '' : 'dbPasswd')
    ..aOB(22, _omitFieldNames ? '' : 'advanced')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AppSettings clone() => AppSettings()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AppSettings copyWith(void Function(AppSettings) updates) => super.copyWith((message) => updates(message as AppSettings)) as AppSettings;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppSettings create() => AppSettings._();
  AppSettings createEmptyInstance() => create();
  static $pb.PbList<AppSettings> createRepeated() => $pb.PbList<AppSettings>();
  @$core.pragma('dart2js:noInline')
  static AppSettings getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppSettings>(create);
  static AppSettings? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get anchorOffset => $_getIZ(0);
  @$pb.TagNumber(1)
  set anchorOffset($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAnchorOffset() => $_has(0);
  @$pb.TagNumber(1)
  void clearAnchorOffset() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get nogetTx => $_getBF(1);
  @$pb.TagNumber(2)
  set nogetTx($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasNogetTx() => $_has(1);
  @$pb.TagNumber(2)
  void clearNogetTx() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get rowsPerPage => $_getIZ(2);
  @$pb.TagNumber(3)
  set rowsPerPage($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRowsPerPage() => $_has(2);
  @$pb.TagNumber(3)
  void clearRowsPerPage() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get showConfirmations => $_getBF(3);
  @$pb.TagNumber(4)
  set showConfirmations($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasShowConfirmations() => $_has(3);
  @$pb.TagNumber(4)
  void clearShowConfirmations() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get currency => $_getSZ(4);
  @$pb.TagNumber(5)
  set currency($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasCurrency() => $_has(4);
  @$pb.TagNumber(5)
  void clearCurrency() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get chartRange => $_getSZ(5);
  @$pb.TagNumber(6)
  set chartRange($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasChartRange() => $_has(5);
  @$pb.TagNumber(6)
  void clearChartRange() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get autoHide => $_getIZ(6);
  @$pb.TagNumber(7)
  set autoHide($core.int v) { $_setUnsignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasAutoHide() => $_has(6);
  @$pb.TagNumber(7)
  void clearAutoHide() => clearField(7);

  @$pb.TagNumber(8)
  $core.int get includeReplyTo => $_getIZ(7);
  @$pb.TagNumber(8)
  set includeReplyTo($core.int v) { $_setUnsignedInt32(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasIncludeReplyTo() => $_has(7);
  @$pb.TagNumber(8)
  void clearIncludeReplyTo() => clearField(8);

  @$pb.TagNumber(9)
  $core.int get messageView => $_getIZ(8);
  @$pb.TagNumber(9)
  set messageView($core.int v) { $_setUnsignedInt32(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasMessageView() => $_has(8);
  @$pb.TagNumber(9)
  void clearMessageView() => clearField(9);

  @$pb.TagNumber(10)
  $core.int get noteView => $_getIZ(9);
  @$pb.TagNumber(10)
  set noteView($core.int v) { $_setUnsignedInt32(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasNoteView() => $_has(9);
  @$pb.TagNumber(10)
  void clearNoteView() => clearField(10);

  @$pb.TagNumber(11)
  $core.int get txView => $_getIZ(10);
  @$pb.TagNumber(11)
  set txView($core.int v) { $_setUnsignedInt32(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasTxView() => $_has(10);
  @$pb.TagNumber(11)
  void clearTxView() => clearField(11);

  @$pb.TagNumber(12)
  $core.bool get protectSend => $_getBF(11);
  @$pb.TagNumber(12)
  set protectSend($core.bool v) { $_setBool(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasProtectSend() => $_has(11);
  @$pb.TagNumber(12)
  void clearProtectSend() => clearField(12);

  @$pb.TagNumber(13)
  $core.bool get protectOpen => $_getBF(12);
  @$pb.TagNumber(13)
  set protectOpen($core.bool v) { $_setBool(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasProtectOpen() => $_has(12);
  @$pb.TagNumber(13)
  void clearProtectOpen() => clearField(13);

  @$pb.TagNumber(14)
  $core.bool get noqrOffline => $_getBF(13);
  @$pb.TagNumber(14)
  set noqrOffline($core.bool v) { $_setBool(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasNoqrOffline() => $_has(13);
  @$pb.TagNumber(14)
  void clearNoqrOffline() => clearField(14);

  @$pb.TagNumber(15)
  $core.bool get fullPrec => $_getBF(14);
  @$pb.TagNumber(15)
  set fullPrec($core.bool v) { $_setBool(14, v); }
  @$pb.TagNumber(15)
  $core.bool hasFullPrec() => $_has(14);
  @$pb.TagNumber(15)
  void clearFullPrec() => clearField(15);

  @$pb.TagNumber(16)
  $core.int get uaType => $_getIZ(15);
  @$pb.TagNumber(16)
  set uaType($core.int v) { $_setUnsignedInt32(15, v); }
  @$pb.TagNumber(16)
  $core.bool hasUaType() => $_has(15);
  @$pb.TagNumber(16)
  void clearUaType() => clearField(16);

  @$pb.TagNumber(17)
  $core.String get backupEncKey => $_getSZ(16);
  @$pb.TagNumber(17)
  set backupEncKey($core.String v) { $_setString(16, v); }
  @$pb.TagNumber(17)
  $core.bool hasBackupEncKey() => $_has(16);
  @$pb.TagNumber(17)
  void clearBackupEncKey() => clearField(17);

  @$pb.TagNumber(18)
  $core.int get developerMode => $_getIZ(17);
  @$pb.TagNumber(18)
  set developerMode($core.int v) { $_setUnsignedInt32(17, v); }
  @$pb.TagNumber(18)
  $core.bool hasDeveloperMode() => $_has(17);
  @$pb.TagNumber(18)
  void clearDeveloperMode() => clearField(18);

  @$pb.TagNumber(19)
  $core.int get minPrivacyLevel => $_getIZ(18);
  @$pb.TagNumber(19)
  set minPrivacyLevel($core.int v) { $_setUnsignedInt32(18, v); }
  @$pb.TagNumber(19)
  $core.bool hasMinPrivacyLevel() => $_has(18);
  @$pb.TagNumber(19)
  void clearMinPrivacyLevel() => clearField(19);

  @$pb.TagNumber(20)
  $core.bool get sound => $_getBF(19);
  @$pb.TagNumber(20)
  set sound($core.bool v) { $_setBool(19, v); }
  @$pb.TagNumber(20)
  $core.bool hasSound() => $_has(19);
  @$pb.TagNumber(20)
  void clearSound() => clearField(20);

  @$pb.TagNumber(21)
  $core.String get dbPasswd => $_getSZ(20);
  @$pb.TagNumber(21)
  set dbPasswd($core.String v) { $_setString(20, v); }
  @$pb.TagNumber(21)
  $core.bool hasDbPasswd() => $_has(20);
  @$pb.TagNumber(21)
  void clearDbPasswd() => clearField(21);

  @$pb.TagNumber(22)
  $core.bool get advanced => $_getBF(21);
  @$pb.TagNumber(22)
  set advanced($core.bool v) { $_setBool(21, v); }
  @$pb.TagNumber(22)
  $core.bool hasAdvanced() => $_has(21);
  @$pb.TagNumber(22)
  void clearAdvanced() => clearField(22);
}

class CoinSettings extends $pb.GeneratedMessage {
  factory CoinSettings({
    $core.int? serverIndex,
    $core.String? serverCustomURL,
    $core.int? blockExplorerIndex,
    $core.String? blockExplorerCustomURL,
    $core.bool? manualFee,
    $fixnum.Int64? fee,
  }) {
    final $result = create();
    if (serverIndex != null) {
      $result.serverIndex = serverIndex;
    }
    if (serverCustomURL != null) {
      $result.serverCustomURL = serverCustomURL;
    }
    if (blockExplorerIndex != null) {
      $result.blockExplorerIndex = blockExplorerIndex;
    }
    if (blockExplorerCustomURL != null) {
      $result.blockExplorerCustomURL = blockExplorerCustomURL;
    }
    if (manualFee != null) {
      $result.manualFee = manualFee;
    }
    if (fee != null) {
      $result.fee = fee;
    }
    return $result;
  }
  CoinSettings._() : super();
  factory CoinSettings.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CoinSettings.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CoinSettings', package: const $pb.PackageName(_omitMessageNames ? '' : 'pb'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'serverIndex', $pb.PbFieldType.OU3)
    ..aOS(2, _omitFieldNames ? '' : 'serverCustomURL', protoName: 'server_custom_URL')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'blockExplorerIndex', $pb.PbFieldType.OU3)
    ..aOS(4, _omitFieldNames ? '' : 'blockExplorerCustomURL', protoName: 'block_explorer_custom_URL')
    ..aOB(5, _omitFieldNames ? '' : 'manualFee')
    ..a<$fixnum.Int64>(6, _omitFieldNames ? '' : 'fee', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CoinSettings clone() => CoinSettings()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CoinSettings copyWith(void Function(CoinSettings) updates) => super.copyWith((message) => updates(message as CoinSettings)) as CoinSettings;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CoinSettings create() => CoinSettings._();
  CoinSettings createEmptyInstance() => create();
  static $pb.PbList<CoinSettings> createRepeated() => $pb.PbList<CoinSettings>();
  @$core.pragma('dart2js:noInline')
  static CoinSettings getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CoinSettings>(create);
  static CoinSettings? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get serverIndex => $_getIZ(0);
  @$pb.TagNumber(1)
  set serverIndex($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasServerIndex() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerIndex() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get serverCustomURL => $_getSZ(1);
  @$pb.TagNumber(2)
  set serverCustomURL($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasServerCustomURL() => $_has(1);
  @$pb.TagNumber(2)
  void clearServerCustomURL() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get blockExplorerIndex => $_getIZ(2);
  @$pb.TagNumber(3)
  set blockExplorerIndex($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasBlockExplorerIndex() => $_has(2);
  @$pb.TagNumber(3)
  void clearBlockExplorerIndex() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get blockExplorerCustomURL => $_getSZ(3);
  @$pb.TagNumber(4)
  set blockExplorerCustomURL($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasBlockExplorerCustomURL() => $_has(3);
  @$pb.TagNumber(4)
  void clearBlockExplorerCustomURL() => clearField(4);

  @$pb.TagNumber(5)
  $core.bool get manualFee => $_getBF(4);
  @$pb.TagNumber(5)
  set manualFee($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasManualFee() => $_has(4);
  @$pb.TagNumber(5)
  void clearManualFee() => clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get fee => $_getI64(5);
  @$pb.TagNumber(6)
  set fee($fixnum.Int64 v) { $_setInt64(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasFee() => $_has(5);
  @$pb.TagNumber(6)
  void clearFee() => clearField(6);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
