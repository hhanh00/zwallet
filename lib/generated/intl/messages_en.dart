// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(currency) => "Amount in ${currency}";

  static String m1(ticker) =>
      "Are you sure you want to save your contacts? It will cost 0.01 m${ticker}";

  static String m2(ticker) =>
      "Do you want to transfer your entire transparent balance to your shielded address? A Network fee of 0.01 m${ticker} will be deducted.";

  static String m3(ticker) => "Send ${ticker}";

  static String m4(ticker) => "Send ${ticker} to...";

  static String m5(amount, ticker, count) =>
      "Sending a total of ${amount} ${ticker} to ${count} recipients";

  static String m6(aZEC, ticker, address) =>
      "Sending ${aZEC} ${ticker} to ${address}";

  static String m7(currency) => "Use ${currency}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "M1": MessageLookupByLibrary.simpleMessage("1 M"),
        "M3": MessageLookupByLibrary.simpleMessage("3 M"),
        "M6": MessageLookupByLibrary.simpleMessage("6 M"),
        "Y1": MessageLookupByLibrary.simpleMessage("1 Y"),
        "about": MessageLookupByLibrary.simpleMessage("About"),
        "account": MessageLookupByLibrary.simpleMessage("Account"),
        "accountBalanceHistory":
            MessageLookupByLibrary.simpleMessage("Account Balance History"),
        "accountHasSomeBalanceAreYouSureYouWantTo":
            MessageLookupByLibrary.simpleMessage(
                "Account has some BALANCE. Are you sure you want to delete it?"),
        "accountName": MessageLookupByLibrary.simpleMessage("Account Name"),
        "accountNameIsRequired":
            MessageLookupByLibrary.simpleMessage("Account name is required"),
        "accounts": MessageLookupByLibrary.simpleMessage("Accounts"),
        "add": MessageLookupByLibrary.simpleMessage("ADD"),
        "addARecipientAndItWillShowHere": MessageLookupByLibrary.simpleMessage(
            "Add a recipient and it will show here"),
        "addContact": MessageLookupByLibrary.simpleMessage("Add Contact"),
        "address": MessageLookupByLibrary.simpleMessage("Address"),
        "addressCopiedToClipboard":
            MessageLookupByLibrary.simpleMessage("Address copied to clipboard"),
        "addressIsEmpty":
            MessageLookupByLibrary.simpleMessage("Address is empty"),
        "advancedOptions":
            MessageLookupByLibrary.simpleMessage("Advanced Options"),
        "amount": MessageLookupByLibrary.simpleMessage("Amount"),
        "amountInSettingscurrency": m0,
        "amountMustBeANumber":
            MessageLookupByLibrary.simpleMessage("Amount must be a number"),
        "amountMustBePositive":
            MessageLookupByLibrary.simpleMessage("Amount must be positive"),
        "amountTooHigh":
            MessageLookupByLibrary.simpleMessage("Amount too high"),
        "approve": MessageLookupByLibrary.simpleMessage("APPROVE"),
        "areYouSureYouWantToDeleteThisContact":
            MessageLookupByLibrary.simpleMessage(
                "Are you sure you want to delete this contact?"),
        "areYouSureYouWantToSaveYourContactsIt": m1,
        "autoHideBalance":
            MessageLookupByLibrary.simpleMessage("Auto Hide Balance"),
        "backup": MessageLookupByLibrary.simpleMessage("Backup"),
        "backupDataRequiredForRestore": MessageLookupByLibrary.simpleMessage(
            "Backup Data - Required for Restore"),
        "backupWarning": MessageLookupByLibrary.simpleMessage(
            "No one can recover your secret keys. If you don\'t have a backup and your phone breaks down, you WILL LOSE YOUR MONEY. You can reach this page by the app menu then Backup"),
        "balance": MessageLookupByLibrary.simpleMessage("Balance"),
        "blue": MessageLookupByLibrary.simpleMessage("Blue"),
        "broadcast": MessageLookupByLibrary.simpleMessage("Broadcast"),
        "budget": MessageLookupByLibrary.simpleMessage("Budget"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "changeAccountName":
            MessageLookupByLibrary.simpleMessage("Change Account Name"),
        "coffee": MessageLookupByLibrary.simpleMessage("Coffee"),
        "coldStorage": MessageLookupByLibrary.simpleMessage("Cold Storage"),
        "confirmDeleteAccount": MessageLookupByLibrary.simpleMessage(
            "Are you SURE you want to DELETE this account? You MUST have a BACKUP to recover it. This operation is NOT reversible."),
        "confs": MessageLookupByLibrary.simpleMessage("Confs"),
        "contactName": MessageLookupByLibrary.simpleMessage("Contact Name"),
        "contacts": MessageLookupByLibrary.simpleMessage("Contacts"),
        "createANewAccount": MessageLookupByLibrary.simpleMessage(
            "Create a new account and it will show up here"),
        "createANewContactAndItWillShowUpHere":
            MessageLookupByLibrary.simpleMessage(
                "Create a new contact and it will show up here"),
        "currency": MessageLookupByLibrary.simpleMessage("Currency"),
        "custom": MessageLookupByLibrary.simpleMessage("Custom"),
        "dark": MessageLookupByLibrary.simpleMessage("Dark"),
        "date": MessageLookupByLibrary.simpleMessage("Date"),
        "datetime": MessageLookupByLibrary.simpleMessage("Date/Time"),
        "delete": MessageLookupByLibrary.simpleMessage("DELETE"),
        "deleteAccount": MessageLookupByLibrary.simpleMessage("Delete Account"),
        "deleteContact": MessageLookupByLibrary.simpleMessage("Delete contact"),
        "doYouWantToDeleteTheSecretKeyAndConvert":
            MessageLookupByLibrary.simpleMessage(
                "Do you want to DELETE the secret key and convert this account to a watch-only account? You will not be able to spend from this device anymore. This operation is NOT reversible."),
        "doYouWantToTransferYourEntireTransparentBalanceTo": m2,
        "duplicateAccount":
            MessageLookupByLibrary.simpleMessage("Duplicate Account"),
        "duplicateContact": MessageLookupByLibrary.simpleMessage(
            "Another contact has this address"),
        "enterSeed": MessageLookupByLibrary.simpleMessage(
            "Enter Seed, Secret Key or Viewing Key. Leave blank for a new account"),
        "gold": MessageLookupByLibrary.simpleMessage("Gold"),
        "height": MessageLookupByLibrary.simpleMessage("Height"),
        "history": MessageLookupByLibrary.simpleMessage("History"),
        "includeFeeInAmount":
            MessageLookupByLibrary.simpleMessage("Include Fee in Amount"),
        "invalidAddress":
            MessageLookupByLibrary.simpleMessage("Invalid Address"),
        "key": MessageLookupByLibrary.simpleMessage(
            "Seed, Secret Key or View Key"),
        "largestSpendingLastMonth":
            MessageLookupByLibrary.simpleMessage("Largest Spending Last Month"),
        "largestSpendingsByAddress": MessageLookupByLibrary.simpleMessage(
            "Largest Spendings by Address"),
        "light": MessageLookupByLibrary.simpleMessage("Light"),
        "max": MessageLookupByLibrary.simpleMessage("MAX"),
        "maxAmountPerNote":
            MessageLookupByLibrary.simpleMessage("Max Amount per Note"),
        "memo": MessageLookupByLibrary.simpleMessage("Memo"),
        "mm": MessageLookupByLibrary.simpleMessage("M/M"),
        "multiPay": MessageLookupByLibrary.simpleMessage("Multi Pay"),
        "multipay": MessageLookupByLibrary.simpleMessage("MultiPay"),
        "na": MessageLookupByLibrary.simpleMessage("N/A"),
        "nameIsEmpty": MessageLookupByLibrary.simpleMessage("Name is empty"),
        "newSnapAddress":
            MessageLookupByLibrary.simpleMessage("New Snap Address"),
        "noAccount": MessageLookupByLibrary.simpleMessage("No account"),
        "noAuthenticationMethod":
            MessageLookupByLibrary.simpleMessage("No Authentication Method"),
        "noContacts": MessageLookupByLibrary.simpleMessage("No Contacts"),
        "noRecipient": MessageLookupByLibrary.simpleMessage("No Recipient"),
        "noSpendingInTheLast30Days": MessageLookupByLibrary.simpleMessage(
            "No Spending in the Last 30 Days"),
        "notEnoughBalance":
            MessageLookupByLibrary.simpleMessage("Not enough balance"),
        "notes": MessageLookupByLibrary.simpleMessage("Notes"),
        "numberOfConfirmationsNeededBeforeSpending":
            MessageLookupByLibrary.simpleMessage(
                "Number of Confirmations Needed before Spending"),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "openInExplorer":
            MessageLookupByLibrary.simpleMessage("Open in Explorer"),
        "pink": MessageLookupByLibrary.simpleMessage("Pink"),
        "pl": MessageLookupByLibrary.simpleMessage("P/L"),
        "pleaseAuthenticateToShowAccountSeed":
            MessageLookupByLibrary.simpleMessage(
                "Please authenticate to show account seed"),
        "pleaseConfirm": MessageLookupByLibrary.simpleMessage("Please Confirm"),
        "pnl": MessageLookupByLibrary.simpleMessage("Pnl"),
        "preparingTransaction":
            MessageLookupByLibrary.simpleMessage("Preparing transaction..."),
        "price": MessageLookupByLibrary.simpleMessage("Price"),
        "protectSend": MessageLookupByLibrary.simpleMessage("Protect Send"),
        "purple": MessageLookupByLibrary.simpleMessage("Purple"),
        "qty": MessageLookupByLibrary.simpleMessage("Qty"),
        "realized": MessageLookupByLibrary.simpleMessage("Realized"),
        "receivePayment":
            MessageLookupByLibrary.simpleMessage("Receive Payment"),
        "rescan": MessageLookupByLibrary.simpleMessage("Rescan"),
        "rescanRequested":
            MessageLookupByLibrary.simpleMessage("Rescan Requested..."),
        "rescanWalletFromTheFirstBlock": MessageLookupByLibrary.simpleMessage(
            "Rescan wallet from the first block?"),
        "retrieveTransactionDetails": MessageLookupByLibrary.simpleMessage(
            "Retrieve Transaction Details"),
        "roundToMillis":
            MessageLookupByLibrary.simpleMessage("Round to millis"),
        "saveToBlockchain":
            MessageLookupByLibrary.simpleMessage("Save to Blockchain"),
        "scanStartingMomentarily":
            MessageLookupByLibrary.simpleMessage("Scan starting momentarily"),
        "secretKey": MessageLookupByLibrary.simpleMessage("Secret Key"),
        "seed": MessageLookupByLibrary.simpleMessage("Seed"),
        "selectAccount": MessageLookupByLibrary.simpleMessage("Select Account"),
        "selectNotesToExcludeFromPayments":
            MessageLookupByLibrary.simpleMessage(
                "Select notes to EXCLUDE from payments"),
        "send": MessageLookupByLibrary.simpleMessage("Send"),
        "sendCointicker": m3,
        "sendCointickerTo": m4,
        "sendingATotalOfAmountCointickerToCountRecipients": m5,
        "sendingAzecCointickerToAddress": m6,
        "server": MessageLookupByLibrary.simpleMessage("Server"),
        "settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "shieldTranspBalance":
            MessageLookupByLibrary.simpleMessage("Shield Transp. Balance"),
        "shieldTransparentBalance":
            MessageLookupByLibrary.simpleMessage("Shield Transparent Balance"),
        "shieldTransparentBalanceWithSending":
            MessageLookupByLibrary.simpleMessage(
                "Shield Transparent Balance When Sending"),
        "shieldingInProgress":
            MessageLookupByLibrary.simpleMessage("Shielding in progress..."),
        "spendable": MessageLookupByLibrary.simpleMessage("Spendable:"),
        "synching": MessageLookupByLibrary.simpleMessage("Synching"),
        "table": MessageLookupByLibrary.simpleMessage("Table"),
        "tapAnIconToShowTheQrCode": MessageLookupByLibrary.simpleMessage(
            "Tap an icon to show the QR code"),
        "tapChartToToggleBetweenAddressAndAmount":
            MessageLookupByLibrary.simpleMessage(
                "Tap Chart to Toggle between Address and Amount"),
        "tapQrCodeForShieldedAddress": MessageLookupByLibrary.simpleMessage(
            "Tap QR Code for Shielded Address"),
        "tapQrCodeForTransparentAddress": MessageLookupByLibrary.simpleMessage(
            "Tap QR Code for Transparent Address"),
        "theme": MessageLookupByLibrary.simpleMessage("Theme"),
        "thisAccountAlreadyExists": MessageLookupByLibrary.simpleMessage(
            "Another account has the same address"),
        "tiltYourDeviceUpToRevealYourBalance":
            MessageLookupByLibrary.simpleMessage(
                "Tilt your device up to reveal your balance"),
        "timestamp": MessageLookupByLibrary.simpleMessage("Timestamp"),
        "toMakeAContactSendThemAMemoWithContact":
            MessageLookupByLibrary.simpleMessage(
                "To make a contact, send them a memo with Contact:"),
        "total": MessageLookupByLibrary.simpleMessage("Total"),
        "tradingChartRange":
            MessageLookupByLibrary.simpleMessage("Trading Chart Range"),
        "tradingPl": MessageLookupByLibrary.simpleMessage("Wallet P&L"),
        "transactionDetails":
            MessageLookupByLibrary.simpleMessage("Transaction Details"),
        "txId": MessageLookupByLibrary.simpleMessage("TX ID"),
        "unsignedTransactionFile":
            MessageLookupByLibrary.simpleMessage("Unsigned Transaction File"),
        "useSettingscurrency": m7,
        "useUa": MessageLookupByLibrary.simpleMessage("Use UA"),
        "version": MessageLookupByLibrary.simpleMessage("Version"),
        "viewingKey": MessageLookupByLibrary.simpleMessage("Viewing Key")
      };
}
