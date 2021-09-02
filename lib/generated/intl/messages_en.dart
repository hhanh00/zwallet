// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static m0(currency) => "Amount in ${currency}";

  static m1(ticker) => "Do you want to transfer your entire transparent balance to your shielded address? A Network fee of 0.01 m${ticker} will be deducted.";

  static m2(ticker) => "Send ${ticker}";

  static m3(ticker) => "Send ${ticker} to...";

  static m4(amount, ticker, count) => "Sending a total of ${amount} ${ticker} to ${count} recipients";

  static m5(aZEC, ticker, address) => "Sending ${aZEC} ${ticker} to ${address}";

  static m6(currency) => "Use ${currency}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "M1" : MessageLookupByLibrary.simpleMessage("1 M"),
    "M3" : MessageLookupByLibrary.simpleMessage("3 M"),
    "M6" : MessageLookupByLibrary.simpleMessage("6 M"),
    "Y1" : MessageLookupByLibrary.simpleMessage("1 Y"),
    "about" : MessageLookupByLibrary.simpleMessage("About"),
    "account" : MessageLookupByLibrary.simpleMessage("Account"),
    "accountBalanceHistory" : MessageLookupByLibrary.simpleMessage("Account Balance History"),
    "accountName" : MessageLookupByLibrary.simpleMessage("Account Name"),
    "accountNameIsRequired" : MessageLookupByLibrary.simpleMessage("Account name is required"),
    "accounts" : MessageLookupByLibrary.simpleMessage("Accounts"),
    "add" : MessageLookupByLibrary.simpleMessage("ADD"),
    "address" : MessageLookupByLibrary.simpleMessage("Address"),
    "addressCopiedToClipboard" : MessageLookupByLibrary.simpleMessage("Address copied to clipboard"),
    "addressIsEmpty" : MessageLookupByLibrary.simpleMessage("Address is empty"),
    "advancedOptions" : MessageLookupByLibrary.simpleMessage("Advanced Options"),
    "amount" : MessageLookupByLibrary.simpleMessage("Amount"),
    "amountInSettingscurrency" : m0,
    "amountMustBeANumber" : MessageLookupByLibrary.simpleMessage("Amount must be a number"),
    "amountMustBePositive" : MessageLookupByLibrary.simpleMessage("Amount must be positive"),
    "approve" : MessageLookupByLibrary.simpleMessage("APPROVE"),
    "backup" : MessageLookupByLibrary.simpleMessage("Backup"),
    "backupDataRequiredForRestore" : MessageLookupByLibrary.simpleMessage("Backup Data - Required for Restore"),
    "balance" : MessageLookupByLibrary.simpleMessage("Balance"),
    "blue" : MessageLookupByLibrary.simpleMessage("Blue"),
    "broadcast" : MessageLookupByLibrary.simpleMessage("Broadcast"),
    "budget" : MessageLookupByLibrary.simpleMessage("Budget"),
    "cancel" : MessageLookupByLibrary.simpleMessage("Cancel"),
    "changeAccountName" : MessageLookupByLibrary.simpleMessage("Change Account Name"),
    "coffee" : MessageLookupByLibrary.simpleMessage("Coffee"),
    "coldStorage" : MessageLookupByLibrary.simpleMessage("Cold Storage"),
    "confirmDeleteAccount" : MessageLookupByLibrary.simpleMessage("Are you SURE you want to DELETE this account? You MUST have a BACKUP to recover it. This operation is NOT reversible."),
    "confs" : MessageLookupByLibrary.simpleMessage("Confs"),
    "contacts" : MessageLookupByLibrary.simpleMessage("Contacts"),
    "currency" : MessageLookupByLibrary.simpleMessage("Currency"),
    "custom" : MessageLookupByLibrary.simpleMessage("Custom"),
    "dark" : MessageLookupByLibrary.simpleMessage("Dark"),
    "datetime" : MessageLookupByLibrary.simpleMessage("Date/Time"),
    "delete" : MessageLookupByLibrary.simpleMessage("DELETE"),
    "doYouWantToDeleteTheSecretKeyAndConvert" : MessageLookupByLibrary.simpleMessage("Do you want to DELETE the secret key and convert this account to a watch-only account? You will not be able to spend from this device anymore. This operation is NOT reversible."),
    "doYouWantToTransferYourEntireTransparentBalanceTo" : m1,
    "enterSeed" : MessageLookupByLibrary.simpleMessage("Enter Seed, Secret Key or Viewing Key. Leave blank for a new account"),
    "height" : MessageLookupByLibrary.simpleMessage("Height"),
    "history" : MessageLookupByLibrary.simpleMessage("History"),
    "includeFeeInAmount" : MessageLookupByLibrary.simpleMessage("Include Fee in Amount"),
    "invalidAddress" : MessageLookupByLibrary.simpleMessage("Invalid Address"),
    "key" : MessageLookupByLibrary.simpleMessage("Key"),
    "largestSpendingLastMonth" : MessageLookupByLibrary.simpleMessage("Largest Spending Last Month"),
    "largestSpendingsByAddress" : MessageLookupByLibrary.simpleMessage("Largest Spendings by Address"),
    "light" : MessageLookupByLibrary.simpleMessage("Light"),
    "max" : MessageLookupByLibrary.simpleMessage("MAX"),
    "maxAmountPerNote" : MessageLookupByLibrary.simpleMessage("Max Amount per Note"),
    "memo" : MessageLookupByLibrary.simpleMessage("Memo"),
    "mm" : MessageLookupByLibrary.simpleMessage("M/M"),
    "multiPay" : MessageLookupByLibrary.simpleMessage("Multi Pay"),
    "multipay" : MessageLookupByLibrary.simpleMessage("MultiPay"),
    "na" : MessageLookupByLibrary.simpleMessage("N/A"),
    "newSnapAddress" : MessageLookupByLibrary.simpleMessage("New Snap Address"),
    "noAccount" : MessageLookupByLibrary.simpleMessage("No account"),
    "noAuthenticationMethod" : MessageLookupByLibrary.simpleMessage("No Authentication Method"),
    "noSpendingInTheLast30Days" : MessageLookupByLibrary.simpleMessage("No Spending in the Last 30 Days"),
    "notEnoughBalance" : MessageLookupByLibrary.simpleMessage("Not enough balance"),
    "notes" : MessageLookupByLibrary.simpleMessage("Notes"),
    "numberOfConfirmationsNeededBeforeSpending" : MessageLookupByLibrary.simpleMessage("Number of Confirmations Needed before Spending"),
    "ok" : MessageLookupByLibrary.simpleMessage("OK"),
    "openInExplorer" : MessageLookupByLibrary.simpleMessage("Open in Explorer"),
    "pink" : MessageLookupByLibrary.simpleMessage("Pink"),
    "pl" : MessageLookupByLibrary.simpleMessage("P/L"),
    "pleaseAuthenticateToShowAccountSeed" : MessageLookupByLibrary.simpleMessage("Please authenticate to show account seed"),
    "pleaseConfirm" : MessageLookupByLibrary.simpleMessage("Please Confirm"),
    "pnl" : MessageLookupByLibrary.simpleMessage("Pnl"),
    "preparingTransaction" : MessageLookupByLibrary.simpleMessage("Preparing transaction..."),
    "price" : MessageLookupByLibrary.simpleMessage("Price"),
    "qty" : MessageLookupByLibrary.simpleMessage("Qty"),
    "realized" : MessageLookupByLibrary.simpleMessage("Realized"),
    "rescan" : MessageLookupByLibrary.simpleMessage("Rescan"),
    "rescanRequested" : MessageLookupByLibrary.simpleMessage("Rescan Requested..."),
    "rescanWalletFromTheFirstBlock" : MessageLookupByLibrary.simpleMessage("Rescan wallet from the first block?"),
    "retrieveTransactionDetails" : MessageLookupByLibrary.simpleMessage("Retrieve Transaction Details"),
    "roundToMillis" : MessageLookupByLibrary.simpleMessage("Round to millis"),
    "scanStartingMomentarily" : MessageLookupByLibrary.simpleMessage("Scan starting momentarily"),
    "secretKey" : MessageLookupByLibrary.simpleMessage("Secret Key"),
    "seed" : MessageLookupByLibrary.simpleMessage("Seed"),
    "selectNotesToExcludeFromPayments" : MessageLookupByLibrary.simpleMessage("Select notes to EXCLUDE from payments"),
    "send" : MessageLookupByLibrary.simpleMessage("Send"),
    "sendCointicker" : m2,
    "sendCointickerTo" : m3,
    "sendingATotalOfAmountCointickerToCountRecipients" : m4,
    "sendingAzecCointickerToAddress" : m5,
    "server" : MessageLookupByLibrary.simpleMessage("Server"),
    "settings" : MessageLookupByLibrary.simpleMessage("Settings"),
    "shieldTranspBalance" : MessageLookupByLibrary.simpleMessage("Shield Transp. Balance"),
    "shieldTransparentBalance" : MessageLookupByLibrary.simpleMessage("Shield Transparent Balance"),
    "shieldTransparentBalanceWithSending" : MessageLookupByLibrary.simpleMessage("Shield Transparent Balance When Sending"),
    "shieldingInProgress" : MessageLookupByLibrary.simpleMessage("Shielding in progress..."),
    "spendable" : MessageLookupByLibrary.simpleMessage("Spendable:"),
    "synching" : MessageLookupByLibrary.simpleMessage("Synching"),
    "table" : MessageLookupByLibrary.simpleMessage("Table"),
    "tapAnIconToShowTheQrCode" : MessageLookupByLibrary.simpleMessage("Tap an icon to show the QR code"),
    "tapChartToToggleBetweenAddressAndAmount" : MessageLookupByLibrary.simpleMessage("Tap Chart to Toggle between Address and Amount"),
    "tapQrCodeForShieldedAddress" : MessageLookupByLibrary.simpleMessage("Tap QR Code for Shielded Address"),
    "tapQrCodeForTransparentAddress" : MessageLookupByLibrary.simpleMessage("Tap QR Code for Transparent Address"),
    "theme" : MessageLookupByLibrary.simpleMessage("Theme"),
    "timestamp" : MessageLookupByLibrary.simpleMessage("Timestamp"),
    "toMakeAContactSendThemAMemoWithContact" : MessageLookupByLibrary.simpleMessage("To make a contact, send them a memo with Contact:"),
    "total" : MessageLookupByLibrary.simpleMessage("Total"),
    "tradingChartRange" : MessageLookupByLibrary.simpleMessage("Trading Chart Range"),
    "tradingPl" : MessageLookupByLibrary.simpleMessage("Wallet P&L"),
    "transactionDetails" : MessageLookupByLibrary.simpleMessage("Transaction Details"),
    "txId" : MessageLookupByLibrary.simpleMessage("TX ID"),
    "unsignedTransactionFile" : MessageLookupByLibrary.simpleMessage("Unsigned Transaction File"),
    "useSettingscurrency" : m6,
    "useUa" : MessageLookupByLibrary.simpleMessage("Use UA"),
    "version" : MessageLookupByLibrary.simpleMessage("Version"),
    "viewingKey" : MessageLookupByLibrary.simpleMessage("Viewing Key")
  };
}
