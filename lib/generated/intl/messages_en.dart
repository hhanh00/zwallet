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
  String get localeName => 'en';

  static String m0(currency) => "Amount in ${currency}";

  static String m1(ticker) =>
      "Are you sure you want to save your contacts? It will cost 0.01 m${ticker}";

  static String m2(name) => "Backup Data - ${name} - Required for Restore";

  static String m3(address, amount) =>
      "Do you want to sign a transaction to ${address} for ${amount}";

  static String m4(ticker) =>
      "Do you want to transfer your entire transparent balance to your shielded address? A Network fee of 0.01 m${ticker} will be deducted.";

  static String m5(app) => "${app} Encrypted Backup";

  static String m6(num) => "${num} more signers needed";

  static String m7(ticker) => "Receive ${ticker}";

  static String m8(ticker) => "Send ${ticker}";

  static String m9(ticker) => "Send ${ticker} to...";

  static String m10(app) => "Sent from ${app}";

  static String m11(amount, ticker, count) =>
      "Sending a total of ${amount} ${ticker} to ${count} recipients";

  static String m12(aZEC, ticker, address) =>
      "Sending ${aZEC} ${ticker} to ${address}";

  static String m13(name) => "Sub Account of ${name}";

  static String m14(text) => "${text} copied to clipboard";

  static String m15(currency) => "Use ${currency}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "M1": MessageLookupByLibrary.simpleMessage("1 M"),
        "M3": MessageLookupByLibrary.simpleMessage("3 M"),
        "M6": MessageLookupByLibrary.simpleMessage("6 M"),
        "Y1": MessageLookupByLibrary.simpleMessage("1 Y"),
        "about": MessageLookupByLibrary.simpleMessage("About"),
        "accentColor": MessageLookupByLibrary.simpleMessage("Accent Color"),
        "account": MessageLookupByLibrary.simpleMessage("Account"),
        "accountBalanceHistory":
            MessageLookupByLibrary.simpleMessage("Account Balance History"),
        "accountHasSomeBalanceAreYouSureYouWantTo":
            MessageLookupByLibrary.simpleMessage(
                "Account has some BALANCE. Are you sure you want to delete it?"),
        "accountIndex": MessageLookupByLibrary.simpleMessage("Account Index"),
        "accountName": MessageLookupByLibrary.simpleMessage("Account Name"),
        "accountNameIsRequired":
            MessageLookupByLibrary.simpleMessage("Account name is required"),
        "accounts": MessageLookupByLibrary.simpleMessage("Accounts"),
        "add": MessageLookupByLibrary.simpleMessage("ADD"),
        "addARecipientAndItWillShowHere": MessageLookupByLibrary.simpleMessage(
            "Add a recipient and it will show here"),
        "addContact": MessageLookupByLibrary.simpleMessage("Add Contact"),
        "addnew": MessageLookupByLibrary.simpleMessage("NEW/RESTORE"),
        "address": MessageLookupByLibrary.simpleMessage("Address"),
        "addressCopiedToClipboard":
            MessageLookupByLibrary.simpleMessage("Address copied to clipboard"),
        "addressIsEmpty":
            MessageLookupByLibrary.simpleMessage("Address is empty"),
        "advanced": MessageLookupByLibrary.simpleMessage("Advanced"),
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
        "applicationReset":
            MessageLookupByLibrary.simpleMessage("Application Reset"),
        "approve": MessageLookupByLibrary.simpleMessage("APPROVE"),
        "areYouSureYouWantToDeleteThisContact":
            MessageLookupByLibrary.simpleMessage(
                "Are you sure you want to delete this contact?"),
        "areYouSureYouWantToSaveYourContactsIt": m1,
        "autoHideBalance":
            MessageLookupByLibrary.simpleMessage("Auto Hide Balance"),
        "backup": MessageLookupByLibrary.simpleMessage("Backup"),
        "backupAllAccounts":
            MessageLookupByLibrary.simpleMessage("Backup All Accounts"),
        "backupDataRequiredForRestore": m2,
        "backupEncryptionKey":
            MessageLookupByLibrary.simpleMessage("Backup Encryption Key"),
        "backupWarning": MessageLookupByLibrary.simpleMessage(
            "No one can recover your secret keys. If you don\'t have a backup and your phone breaks down, you WILL LOSE YOUR MONEY. You can reach this page by the app menu then Backup"),
        "balance": MessageLookupByLibrary.simpleMessage("Balance"),
        "blue": MessageLookupByLibrary.simpleMessage("Blue"),
        "broadcast": MessageLookupByLibrary.simpleMessage("Broadcast"),
        "budget": MessageLookupByLibrary.simpleMessage("Budget"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "changeAccountName":
            MessageLookupByLibrary.simpleMessage("Change Account Name"),
        "changingTheModeWillTakeEffectAtNextRestart":
            MessageLookupByLibrary.simpleMessage(
                "Changing the mode will take effect at next restart"),
        "closeApplication":
            MessageLookupByLibrary.simpleMessage("Close Application"),
        "coffee": MessageLookupByLibrary.simpleMessage("Coffee"),
        "coldStorage": MessageLookupByLibrary.simpleMessage("Cold Storage"),
        "color": MessageLookupByLibrary.simpleMessage("Color"),
        "confirmDeleteAccount": MessageLookupByLibrary.simpleMessage(
            "Are you SURE you want to DELETE this account? You MUST have a BACKUP to recover it. This operation is NOT reversible."),
        "confirmResetApp": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to reset the app? Your accounts will NOT be deleted"),
        "confirmSignATransactionToAddressFor": m3,
        "confirmSigning":
            MessageLookupByLibrary.simpleMessage("Confirm Signing"),
        "confs": MessageLookupByLibrary.simpleMessage("Confs"),
        "contactName": MessageLookupByLibrary.simpleMessage("Contact Name"),
        "contacts": MessageLookupByLibrary.simpleMessage("Contacts"),
        "copy": MessageLookupByLibrary.simpleMessage("Copy"),
        "createANewAccount":
            MessageLookupByLibrary.simpleMessage("Tap + to add a new account"),
        "createANewContactAndItWillShowUpHere":
            MessageLookupByLibrary.simpleMessage("Tap + to add a new contact"),
        "currency": MessageLookupByLibrary.simpleMessage("Currency"),
        "custom": MessageLookupByLibrary.simpleMessage("Custom"),
        "dark": MessageLookupByLibrary.simpleMessage("Dark"),
        "date": MessageLookupByLibrary.simpleMessage("Date"),
        "datetime": MessageLookupByLibrary.simpleMessage("Date/Time"),
        "defaultMemo": MessageLookupByLibrary.simpleMessage("Default Memo"),
        "delete": MessageLookupByLibrary.simpleMessage("DELETE"),
        "deleteAccount": MessageLookupByLibrary.simpleMessage("Delete Account"),
        "deleteContact": MessageLookupByLibrary.simpleMessage("Delete contact"),
        "disconnected": MessageLookupByLibrary.simpleMessage("Disconnected"),
        "doYouWantToDeleteTheSecretKeyAndConvert":
            MessageLookupByLibrary.simpleMessage(
                "Do you want to DELETE the secret key and convert this account to a watch-only account? You will not be able to spend from this device anymore. This operation is NOT reversible."),
        "doYouWantToTransferYourEntireTransparentBalanceTo": m4,
        "duplicateAccount":
            MessageLookupByLibrary.simpleMessage("Duplicate Account"),
        "duplicateContact": MessageLookupByLibrary.simpleMessage(
            "Another contact has this address"),
        "encryptedBackup": m5,
        "enterSecretShareIfAccountIsMultisignature":
            MessageLookupByLibrary.simpleMessage(
                "Enter secret share if account is multi-signature"),
        "enterSeed": MessageLookupByLibrary.simpleMessage(
            "Enter Seed, Secret Key or Viewing Key. Leave blank for a new account"),
        "excludedNotes": MessageLookupByLibrary.simpleMessage("Excluded Notes"),
        "fileSaved": MessageLookupByLibrary.simpleMessage("File saved"),
        "fullBackup": MessageLookupByLibrary.simpleMessage("Full Backup"),
        "fullRestore": MessageLookupByLibrary.simpleMessage("Full Restore"),
        "gold": MessageLookupByLibrary.simpleMessage("Gold"),
        "height": MessageLookupByLibrary.simpleMessage("Height"),
        "help": MessageLookupByLibrary.simpleMessage("Help"),
        "history": MessageLookupByLibrary.simpleMessage("History"),
        "includeFeeInAmount":
            MessageLookupByLibrary.simpleMessage("Include Fee in Amount"),
        "invalidAddress":
            MessageLookupByLibrary.simpleMessage("Invalid Address"),
        "key": MessageLookupByLibrary.simpleMessage(
            "Seed, Secret Key or View Key (optional)"),
        "largestSpendingLastMonth":
            MessageLookupByLibrary.simpleMessage("Largest Spending Last Month"),
        "largestSpendingsByAddress": MessageLookupByLibrary.simpleMessage(
            "Largest Spendings by Address"),
        "ledger": MessageLookupByLibrary.simpleMessage("Ledger"),
        "light": MessageLookupByLibrary.simpleMessage("Light"),
        "loadBackup": MessageLookupByLibrary.simpleMessage("Load Backup"),
        "loading": MessageLookupByLibrary.simpleMessage("Loading..."),
        "max": MessageLookupByLibrary.simpleMessage("MAX"),
        "maxAmountPerNote":
            MessageLookupByLibrary.simpleMessage("Max Amount per Note"),
        "memo": MessageLookupByLibrary.simpleMessage("Memo"),
        "mm": MessageLookupByLibrary.simpleMessage("M/M"),
        "mode": MessageLookupByLibrary.simpleMessage("Mode"),
        "multiPay": MessageLookupByLibrary.simpleMessage("Multi Pay"),
        "multipay": MessageLookupByLibrary.simpleMessage("MultiPay"),
        "multipleAddresses":
            MessageLookupByLibrary.simpleMessage("multiple addresses"),
        "multisig": MessageLookupByLibrary.simpleMessage("Multisig"),
        "multisigShares":
            MessageLookupByLibrary.simpleMessage("Multisig Shares"),
        "na": MessageLookupByLibrary.simpleMessage("N/A"),
        "nameIsEmpty": MessageLookupByLibrary.simpleMessage("Name is empty"),
        "newSnapAddress":
            MessageLookupByLibrary.simpleMessage("New Snap Address"),
        "newSubAccount":
            MessageLookupByLibrary.simpleMessage("New Sub Account"),
        "noAccount": MessageLookupByLibrary.simpleMessage("No account"),
        "noActiveAccount":
            MessageLookupByLibrary.simpleMessage("No active account"),
        "noAuthenticationMethod":
            MessageLookupByLibrary.simpleMessage("No Authentication Method"),
        "noContacts": MessageLookupByLibrary.simpleMessage("No Contacts"),
        "noRecipient": MessageLookupByLibrary.simpleMessage("No Recipient"),
        "noSpendingInTheLast30Days": MessageLookupByLibrary.simpleMessage(
            "No Spending in the Last 30 Days"),
        "notEnoughBalance":
            MessageLookupByLibrary.simpleMessage("Not enough balance"),
        "notes": MessageLookupByLibrary.simpleMessage("Notes"),
        "numMoreSignersNeeded": m6,
        "numberOfConfirmationsNeededBeforeSpending":
            MessageLookupByLibrary.simpleMessage(
                "Number of Confirmations Needed before Spending"),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "openInExplorer":
            MessageLookupByLibrary.simpleMessage("Open in Explorer"),
        "pink": MessageLookupByLibrary.simpleMessage("Pink"),
        "pl": MessageLookupByLibrary.simpleMessage("P/L"),
        "pleaseAuthenticateToSend":
            MessageLookupByLibrary.simpleMessage("Please authenticate to Send"),
        "pleaseAuthenticateToShowAccountSeed":
            MessageLookupByLibrary.simpleMessage(
                "Please authenticate to show account seed"),
        "pleaseConfirm": MessageLookupByLibrary.simpleMessage("Please Confirm"),
        "pleaseQuitAndRestartTheAppNow": MessageLookupByLibrary.simpleMessage(
            "Please Quit and Restart the app now"),
        "pleaseRestartNow":
            MessageLookupByLibrary.simpleMessage("Please Restart now"),
        "pnl": MessageLookupByLibrary.simpleMessage("Pnl"),
        "pnlHistory": MessageLookupByLibrary.simpleMessage("PNL History"),
        "preparingTransaction":
            MessageLookupByLibrary.simpleMessage("Preparing transaction..."),
        "price": MessageLookupByLibrary.simpleMessage("Price"),
        "primary": MessageLookupByLibrary.simpleMessage("Primary"),
        "protectSend": MessageLookupByLibrary.simpleMessage("Protect Send"),
        "protectSendSettingChanged": MessageLookupByLibrary.simpleMessage(
            "Protect Send setting changed"),
        "purple": MessageLookupByLibrary.simpleMessage("Purple"),
        "qty": MessageLookupByLibrary.simpleMessage("Qty"),
        "realized": MessageLookupByLibrary.simpleMessage("Realized"),
        "receive": m7,
        "receivePayment":
            MessageLookupByLibrary.simpleMessage("Receive Payment"),
        "rescan": MessageLookupByLibrary.simpleMessage("Rescan"),
        "rescanNeeded": MessageLookupByLibrary.simpleMessage("Rescan Needed"),
        "rescanRequested":
            MessageLookupByLibrary.simpleMessage("Rescan Requested..."),
        "rescanWalletFromTheFirstBlock": MessageLookupByLibrary.simpleMessage(
            "Rescan wallet from the first block?"),
        "reset": MessageLookupByLibrary.simpleMessage("RESET"),
        "restart": MessageLookupByLibrary.simpleMessage("Restart"),
        "retrieveTransactionDetails": MessageLookupByLibrary.simpleMessage(
            "Retrieve Transaction Details"),
        "roundToMillis":
            MessageLookupByLibrary.simpleMessage("Round to millis"),
        "saveBackup": MessageLookupByLibrary.simpleMessage("Save Backup"),
        "saveToBlockchain":
            MessageLookupByLibrary.simpleMessage("Save to Blockchain"),
        "scanStartingMomentarily":
            MessageLookupByLibrary.simpleMessage("Scan starting momentarily"),
        "secondary": MessageLookupByLibrary.simpleMessage("Secondary"),
        "secretKey": MessageLookupByLibrary.simpleMessage("Secret Key"),
        "secretShare": MessageLookupByLibrary.simpleMessage("Secret Share"),
        "seed": MessageLookupByLibrary.simpleMessage("Seed"),
        "selectAccount": MessageLookupByLibrary.simpleMessage("Select Account"),
        "selectNotesToExcludeFromPayments":
            MessageLookupByLibrary.simpleMessage(
                "Select notes to EXCLUDE from payments"),
        "send": MessageLookupByLibrary.simpleMessage("Send"),
        "sendCointicker": m8,
        "sendCointickerTo": m9,
        "sendFrom": m10,
        "sendingATotalOfAmountCointickerToCountRecipients": m11,
        "sendingAzecCointickerToAddress": m12,
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
        "sign": MessageLookupByLibrary.simpleMessage("Sign Transaction"),
        "simple": MessageLookupByLibrary.simpleMessage("Simple"),
        "simpleMode": MessageLookupByLibrary.simpleMessage("Simple Mode"),
        "spendable": MessageLookupByLibrary.simpleMessage("Spendable"),
        "spendableBalance":
            MessageLookupByLibrary.simpleMessage("Spendable Balance"),
        "splitAccount": MessageLookupByLibrary.simpleMessage("Split Account"),
        "subAccountOf": m13,
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
        "tapTransactionForDetails":
            MessageLookupByLibrary.simpleMessage("Tap Transaction for Details"),
        "textCopiedToClipboard": m14,
        "theme": MessageLookupByLibrary.simpleMessage("Theme"),
        "themeEditor": MessageLookupByLibrary.simpleMessage("Theme Editor"),
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
        "totalBalance": MessageLookupByLibrary.simpleMessage("Total Balance"),
        "tradingChartRange":
            MessageLookupByLibrary.simpleMessage("Trading Chart Range"),
        "tradingPl": MessageLookupByLibrary.simpleMessage("Wallet P&L"),
        "transactionDetails":
            MessageLookupByLibrary.simpleMessage("Transaction Details"),
        "transactionHistory":
            MessageLookupByLibrary.simpleMessage("Transaction History"),
        "txId": MessageLookupByLibrary.simpleMessage("TX ID"),
        "underConfirmed":
            MessageLookupByLibrary.simpleMessage("Under Confirmed"),
        "unshielded": MessageLookupByLibrary.simpleMessage("Unshielded"),
        "unshieldedBalance":
            MessageLookupByLibrary.simpleMessage("Unshielded Balance"),
        "unsignedTransactionFile":
            MessageLookupByLibrary.simpleMessage("Unsigned Transaction File"),
        "useSettingscurrency": m15,
        "useTransparentBalance":
            MessageLookupByLibrary.simpleMessage("Use Transparent Balance"),
        "useUa": MessageLookupByLibrary.simpleMessage("Use UA"),
        "version": MessageLookupByLibrary.simpleMessage("Version"),
        "viewingKey": MessageLookupByLibrary.simpleMessage("Viewing Key")
      };
}
