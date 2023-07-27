// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh_Hant';

  static String m0(currency) => "金額（${currency}）";

  static String m1(ticker) =>
      "您確定要儲存您的聯絡人嗎？這將會花費 0.01 m${ticker}";

  static String m2(name) => "備份數據 - ${name} - 恢復所需";

  static String m3(rewindHeight) =>
      "檢測到區塊重新組織。倒回到高度 ${rewindHeight}";

  static String m4(address, amount) =>
      "您是否要為 ${address} 簽署交易，金額為 ${amount}";

  static String m5(ticker) =>
      "您是否要將您的所有透明餘額轉移到隱藏地址？將收取 0.01 m${ticker} 的網絡手續費。";

  static String m6(app) => "${app} 加密備份";

  static String m7(msg) => "錯誤：${msg}";

  static String m8(message) => "無效的 QR 碼：${message}";

  static String m9(amount, ticker) => "最大可用金額：${amount} ${ticker}";

  static String m10(num) => "還需要 ${num} 個簽署者";

  static String m11(level) => "隱私等級：${level}";

  static String m12(ticker) => "接收 ${ticker}";

  static String m13(amount, ticker) => "已接收 ${amount} ${ticker}";

  static String m14(height) => "已從高度 ${height} 要求重新掃描...";

  static String m15(ticker) => "發送 ${ticker}";

  static String m16(ticker) => "發送 ${ticker} 至...";

  static String m17(app) => "來自 ${app} 的發送";

  static String m18(amount, ticker, count) =>
      "發送總數 ${amount} ${ticker} 至 ${count} 個收件人";

  static String m19(aZEC, ticker, address) =>
      "發送 ${aZEC} ${ticker} 至 ${address}";

  static String m20(amount, ticker) => "花費 ${amount} ${ticker}";

  static String m21(index, name) => "${name} 的子賬戶 ${index}";

  static String m22(name) => "${name} 的子賬戶";

  static String m23(text) => "已複製 ${text} 至剪貼板";

  static String m24(txid) => "交易 ID：${txid}";

  static String m25(currency) => "使用 ${currency}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "M1": MessageLookupByLibrary.simpleMessage("1 M"),
        "M3": MessageLookupByLibrary.simpleMessage("3 M"),
        "M6": MessageLookupByLibrary.simpleMessage("6 M"),
        "Y1": MessageLookupByLibrary.simpleMessage("1 Y"),
        "about": MessageLookupByLibrary.simpleMessage("關於"),
        "accentColor": MessageLookupByLibrary.simpleMessage("強調顏色"),
        "account": MessageLookupByLibrary.simpleMessage("帳戶"),
        "accountBalanceHistory": MessageLookupByLibrary.simpleMessage("帳戶餘額歷史"),
        "accountHasSomeBalanceAreYouSureYouWantTo": MessageLookupByLibrary.simpleMessage("帳戶有一些餘額。您確定要刪除它嗎？"),
        "accountIndex": MessageLookupByLibrary.simpleMessage("帳戶索引"),
        "accountName": MessageLookupByLibrary.simpleMessage("帳戶名稱"),
        "accountNameIsRequired": MessageLookupByLibrary.simpleMessage("帳戶名稱是必需的"),
        "accounts": MessageLookupByLibrary.simpleMessage("帳戶"),
        "add": MessageLookupByLibrary.simpleMessage("新增"),
        "addARecipientAndItWillShowHere": MessageLookupByLibrary.simpleMessage("新增收件人，它將顯示在這裡"),
        "addContact": MessageLookupByLibrary.simpleMessage("新增聯絡人"),
        "addnew": MessageLookupByLibrary.simpleMessage("新增/還原"),
        "address": MessageLookupByLibrary.simpleMessage("地址"),
        "addressCopiedToClipboard": MessageLookupByLibrary.simpleMessage("地址已複製到剪貼簿"),
        "addressIsEmpty": MessageLookupByLibrary.simpleMessage("地址為空"),
        "advanced": MessageLookupByLibrary.simpleMessage("進階"),
        "advancedOptions": MessageLookupByLibrary.simpleMessage("進階選項"),
        "always": MessageLookupByLibrary.simpleMessage("總是"),
        "amount": MessageLookupByLibrary.simpleMessage("金額"),
        "amountInSettingscurrency": m0,
        "amountMustBeANumber": MessageLookupByLibrary.simpleMessage("金額必須為數字"),
        "amountMustBePositive": MessageLookupByLibrary.simpleMessage("金額必須為正數"),
        "amountTooHigh": MessageLookupByLibrary.simpleMessage("金額過高"),
        "antispamFilter": MessageLookupByLibrary.simpleMessage("反垃圾郵件過濾器"),
        "applicationReset": MessageLookupByLibrary.simpleMessage("應用程式重置"),
        "approve": MessageLookupByLibrary.simpleMessage("確認"),
        "areYouSureYouWantToDeleteThisContact": MessageLookupByLibrary.simpleMessage("您確定要刪除此聯絡人嗎？"),
        "areYouSureYouWantToDeleteThisSendTemplate": MessageLookupByLibrary.simpleMessage("您確定要刪除此發送模板嗎？"),
        "areYouSureYouWantToSaveYourContactsIt": m1,
        "auto": MessageLookupByLibrary.simpleMessage("自動"),
        "autoHideBalance": MessageLookupByLibrary.simpleMessage("自動隱藏餘額"),
        "backup": MessageLookupByLibrary.simpleMessage("備份"),
        "backupAllAccounts": MessageLookupByLibrary.simpleMessage("備份所有帳戶"),
        "backupDataRequiredForRestore": m2,
        "backupEncryptionKey": MessageLookupByLibrary.simpleMessage("備份加密金鑰"),
        "backupWarning": MessageLookupByLibrary.simpleMessage("沒有人能夠恢復您的私鑰。如果您沒有備份且手機出現故障，您將會丟失您的資金。您可以通過應用程式菜單，然後進入備份頁面"),
        "balance": MessageLookupByLibrary.simpleMessage("餘額"),
        "barcode": MessageLookupByLibrary.simpleMessage("條碼"),
        "barcodeScannerIsNotAvailableOnDesktop": MessageLookupByLibrary.simpleMessage("桌面版不支援條碼掃描"),
        "blockExplorer": MessageLookupByLibrary.simpleMessage("區塊瀏覽器"),
        "blockReorgDetectedRewind": m3,
        "blue": MessageLookupByLibrary.simpleMessage("藍色"),
        "body": MessageLookupByLibrary.simpleMessage("正文"),
        "broadcast": MessageLookupByLibrary.simpleMessage("廣播"),
        "broadcastFromYourOnlineDevice": MessageLookupByLibrary.simpleMessage("從您的在線設備進行廣播"),
        "budget": MessageLookupByLibrary.simpleMessage("預算"),
        "cancel": MessageLookupByLibrary.simpleMessage("取消"),
        "cancelScan": MessageLookupByLibrary.simpleMessage("取消掃描"),
        "changeAccountName": MessageLookupByLibrary.simpleMessage("更改帳戶名稱"),
        "changeTransparentKey": MessageLookupByLibrary.simpleMessage("更改透明金鑰"),
        "checkTransaction": MessageLookupByLibrary.simpleMessage("檢查交易"),
        "close": MessageLookupByLibrary.simpleMessage("關閉"),
        "closeApplication": MessageLookupByLibrary.simpleMessage("關閉應用程式"),
        "coffee": MessageLookupByLibrary.simpleMessage("咖啡"),
        "coldStorage": MessageLookupByLibrary.simpleMessage("冷儲存"),
        "color": MessageLookupByLibrary.simpleMessage("顏色"),
        "confirmDeleteAccount": MessageLookupByLibrary.simpleMessage("您確定要刪除此帳戶嗎？您必須有備份才能恢復。此操作不可撤銷。"),
        "confirmResetApp": MessageLookupByLibrary.simpleMessage("您確定要重置應用程式嗎？您的帳戶將不會被刪除。"),
        "confirmSignATransactionToAddressFor": m4,
        "confirmSigning": MessageLookupByLibrary.simpleMessage("確認簽名"),
        "confs": MessageLookupByLibrary.simpleMessage("確認數量"),
        "contactName": MessageLookupByLibrary.simpleMessage("聯絡人名稱"),
        "contacts": MessageLookupByLibrary.simpleMessage("聯絡人"),
        "convertToWatchonly": MessageLookupByLibrary.simpleMessage("轉為僅查看"),
        "copy": MessageLookupByLibrary.simpleMessage("複製"),
        "count": MessageLookupByLibrary.simpleMessage("計數"),
        "createANewAccount": MessageLookupByLibrary.simpleMessage("點擊 + 添加新帳戶"),
        "createANewContactAndItWillShowUpHere": MessageLookupByLibrary.simpleMessage("點擊 + 添加新聯絡人"),
        "crypto": MessageLookupByLibrary.simpleMessage("加密貨幣"),
        "currency": MessageLookupByLibrary.simpleMessage("貨幣"),
        "currentPassword": MessageLookupByLibrary.simpleMessage("當前密碼"),
        "currentPasswordIncorrect": MessageLookupByLibrary.simpleMessage("當前密碼不正確"),
        "custom": MessageLookupByLibrary.simpleMessage("自定義"),
        "dark": MessageLookupByLibrary.simpleMessage("暗黑模式"),
        "databaseEncrypted": MessageLookupByLibrary.simpleMessage("數據庫已加密"),
        "databasePassword": MessageLookupByLibrary.simpleMessage("數據庫密碼"),
        "databaseRestored": MessageLookupByLibrary.simpleMessage("數據庫已恢復"),
        "date": MessageLookupByLibrary.simpleMessage("日期"),
        "datetime": MessageLookupByLibrary.simpleMessage("日期/時間"),
        "dbImportSuccessful": MessageLookupByLibrary.simpleMessage("數據庫導入成功"),
        "defaultMemo": MessageLookupByLibrary.simpleMessage("默認備註"),
        "delete": MessageLookupByLibrary.simpleMessage("刪除"),
        "deleteAccount": MessageLookupByLibrary.simpleMessage("刪除帳戶"),
        "deleteContact": MessageLookupByLibrary.simpleMessage("刪除聯絡人"),
        "deleteTemplate": MessageLookupByLibrary.simpleMessage("刪除模板？"),
        "derivationPath": MessageLookupByLibrary.simpleMessage("導出路徑"),
        "disconnected": MessageLookupByLibrary.simpleMessage("未連接"),
        "doYouWantToDeleteTheSecretKeyAndConvert": MessageLookupByLibrary.simpleMessage("您是否要刪除密鑰並將此帳戶轉換為僅查看帳戶？您將無法再從此設備進行支付。此操作不可撤銷。"),
        "doYouWantToRestore": MessageLookupByLibrary.simpleMessage("您是否要恢復您的數據庫？這將刪除您當前的數據。"),
        "doYouWantToTransferYourEntireTransparentBalanceTo": m5,
        "duplicateAccount": MessageLookupByLibrary.simpleMessage("重複帳戶"),
        "duplicateContact": MessageLookupByLibrary.simpleMessage("另一個聯絡人已擁有該地址"),
        "editContact": MessageLookupByLibrary.simpleMessage("編輯聯絡人"),
        "encryptDatabase": MessageLookupByLibrary.simpleMessage("加密數據庫"),
        "encryptedBackup": m6,
        "encryptionKey": MessageLookupByLibrary.simpleMessage("加密金鑰"),
        "enterSecretShareIfAccountIsMultisignature": MessageLookupByLibrary.simpleMessage("如果帳戶是多簽名的，請輸入密鑰份額"),
        "enterSeed": MessageLookupByLibrary.simpleMessage("輸入種子、密鑰或查看金鑰。留空以創建新帳戶"),
        "error": m7,
        "excludedNotes": MessageLookupByLibrary.simpleMessage("排除的備註"),
        "expert": MessageLookupByLibrary.simpleMessage("專家"),
        "fileSaved": MessageLookupByLibrary.simpleMessage("文件已保存"),
        "fromPool": MessageLookupByLibrary.simpleMessage("來自Pool"),
        "fromto": MessageLookupByLibrary.simpleMessage("來自/發送至"),
        "fullBackup": MessageLookupByLibrary.simpleMessage("完整備份"),
        "fullRestore": MessageLookupByLibrary.simpleMessage("完整恢復"),
        "gapLimit": MessageLookupByLibrary.simpleMessage("間隙限制"),
        "goToTransaction": MessageLookupByLibrary.simpleMessage("查看交易"),
        "gold": MessageLookupByLibrary.simpleMessage("黃金"),
        "height": MessageLookupByLibrary.simpleMessage("高度"),
        "help": MessageLookupByLibrary.simpleMessage("幫助"),
        "high": MessageLookupByLibrary.simpleMessage("高"),
        "history": MessageLookupByLibrary.simpleMessage("歷史記錄"),
        "iHaveMadeABackup": MessageLookupByLibrary.simpleMessage("我已經備份了"),
        "import": MessageLookupByLibrary.simpleMessage("導入"),
        "includeFeeInAmount": MessageLookupByLibrary.simpleMessage("在金額中包含手續費"),
        "includeReplyTo": MessageLookupByLibrary.simpleMessage("在備註中包含我的地址"),
        "incomingFunds": MessageLookupByLibrary.simpleMessage("收到的資金"),
        "inputBarcodeValue": MessageLookupByLibrary.simpleMessage("輸入條碼值"),
        "invalidAddress": MessageLookupByLibrary.simpleMessage("無效地址"),
        "invalidKey": MessageLookupByLibrary.simpleMessage("無效金鑰"),
        "invalidPassword": MessageLookupByLibrary.simpleMessage("無效密碼"),
        "invalidQrCode": m8,
        "key": MessageLookupByLibrary.simpleMessage("種子、密鑰或查看金鑰（選填）"),
        "keyTool": MessageLookupByLibrary.simpleMessage("金鑰工具"),
        "largestSpendingLastMonth": MessageLookupByLibrary.simpleMessage("上個月最大花費"),
        "largestSpendingsByAddress": MessageLookupByLibrary.simpleMessage("地址最大花費"),
        "ledger": MessageLookupByLibrary.simpleMessage("Ledger"),
        "light": MessageLookupByLibrary.simpleMessage("亮"),
        "loadBackup": MessageLookupByLibrary.simpleMessage("載入備份"),
        "loading": MessageLookupByLibrary.simpleMessage("載入中..."),
        "low": MessageLookupByLibrary.simpleMessage("低"),
        "markAllAsRead": MessageLookupByLibrary.simpleMessage("全部標記為已讀"),
        "max": MessageLookupByLibrary.simpleMessage("最大值"),
        "maxAmountPerNote": MessageLookupByLibrary.simpleMessage("每筆備註最大金額"),
        "maxSpendableAmount": m9,
        "medium": MessageLookupByLibrary.simpleMessage("中等"),
        "memo": MessageLookupByLibrary.simpleMessage("備註"),
        "message": MessageLookupByLibrary.simpleMessage("訊息"),
        "messages": MessageLookupByLibrary.simpleMessage("訊息"),
        "minPrivacy": MessageLookupByLibrary.simpleMessage("最小隱私"),
        "mm": MessageLookupByLibrary.simpleMessage("M/M"),
        "mobileCharges": MessageLookupByLibrary.simpleMessage("使用行動數據可能產生額外費用。是否繼續？"),
        "mode": MessageLookupByLibrary.simpleMessage("模式"),
        "multiPay": MessageLookupByLibrary.simpleMessage("多重支付"),
        "multipay": MessageLookupByLibrary.simpleMessage("多重支付"),
        "multipleAddresses": MessageLookupByLibrary.simpleMessage("多個地址"),
        "multisig": MessageLookupByLibrary.simpleMessage("多重簽名"),
        "multisigShares": MessageLookupByLibrary.simpleMessage("多重簽名分享"),
        "na": MessageLookupByLibrary.simpleMessage("N/A"),
        "name": MessageLookupByLibrary.simpleMessage("名稱"),
        "nameIsEmpty": MessageLookupByLibrary.simpleMessage("名稱為空"),
        "never": MessageLookupByLibrary.simpleMessage("從不"),
        "newAccount": MessageLookupByLibrary.simpleMessage("新帳戶"),
        "newLabel": MessageLookupByLibrary.simpleMessage("新"),
        "newPassword": MessageLookupByLibrary.simpleMessage("新密碼"),
        "newPasswordsDoNotMatch": MessageLookupByLibrary.simpleMessage("新密碼不相符"),
        "newSnapAddress": MessageLookupByLibrary.simpleMessage("新的 Snap 地址"),
        "newSubAccount": MessageLookupByLibrary.simpleMessage("新子帳戶"),
        "newTemplate": MessageLookupByLibrary.simpleMessage("新範本"),
        "noAccount": MessageLookupByLibrary.simpleMessage("無帳戶"),
        "noActiveAccount": MessageLookupByLibrary.simpleMessage("無活躍帳戶"),
        "noAuthenticationMethod": MessageLookupByLibrary.simpleMessage("無認證方法"),
        "noContacts": MessageLookupByLibrary.simpleMessage("無聯絡人"),
        "noRecipient": MessageLookupByLibrary.simpleMessage("無收款人"),
        "noSpendingInTheLast30Days": MessageLookupByLibrary.simpleMessage("過去30天無消費"),
        "notEnoughBalance": MessageLookupByLibrary.simpleMessage("餘額不足"),
        "notes": MessageLookupByLibrary.simpleMessage("備註"),
        "now": MessageLookupByLibrary.simpleMessage("現在"),
        "numMoreSignersNeeded": m10,
        "numberOfConfirmationsNeededBeforeSpending": MessageLookupByLibrary.simpleMessage("在支出之前所需的確認次數"),
        "ok": MessageLookupByLibrary.simpleMessage("確定"),
        "openInExplorer": MessageLookupByLibrary.simpleMessage("在瀏覽器中開啟"),
        "paymentInProgress": MessageLookupByLibrary.simpleMessage("付款進行中..."),
        "paymentMade": MessageLookupByLibrary.simpleMessage("已付款"),
        "pink": MessageLookupByLibrary.simpleMessage("粉紅色"),
        "pl": MessageLookupByLibrary.simpleMessage("盈虧"),
        "playSound": MessageLookupByLibrary.simpleMessage("播放音效"),
        "pleaseAuthenticateToSend": MessageLookupByLibrary.simpleMessage("請驗證以進行轉帳"),
        "pleaseAuthenticateToShowAccountSeed": MessageLookupByLibrary.simpleMessage("請驗證以顯示帳戶種子"),
        "pleaseConfirm": MessageLookupByLibrary.simpleMessage("請確認"),
        "pleaseQuitAndRestartTheAppNow": MessageLookupByLibrary.simpleMessage("請退出並重新啟動應用程式"),
        "pnl": MessageLookupByLibrary.simpleMessage("PNL"),
        "pnlHistory": MessageLookupByLibrary.simpleMessage("PNL 歷史"),
        "pools": MessageLookupByLibrary.simpleMessage("Pool 轉帳"),
        "preparingTransaction": MessageLookupByLibrary.simpleMessage("準備交易中..."),
        "price": MessageLookupByLibrary.simpleMessage("價格"),
        "primary": MessageLookupByLibrary.simpleMessage("主要"),
        "privacy": m11,
        "privacyLevelTooLow": MessageLookupByLibrary.simpleMessage("隱私等級太低 - 長按以覆寫"),
        "privateKey": MessageLookupByLibrary.simpleMessage("私鑰"),
        "protectOpen": MessageLookupByLibrary.simpleMessage("保護開啟"),
        "protectSend": MessageLookupByLibrary.simpleMessage("保護轉帳"),
        "protectSendSettingChanged": MessageLookupByLibrary.simpleMessage("保護轉帳設定已變更"),
        "purple": MessageLookupByLibrary.simpleMessage("紫色"),
        "qty": MessageLookupByLibrary.simpleMessage("數量"),
        "rawTransaction": MessageLookupByLibrary.simpleMessage("原始交易"),
        "realized": MessageLookupByLibrary.simpleMessage("實現"),
        "receive": m12,
        "receivePayment": MessageLookupByLibrary.simpleMessage("接收付款"),
        "received": m13,
        "recipient": MessageLookupByLibrary.simpleMessage("收款人"),
        "repeatNewPassword": MessageLookupByLibrary.simpleMessage("重複新密碼"),
        "reply": MessageLookupByLibrary.simpleMessage("回覆"),
        "rescan": MessageLookupByLibrary.simpleMessage("重新掃描"),
        "rescanFrom": MessageLookupByLibrary.simpleMessage("重新掃描自..."),
        "rescanNeeded": MessageLookupByLibrary.simpleMessage("需要重新掃描"),
        "rescanRequested": m14,
        "rescanning": MessageLookupByLibrary.simpleMessage("正在重新掃描..."),
        "reset": MessageLookupByLibrary.simpleMessage("重置"),
        "restart": MessageLookupByLibrary.simpleMessage("重新啟動"),
        "restoreAnAccount": MessageLookupByLibrary.simpleMessage("還原帳戶?"),
        "resumeScan": MessageLookupByLibrary.simpleMessage("繼續掃描"),
        "retrieveTransactionDetails": MessageLookupByLibrary.simpleMessage("檢索交易詳細信息"),
        "rewindToCheckpoint": MessageLookupByLibrary.simpleMessage("回到檢查點"),
        "roundToMillis": MessageLookupByLibrary.simpleMessage("四捨五入至毫秒"),
        "save": MessageLookupByLibrary.simpleMessage("儲存"),
        "saveBackup": MessageLookupByLibrary.simpleMessage("儲存備份"),
        "saveToBlockchain": MessageLookupByLibrary.simpleMessage("儲存到區塊鏈"),
        "scanQrCode": MessageLookupByLibrary.simpleMessage("掃描 QR 碼"),
        "scanStartingMomentarily": MessageLookupByLibrary.simpleMessage("即將開始掃描"),
        "scanTransparentAddresses": MessageLookupByLibrary.simpleMessage("掃描透明地址"),
        "scanningAddresses": MessageLookupByLibrary.simpleMessage("正在掃描地址"),
        "secondary": MessageLookupByLibrary.simpleMessage("次要"),
        "secretKey": MessageLookupByLibrary.simpleMessage("私鑰"),
        "secretShare": MessageLookupByLibrary.simpleMessage("秘密分享"),
        "seed": MessageLookupByLibrary.simpleMessage("種子"),
        "selectAccount": MessageLookupByLibrary.simpleMessage("選擇帳戶"),
        "selectCheckpoint": MessageLookupByLibrary.simpleMessage("選擇檢查點"),
        "selectNotesToExcludeFromPayments": MessageLookupByLibrary.simpleMessage("選擇要排除的付款備註"),
        "send": MessageLookupByLibrary.simpleMessage("發送"),
        "sendCointicker": m15,
        "sendCointickerTo": m16,
        "sendFrom": m17,
        "sender": MessageLookupByLibrary.simpleMessage("寄件人"),
        "sendingATotalOfAmountCointickerToCountRecipients": m18,
        "sendingAzecCointickerToAddress": m19,
        "server": MessageLookupByLibrary.simpleMessage("伺服器"),
        "set": MessageLookupByLibrary.simpleMessage("設定"),
        "settings": MessageLookupByLibrary.simpleMessage("設定"),
        "shieldTranspBalance": MessageLookupByLibrary.simpleMessage("隱藏透明餘額"),
        "shieldTransparentBalance": MessageLookupByLibrary.simpleMessage("隱藏透明餘額"),
        "shieldTransparentBalanceWithSending": MessageLookupByLibrary.simpleMessage("發送時隱藏透明餘額"),
        "shieldingInProgress": MessageLookupByLibrary.simpleMessage("隱藏進行中..."),
        "showMessagesAsTable": MessageLookupByLibrary.simpleMessage("以表格顯示訊息"),
        "sign": MessageLookupByLibrary.simpleMessage("簽署交易"),
        "signOffline": MessageLookupByLibrary.simpleMessage("簽署"),
        "signOnYourOfflineDevice": MessageLookupByLibrary.simpleMessage("在離線裝置上簽署"),
        "signedTx": MessageLookupByLibrary.simpleMessage("已簽署交易"),
        "signingPleaseWait": MessageLookupByLibrary.simpleMessage("正在簽署，請稍候..."),
        "simple": MessageLookupByLibrary.simpleMessage("簡易"),
        "simpleMode": MessageLookupByLibrary.simpleMessage("簡易模式"),
        "spendable": MessageLookupByLibrary.simpleMessage("可使用"),
        "spendableBalance": MessageLookupByLibrary.simpleMessage("可用餘額"),
        "spent": m20,
        "splitAccount": MessageLookupByLibrary.simpleMessage("拆分帳戶"),
        "splitNotes": MessageLookupByLibrary.simpleMessage("拆分備註"),
        "subAccountIndexOf": m21,
        "subAccountOf": m22,
        "subject": MessageLookupByLibrary.simpleMessage("主題"),
        "sweep": MessageLookupByLibrary.simpleMessage("清除"),
        "syncPaused": MessageLookupByLibrary.simpleMessage("同步已暫停"),
        "synching": MessageLookupByLibrary.simpleMessage("同步中"),
        "synchronizationInProgress": MessageLookupByLibrary.simpleMessage("同步進行中"),
        "table": MessageLookupByLibrary.simpleMessage("表格"),
        "tapAnIconToShowTheQrCode": MessageLookupByLibrary.simpleMessage("點擊圖示顯示 QR 碼"),
        "tapChartToToggleBetweenAddressAndAmount": MessageLookupByLibrary.simpleMessage("點擊圖表切換地址和金額"),
        "tapQrCodeForSaplingAddress": MessageLookupByLibrary.simpleMessage("點擊 QR 碼查看 Sapling 地址"),
        "tapQrCodeForShieldedAddress": MessageLookupByLibrary.simpleMessage("點擊 QR 碼查看隱藏地址"),
        "tapQrCodeForTransparentAddress": MessageLookupByLibrary.simpleMessage("點擊 QR 碼查看透明地址"),
        "tapTransactionForDetails": MessageLookupByLibrary.simpleMessage("點擊交易以查看詳細信息"),
        "template": MessageLookupByLibrary.simpleMessage("範本"),
        "textCopiedToClipboard": m23,
        "thePrivateWalletMessenger": MessageLookupByLibrary.simpleMessage("私人錢包和通訊器"),
        "theme": MessageLookupByLibrary.simpleMessage("主題"),
        "themeEditor": MessageLookupByLibrary.simpleMessage("主題編輯器"),
        "thisAccountAlreadyExists": MessageLookupByLibrary.simpleMessage("另一個帳戶已存在"),
        "tiltYourDeviceUpToRevealYourBalance": MessageLookupByLibrary.simpleMessage("傾斜裝置以顯示您的餘額"),
        "timestamp": MessageLookupByLibrary.simpleMessage("時間戳"),
        "toMakeAContactSendThemAMemoWithContact": MessageLookupByLibrary.simpleMessage("要建立聯絡人，請傳送帶有聯絡人的備註："),
        "toPool": MessageLookupByLibrary.simpleMessage("至池"),
        "total": MessageLookupByLibrary.simpleMessage("總計"),
        "totalBalance": MessageLookupByLibrary.simpleMessage("總餘額"),
        "tradingChartRange": MessageLookupByLibrary.simpleMessage("交易圖表範圍"),
        "tradingPl": MessageLookupByLibrary.simpleMessage("錢包損益"),
        "transactionDetails": MessageLookupByLibrary.simpleMessage("交易詳細信息"),
        "transactionHistory": MessageLookupByLibrary.simpleMessage("交易歷史記錄"),
        "transactions": MessageLookupByLibrary.simpleMessage("交易"),
        "transfer": MessageLookupByLibrary.simpleMessage("轉帳"),
        "transparentKey": MessageLookupByLibrary.simpleMessage("透明鑰匙"),
        "txId": m24,
        "underConfirmed": MessageLookupByLibrary.simpleMessage("尚未確認"),
        "unifiedViewingKey": MessageLookupByLibrary.simpleMessage("統一查看鑰匙"),
        "unshielded": MessageLookupByLibrary.simpleMessage("未隱藏"),
        "unshieldedBalance": MessageLookupByLibrary.simpleMessage("未隱藏餘額"),
        "unsignedTransactionFile": MessageLookupByLibrary.simpleMessage("未簽署的交易檔案"),
        "unsignedTx": MessageLookupByLibrary.simpleMessage("未簽署的交易"),
        "update": MessageLookupByLibrary.simpleMessage("重新計算"),
        "useGpu": MessageLookupByLibrary.simpleMessage("使用 GPU"),
        "useQrForOfflineSigning": MessageLookupByLibrary.simpleMessage("離線簽署使用 QR 碼"),
        "useSettingscurrency": m25,
        "useTransparentBalance": MessageLookupByLibrary.simpleMessage("使用透明餘額"),
        "useUa": MessageLookupByLibrary.simpleMessage("使用 UA"),
        "version": MessageLookupByLibrary.simpleMessage("版本"),
        "veryLow": MessageLookupByLibrary.simpleMessage("非常低"),
        "viewingKey": MessageLookupByLibrary.simpleMessage("查看鑰匙"),
        "welcomeToYwallet": MessageLookupByLibrary.simpleMessage("歡迎使用 YWallet")
        "viewingKey": MessageLookupByLibrary.simpleMessage("查看鑰匙"),
        "welcomeToYwallet": MessageLookupByLibrary.simpleMessage("歡迎使用 YWallet")
      };
}
