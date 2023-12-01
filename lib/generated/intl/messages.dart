import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'messages_en.dart';
import 'messages_es.dart';
import 'messages_fr.dart';

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'intl/messages.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S)!;
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr')
  ];

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @budget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget;

  /// No description provided for @tradingPl.
  ///
  /// In en, this message translates to:
  /// **'Wallet P&L'**
  String get tradingPl;

  /// No description provided for @contacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contacts;

  /// No description provided for @accounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get accounts;

  /// No description provided for @backup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backup;

  /// No description provided for @rescan.
  ///
  /// In en, this message translates to:
  /// **'Rescan'**
  String get rescan;

  /// No description provided for @catchup.
  ///
  /// In en, this message translates to:
  /// **'Catch up'**
  String get catchup;

  /// No description provided for @coldStorage.
  ///
  /// In en, this message translates to:
  /// **'Cold Storage'**
  String get coldStorage;

  /// No description provided for @multipay.
  ///
  /// In en, this message translates to:
  /// **'MultiPay'**
  String get multipay;

  /// No description provided for @broadcast.
  ///
  /// In en, this message translates to:
  /// **'Broadcast'**
  String get broadcast;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @synching.
  ///
  /// In en, this message translates to:
  /// **'Synching'**
  String get synching;

  /// No description provided for @tapQrCodeForShieldedAddress.
  ///
  /// In en, this message translates to:
  /// **'Tap QR Code for Shielded Address'**
  String get tapQrCodeForShieldedAddress;

  /// No description provided for @tapQrCodeForTransparentAddress.
  ///
  /// In en, this message translates to:
  /// **'Tap QR Code for Transparent Address'**
  String get tapQrCodeForTransparentAddress;

  /// No description provided for @addressCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Address copied to clipboard'**
  String get addressCopiedToClipboard;

  /// No description provided for @shieldTransparentBalance.
  ///
  /// In en, this message translates to:
  /// **'Shield Transparent Balance'**
  String get shieldTransparentBalance;

  /// No description provided for @doYouWantToTransferYourEntireTransparentBalanceTo.
  ///
  /// In en, this message translates to:
  /// **'Do you want to transfer your entire transparent balance to your shielded address? A Network fee of 0.01 m{ticker} will be deducted.'**
  String doYouWantToTransferYourEntireTransparentBalanceTo(Object ticker);

  /// No description provided for @shieldingInProgress.
  ///
  /// In en, this message translates to:
  /// **'Shielding in progress...'**
  String get shieldingInProgress;

  /// No description provided for @txId.
  ///
  /// In en, this message translates to:
  /// **'TX ID: {txid}'**
  String txId(Object txid);

  /// No description provided for @txID.
  ///
  /// In en, this message translates to:
  /// **'TXID'**
  String get txID;

  /// No description provided for @pleaseAuthenticateToShowAccountSeed.
  ///
  /// In en, this message translates to:
  /// **'Please authenticate to show account seed'**
  String get pleaseAuthenticateToShowAccountSeed;

  /// No description provided for @noAuthenticationMethod.
  ///
  /// In en, this message translates to:
  /// **'No Authentication Method'**
  String get noAuthenticationMethod;

  /// No description provided for @rescanFrom.
  ///
  /// In en, this message translates to:
  /// **'Rescan from...'**
  String get rescanFrom;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @rescanRequested.
  ///
  /// In en, this message translates to:
  /// **'Rescan Requested from {height}...'**
  String rescanRequested(Object height);

  /// No description provided for @confirmWatchOnly.
  ///
  /// In en, this message translates to:
  /// **'Do you want to DELETE the secret key and convert this account to a watch-only account? You will not be able to spend from this device anymore. This operation is NOT reversible.'**
  String get confirmWatchOnly;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'DELETE'**
  String get delete;

  /// No description provided for @confs.
  ///
  /// In en, this message translates to:
  /// **'Confs'**
  String get confs;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @datetime.
  ///
  /// In en, this message translates to:
  /// **'Date/Time'**
  String get datetime;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @selectNotesToExcludeFromPayments.
  ///
  /// In en, this message translates to:
  /// **'Select notes to EXCLUDE from payments'**
  String get selectNotesToExcludeFromPayments;

  /// No description provided for @largestSpendingsByAddress.
  ///
  /// In en, this message translates to:
  /// **'Largest Spendings by Address'**
  String get largestSpendingsByAddress;

  /// No description provided for @tapChartToToggleBetweenAddressAndAmount.
  ///
  /// In en, this message translates to:
  /// **'Tap Chart to Toggle between Address and Amount'**
  String get tapChartToToggleBetweenAddressAndAmount;

  /// No description provided for @accountBalanceHistory.
  ///
  /// In en, this message translates to:
  /// **'Account Balance History'**
  String get accountBalanceHistory;

  /// No description provided for @noSpendingInTheLast30Days.
  ///
  /// In en, this message translates to:
  /// **'No Spending in the Last 30 Days'**
  String get noSpendingInTheLast30Days;

  /// No description provided for @largestSpendingLastMonth.
  ///
  /// In en, this message translates to:
  /// **'Largest Spending Last Month'**
  String get largestSpendingLastMonth;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @pnl.
  ///
  /// In en, this message translates to:
  /// **'Pnl'**
  String get pnl;

  /// No description provided for @mm.
  ///
  /// In en, this message translates to:
  /// **'M/M'**
  String get mm;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @qty.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get qty;

  /// No description provided for @table.
  ///
  /// In en, this message translates to:
  /// **'Table'**
  String get table;

  /// No description provided for @pl.
  ///
  /// In en, this message translates to:
  /// **'P/L'**
  String get pl;

  /// No description provided for @realized.
  ///
  /// In en, this message translates to:
  /// **'Realized'**
  String get realized;

  /// No description provided for @toMakeAContactSendThemAMemoWithContact.
  ///
  /// In en, this message translates to:
  /// **'To make a contact, send them a memo with Contact:'**
  String get toMakeAContactSendThemAMemoWithContact;

  /// No description provided for @newSnapAddress.
  ///
  /// In en, this message translates to:
  /// **'New Snap Address'**
  String get newSnapAddress;

  /// No description provided for @shieldTranspBalance.
  ///
  /// In en, this message translates to:
  /// **'Shield Transp. Balance'**
  String get shieldTranspBalance;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'No account'**
  String get noAccount;

  /// No description provided for @seed.
  ///
  /// In en, this message translates to:
  /// **'Seed'**
  String get seed;

  /// No description provided for @confirmDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Are you SURE you want to DELETE this account? You MUST have a BACKUP to recover it. This operation is NOT reversible.'**
  String get confirmDeleteAccount;

  /// No description provided for @confirmDeleteContact.
  ///
  /// In en, this message translates to:
  /// **'Are you SURE you want to DELETE this contact?'**
  String get confirmDeleteContact;

  /// No description provided for @changeAccountName.
  ///
  /// In en, this message translates to:
  /// **'Change Account Name'**
  String get changeAccountName;

  /// No description provided for @backupDataRequiredForRestore.
  ///
  /// In en, this message translates to:
  /// **'Backup Data - {name} - Required for Restore'**
  String backupDataRequiredForRestore(Object name);

  /// No description provided for @secretKey.
  ///
  /// In en, this message translates to:
  /// **'Secret Key'**
  String get secretKey;

  /// No description provided for @publicKey.
  ///
  /// In en, this message translates to:
  /// **'Public Key'**
  String get publicKey;

  /// No description provided for @viewingKey.
  ///
  /// In en, this message translates to:
  /// **'Viewing Key'**
  String get viewingKey;

  /// No description provided for @tapAnIconToShowTheQrCode.
  ///
  /// In en, this message translates to:
  /// **'Tap an icon to show the QR code'**
  String get tapAnIconToShowTheQrCode;

  /// No description provided for @multiPay.
  ///
  /// In en, this message translates to:
  /// **'Multi Pay'**
  String get multiPay;

  /// No description provided for @pleaseConfirm.
  ///
  /// In en, this message translates to:
  /// **'Please Confirm'**
  String get pleaseConfirm;

  /// No description provided for @sendingATotalOfAmountCointickerToCountRecipients.
  ///
  /// In en, this message translates to:
  /// **'Sending a total of {amount} {ticker} to {count} recipients'**
  String sendingATotalOfAmountCointickerToCountRecipients(Object amount, Object count, Object ticker);

  /// No description provided for @preparingTransaction.
  ///
  /// In en, this message translates to:
  /// **'Preparing transaction...'**
  String get preparingTransaction;

  /// No description provided for @sendCointickerTo.
  ///
  /// In en, this message translates to:
  /// **'Send {ticker} to...'**
  String sendCointickerTo(Object ticker);

  /// No description provided for @addressIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Address is empty'**
  String get addressIsEmpty;

  /// No description provided for @invalidAddress.
  ///
  /// In en, this message translates to:
  /// **'Invalid Address'**
  String get invalidAddress;

  /// No description provided for @amountMustBeANumber.
  ///
  /// In en, this message translates to:
  /// **'Amount must be a number'**
  String get amountMustBeANumber;

  /// No description provided for @amountMustBePositive.
  ///
  /// In en, this message translates to:
  /// **'Amount must be positive'**
  String get amountMustBePositive;

  /// No description provided for @accountName.
  ///
  /// In en, this message translates to:
  /// **'Account Name'**
  String get accountName;

  /// No description provided for @accountNameIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Account name is required'**
  String get accountNameIsRequired;

  /// No description provided for @enterSeed.
  ///
  /// In en, this message translates to:
  /// **'Enter Seed, Secret Key or Viewing Key. Leave blank for a new account'**
  String get enterSeed;

  /// No description provided for @scanStartingMomentarily.
  ///
  /// In en, this message translates to:
  /// **'Scan starting momentarily'**
  String get scanStartingMomentarily;

  /// No description provided for @key.
  ///
  /// In en, this message translates to:
  /// **'Seed, Secret Key or View Key (optional)'**
  String get key;

  /// No description provided for @sendCointicker.
  ///
  /// In en, this message translates to:
  /// **'Send {ticker}'**
  String sendCointicker(Object ticker);

  /// No description provided for @max.
  ///
  /// In en, this message translates to:
  /// **'MAX'**
  String get max;

  /// No description provided for @advancedOptions.
  ///
  /// In en, this message translates to:
  /// **'Advanced Options'**
  String get advancedOptions;

  /// No description provided for @memo.
  ///
  /// In en, this message translates to:
  /// **'Memo'**
  String get memo;

  /// No description provided for @roundToMillis.
  ///
  /// In en, this message translates to:
  /// **'Round to millis'**
  String get roundToMillis;

  /// No description provided for @useSettingscurrency.
  ///
  /// In en, this message translates to:
  /// **'Use {currency}'**
  String useSettingscurrency(Object currency);

  /// No description provided for @includeFeeInAmount.
  ///
  /// In en, this message translates to:
  /// **'Include Fee in Amount'**
  String get includeFeeInAmount;

  /// No description provided for @maxAmountPerNote.
  ///
  /// In en, this message translates to:
  /// **'Max Amount per Note'**
  String get maxAmountPerNote;

  /// No description provided for @spendable.
  ///
  /// In en, this message translates to:
  /// **'Spendable'**
  String get spendable;

  /// No description provided for @notEnoughBalance.
  ///
  /// In en, this message translates to:
  /// **'Not enough balance'**
  String get notEnoughBalance;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'APPROVE'**
  String get approve;

  /// No description provided for @sendingAzecCointickerToAddress.
  ///
  /// In en, this message translates to:
  /// **'Sending {aZEC} {ticker} to {address}'**
  String sendingAzecCointickerToAddress(Object aZEC, Object address, Object ticker);

  /// No description provided for @unsignedTransactionFile.
  ///
  /// In en, this message translates to:
  /// **'Unsigned Transaction File'**
  String get unsignedTransactionFile;

  /// No description provided for @amountInSettingscurrency.
  ///
  /// In en, this message translates to:
  /// **'Amount in {currency}'**
  String amountInSettingscurrency(Object currency);

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @server.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get server;

  /// No description provided for @blue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get blue;

  /// No description provided for @pink.
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get pink;

  /// No description provided for @coffee.
  ///
  /// In en, this message translates to:
  /// **'Coffee'**
  String get coffee;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @numberOfConfirmationsNeededBeforeSpending.
  ///
  /// In en, this message translates to:
  /// **'Number of Confirmations Needed before Spending'**
  String get numberOfConfirmationsNeededBeforeSpending;

  /// No description provided for @retrieveTransactionDetails.
  ///
  /// In en, this message translates to:
  /// **'Retrieve Transaction Details'**
  String get retrieveTransactionDetails;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @transactionDetails.
  ///
  /// In en, this message translates to:
  /// **'Transaction Details'**
  String get transactionDetails;

  /// No description provided for @timestamp.
  ///
  /// In en, this message translates to:
  /// **'Timestamp'**
  String get timestamp;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @openInExplorer.
  ///
  /// In en, this message translates to:
  /// **'Open in Explorer'**
  String get openInExplorer;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @na.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get na;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @tradingChartRange.
  ///
  /// In en, this message translates to:
  /// **'Trading Chart Range'**
  String get tradingChartRange;

  /// No description provided for @m1.
  ///
  /// In en, this message translates to:
  /// **'1 M'**
  String get m1;

  /// No description provided for @m3.
  ///
  /// In en, this message translates to:
  /// **'3 M'**
  String get m3;

  /// No description provided for @m6.
  ///
  /// In en, this message translates to:
  /// **'6 M'**
  String get m6;

  /// No description provided for @y1.
  ///
  /// In en, this message translates to:
  /// **'1 Y'**
  String get y1;

  /// No description provided for @shieldTransparentBalanceWithSending.
  ///
  /// In en, this message translates to:
  /// **'Shield Transparent Balance When Sending'**
  String get shieldTransparentBalanceWithSending;

  /// No description provided for @useUa.
  ///
  /// In en, this message translates to:
  /// **'Use UA'**
  String get useUa;

  /// No description provided for @createANewAccount.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add a new account'**
  String get createANewAccount;

  /// No description provided for @duplicateAccount.
  ///
  /// In en, this message translates to:
  /// **'Duplicate Account'**
  String get duplicateAccount;

  /// No description provided for @thisAccountAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Another account has the same address'**
  String get thisAccountAlreadyExists;

  /// No description provided for @selectAccount.
  ///
  /// In en, this message translates to:
  /// **'Select Account'**
  String get selectAccount;

  /// No description provided for @nameIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Name is empty'**
  String get nameIsEmpty;

  /// No description provided for @deleteContact.
  ///
  /// In en, this message translates to:
  /// **'Delete contact'**
  String get deleteContact;

  /// No description provided for @areYouSureYouWantToDeleteThisContact.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this contact?'**
  String get areYouSureYouWantToDeleteThisContact;

  /// No description provided for @saveToBlockchain.
  ///
  /// In en, this message translates to:
  /// **'Save to Blockchain'**
  String get saveToBlockchain;

  /// No description provided for @areYouSureYouWantToSaveYourContactsIt.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to save your contacts? It will cost 0.01 m{ticker}'**
  String areYouSureYouWantToSaveYourContactsIt(Object ticker);

  /// No description provided for @confirmSaveContacts.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to save your contacts?'**
  String get confirmSaveContacts;

  /// No description provided for @backupWarning.
  ///
  /// In en, this message translates to:
  /// **'No one can recover your secret keys. If you don\'t have a backup and your phone breaks down, you WILL LOSE YOUR MONEY. You can reach this page by the app menu then Backup'**
  String get backupWarning;

  /// No description provided for @contactName.
  ///
  /// In en, this message translates to:
  /// **'Contact Name'**
  String get contactName;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @duplicateContact.
  ///
  /// In en, this message translates to:
  /// **'Another contact has this address'**
  String get duplicateContact;

  /// No description provided for @autoHideBalance.
  ///
  /// In en, this message translates to:
  /// **'Hide Balance'**
  String get autoHideBalance;

  /// No description provided for @tiltYourDeviceUpToRevealYourBalance.
  ///
  /// In en, this message translates to:
  /// **'Tilt your device up to reveal your balance'**
  String get tiltYourDeviceUpToRevealYourBalance;

  /// No description provided for @noContacts.
  ///
  /// In en, this message translates to:
  /// **'No Contacts'**
  String get noContacts;

  /// No description provided for @createANewContactAndItWillShowUpHere.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add a new contact'**
  String get createANewContactAndItWillShowUpHere;

  /// No description provided for @addContact.
  ///
  /// In en, this message translates to:
  /// **'Add Contact'**
  String get addContact;

  /// No description provided for @accountHasSomeBalanceAreYouSureYouWantTo.
  ///
  /// In en, this message translates to:
  /// **'Account has some BALANCE. Are you sure you want to delete it?'**
  String get accountHasSomeBalanceAreYouSureYouWantTo;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @gold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get gold;

  /// No description provided for @purple.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get purple;

  /// No description provided for @noRecipient.
  ///
  /// In en, this message translates to:
  /// **'No Recipient'**
  String get noRecipient;

  /// No description provided for @addARecipientAndItWillShowHere.
  ///
  /// In en, this message translates to:
  /// **'Add a recipient and it will show here'**
  String get addARecipientAndItWillShowHere;

  /// No description provided for @receivePayment.
  ///
  /// In en, this message translates to:
  /// **'Receive Payment'**
  String get receivePayment;

  /// No description provided for @amountTooHigh.
  ///
  /// In en, this message translates to:
  /// **'Amount too high'**
  String get amountTooHigh;

  /// No description provided for @protectSend.
  ///
  /// In en, this message translates to:
  /// **'Protect Send'**
  String get protectSend;

  /// No description provided for @protectSendSettingChanged.
  ///
  /// In en, this message translates to:
  /// **'Protect Send setting changed'**
  String get protectSendSettingChanged;

  /// No description provided for @pleaseAuthenticateToSend.
  ///
  /// In en, this message translates to:
  /// **'Please authenticate to Send'**
  String get pleaseAuthenticateToSend;

  /// No description provided for @unshielded.
  ///
  /// In en, this message translates to:
  /// **'Unshielded'**
  String get unshielded;

  /// No description provided for @unshieldedBalance.
  ///
  /// In en, this message translates to:
  /// **'Unshielded Balance'**
  String get unshieldedBalance;

  /// No description provided for @totalBalance.
  ///
  /// In en, this message translates to:
  /// **'Total Balance'**
  String get totalBalance;

  /// No description provided for @underConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Under Confirmed'**
  String get underConfirmed;

  /// No description provided for @excludedNotes.
  ///
  /// In en, this message translates to:
  /// **'Excluded Notes'**
  String get excludedNotes;

  /// No description provided for @spendableBalance.
  ///
  /// In en, this message translates to:
  /// **'Spendable Balance'**
  String get spendableBalance;

  /// No description provided for @rescanNeeded.
  ///
  /// In en, this message translates to:
  /// **'Rescan Needed'**
  String get rescanNeeded;

  /// No description provided for @tapTransactionForDetails.
  ///
  /// In en, this message translates to:
  /// **'Tap Transaction for Details'**
  String get tapTransactionForDetails;

  /// No description provided for @transactionHistory.
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get transactionHistory;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @receive.
  ///
  /// In en, this message translates to:
  /// **'Receive {ticker}'**
  String receive(Object ticker);

  /// No description provided for @pnlHistory.
  ///
  /// In en, this message translates to:
  /// **'PNL History'**
  String get pnlHistory;

  /// No description provided for @useTransparentBalance.
  ///
  /// In en, this message translates to:
  /// **'Use Transparent Balance'**
  String get useTransparentBalance;

  /// No description provided for @themeEditor.
  ///
  /// In en, this message translates to:
  /// **'Theme Editor'**
  String get themeEditor;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @accentColor.
  ///
  /// In en, this message translates to:
  /// **'Accent Color'**
  String get accentColor;

  /// No description provided for @primary.
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get primary;

  /// No description provided for @secondary.
  ///
  /// In en, this message translates to:
  /// **'Secondary'**
  String get secondary;

  /// No description provided for @multisig.
  ///
  /// In en, this message translates to:
  /// **'Multisig'**
  String get multisig;

  /// No description provided for @enterSecretShareIfAccountIsMultisignature.
  ///
  /// In en, this message translates to:
  /// **'Enter secret share if account is multi-signature'**
  String get enterSecretShareIfAccountIsMultisignature;

  /// No description provided for @secretShare.
  ///
  /// In en, this message translates to:
  /// **'Secret Share'**
  String get secretShare;

  /// No description provided for @fileSaved.
  ///
  /// In en, this message translates to:
  /// **'File saved'**
  String get fileSaved;

  /// No description provided for @numMoreSignersNeeded.
  ///
  /// In en, this message translates to:
  /// **'{num} more signers needed'**
  String numMoreSignersNeeded(Object num);

  /// No description provided for @sign.
  ///
  /// In en, this message translates to:
  /// **'Sign Transaction'**
  String get sign;

  /// No description provided for @splitAccount.
  ///
  /// In en, this message translates to:
  /// **'Split Account'**
  String get splitAccount;

  /// No description provided for @confirmSigning.
  ///
  /// In en, this message translates to:
  /// **'Confirm Signing'**
  String get confirmSigning;

  /// No description provided for @confirmSignATransactionToAddressFor.
  ///
  /// In en, this message translates to:
  /// **'Do you want to sign a transaction to {address} for {amount}'**
  String confirmSignATransactionToAddressFor(Object address, Object amount);

  /// No description provided for @multisigShares.
  ///
  /// In en, this message translates to:
  /// **'Multisig Shares'**
  String get multisigShares;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @textCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'{text} copied to clipboard'**
  String textCopiedToClipboard(Object text);

  /// No description provided for @multipleAddresses.
  ///
  /// In en, this message translates to:
  /// **'multiple addresses'**
  String get multipleAddresses;

  /// No description provided for @addnew.
  ///
  /// In en, this message translates to:
  /// **'New/Restore'**
  String get addnew;

  /// No description provided for @applicationReset.
  ///
  /// In en, this message translates to:
  /// **'Application Reset'**
  String get applicationReset;

  /// No description provided for @confirmResetApp.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset the app? Your accounts will NOT be deleted'**
  String get confirmResetApp;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @restart.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restart;

  /// No description provided for @pleaseQuitAndRestartTheAppNow.
  ///
  /// In en, this message translates to:
  /// **'Please Quit and Restart the app in order for these changes to take effect'**
  String get pleaseQuitAndRestartTheAppNow;

  /// No description provided for @mode.
  ///
  /// In en, this message translates to:
  /// **'Advanced Mode'**
  String get mode;

  /// No description provided for @simple.
  ///
  /// In en, this message translates to:
  /// **'Simple'**
  String get simple;

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// No description provided for @sendFrom.
  ///
  /// In en, this message translates to:
  /// **'Sent from {app}'**
  String sendFrom(Object app);

  /// No description provided for @defaultMemo.
  ///
  /// In en, this message translates to:
  /// **'Default Memo'**
  String get defaultMemo;

  /// No description provided for @fullBackup.
  ///
  /// In en, this message translates to:
  /// **'Full Backup'**
  String get fullBackup;

  /// No description provided for @backupEncryptionKey.
  ///
  /// In en, this message translates to:
  /// **'Backup Encryption Key'**
  String get backupEncryptionKey;

  /// No description provided for @saveBackup.
  ///
  /// In en, this message translates to:
  /// **'Save Backup'**
  String get saveBackup;

  /// No description provided for @encryptedBackup.
  ///
  /// In en, this message translates to:
  /// **'{app} Encrypted Backup'**
  String encryptedBackup(Object app);

  /// No description provided for @fullRestore.
  ///
  /// In en, this message translates to:
  /// **'Full Restore'**
  String get fullRestore;

  /// No description provided for @loadBackup.
  ///
  /// In en, this message translates to:
  /// **'Load Backup'**
  String get loadBackup;

  /// No description provided for @backupAllAccounts.
  ///
  /// In en, this message translates to:
  /// **'Backup All Accounts'**
  String get backupAllAccounts;

  /// No description provided for @simpleMode.
  ///
  /// In en, this message translates to:
  /// **'Simple Mode'**
  String get simpleMode;

  /// No description provided for @accountIndex.
  ///
  /// In en, this message translates to:
  /// **'Account Index'**
  String get accountIndex;

  /// No description provided for @subAccountOf.
  ///
  /// In en, this message translates to:
  /// **'Sub Account of {name}'**
  String subAccountOf(Object name);

  /// No description provided for @subAccountIndexOf.
  ///
  /// In en, this message translates to:
  /// **'Sub Account {index} of {name}'**
  String subAccountIndexOf(Object index, Object name);

  /// No description provided for @newSubAccount.
  ///
  /// In en, this message translates to:
  /// **'New Sub Account'**
  String get newSubAccount;

  /// No description provided for @noActiveAccount.
  ///
  /// In en, this message translates to:
  /// **'No active account'**
  String get noActiveAccount;

  /// No description provided for @closeApplication.
  ///
  /// In en, this message translates to:
  /// **'Close Application'**
  String get closeApplication;

  /// No description provided for @disconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get disconnected;

  /// No description provided for @ledger.
  ///
  /// In en, this message translates to:
  /// **'Ledger'**
  String get ledger;

  /// No description provided for @mobileCharges.
  ///
  /// In en, this message translates to:
  /// **'On Mobile Data, scanning may incur additional charges. Do you want to proceed?'**
  String get mobileCharges;

  /// No description provided for @iHaveMadeABackup.
  ///
  /// In en, this message translates to:
  /// **'I have made a backup'**
  String get iHaveMadeABackup;

  /// No description provided for @barcodeScannerIsNotAvailableOnDesktop.
  ///
  /// In en, this message translates to:
  /// **'Barcode scanner is not available on desktop'**
  String get barcodeScannerIsNotAvailableOnDesktop;

  /// No description provided for @signOffline.
  ///
  /// In en, this message translates to:
  /// **'Sign'**
  String get signOffline;

  /// No description provided for @rawTransaction.
  ///
  /// In en, this message translates to:
  /// **'Raw Transaction'**
  String get rawTransaction;

  /// No description provided for @convertToWatchonly.
  ///
  /// In en, this message translates to:
  /// **'To Watch-Only'**
  String get convertToWatchonly;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @body.
  ///
  /// In en, this message translates to:
  /// **'Body'**
  String get body;

  /// No description provided for @subject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get subject;

  /// No description provided for @includeReplyTo.
  ///
  /// In en, this message translates to:
  /// **'Include My Address in Memo'**
  String get includeReplyTo;

  /// No description provided for @sender.
  ///
  /// In en, this message translates to:
  /// **'Sender'**
  String get sender;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @recipient.
  ///
  /// In en, this message translates to:
  /// **'Recipient'**
  String get recipient;

  /// No description provided for @fromto.
  ///
  /// In en, this message translates to:
  /// **'From/To'**
  String get fromto;

  /// No description provided for @rescanning.
  ///
  /// In en, this message translates to:
  /// **'Rescanning...'**
  String get rescanning;

  /// No description provided for @markAllAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark All as Read'**
  String get markAllAsRead;

  /// No description provided for @showMessagesAsTable.
  ///
  /// In en, this message translates to:
  /// **'Show Messages as Table'**
  String get showMessagesAsTable;

  /// No description provided for @editContact.
  ///
  /// In en, this message translates to:
  /// **'Edit Contact'**
  String get editContact;

  /// No description provided for @now.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get now;

  /// No description provided for @protectOpen.
  ///
  /// In en, this message translates to:
  /// **'Protect Open'**
  String get protectOpen;

  /// No description provided for @gapLimit.
  ///
  /// In en, this message translates to:
  /// **'Gap Limit'**
  String get gapLimit;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'ERROR'**
  String get error;

  /// No description provided for @paymentInProgress.
  ///
  /// In en, this message translates to:
  /// **'Payment in progress...'**
  String get paymentInProgress;

  /// No description provided for @useQrForOfflineSigning.
  ///
  /// In en, this message translates to:
  /// **'Use QR for offline signing'**
  String get useQrForOfflineSigning;

  /// No description provided for @unsignedTx.
  ///
  /// In en, this message translates to:
  /// **'Unsigned Tx'**
  String get unsignedTx;

  /// No description provided for @signOnYourOfflineDevice.
  ///
  /// In en, this message translates to:
  /// **'Sign on your offline device'**
  String get signOnYourOfflineDevice;

  /// No description provided for @signedTx.
  ///
  /// In en, this message translates to:
  /// **'Signed Tx'**
  String get signedTx;

  /// No description provided for @broadcastFromYourOnlineDevice.
  ///
  /// In en, this message translates to:
  /// **'Broadcast from your online device'**
  String get broadcastFromYourOnlineDevice;

  /// No description provided for @checkTransaction.
  ///
  /// In en, this message translates to:
  /// **'Check Transaction'**
  String get checkTransaction;

  /// No description provided for @crypto.
  ///
  /// In en, this message translates to:
  /// **'Crypto'**
  String get crypto;

  /// No description provided for @restoreAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Restore an account?'**
  String get restoreAnAccount;

  /// No description provided for @welcomeToYwallet.
  ///
  /// In en, this message translates to:
  /// **'Welcome to YWallet'**
  String get welcomeToYwallet;

  /// No description provided for @thePrivateWalletMessenger.
  ///
  /// In en, this message translates to:
  /// **'The private wallet & messenger'**
  String get thePrivateWalletMessenger;

  /// No description provided for @newAccount.
  ///
  /// In en, this message translates to:
  /// **'New Account'**
  String get newAccount;

  /// No description provided for @invalidKey.
  ///
  /// In en, this message translates to:
  /// **'Invalid Key'**
  String get invalidKey;

  /// No description provided for @barcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get barcode;

  /// No description provided for @inputBarcodeValue.
  ///
  /// In en, this message translates to:
  /// **'Input barcode'**
  String get inputBarcodeValue;

  /// No description provided for @auto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get auto;

  /// No description provided for @count.
  ///
  /// In en, this message translates to:
  /// **'Count'**
  String get count;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @changeTransparentKey.
  ///
  /// In en, this message translates to:
  /// **'Change Transparent Key'**
  String get changeTransparentKey;

  /// No description provided for @cancelScan.
  ///
  /// In en, this message translates to:
  /// **'Cancel Scan'**
  String get cancelScan;

  /// No description provided for @resumeScan.
  ///
  /// In en, this message translates to:
  /// **'Resume Scan'**
  String get resumeScan;

  /// No description provided for @syncPaused.
  ///
  /// In en, this message translates to:
  /// **'PAUSED - Tap to Resume'**
  String get syncPaused;

  /// No description provided for @derivationPath.
  ///
  /// In en, this message translates to:
  /// **'Derivation Path'**
  String get derivationPath;

  /// No description provided for @privateKey.
  ///
  /// In en, this message translates to:
  /// **'Private Key'**
  String get privateKey;

  /// No description provided for @keyTool.
  ///
  /// In en, this message translates to:
  /// **'Key Tool'**
  String get keyTool;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Recalc'**
  String get update;

  /// No description provided for @antispamFilter.
  ///
  /// In en, this message translates to:
  /// **'Anti-Spam Filter'**
  String get antispamFilter;

  /// No description provided for @doYouWantToRestore.
  ///
  /// In en, this message translates to:
  /// **'Do you want to restore your database? THIS WILL ERASE YOUR CURRENT DATA'**
  String get doYouWantToRestore;

  /// No description provided for @useGpu.
  ///
  /// In en, this message translates to:
  /// **'Use GPU'**
  String get useGpu;

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @newLabel.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newLabel;

  /// No description provided for @invalidQrCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid QR code: {message}'**
  String invalidQrCode(Object message);

  /// No description provided for @expert.
  ///
  /// In en, this message translates to:
  /// **'Expert'**
  String get expert;

  /// No description provided for @blockReorgDetectedRewind.
  ///
  /// In en, this message translates to:
  /// **'Block reorg detected. Rewind to {rewindHeight}'**
  String blockReorgDetectedRewind(Object rewindHeight);

  /// No description provided for @goToTransaction.
  ///
  /// In en, this message translates to:
  /// **'Show Transaction'**
  String get goToTransaction;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @synchronizationInProgress.
  ///
  /// In en, this message translates to:
  /// **'Synchronization in Progress'**
  String get synchronizationInProgress;

  /// No description provided for @incomingFunds.
  ///
  /// In en, this message translates to:
  /// **'Incoming funds'**
  String get incomingFunds;

  /// No description provided for @paymentMade.
  ///
  /// In en, this message translates to:
  /// **'Payment made'**
  String get paymentMade;

  /// No description provided for @received.
  ///
  /// In en, this message translates to:
  /// **'Received {amount} {ticker}'**
  String received(Object amount, Object ticker);

  /// No description provided for @spent.
  ///
  /// In en, this message translates to:
  /// **'Spent {amount} {ticker}'**
  String spent(Object amount, Object ticker);

  /// No description provided for @set.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get set;

  /// No description provided for @encryptionKey.
  ///
  /// In en, this message translates to:
  /// **'Encryption Key'**
  String get encryptionKey;

  /// No description provided for @dbImportSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Db Import Successful'**
  String get dbImportSuccessful;

  /// No description provided for @pools.
  ///
  /// In en, this message translates to:
  /// **'Pools'**
  String get pools;

  /// No description provided for @poolTransfer.
  ///
  /// In en, this message translates to:
  /// **'Pool Transfer'**
  String get poolTransfer;

  /// No description provided for @fromPool.
  ///
  /// In en, this message translates to:
  /// **'From Pool'**
  String get fromPool;

  /// No description provided for @toPool.
  ///
  /// In en, this message translates to:
  /// **'To Pool'**
  String get toPool;

  /// No description provided for @maxSpendableAmount.
  ///
  /// In en, this message translates to:
  /// **'Max spendable: {amount} {ticker}'**
  String maxSpendableAmount(Object amount, Object ticker);

  /// No description provided for @splitNotes.
  ///
  /// In en, this message translates to:
  /// **'Split Notes'**
  String get splitNotes;

  /// No description provided for @transfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transfer;

  /// No description provided for @template.
  ///
  /// In en, this message translates to:
  /// **'Template'**
  String get template;

  /// No description provided for @newTemplate.
  ///
  /// In en, this message translates to:
  /// **'New Template'**
  String get newTemplate;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @deleteTemplate.
  ///
  /// In en, this message translates to:
  /// **'Delete Template?'**
  String get deleteTemplate;

  /// No description provided for @areYouSureYouWantToDeleteThisSendTemplate.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this send template?'**
  String get areYouSureYouWantToDeleteThisSendTemplate;

  /// No description provided for @rewindToCheckpoint.
  ///
  /// In en, this message translates to:
  /// **'Rewind to Checkpoint'**
  String get rewindToCheckpoint;

  /// No description provided for @selectCheckpoint.
  ///
  /// In en, this message translates to:
  /// **'Select Checkpoint'**
  String get selectCheckpoint;

  /// No description provided for @scanQrCode.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scanQrCode;

  /// No description provided for @minPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Min Privacy'**
  String get minPrivacy;

  /// No description provided for @privacyLevelTooLow.
  ///
  /// In en, this message translates to:
  /// **'Privacy Too LOW - Long press to override'**
  String get privacyLevelTooLow;

  /// No description provided for @veryLow.
  ///
  /// In en, this message translates to:
  /// **'Very Low'**
  String get veryLow;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'PRIVACY: {level}'**
  String privacy(Object level);

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @signingPleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Signing, please wait...'**
  String get signingPleaseWait;

  /// No description provided for @sweep.
  ///
  /// In en, this message translates to:
  /// **'Sweep'**
  String get sweep;

  /// No description provided for @transparentKey.
  ///
  /// In en, this message translates to:
  /// **'Transparent Key'**
  String get transparentKey;

  /// No description provided for @unifiedViewingKey.
  ///
  /// In en, this message translates to:
  /// **'Unified Viewing Key'**
  String get unifiedViewingKey;

  /// No description provided for @encryptDatabase.
  ///
  /// In en, this message translates to:
  /// **'Encrypt Database'**
  String get encryptDatabase;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @repeatNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Repeat New Password'**
  String get repeatNewPassword;

  /// No description provided for @databasePassword.
  ///
  /// In en, this message translates to:
  /// **'Database Password'**
  String get databasePassword;

  /// No description provided for @currentPasswordIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Current password incorrect'**
  String get currentPasswordIncorrect;

  /// No description provided for @newPasswordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'New passwords do not match'**
  String get newPasswordsDoNotMatch;

  /// No description provided for @databaseEncrypted.
  ///
  /// In en, this message translates to:
  /// **'Database Encrypted'**
  String get databaseEncrypted;

  /// No description provided for @invalidPassword.
  ///
  /// In en, this message translates to:
  /// **'Invalid Password'**
  String get invalidPassword;

  /// No description provided for @databaseRestored.
  ///
  /// In en, this message translates to:
  /// **'Database Restored'**
  String get databaseRestored;

  /// No description provided for @never.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get never;

  /// No description provided for @always.
  ///
  /// In en, this message translates to:
  /// **'Always'**
  String get always;

  /// No description provided for @scanTransparentAddresses.
  ///
  /// In en, this message translates to:
  /// **'Scan Transparent Addresses'**
  String get scanTransparentAddresses;

  /// No description provided for @scanningAddresses.
  ///
  /// In en, this message translates to:
  /// **'Scanning addresses'**
  String get scanningAddresses;

  /// No description provided for @blockExplorer.
  ///
  /// In en, this message translates to:
  /// **'Block Explorer'**
  String get blockExplorer;

  /// No description provided for @tapQrCodeForSaplingAddress.
  ///
  /// In en, this message translates to:
  /// **'Tap QR Code for Sapling Address'**
  String get tapQrCodeForSaplingAddress;

  /// No description provided for @playSound.
  ///
  /// In en, this message translates to:
  /// **'Play Sound Effects'**
  String get playSound;

  /// No description provided for @fee.
  ///
  /// In en, this message translates to:
  /// **'Fee'**
  String get fee;

  /// No description provided for @coins.
  ///
  /// In en, this message translates to:
  /// **'Coins'**
  String get coins;

  /// No description provided for @rewind.
  ///
  /// In en, this message translates to:
  /// **'Rewind'**
  String get rewind;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @marketPrice.
  ///
  /// In en, this message translates to:
  /// **'Mkt Prices'**
  String get marketPrice;

  /// No description provided for @txPlan.
  ///
  /// In en, this message translates to:
  /// **'Transaction Plan'**
  String get txPlan;

  /// No description provided for @pool.
  ///
  /// In en, this message translates to:
  /// **'Pool'**
  String get pool;

  /// No description provided for @transparentInput.
  ///
  /// In en, this message translates to:
  /// **'Transparent Input'**
  String get transparentInput;

  /// No description provided for @saplingInput.
  ///
  /// In en, this message translates to:
  /// **'Sapling Input'**
  String get saplingInput;

  /// No description provided for @orchardInput.
  ///
  /// In en, this message translates to:
  /// **'Orchard Input'**
  String get orchardInput;

  /// No description provided for @netSapling.
  ///
  /// In en, this message translates to:
  /// **'Net Sapling Change'**
  String get netSapling;

  /// No description provided for @netOrchard.
  ///
  /// In en, this message translates to:
  /// **'Net Orchard Change'**
  String get netOrchard;

  /// No description provided for @transparent.
  ///
  /// In en, this message translates to:
  /// **'Transparent'**
  String get transparent;

  /// No description provided for @sapling.
  ///
  /// In en, this message translates to:
  /// **'Sapling'**
  String get sapling;

  /// No description provided for @orchard.
  ///
  /// In en, this message translates to:
  /// **'Orchard'**
  String get orchard;

  /// No description provided for @paymentURI.
  ///
  /// In en, this message translates to:
  /// **'Payment URI'**
  String get paymentURI;

  /// No description provided for @lastPayment.
  ///
  /// In en, this message translates to:
  /// **'Repeat Last Payment'**
  String get lastPayment;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @prev.
  ///
  /// In en, this message translates to:
  /// **'Prev'**
  String get prev;

  /// No description provided for @nan.
  ///
  /// In en, this message translates to:
  /// **'Not a number'**
  String get nan;

  /// No description provided for @memoTooLong.
  ///
  /// In en, this message translates to:
  /// **'Memo too long'**
  String get memoTooLong;

  /// No description provided for @sending.
  ///
  /// In en, this message translates to:
  /// **'Sending Transaction'**
  String get sending;

  /// No description provided for @sent.
  ///
  /// In en, this message translates to:
  /// **'Transaction Sent'**
  String get sent;

  /// No description provided for @sent_failed.
  ///
  /// In en, this message translates to:
  /// **'Transaction Failed'**
  String get sent_failed;

  /// No description provided for @invalidPaymentURI.
  ///
  /// In en, this message translates to:
  /// **'Invalid Payment URI'**
  String get invalidPaymentURI;

  /// No description provided for @noSelection.
  ///
  /// In en, this message translates to:
  /// **'Nothing Selected'**
  String get noSelection;

  /// No description provided for @confirmations.
  ///
  /// In en, this message translates to:
  /// **'Min. Confirmations'**
  String get confirmations;

  /// No description provided for @hidden.
  ///
  /// In en, this message translates to:
  /// **'Hidden'**
  String get hidden;

  /// No description provided for @autoHide.
  ///
  /// In en, this message translates to:
  /// **'Auto Hide'**
  String get autoHide;

  /// No description provided for @shown.
  ///
  /// In en, this message translates to:
  /// **'Shown'**
  String get shown;

  /// No description provided for @useZats.
  ///
  /// In en, this message translates to:
  /// **'Use Zats (8 decimals)'**
  String get useZats;

  /// No description provided for @mainUA.
  ///
  /// In en, this message translates to:
  /// **'Main UA Receivers'**
  String get mainUA;

  /// No description provided for @replyUA.
  ///
  /// In en, this message translates to:
  /// **'Reply UA Receivers'**
  String get replyUA;

  /// No description provided for @uaReceivers.
  ///
  /// In en, this message translates to:
  /// **'UA Receivers'**
  String get uaReceivers;

  /// No description provided for @list.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get list;

  /// No description provided for @autoView.
  ///
  /// In en, this message translates to:
  /// **'Orientation'**
  String get autoView;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @priv.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get priv;

  /// No description provided for @views.
  ///
  /// In en, this message translates to:
  /// **'Views'**
  String get views;

  /// No description provided for @autoFee.
  ///
  /// In en, this message translates to:
  /// **'Automatic Fee'**
  String get autoFee;

  /// No description provided for @accountManager.
  ///
  /// In en, this message translates to:
  /// **'Account Manager'**
  String get accountManager;

  /// No description provided for @pleaseWaitPlan.
  ///
  /// In en, this message translates to:
  /// **'Computing Transaction'**
  String get pleaseWaitPlan;

  /// No description provided for @deletePayment.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this recipient'**
  String get deletePayment;

  /// No description provided for @ua.
  ///
  /// In en, this message translates to:
  /// **'UA'**
  String get ua;

  /// No description provided for @receivers.
  ///
  /// In en, this message translates to:
  /// **'Receivers'**
  String get receivers;

  /// No description provided for @secured.
  ///
  /// In en, this message translates to:
  /// **'Secured'**
  String get secured;

  /// No description provided for @external.
  ///
  /// In en, this message translates to:
  /// **'External'**
  String get external;

  /// No description provided for @derpath.
  ///
  /// In en, this message translates to:
  /// **'Derivation Path'**
  String get derpath;

  /// No description provided for @shielded.
  ///
  /// In en, this message translates to:
  /// **'Shielded'**
  String get shielded;

  /// No description provided for @addressIndex.
  ///
  /// In en, this message translates to:
  /// **'Address Index'**
  String get addressIndex;

  /// No description provided for @index.
  ///
  /// In en, this message translates to:
  /// **'Index'**
  String get index;

  /// No description provided for @pleaseAuthenticate.
  ///
  /// In en, this message translates to:
  /// **'Please Authenticate'**
  String get pleaseAuthenticate;

  /// No description provided for @diversified.
  ///
  /// In en, this message translates to:
  /// **'Diversified'**
  String get diversified;

  /// No description provided for @source.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get source;

  /// No description provided for @destination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get destination;

  /// No description provided for @scanRawTx.
  ///
  /// In en, this message translates to:
  /// **'Scan the Unsigned Tx QR codes'**
  String get scanRawTx;

  /// No description provided for @scanSignedTx.
  ///
  /// In en, this message translates to:
  /// **'Scan the Signed Tx QR codes'**
  String get scanSignedTx;

  /// No description provided for @pickColor.
  ///
  /// In en, this message translates to:
  /// **'Pick a Color'**
  String get pickColor;

  /// No description provided for @qr.
  ///
  /// In en, this message translates to:
  /// **'QR Code'**
  String get qr;

  /// No description provided for @rescanWarning.
  ///
  /// In en, this message translates to:
  /// **'RESCAN resets all your accounts. You may want to consider using REWIND instead'**
  String get rescanWarning;

  /// No description provided for @cannotUseTKey.
  ///
  /// In en, this message translates to:
  /// **'Cannot import transparent private key. Use SWEEP instead'**
  String get cannotUseTKey;

  /// No description provided for @noDbPassword.
  ///
  /// In en, this message translates to:
  /// **'Database must be encrypted to protect open/spend'**
  String get noDbPassword;

  /// No description provided for @seedOrKeyRequired.
  ///
  /// In en, this message translates to:
  /// **'Seed or Private Key required'**
  String get seedOrKeyRequired;

  /// No description provided for @keygen.
  ///
  /// In en, this message translates to:
  /// **'Backup Keygen'**
  String get keygen;

  /// No description provided for @keygenHelp.
  ///
  /// In en, this message translates to:
  /// **'Full backups use the AGE encryption system. The encryption key is used to encrypt the backup but CANNOT decrypt it. The SECRET key is needed to restore the backup.\nThe app will not store the keys. Every time this keygen will produce a DIFFERENT pair of keys.\n\nYou MUST save BOTH keys that you use'**
  String get keygenHelp;

  /// No description provided for @confirmSaveKeys.
  ///
  /// In en, this message translates to:
  /// **'Have you saved your keys?'**
  String get confirmSaveKeys;

  /// No description provided for @deductFee.
  ///
  /// In en, this message translates to:
  /// **'Deduct fee from amount'**
  String get deductFee;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'DISCONNECTED'**
  String get connectionError;

  /// No description provided for @disclaimer.
  ///
  /// In en, this message translates to:
  /// **'Disclaimer'**
  String get disclaimer;

  /// No description provided for @disclaimerText.
  ///
  /// In en, this message translates to:
  /// **'SELF-CUSTODY'**
  String get disclaimerText;

  /// No description provided for @disclaimer_1.
  ///
  /// In en, this message translates to:
  /// **'I understand I am responsible for securing my seed phrase'**
  String get disclaimer_1;

  /// No description provided for @disclaimer_2.
  ///
  /// In en, this message translates to:
  /// **'I understand YWallet cannot recover my seed phrase'**
  String get disclaimer_2;

  /// No description provided for @disclaimer_3.
  ///
  /// In en, this message translates to:
  /// **'I understand whoever knows my seed phrase can get my funds'**
  String get disclaimer_3;

  /// No description provided for @confirmRescanFrom.
  ///
  /// In en, this message translates to:
  /// **'Do you want to rescan from block {height}?'**
  String confirmRescanFrom(Object height);

  /// No description provided for @confirmRewind.
  ///
  /// In en, this message translates to:
  /// **'Do you want to rewind to block {height}?'**
  String confirmRewind(Object height);

  /// No description provided for @backupMissing.
  ///
  /// In en, this message translates to:
  /// **'BACKUP MISSING'**
  String get backupMissing;

  /// No description provided for @noRemindBackup.
  ///
  /// In en, this message translates to:
  /// **'Do not remind me'**
  String get noRemindBackup;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copy to Clipboard'**
  String get copiedToClipboard;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return SEn();
    case 'es': return SEs();
    case 'fr': return SFr();
  }

  throw FlutterError(
    'S.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
