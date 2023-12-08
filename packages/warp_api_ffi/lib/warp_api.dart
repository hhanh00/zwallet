import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:flat_buffers/flat_buffers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:ffi/ffi.dart';
import 'warp_api_generated.dart' hide bool;
import 'data_fb_generated.dart';

typedef report_callback = Void Function(Int32);

const DAY_SEC = 24 * 3600;
const DAY_MS = DAY_SEC * 1000;
const DEFAULT_ACCOUNT = 1;

final warp_api_lib = init();

NativeLibrary init() {
  var lib = NativeLibrary(WarpApi.open());
  lib.dart_post_cobject(NativeApi.postCObject.cast());
  return lib;
}

Pointer<Char> toNative(String s) {
  return s.toNativeUtf8().cast<Char>();
}

Pointer<Uint8> toNativeBytes(Uint8List bytes) {
  final len = bytes.length;
  final ptr = malloc.allocate<Uint8>(bytes.length);
  final list = ptr.asTypedList(bytes.length);
  for (var i = 0; i < len; i++) {
    list[i] = bytes[i];
  }
  return ptr;
}

bool unwrapResultBool(CResult_bool r) {
  if (r.error != nullptr) throw convertCString(r.error);
  return r.value != 0;
}

int unwrapResultU8(CResult_u8 r) {
  if (r.error != nullptr) throw convertCString(r.error);
  return r.value;
}

int unwrapResultU32(CResult_u32 r) {
  if (r.error != nullptr) throw convertCString(r.error);
  return r.value;
}

int unwrapResultU64(CResult_u64 r) {
  if (r.error != nullptr) throw convertCString(r.error);
  return r.value;
}

String unwrapResultString(CResult_____c_char r) {
  if (r.error != nullptr) throw convertCString(r.error);
  return convertCString(r.value);
}

List<int> unwrapResultBytes(CResult______u8 r) {
  if (r.error != nullptr) throw convertCString(r.error);
  return convertBytes(r.value, r.len);
}

class WarpApi {
  static const MethodChannel _channel = const MethodChannel('warp_api');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static DynamicLibrary open() {
    if (Platform.isAndroid) return DynamicLibrary.open('libwarp_api_ffi.so');
    if (Platform.isIOS) return DynamicLibrary.executable();
    if (Platform.isWindows) return DynamicLibrary.open('warp_api_ffi.dll');
    if (Platform.isLinux) return DynamicLibrary.open('libwarp_api_ffi.so');
    if (Platform.isMacOS) return DynamicLibrary.open('libwarp_api_ffi.dylib');
    throw UnsupportedError('This platform is not supported.');
  }

  static void migrateWallet(int coin, String dbPath) {
    unwrapResultU8(warp_api_lib.migrate_db(coin, toNative(dbPath)));
  }

  static void migrateData(int coin) {
    unwrapResultU8(warp_api_lib.migrate_data_db(coin));
  }

  static void initWallet(int coin, String dbPath) {
    unwrapResultU8(warp_api_lib.init_wallet(coin, toNative(dbPath)));
  }

  static void mempoolRun(int port) {
    compute(mempoolRunIsolateFn, port);
  }

  static Future<int> newAccount(
      int coin, String name, String key, int index) async {
    return await compute(
        (_) => unwrapResultU32(warp_api_lib.new_account(
            coin,
            toNative(name),
            toNative(key),
            index)),
        null);
  }

  static String ledgerGetFVK(int coin) {
    return unwrapResultString(warp_api_lib.ledger_get_fvk(coin));
  }

  static void convertToWatchOnly(int coin, int id) {
    warp_api_lib.convert_to_watchonly(coin, id);
  }

  static Backup getBackup(int coin, int id) {
    final r = unwrapResultBytes(warp_api_lib.get_backup(coin, id));
    final backup = Backup(r);
    return backup;
  }

  static void setBackupReminder(int coin, int id, bool v) {
    warp_api_lib.set_backup_reminder(coin, id, v ? 1 : 0);
  }

  static String getAddress(int coin, int id, int uaType) {
    final address = warp_api_lib.get_address(coin, id, uaType);
    return unwrapResultString(address);
  }

  static int receiversOfAddress(int coin, String address) {
    return warp_api_lib.receivers_of_address(coin, toNative(address));
  }

  static void importTransparentPath(int coin, int id, String path) {
    warp_api_lib.import_transparent_key(
        coin, id, toNative(path));
  }

  static void importTransparentSecretKey(int coin, int id, String key) {
    warp_api_lib.import_transparent_secret_key(
        coin, id, toNative(key));
  }

  static void importFromZWL(int coin, String name, String path) {
    warp_api_lib.import_from_zwl(coin, toNative(name),
        toNative(path));
  }

  static Future<void> skipToLastHeight(int coin) async {
    await compute((_) => warp_api_lib.skip_to_last_height(coin), null);
  }

  static int rewindTo(int coin, int height) {
    return unwrapResultU32(warp_api_lib.rewind_to(coin, height));
  }

  static void rescanFrom(int height) {
    warp_api_lib.rescan_from(height);
  }

  static int warpSync(SyncParams params) {
    final res = warp_api_lib.warp(params.coin, params.getTx ? 1 : 0,
        params.anchorOffset, params.maxCost, params.port!.nativePort);
    params.port!.send(null);
    return unwrapResultU8(res);
  }

  static Future<int> warpSync2(
      int coin, bool getTx, int anchorOffset, int maxCost, int port) async {
    final res = await compute(
        (_) =>
            warp_api_lib.warp(coin, getTx ? 1 : 0, anchorOffset, maxCost, port),
        null);
    return unwrapResultU8(res);
  }

  static void cancelSync() {
    warp_api_lib.cancel_warp();
  }

  static Future<int> getLatestHeight(int coin) async {
    return await compute(
        (_) => unwrapResultU32(warp_api_lib.get_latest_height(coin)), null);
  }

  static bool validSeed(int coin, String seed) {
    return warp_api_lib.is_valid_seed(coin, toNative(seed)) != 0;
  }

  static int validKey(int coin, String key) {
    return warp_api_lib.is_valid_key(coin, toNative(key));
  }

  static bool validAddress(int coin, String address) {
    return warp_api_lib.valid_address(coin, toNative(address)) != 0;
  }

  static String getDiversifiedAddress(int coin, int account, int uaType, int time) {
    final address = warp_api_lib.get_diversified_address(coin, account, uaType, time);
    return unwrapResultString(address);
  }

  static bool checkAccount(int coin, int account) {
    return account != 0 && warp_api_lib.check_account(coin, account) != 0;
  }

  // static Future<String> sendPayment(
  //     int coin,
  //     int account,
  //     List<Recipient> recipients,
  //     bool useTransparent,
  //     int anchorOffset,
  //     void Function(int) f) async {
  //   var receivePort = ReceivePort();
  //   receivePort.listen((progress) {
  //     f(progress);
  //   });
  //
  //   final recipientJson = jsonEncode(recipients);
  //
  //   return await compute(
  //       sendPaymentIsolateFn,
  //       PaymentParams(coin, account,
  //           recipientJson, useTransparent, anchorOffset, receivePort.sendPort));
  // }

  static PoolBalance getPoolBalances(
      int coin, int account, int confirmations, bool include_unconfirmed) {
    final bb = warp_api_lib.get_pool_balances(
        coin, account, confirmations, include_unconfirmed ? 1 : 0);
    final r = unwrapResultBytes(bb);
    return PoolBalance(r);
  }

  static Future<int> getTBalance(int coin, int account) async {
    return await compute((_) {
      final balance = warp_api_lib.get_taddr_balance(coin, account);
      return unwrapResultU64(balance);
    }, null);
  }

  static Future<int> getTBalanceAsync(int coin, int account) async {
    final balance =
        await compute(getTBalanceIsolateFn, GetTBalanceParams(coin, account));
    return balance;
  }

  static Future<String> transferPools(
      int coin,
      int account,
      int fromPool,
      int toPool,
      int amount,
      bool includeFee,
      String memo,
      int splitAmount,
      int anchorOffset,
      FeeT fee) async {
    final txId = await compute(
        transferPoolsIsolateFn,
        TransferPoolsParams(coin, account, fromPool, toPool, amount, includeFee,
            memo, splitAmount, anchorOffset, fee));
    return txId;
  }

  static String shieldTAddr(
      int coin, int account, int amount, int anchorOffset, FeeT fee) {
    final fee2 = encodeFee(fee);
    final txPlan = warp_api_lib.shield_taddr(coin, account, amount,
        anchorOffset, toNativeBytes(fee2), fee2.lengthInBytes);
    return unwrapResultString(txPlan);
  }

  static Future<String> prepareTx(
      int coin,
      int account,
      List<Recipient> recipients,
      int pools,
      int senderUAType,
      int anchorOffset,
      FeeT fee) async {
    final builder = Builder();
    final rs = recipients.map((r) => r.unpack()).toList();
    int root = RecipientsT(values: rs).pack(builder);
    builder.finish(root);
    final fee2 = encodeFee(fee);
    return await compute((_) {
      final res = warp_api_lib.prepare_multi_payment(
          coin,
          account,
          toNativeBytes(builder.buffer),
          builder.size(),
          pools,
          senderUAType,
          anchorOffset,
          toNativeBytes(fee2),
          fee2.lengthInBytes);
      final json = unwrapResultString(res);
      return json;
    }, null);
  }

  static TxReport transactionReport(int coin, String plan) {
    final data = unwrapResultBytes(
        warp_api_lib.transaction_report(coin, toNative(plan)));
    final report = TxReport(data);
    return report;
  }

  static Future<String> signAndBroadcast(
      int coin, int account, String plan) async {
    return await compute((_) {
      final txid = warp_api_lib.sign_and_broadcast(
          coin, account, toNative(plan));
      return unwrapResultString(txid);
    }, null);
  }

  static Future<String> signOnly(
      int coin, int account, String tx, {void Function(int)? progressFn}) async {
    var receivePort = ReceivePort();
    receivePort.listen((progress) {
      progressFn?.call(progress);
    });
    int nativePort = receivePort.sendPort.nativePort;

    return await compute((_) {
      final txIdRes = unwrapResultString(warp_api_lib.sign(coin, account,
          toNative(tx), nativePort));
      return txIdRes;
    }, null);
  }

  static String broadcast(int coin, String txStr) {
    final res =
        warp_api_lib.broadcast_tx(coin, toNative(txStr));
    return unwrapResultString(res);
  }

  static bool isValidTransparentKey(String key) {
    return warp_api_lib.is_valid_tkey(toNative(key)) != 0;
  }

  static Future<String> sweepTransparent(int coin, int account, int latestHeight, String sk, int pool,
      String address, FeeT fee) async {
    return await compute((_) {
      final fee2 = encodeFee(fee);
      final txid = warp_api_lib.sweep_tkey(coin, account, latestHeight, toNative(sk), pool,
          toNative(address), toNativeBytes(fee2), fee2.lengthInBytes);
      return unwrapResultString(txid);
    }, null);
  }

  static Future<String> sweepTransparentSeed(int coin, int account, int latestHeight, String seed, int pool,
      String address, int index, int limit, FeeT fee) async {
    return await compute((_) {
      final fee2 = encodeFee(fee);
      final txid = warp_api_lib.sweep_tseed(coin, account, latestHeight, toNative(seed), pool,
          toNative(address), index, limit, toNativeBytes(fee2), fee2.lengthInBytes);
      return unwrapResultString(txid);
    }, null);
  }

  // static String ledgerSign(int coin, String txFilename) {
  //   final res = warp_api_lib.ledger_sign(coin, toNative(txFilename));
  //   return res.cast<Utf8>().toDartString();
  // }

  static DateTime getActivationDate() {
    final res = unwrapResultU32(warp_api_lib.get_activation_date());
    return DateTime.fromMillisecondsSinceEpoch(res * 1000);
  }

  static Future<int> getBlockHeightByTime(int coin, DateTime time) async {
    final res = await compute(
        (_) => warp_api_lib.get_block_by_time(
            coin, time.millisecondsSinceEpoch ~/ 1000),
        null);
    return unwrapResultU32(res);
  }

  static void setDbPasswd(int coin, String passwd) {
    warp_api_lib.set_coin_passwd(coin, toNative(passwd));
  }

  static void updateLWD(int coin, String url) {
    warp_api_lib.set_coin_lwd_url(coin, toNative(url));
  }

  static String getLWD(int coin) {
    return convertCString(warp_api_lib.get_lwd_url(coin));
  }

  static void storeContact(int id, String name, String address, bool dirty) {
    warp_api_lib.store_contact(id, toNative(name),
        toNative(address), dirty ? 1 : 0);
  }

  static String commitUnsavedContacts(int coin, int account, int anchorOffset, FeeT fee) {
    final fee2 = encodeFee(fee);
    return unwrapResultString(warp_api_lib.commit_unsaved_contacts(
        coin, account, anchorOffset, toNativeBytes(fee2), fee2.lengthInBytes));
  }

  static void markMessageAsRead(int coin, int messageId, bool read) {
    warp_api_lib.mark_message_read(coin, messageId, read ? 1 : 0);
  }

  static void markAllMessagesAsRead(int coin, int account, bool read) {
    warp_api_lib.mark_all_messages_read(coin, account, read ? 1 : 0);
  }

  static void truncateData() {
    warp_api_lib.truncate_data();
  }

  static void truncateSyncData() {
    warp_api_lib.truncate_sync_data();
  }

  static void deleteAccount(int coin, int account) {
    warp_api_lib.delete_account(coin, account);
  }

  static int getFirstAccount(int coin) {
    return unwrapResultU32(warp_api_lib.get_first_account(coin));
  }

  static String makePaymentURI(
      int coin, String address, int amount, String memo) {
    final uri = warp_api_lib.make_payment_uri(
        coin, toNative(address), amount, toNative(memo));
    return unwrapResultString(uri);
  }

  static PaymentUri? decodePaymentURI(int coin, String uri) {
    try {
      final data =
          unwrapResultBytes(warp_api_lib.decode_payment_uri(coin, toNative(uri)));
      return PaymentUri(data);
    }
    catch (_) {
      return null;
    }
  }

  static Future<Agekeys> generateKey() async {
    final keys = await compute((_) => unwrapResultBytes(warp_api_lib.generate_key()), null);
    final ageKeys = Agekeys(keys);
    return ageKeys;
  }

  static void zipBackup(String key, String filename, String tmpDir) {
    final r = warp_api_lib.zip_backup(
        toNative(key), toNative(filename), toNative(tmpDir));
    unwrapResultU8(r);
  }

  static String decryptBackup(String key, String path, String tempDir) {
    return unwrapResultString(warp_api_lib.decrypt_backup(
        toNative(key), toNative(path), toNative(tempDir)));
  }

  static void unzipBackup(String path, String dbDir) {
    unwrapResultU8(warp_api_lib.unzip_backup(toNative(path), toNative(dbDir)));
  }

  static List<String> splitData(int id, String data) {
    final res = unwrapResultBytes(
        warp_api_lib.split_data(id, toNative(data)));
    final raptorq = RaptorQdrops(res);
    return raptorq.drops!;
  }

  static RaptorQresultT mergeData(String drop) {
    final res = unwrapResultBytes(
        warp_api_lib.merge_data(toNative(drop)));
    final raptorqResult = RaptorQresult(res);
    return raptorqResult.unpack();
  }

  static String getTxSummary(String tx) {
    return unwrapResultString(
        warp_api_lib.get_tx_summary(toNative(tx)));
  }

  static Future<KeyPack> deriveZip32(int coin, int idAccount, int accountIndex,
      int externalIndex, int? addressIndex) async {
    final res = await compute((_) => unwrapResultBytes(warp_api_lib.derive_zip32(
        coin,
        idAccount,
        accountIndex,
        externalIndex,
        addressIndex != null ? 1 : 0,
        addressIndex ?? 0)), null);
    final kp = KeyPack(res);
    return kp;
  }

  static void ledgerBuildKeys() {
    unwrapResultU8(warp_api_lib.ledger_build_keys());
  }

  static String ledgerGetAddress() {
    return unwrapResultString(warp_api_lib.ledger_get_address());
  }

  static Future<String> ledgerSend(int coin, String txPlan) async {
    return await compute((_) {
      return unwrapResultString(
          warp_api_lib.ledger_send(coin, toNative(txPlan)));
    }, null);
  }

  static bool hasCuda() {
    return warp_api_lib.has_cuda() != 0;
  }

  static bool hasMetal() {
    return warp_api_lib.has_metal() != 0;
  }

  static bool hasGPU() {
    return warp_api_lib.has_gpu() != 0;
  }

  static void useGPU(bool v) {
    warp_api_lib.use_gpu(v ? 1 : 0);
  }

  static List<Account> getAccountList(int coin) {
    final r = unwrapResultBytes(warp_api_lib.get_account_list(coin));
    return AccountVec(r).accounts!;
  }

  static int countAccounts(int coin) {
    final r = unwrapResultU32(warp_api_lib.count_accounts(coin));
    return r;
  }

  static String getTAddr(int coin, int id) {
    return unwrapResultString(warp_api_lib.get_t_addr(coin, id));
  }

  static String getSK(int coin, int id) {
    return unwrapResultString(warp_api_lib.get_sk(coin, id));
  }

  static void updateAccountName(int coin, int id, String name) {
    warp_api_lib.update_account_name(coin, id, toNative(name));
  }

  static Balance getBalance(int coin, int id, int confirmedHeight) {
    final r =
        unwrapResultBytes(warp_api_lib.get_balances(coin, id, confirmedHeight));
    final b = Balance(r);
    return b;
  }

  static Height getDbHeight(int coin) {
    final r = unwrapResultBytes(warp_api_lib.get_db_height(coin));
    final h = Height(r);
    return h;
  }

  static Future<List<ShieldedNote>> getNotes(int coin, int id) async {
    return await compute((_) {
      final r = unwrapResultBytes(warp_api_lib.get_notes(coin, id));
      final ns = ShieldedNoteVec(r);
      return ns.notes!;
    }, null);
  }

  static Future<List<ShieldedTx>> getTxs(int coin, int id) async {
    return await compute((_) {
      final r = unwrapResultBytes(warp_api_lib.get_txs(coin, id));
      final txs = ShieldedTxVec(r);
      return txs.txs!;
    }, null);
  }

  static Future<List<Message>> getMessages(int coin, int id) async {
    return await compute((_) {
      final r = unwrapResultBytes(warp_api_lib.get_messages(coin, id));
      final msgs = MessageVec(r);
      return msgs.messages!;
    }, null);
  }

  static List<ShieldedNote> getNotesSync(int coin, int id) {
    final r = unwrapResultBytes(warp_api_lib.get_notes(coin, id));
    final ns = ShieldedNoteVec(r);
    return ns.notes!;
  }

  static List<ShieldedTx> getTxsSync(int coin, int id) {
    final r = unwrapResultBytes(warp_api_lib.get_txs(coin, id));
    final txs = ShieldedTxVec(r);
    return txs.txs!;
  }

  static List<Message> getMessagesSync(int coin, int id) {
    final r = unwrapResultBytes(warp_api_lib.get_messages(coin, id));
    final msgs = MessageVec(r);
    return msgs.messages!;
  }

  static PrevNext getPrevNextMessage(
      int coin, int id, String subject, int height) {
    final r = unwrapResultBytes(warp_api_lib.get_prev_next_message(
        coin, id, toNative(subject), height));
    final pn = PrevNext(r);
    return pn;
  }

  // static List<SendTemplateT> getSendTemplates(int coin) {
  //   final r = unwrapResultBytes(warp_api_lib.get_templates(coin));
  //   final templates = SendTemplateVec(r).unpack();
  //   return templates.templates!;
  // }

  // static int saveSendTemplate(int coin, SendTemplateT t) {
  //   final template = SendTemplateObjectBuilder(
  //     id: t.id,
  //     title: t.title,
  //     address: t.address,
  //     amount: t.amount,
  //     feeIncluded: t.feeIncluded,
  //     fiatAmount: t.fiatAmount,
  //     fiat: t.fiat,
  //     includeReplyTo: t.includeReplyTo,
  //     subject: t.subject,
  //     body: t.body,
  //   ).toBytes();
  //   print("templ $t");
  //   final data = toNativeBytes(template);

  //   return unwrapResultU32(
  //       warp_api_lib.save_send_template(coin, data, template.length));
  // }

  static void deleteSendTemplate(int coin, int id) {
    warp_api_lib.delete_send_template(coin, id);
  }

  static List<Contact> getContacts(int coin) {
    final r = unwrapResultBytes(warp_api_lib.get_contacts(coin));
    final contacts = ContactVec(r);
    return contacts.contacts!;
  }

  static ContactT getContact(int coin, int id) {
    final r = unwrapResultBytes(warp_api_lib.get_contact(coin, id));
    final contact = Contact(r).unpack();
    return contact;
  }

  static List<TxTimeValue> getPnLTxs(int coin, int id, int timestamp) {
    final r = unwrapResultBytes(warp_api_lib.get_pnl_txs(coin, id, timestamp));
    final txs = TxTimeValueVec(r);
    return txs.values!;
  }

  static List<Spending> getSpendings(int coin, int id, int timestamp) {
    final r =
        unwrapResultBytes(warp_api_lib.get_spendings(coin, id, timestamp));
    final quotes = SpendingVec(r);
    return quotes.values!;
  }

  static void updateExcluded(int coin, int id, bool excluded) {
    unwrapResultU8(warp_api_lib.update_excluded(coin, id, excluded ? 1 : 0));
  }

  static void invertExcluded(int coin, int id) {
    unwrapResultU8(warp_api_lib.invert_excluded(coin, id));
  }

  static List<Checkpoint> getCheckpoints(int coin) {
    final r = unwrapResultBytes(warp_api_lib.get_checkpoints(coin));
    final quotes = CheckpointVec(r);
    return quotes.values!;
  }

  static void clearTxDetails(int coin, int account) {
    warp_api_lib.clear_tx_details(coin, account);
  }

  static void cloneDbWithPasswd(int coin, String tempPath, String passwd) {
    warp_api_lib.clone_db_with_passwd(
        coin, toNative(tempPath), toNative(passwd));
  }

  static bool decryptDb(String dbPath, String passwd) {
    return unwrapResultBool(
        warp_api_lib.decrypt_db(toNative(dbPath), toNative(passwd)));
  }

  static String getProperty(int coin, String name) {
    return unwrapResultString(warp_api_lib.get_property(coin, toNative(name)));
  }

  static void setProperty(int coin, String name, String value) {
    unwrapResultU8(
        warp_api_lib.set_property(coin, toNative(name), toNative(value)));
  }

  static int getAvailableAddrs(int coin, int account) {
    if (account == 0) return 0;
    return unwrapResultU8(warp_api_lib.get_available_addrs(coin, account));
  }

  static Future<int> importFromLedger(int coin, String name) async {
    return await compute((_) {
      return unwrapResultU32(
          warp_api_lib.ledger_import_account(coin, toNative(name)));
    }, null);
  }

  static bool ledgerHasAccount(int coin, int account) {
    return unwrapResultBool(warp_api_lib.ledger_has_account(coin, account));
  }

  static Future<String> zipDbs(String passwd, String tempDir) async {
    return await compute((_) => 
    unwrapResultString(warp_api_lib.zip_dbs(toNative(passwd), toNative(tempDir))), null);
  }
}

String signOnlyIsolateFn(SignOnlyParams params) {
  final txIdRes = warp_api_lib.sign(params.coin, params.account,
      toNative(params.tx), params.port.nativePort);
  if (txIdRes.error != nullptr) throw convertCString(txIdRes.error);
  return convertCString(txIdRes.value);
}

String transferPoolsIsolateFn(TransferPoolsParams params) {
  final fee2 = encodeFee(params.fee);
  final txId = warp_api_lib.transfer_pools(
      params.coin,
      params.account,
      params.fromPool,
      params.toPool,
      params.amount,
      params.takeFee ? 1 : 0,
      toNative(params.memo),
      params.splitAmount,
      params.anchorOffset,
      toNativeBytes(fee2),
      fee2.lengthInBytes);
  return unwrapResultString(txId);
}

int getTBalanceIsolateFn(GetTBalanceParams params) {
  return unwrapResultU64(
      warp_api_lib.get_taddr_balance(params.coin, params.account));
}

class SyncParams {
  final int coin;
  final bool getTx;
  final int anchorOffset;
  final int maxCost;
  final SendPort? port;

  SyncParams(this.coin, this.getTx, this.anchorOffset, this.maxCost, this.port);
}

class PaymentParams {
  final int coin;
  final int account;
  final String recipientsJson;
  final bool useTransparent;
  final int anchorOffset;
  final SendPort port;

  PaymentParams(this.coin, this.account, this.recipientsJson,
      this.useTransparent, this.anchorOffset, this.port);
}

class SignOnlyParams {
  final int coin;
  final int account;
  final String tx;
  final SendPort port;

  SignOnlyParams(this.coin, this.account, this.tx, this.port);
}

class TransferPoolsParams {
  final int coin;
  final int account;
  final int fromPool;
  final int toPool;
  final int amount;
  final bool takeFee;
  final String memo;
  final int splitAmount;
  final int anchorOffset;
  final FeeT fee;

  TransferPoolsParams(
      this.coin,
      this.account,
      this.fromPool,
      this.toPool,
      this.amount,
      this.takeFee,
      this.memo,
      this.splitAmount,
      this.anchorOffset,
      this.fee);
}

class SyncHistoricalPricesParams {
  final String currency;

  SyncHistoricalPricesParams(this.currency);
}

class GetTBalanceParams {
  final int coin;
  final int account;

  GetTBalanceParams(this.coin, this.account);
}

class BlockHeightByTimeParams {
  final int time;

  BlockHeightByTimeParams(this.time);
}

String convertCString(Pointer<Char> s) {
  final str = s.cast<Utf8>().toDartString();
  warp_api_lib.deallocate_str(s);
  return str;
}

List<int> convertBytes(Pointer<Uint8> s, int len) {
  final bytes = [...s.asTypedList(len)];
  warp_api_lib.deallocate_bytes(s, len);
  return bytes;
}

Uint8List encodeFee(FeeT fee) {
  final feeBuilder = Builder();
  int fee2 = fee.pack(feeBuilder);
  feeBuilder.finish(fee2);
  return feeBuilder.buffer;
}

void mempoolRunIsolateFn(int port) {
  warp_api_lib.mempool_run(port);
}
