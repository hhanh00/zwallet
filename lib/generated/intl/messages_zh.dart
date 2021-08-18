// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh';

  static m0(currency) => "於 ${currency}的數量";

  static m1(ticker) => "發送 ${ticker}";

  static m2(ticker) => "發送 ${ticker} 至...";

  static m3(amount, ticker, count) => "發送數目${amount} ${ticker} 至 ${count} 收款人";

  static m4(aZEC, ticker, address) => "傳送 ${aZEC} ${ticker} 至 ${address}";

  static m5(currency) => "使用 ${currency}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "about" : MessageLookupByLibrary.simpleMessage("關於"),
    "account" : MessageLookupByLibrary.simpleMessage("帳戶"),
    "accountBalanceHistory" : MessageLookupByLibrary.simpleMessage("帳戶結餘記錄"),
    "accountName" : MessageLookupByLibrary.simpleMessage("帳戶名稱"),
    "accountNameIsRequired" : MessageLookupByLibrary.simpleMessage("請輸入帳戶名稱"),
    "accounts" : MessageLookupByLibrary.simpleMessage("帳戶"),
    "add" : MessageLookupByLibrary.simpleMessage("增加"),
    "address" : MessageLookupByLibrary.simpleMessage("地址"),
    "addressCopiedToClipboard" : MessageLookupByLibrary.simpleMessage("複製地址到剪貼簿"),
    "addressIsEmpty" : MessageLookupByLibrary.simpleMessage("沒有地址"),
    "advancedOptions" : MessageLookupByLibrary.simpleMessage("進階選項"),
    "amount" : MessageLookupByLibrary.simpleMessage("數量"),
    "amountInSettingscurrency" : m0,
    "amountMustBeANumber" : MessageLookupByLibrary.simpleMessage("請輸入數字（數量）"),
    "amountMustBePositive" : MessageLookupByLibrary.simpleMessage("數量必須為正數"),
    "approve" : MessageLookupByLibrary.simpleMessage("同意"),
    "backup" : MessageLookupByLibrary.simpleMessage("備份"),
    "backupDataRequiredForRestore" : MessageLookupByLibrary.simpleMessage("將資料備份 - 要求重置"),
    "balance" : MessageLookupByLibrary.simpleMessage("粵語"),
    "blue" : MessageLookupByLibrary.simpleMessage("藍色"),
    "broadcast" : MessageLookupByLibrary.simpleMessage("廣播"),
    "budget" : MessageLookupByLibrary.simpleMessage("預算"),
    "cancel" : MessageLookupByLibrary.simpleMessage("取消"),
    "changeAccountName" : MessageLookupByLibrary.simpleMessage("更改帳戶名稱"),
    "coffee" : MessageLookupByLibrary.simpleMessage("咖啡色"),
    "coldStorage" : MessageLookupByLibrary.simpleMessage("冷藏庫"),
    "confirmDeleteAccount" : MessageLookupByLibrary.simpleMessage("你確定要將這帳戶刪除？這指令執行後，帳戶會被永久刪除，不能復原。"),
    "confs" : MessageLookupByLibrary.simpleMessage("確認"),
    "contacts" : MessageLookupByLibrary.simpleMessage("通訊錄"),
    "currency" : MessageLookupByLibrary.simpleMessage("貨幣"),
    "custom" : MessageLookupByLibrary.simpleMessage("自訂"),
    "dark" : MessageLookupByLibrary.simpleMessage("深色"),
    "datetime" : MessageLookupByLibrary.simpleMessage("日期/時間"),
    "delete" : MessageLookupByLibrary.simpleMessage("刪除"),
    "doYouWantToDeleteTheSecretKeyAndConvert" : MessageLookupByLibrary.simpleMessage("你確定銷毀這秘密鎖匙？這指令執行後，該鎖匙會被永久刪除，不能復原。"),
    "doYouWantToTransferYourEntireTransparentBalanceTo" : MessageLookupByLibrary.simpleMessage("你需要將你的公開結餘轉往屏蔽地址?"),
    "enterSeed" : MessageLookupByLibrary.simpleMessage("輸入種子，秘密鎖匙或查看鎖匙\n留空預備新帳戶"),
    "height" : MessageLookupByLibrary.simpleMessage("高度"),
    "history" : MessageLookupByLibrary.simpleMessage("過去記錄"),
    "includeFeeInAmount" : MessageLookupByLibrary.simpleMessage("將費用加到總數"),
    "invalidAddress" : MessageLookupByLibrary.simpleMessage("地址不正確"),
    "key" : MessageLookupByLibrary.simpleMessage("鎖匙"),
    "largestSpendingLastMonth" : MessageLookupByLibrary.simpleMessage("上月最高開支"),
    "largestSpendingsByAddress" : MessageLookupByLibrary.simpleMessage("最大支出（用地址搜尋）"),
    "light" : MessageLookupByLibrary.simpleMessage("淺色"),
    "max" : MessageLookupByLibrary.simpleMessage("最大值"),
    "maxAmountPerNote" : MessageLookupByLibrary.simpleMessage("最大數量(每一紙幣)"),
    "memo" : MessageLookupByLibrary.simpleMessage("備忘"),
    "mm" : MessageLookupByLibrary.simpleMessage("按市值計"),
    "multiPay" : MessageLookupByLibrary.simpleMessage("廣泛支付"),
    "multipay" : MessageLookupByLibrary.simpleMessage("廣泛支付"),
    "na" : MessageLookupByLibrary.simpleMessage("不適用"),
    "newSnapAddress" : MessageLookupByLibrary.simpleMessage("立即地址"),
    "noAccount" : MessageLookupByLibrary.simpleMessage("沒有帳戶"),
    "noAuthenticationMethod" : MessageLookupByLibrary.simpleMessage("不用驗證"),
    "noSpendingInTheLast30Days" : MessageLookupByLibrary.simpleMessage("過去三十天內沒有任何開支"),
    "notEnoughBalance" : MessageLookupByLibrary.simpleMessage("帳戶結餘不足"),
    "notes" : MessageLookupByLibrary.simpleMessage("紙幣"),
    "numberOfConfirmationsNeededBeforeSpending" : MessageLookupByLibrary.simpleMessage("支付前需要確認之次數"),
    "ok" : MessageLookupByLibrary.simpleMessage("OK"),
    "openInExplorer" : MessageLookupByLibrary.simpleMessage("用瀏覽器開啟"),
    "pink" : MessageLookupByLibrary.simpleMessage("粉紅色"),
    "pl" : MessageLookupByLibrary.simpleMessage("獲利/虧損"),
    "pleaseAuthenticateToShowAccountSeed" : MessageLookupByLibrary.simpleMessage("如要顯示帳戶種子，請驗證"),
    "pleaseConfirm" : MessageLookupByLibrary.simpleMessage("請確認"),
    "pnl" : MessageLookupByLibrary.simpleMessage("獲利與虧損"),
    "preparingTransaction" : MessageLookupByLibrary.simpleMessage("準備交易⋯"),
    "price" : MessageLookupByLibrary.simpleMessage("價格"),
    "qty" : MessageLookupByLibrary.simpleMessage("數量"),
    "real" : MessageLookupByLibrary.simpleMessage("真實"),
    "realized" : MessageLookupByLibrary.simpleMessage("已獲利"),
    "rescan" : MessageLookupByLibrary.simpleMessage("重新掃描"),
    "rescanRequested" : MessageLookupByLibrary.simpleMessage("已經收到重新掃描要求"),
    "rescanWalletFromTheFirstBlock" : MessageLookupByLibrary.simpleMessage("由第一組開始重新掃描銀包"),
    "retrieveTransactionDetails" : MessageLookupByLibrary.simpleMessage("修復交易資料"),
    "roundToMillis" : MessageLookupByLibrary.simpleMessage("約數至千分之一"),
    "scanStartingMomentarily" : MessageLookupByLibrary.simpleMessage("掃描即將開始"),
    "secretKey" : MessageLookupByLibrary.simpleMessage("秘密鎖匙"),
    "seed" : MessageLookupByLibrary.simpleMessage("種子"),
    "selectNotesToExcludeFromPayments" : MessageLookupByLibrary.simpleMessage("選取不需要的貨幣"),
    "send" : MessageLookupByLibrary.simpleMessage("發送"),
    "sendCointicker" : m1,
    "sendCointickerTo" : m2,
    "sendingATotalOfAmountCointickerToCountRecipients" : m3,
    "sendingAzecCointickerToAddress" : m4,
    "server" : MessageLookupByLibrary.simpleMessage("伺服器"),
    "settings" : MessageLookupByLibrary.simpleMessage("設定"),
    "shieldTranspBalance" : MessageLookupByLibrary.simpleMessage("屏蔽公開餘額"),
    "shieldTransparentBalance" : MessageLookupByLibrary.simpleMessage("屏蔽你的公開結餘"),
    "shieldingInProgress" : MessageLookupByLibrary.simpleMessage("屏蔽進行中"),
    "spendable" : MessageLookupByLibrary.simpleMessage("可使用的"),
    "synching" : MessageLookupByLibrary.simpleMessage("同步"),
    "table" : MessageLookupByLibrary.simpleMessage("表列"),
    "tapAnIconToShowTheQrCode" : MessageLookupByLibrary.simpleMessage("請點擊並顯示二維碼"),
    "tapChartToToggleBetweenAddressAndAmount" : MessageLookupByLibrary.simpleMessage("點擊表列以切換地址及總數"),
    "tapQrCodeForShieldedAddress" : MessageLookupByLibrary.simpleMessage("屏蔽地址請點擊二維碼"),
    "tapQrCodeForTransparentAddress" : MessageLookupByLibrary.simpleMessage("公開地址請點擊二維碼"),
    "theme" : MessageLookupByLibrary.simpleMessage("佈置主題"),
    "timestamp" : MessageLookupByLibrary.simpleMessage("時間蓋章"),
    "toMakeAContactSendThemAMemoWithContact" : MessageLookupByLibrary.simpleMessage("發送備忘到 Contact:"),
    "total" : MessageLookupByLibrary.simpleMessage("總數"),
    "tradingChartRange" : MessageLookupByLibrary.simpleMessage("交易範圍"),
    "tradingPl" : MessageLookupByLibrary.simpleMessage("交易"),
    "transactionDetails" : MessageLookupByLibrary.simpleMessage("交易資料"),
    "txId" : MessageLookupByLibrary.simpleMessage("TX ID:"),
    "txid" : MessageLookupByLibrary.simpleMessage("交易編號"),
    "unsignedTransactionFile" : MessageLookupByLibrary.simpleMessage("未簽署交易文件"),
    "useSettingscurrency" : m5,
    "version" : MessageLookupByLibrary.simpleMessage("版本"),
    "viewingKey" : MessageLookupByLibrary.simpleMessage("查看鎖匙")
  };
}
