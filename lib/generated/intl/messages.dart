import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'messages_en.dart';
import 'messages_es.dart';
import 'messages_fr.dart';
import 'messages_pt.dart';

// ignore_for_file: type=lint

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
    Locale('fr'),
    Locale('pt')
  ];

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @accountBalanceHistory.
  ///
  /// In en, this message translates to:
  /// **'Account Balance History'**
  String get accountBalanceHistory;

  /// No description provided for @accountIndex.
  ///
  /// In en, this message translates to:
  /// **'Account Index'**
  String get accountIndex;

  /// No description provided for @accountManager.
  ///
  /// In en, this message translates to:
  /// **'Account Manager'**
  String get accountManager;

  /// No description provided for @accountName.
  ///
  /// In en, this message translates to:
  /// **'Account Name'**
  String get accountName;

  /// No description provided for @accounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get accounts;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @addContact.
  ///
  /// In en, this message translates to:
  /// **'Add Contact'**
  String get addContact;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @addressCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Address copied to clipboard'**
  String get addressCopiedToClipboard;

  /// No description provided for @addressIndex.
  ///
  /// In en, this message translates to:
  /// **'Address Index'**
  String get addressIndex;

  /// No description provided for @addressIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Address is empty'**
  String get addressIsEmpty;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @amountCurrency.
  ///
  /// In en, this message translates to:
  /// **'Amount in Fiat'**
  String get amountCurrency;

  /// No description provided for @amountMustBePositive.
  ///
  /// In en, this message translates to:
  /// **'Amount must be positive'**
  String get amountMustBePositive;

  /// No description provided for @amountSlider.
  ///
  /// In en, this message translates to:
  /// **'Amount Slider'**
  String get amountSlider;

  /// No description provided for @antispamFilter.
  ///
  /// In en, this message translates to:
  /// **'Anti-Spam Filter'**
  String get antispamFilter;

  /// No description provided for @any.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get any;

  /// No description provided for @appData.
  ///
  /// In en, this message translates to:
  /// **'App Data'**
  String get appData;

  /// No description provided for @auto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get auto;

  /// No description provided for @autoFee.
  ///
  /// In en, this message translates to:
  /// **'Automatic Fee'**
  String get autoFee;

  /// No description provided for @autoHide.
  ///
  /// In en, this message translates to:
  /// **'Auto Hide'**
  String get autoHide;

  /// No description provided for @autoHideBalance.
  ///
  /// In en, this message translates to:
  /// **'Hide Balance'**
  String get autoHideBalance;

  /// No description provided for @autoView.
  ///
  /// In en, this message translates to:
  /// **'Orientation'**
  String get autoView;

  /// No description provided for @backgroundSync.
  ///
  /// In en, this message translates to:
  /// **'Background Sync'**
  String get backgroundSync;

  /// No description provided for @backup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backup;

  /// No description provided for @backupAllAccounts.
  ///
  /// In en, this message translates to:
  /// **'Backup All Accounts'**
  String get backupAllAccounts;

  /// No description provided for @backupMissing.
  ///
  /// In en, this message translates to:
  /// **'BACKUP MISSING'**
  String get backupMissing;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @barcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get barcode;

  /// No description provided for @blockExplorer.
  ///
  /// In en, this message translates to:
  /// **'Block Explorer'**
  String get blockExplorer;

  /// No description provided for @body.
  ///
  /// In en, this message translates to:
  /// **'Body'**
  String get body;

  /// No description provided for @broadcast.
  ///
  /// In en, this message translates to:
  /// **'Broadcast'**
  String get broadcast;

  /// No description provided for @budget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @cannotDeleteActive.
  ///
  /// In en, this message translates to:
  /// **'Cannot delete the active account unless it is the last one'**
  String get cannotDeleteActive;

  /// No description provided for @cannotUseTKey.
  ///
  /// In en, this message translates to:
  /// **'Cannot import transparent private key. Use SWEEP instead'**
  String get cannotUseTKey;

  /// No description provided for @catchup.
  ///
  /// In en, this message translates to:
  /// **'Catch up'**
  String get catchup;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @coldStorage.
  ///
  /// In en, this message translates to:
  /// **'Cold Storage'**
  String get coldStorage;

  /// No description provided for @configure.
  ///
  /// In en, this message translates to:
  /// **'Configure'**
  String get configure;

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

  /// No description provided for @confirmSaveContacts.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to save your contacts?'**
  String get confirmSaveContacts;

  /// No description provided for @confirmSaveKeys.
  ///
  /// In en, this message translates to:
  /// **'Have you saved your keys?'**
  String get confirmSaveKeys;

  /// No description provided for @confirmWatchOnly.
  ///
  /// In en, this message translates to:
  /// **'Deleting or converting to viewing key is NOT reversible. You CANNOT upgrade back to using a secret key.'**
  String get confirmWatchOnly;

  /// No description provided for @confirmations.
  ///
  /// In en, this message translates to:
  /// **'Min. Confirmations'**
  String get confirmations;

  /// No description provided for @confs.
  ///
  /// In en, this message translates to:
  /// **'Confs'**
  String get confs;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'DISCONNECTED'**
  String get connectionError;

  /// No description provided for @contactName.
  ///
  /// In en, this message translates to:
  /// **'Contact Name'**
  String get contactName;

  /// No description provided for @contacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contacts;

  /// No description provided for @convertToWatchonly.
  ///
  /// In en, this message translates to:
  /// **'To Watch-Only'**
  String get convertToWatchonly;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copy to Clipboard'**
  String get copiedToClipboard;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @count.
  ///
  /// In en, this message translates to:
  /// **'Count'**
  String get count;

  /// No description provided for @crypto.
  ///
  /// In en, this message translates to:
  /// **'Crypto'**
  String get crypto;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @customSend.
  ///
  /// In en, this message translates to:
  /// **'Use Custom Send'**
  String get customSend;

  /// No description provided for @customSendSettings.
  ///
  /// In en, this message translates to:
  /// **'Custom Send Settings'**
  String get customSendSettings;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @databasePassword.
  ///
  /// In en, this message translates to:
  /// **'Database Password'**
  String get databasePassword;

  /// No description provided for @databaseRestored.
  ///
  /// In en, this message translates to:
  /// **'Database Restored'**
  String get databaseRestored;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @datetime.
  ///
  /// In en, this message translates to:
  /// **'Date/Time'**
  String get datetime;

  /// No description provided for @deductFee.
  ///
  /// In en, this message translates to:
  /// **'Deduct fee from amount'**
  String get deductFee;

  /// No description provided for @defaultMemo.
  ///
  /// In en, this message translates to:
  /// **'Default Memo'**
  String get defaultMemo;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'DELETE'**
  String get delete;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account {name}'**
  String deleteAccount(Object name);

  /// No description provided for @deletePayment.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this recipient'**
  String get deletePayment;

  /// No description provided for @derpath.
  ///
  /// In en, this message translates to:
  /// **'Derivation Path'**
  String get derpath;

  /// No description provided for @destination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get destination;

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

  /// No description provided for @diversified.
  ///
  /// In en, this message translates to:
  /// **'Diversified'**
  String get diversified;

  /// No description provided for @editContact.
  ///
  /// In en, this message translates to:
  /// **'Edit Contact'**
  String get editContact;

  /// No description provided for @encryptDatabase.
  ///
  /// In en, this message translates to:
  /// **'Encrypt Database'**
  String get encryptDatabase;

  /// No description provided for @encryptionKey.
  ///
  /// In en, this message translates to:
  /// **'Encryption Key'**
  String get encryptionKey;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'ERROR'**
  String get error;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @fee.
  ///
  /// In en, this message translates to:
  /// **'Fee'**
  String get fee;

  /// No description provided for @fromPool.
  ///
  /// In en, this message translates to:
  /// **'From Pool'**
  String get fromPool;

  /// No description provided for @fromto.
  ///
  /// In en, this message translates to:
  /// **'From/To'**
  String get fromto;

  /// No description provided for @fullBackup.
  ///
  /// In en, this message translates to:
  /// **'Full Backup'**
  String get fullBackup;

  /// No description provided for @fullRestore.
  ///
  /// In en, this message translates to:
  /// **'Full Restore'**
  String get fullRestore;

  /// No description provided for @gapLimit.
  ///
  /// In en, this message translates to:
  /// **'Gap Limit'**
  String get gapLimit;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @hidden.
  ///
  /// In en, this message translates to:
  /// **'Hidden'**
  String get hidden;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @includeReplyTo.
  ///
  /// In en, this message translates to:
  /// **'Include My Address in Memo'**
  String get includeReplyTo;

  /// No description provided for @incomingFunds.
  ///
  /// In en, this message translates to:
  /// **'Incoming funds'**
  String get incomingFunds;

  /// No description provided for @index.
  ///
  /// In en, this message translates to:
  /// **'Index'**
  String get index;

  /// No description provided for @interval.
  ///
  /// In en, this message translates to:
  /// **'Interval'**
  String get interval;

  /// No description provided for @invalidAddress.
  ///
  /// In en, this message translates to:
  /// **'Invalid Address'**
  String get invalidAddress;

  /// No description provided for @invalidKey.
  ///
  /// In en, this message translates to:
  /// **'Invalid Key'**
  String get invalidKey;

  /// No description provided for @invalidPassword.
  ///
  /// In en, this message translates to:
  /// **'Invalid Password'**
  String get invalidPassword;

  /// No description provided for @invalidPaymentURI.
  ///
  /// In en, this message translates to:
  /// **'Invalid Payment URI'**
  String get invalidPaymentURI;

  /// No description provided for @key.
  ///
  /// In en, this message translates to:
  /// **'Seed, Secret Key or View Key (optional)'**
  String get key;

  /// No description provided for @keyTool.
  ///
  /// In en, this message translates to:
  /// **'Key Tool'**
  String get keyTool;

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

  /// No description provided for @largestSpendingsByAddress.
  ///
  /// In en, this message translates to:
  /// **'Largest Spendings by Address'**
  String get largestSpendingsByAddress;

  /// No description provided for @ledger.
  ///
  /// In en, this message translates to:
  /// **'Ledger'**
  String get ledger;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @list.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get list;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @mainReceivers.
  ///
  /// In en, this message translates to:
  /// **'Main Receivers'**
  String get mainReceivers;

  /// No description provided for @market.
  ///
  /// In en, this message translates to:
  /// **'Market'**
  String get market;

  /// No description provided for @marketPrice.
  ///
  /// In en, this message translates to:
  /// **'Mkt Prices'**
  String get marketPrice;

  /// No description provided for @max.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get max;

  /// No description provided for @maxAmountPerNote.
  ///
  /// In en, this message translates to:
  /// **'Max Amount per Note'**
  String get maxAmountPerNote;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @memo.
  ///
  /// In en, this message translates to:
  /// **'Memo'**
  String get memo;

  /// No description provided for @memoTooLong.
  ///
  /// In en, this message translates to:
  /// **'Memo too long'**
  String get memoTooLong;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @minPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Min Privacy'**
  String get minPrivacy;

  /// No description provided for @mode.
  ///
  /// In en, this message translates to:
  /// **'Advanced Mode'**
  String get mode;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @multiPay.
  ///
  /// In en, this message translates to:
  /// **'Multi Pay'**
  String get multiPay;

  /// No description provided for @na.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get na;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @nan.
  ///
  /// In en, this message translates to:
  /// **'Not a number'**
  String get nan;

  /// No description provided for @netOrchard.
  ///
  /// In en, this message translates to:
  /// **'Net Orchard Change'**
  String get netOrchard;

  /// No description provided for @netSapling.
  ///
  /// In en, this message translates to:
  /// **'Net Sapling Change'**
  String get netSapling;

  /// No description provided for @newAccount.
  ///
  /// In en, this message translates to:
  /// **'New Account'**
  String get newAccount;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @newPasswordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'New passwords do not match'**
  String get newPasswordsDoNotMatch;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @noAuthenticationMethod.
  ///
  /// In en, this message translates to:
  /// **'No Authentication Method'**
  String get noAuthenticationMethod;

  /// No description provided for @noDbPassword.
  ///
  /// In en, this message translates to:
  /// **'Database must be encrypted to protect open/spend'**
  String get noDbPassword;

  /// No description provided for @noRemindBackup.
  ///
  /// In en, this message translates to:
  /// **'Do not remind me'**
  String get noRemindBackup;

  /// No description provided for @notEnoughBalance.
  ///
  /// In en, this message translates to:
  /// **'Not enough balance'**
  String get notEnoughBalance;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @now.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get now;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @openInExplorer.
  ///
  /// In en, this message translates to:
  /// **'Open in Explorer'**
  String get openInExplorer;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @orchard.
  ///
  /// In en, this message translates to:
  /// **'Orchard'**
  String get orchard;

  /// No description provided for @orchardInput.
  ///
  /// In en, this message translates to:
  /// **'Orchard Input'**
  String get orchardInput;

  /// No description provided for @paymentMade.
  ///
  /// In en, this message translates to:
  /// **'Payment made'**
  String get paymentMade;

  /// No description provided for @paymentURI.
  ///
  /// In en, this message translates to:
  /// **'Payment URI'**
  String get paymentURI;

  /// No description provided for @ping.
  ///
  /// In en, this message translates to:
  /// **'Ping Test'**
  String get ping;

  /// No description provided for @pleaseAuthenticate.
  ///
  /// In en, this message translates to:
  /// **'Please Authenticate'**
  String get pleaseAuthenticate;

  /// No description provided for @pleaseQuitAndRestartTheAppNow.
  ///
  /// In en, this message translates to:
  /// **'Please Quit and Restart the app in order for these changes to take effect'**
  String get pleaseQuitAndRestartTheAppNow;

  /// No description provided for @pool.
  ///
  /// In en, this message translates to:
  /// **'Pool'**
  String get pool;

  /// No description provided for @poolTransfer.
  ///
  /// In en, this message translates to:
  /// **'Pool Transfer'**
  String get poolTransfer;

  /// No description provided for @pools.
  ///
  /// In en, this message translates to:
  /// **'Pools'**
  String get pools;

  /// No description provided for @prev.
  ///
  /// In en, this message translates to:
  /// **'Prev'**
  String get prev;

  /// No description provided for @priv.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get priv;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'PRIVACY: {level}'**
  String privacy(Object level);

  /// No description provided for @privacyLevelTooLow.
  ///
  /// In en, this message translates to:
  /// **'Privacy Too LOW - Long press to override'**
  String get privacyLevelTooLow;

  /// No description provided for @privateKey.
  ///
  /// In en, this message translates to:
  /// **'Private Key'**
  String get privateKey;

  /// No description provided for @protectOpen.
  ///
  /// In en, this message translates to:
  /// **'Protect Open'**
  String get protectOpen;

  /// No description provided for @protectSend.
  ///
  /// In en, this message translates to:
  /// **'Protect Send'**
  String get protectSend;

  /// No description provided for @publicKey.
  ///
  /// In en, this message translates to:
  /// **'Public Key'**
  String get publicKey;

  /// No description provided for @qr.
  ///
  /// In en, this message translates to:
  /// **'QR Code'**
  String get qr;

  /// No description provided for @rawTransaction.
  ///
  /// In en, this message translates to:
  /// **'Raw Transaction'**
  String get rawTransaction;

  /// No description provided for @receive.
  ///
  /// In en, this message translates to:
  /// **'Receive {ticker}'**
  String receive(Object ticker);

  /// No description provided for @received.
  ///
  /// In en, this message translates to:
  /// **'Received {amount} {ticker}'**
  String received(Object amount, Object ticker);

  /// No description provided for @receivers.
  ///
  /// In en, this message translates to:
  /// **'Receivers'**
  String get receivers;

  /// No description provided for @recipient.
  ///
  /// In en, this message translates to:
  /// **'Recipient'**
  String get recipient;

  /// No description provided for @repeatNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Repeat New Password'**
  String get repeatNewPassword;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @replyUA.
  ///
  /// In en, this message translates to:
  /// **'Reply UA Receivers'**
  String get replyUA;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Value Required'**
  String get required;

  /// No description provided for @rescan.
  ///
  /// In en, this message translates to:
  /// **'Rescan'**
  String get rescan;

  /// No description provided for @rescanFrom.
  ///
  /// In en, this message translates to:
  /// **'Rescan from...'**
  String get rescanFrom;

  /// No description provided for @rescanWarning.
  ///
  /// In en, this message translates to:
  /// **'RESCAN resets all your accounts. You may want to consider using REWIND instead'**
  String get rescanWarning;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @restart.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restart;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @restoreAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Restore an account?'**
  String get restoreAnAccount;

  /// No description provided for @retrieveTransactionDetails.
  ///
  /// In en, this message translates to:
  /// **'Retrieve Transaction Details'**
  String get retrieveTransactionDetails;

  /// No description provided for @rewind.
  ///
  /// In en, this message translates to:
  /// **'Rewind'**
  String get rewind;

  /// No description provided for @sapling.
  ///
  /// In en, this message translates to:
  /// **'Sapling'**
  String get sapling;

  /// No description provided for @saplingInput.
  ///
  /// In en, this message translates to:
  /// **'Sapling Input'**
  String get saplingInput;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @scanQrCode.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scanQrCode;

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

  /// No description provided for @secretKey.
  ///
  /// In en, this message translates to:
  /// **'Secret Key'**
  String get secretKey;

  /// No description provided for @secured.
  ///
  /// In en, this message translates to:
  /// **'Secured'**
  String get secured;

  /// No description provided for @seed.
  ///
  /// In en, this message translates to:
  /// **'Seed'**
  String get seed;

  /// No description provided for @seedKeys.
  ///
  /// In en, this message translates to:
  /// **'Seed & Keys'**
  String get seedKeys;

  /// No description provided for @seedOrKeyRequired.
  ///
  /// In en, this message translates to:
  /// **'Seed or Private Key required'**
  String get seedOrKeyRequired;

  /// No description provided for @selectNotesToExcludeFromPayments.
  ///
  /// In en, this message translates to:
  /// **'Select notes to EXCLUDE from payments'**
  String get selectNotesToExcludeFromPayments;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @sendCointicker.
  ///
  /// In en, this message translates to:
  /// **'Send {ticker}'**
  String sendCointicker(Object ticker);

  /// No description provided for @sendFrom.
  ///
  /// In en, this message translates to:
  /// **'Sent from {app}'**
  String sendFrom(Object app);

  /// No description provided for @sender.
  ///
  /// In en, this message translates to:
  /// **'Sender'**
  String get sender;

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

  /// No description provided for @server.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get server;

  /// No description provided for @set.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get set;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @shielded.
  ///
  /// In en, this message translates to:
  /// **'Shielded'**
  String get shielded;

  /// No description provided for @showSubKeys.
  ///
  /// In en, this message translates to:
  /// **'Show Sub Keys'**
  String get showSubKeys;

  /// No description provided for @sign.
  ///
  /// In en, this message translates to:
  /// **'Sign Transaction'**
  String get sign;

  /// No description provided for @signOffline.
  ///
  /// In en, this message translates to:
  /// **'Sign'**
  String get signOffline;

  /// No description provided for @signedTx.
  ///
  /// In en, this message translates to:
  /// **'Signed Tx'**
  String get signedTx;

  /// No description provided for @source.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get source;

  /// No description provided for @spendable.
  ///
  /// In en, this message translates to:
  /// **'Spendable'**
  String get spendable;

  /// No description provided for @spent.
  ///
  /// In en, this message translates to:
  /// **'Spent {amount} {ticker}'**
  String spent(Object amount, Object ticker);

  /// No description provided for @subject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get subject;

  /// No description provided for @sweep.
  ///
  /// In en, this message translates to:
  /// **'Sweep'**
  String get sweep;

  /// No description provided for @sync.
  ///
  /// In en, this message translates to:
  /// **'Synchronization'**
  String get sync;

  /// No description provided for @syncPaused.
  ///
  /// In en, this message translates to:
  /// **'PAUSED - Tap to Resume'**
  String get syncPaused;

  /// No description provided for @table.
  ///
  /// In en, this message translates to:
  /// **'Table'**
  String get table;

  /// No description provided for @template.
  ///
  /// In en, this message translates to:
  /// **'Template'**
  String get template;

  /// No description provided for @textCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'{text} copied to clipboard'**
  String textCopiedToClipboard(Object text);

  /// No description provided for @thePrivateWalletMessenger.
  ///
  /// In en, this message translates to:
  /// **'The private wallet & messenger'**
  String get thePrivateWalletMessenger;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @thisAccountAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Another account has the same address'**
  String get thisAccountAlreadyExists;

  /// No description provided for @timestamp.
  ///
  /// In en, this message translates to:
  /// **'Timestamp'**
  String get timestamp;

  /// No description provided for @toPool.
  ///
  /// In en, this message translates to:
  /// **'To Pool'**
  String get toPool;

  /// No description provided for @tools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get tools;

  /// No description provided for @totalBalance.
  ///
  /// In en, this message translates to:
  /// **'Total Balance'**
  String get totalBalance;

  /// No description provided for @transactionDetails.
  ///
  /// In en, this message translates to:
  /// **'Transaction Details'**
  String get transactionDetails;

  /// No description provided for @transactionHistory.
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get transactionHistory;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @transfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transfer;

  /// No description provided for @transparent.
  ///
  /// In en, this message translates to:
  /// **'Transparent'**
  String get transparent;

  /// No description provided for @transparentInput.
  ///
  /// In en, this message translates to:
  /// **'Transparent Input'**
  String get transparentInput;

  /// No description provided for @transparentKey.
  ///
  /// In en, this message translates to:
  /// **'Transparent Key'**
  String get transparentKey;

  /// No description provided for @txID.
  ///
  /// In en, this message translates to:
  /// **'TXID'**
  String get txID;

  /// No description provided for @txId.
  ///
  /// In en, this message translates to:
  /// **'TX ID: {txid}'**
  String txId(Object txid);

  /// No description provided for @txPlan.
  ///
  /// In en, this message translates to:
  /// **'Transaction Plan'**
  String get txPlan;

  /// No description provided for @mainAddress.
  ///
  /// In en, this message translates to:
  /// **'Main Address'**
  String get mainAddress;

  /// No description provided for @unifiedViewingKey.
  ///
  /// In en, this message translates to:
  /// **'Unified Viewing Key'**
  String get unifiedViewingKey;

  /// No description provided for @unsignedTx.
  ///
  /// In en, this message translates to:
  /// **'Unsigned Tx'**
  String get unsignedTx;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Recalc'**
  String get update;

  /// No description provided for @useZats.
  ///
  /// In en, this message translates to:
  /// **'Use Zats (8 decimals)'**
  String get useZats;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @veryLow.
  ///
  /// In en, this message translates to:
  /// **'Very Low'**
  String get veryLow;

  /// No description provided for @viewingKey.
  ///
  /// In en, this message translates to:
  /// **'Viewing Key'**
  String get viewingKey;

  /// No description provided for @views.
  ///
  /// In en, this message translates to:
  /// **'Views'**
  String get views;

  /// No description provided for @welcomeToYwallet.
  ///
  /// In en, this message translates to:
  /// **'Welcome to YWallet'**
  String get welcomeToYwallet;

  /// No description provided for @wifi.
  ///
  /// In en, this message translates to:
  /// **'WiFi'**
  String get wifi;

  /// No description provided for @dontShowAnymore.
  ///
  /// In en, this message translates to:
  /// **'Do not show anymore'**
  String get dontShowAnymore;

  /// No description provided for @swapDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Swaps are offered by third-party providers. Use at your own risk and do your own research.'**
  String get swapDisclaimer;

  /// No description provided for @swap.
  ///
  /// In en, this message translates to:
  /// **'Swap'**
  String get swap;

  /// No description provided for @swapProviders.
  ///
  /// In en, this message translates to:
  /// **'Swap Providers'**
  String get swapProviders;

  /// No description provided for @stealthEx.
  ///
  /// In en, this message translates to:
  /// **'StealthEX'**
  String get stealthEx;

  /// No description provided for @getQuote.
  ///
  /// In en, this message translates to:
  /// **'Get Quote'**
  String get getQuote;

  /// No description provided for @invalidSwapCurrencies.
  ///
  /// In en, this message translates to:
  /// **'Swap must include ZEC'**
  String get invalidSwapCurrencies;

  /// No description provided for @checkSwapAddress.
  ///
  /// In en, this message translates to:
  /// **'Make sure that the destination address is valid!'**
  String get checkSwapAddress;

  /// No description provided for @swapSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get swapSend;

  /// No description provided for @swapReceive.
  ///
  /// In en, this message translates to:
  /// **'Receive'**
  String get swapReceive;

  /// No description provided for @swapFromTip.
  ///
  /// In en, this message translates to:
  /// **'Tip: Send the funds to the address in the upper box and you will receive the ZEC in your transparent address.'**
  String get swapFromTip;

  /// No description provided for @swapToTip.
  ///
  /// In en, this message translates to:
  /// **'Tip: Tap the Send Button and receive the other currency'**
  String get swapToTip;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Please Confirm'**
  String get confirm;

  /// No description provided for @confirmClearSwapHistory.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear the swap history?'**
  String get confirmClearSwapHistory;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @vote.
  ///
  /// In en, this message translates to:
  /// **'Vote'**
  String get vote;

  /// No description provided for @birthHeight.
  ///
  /// In en, this message translates to:
  /// **'Birth Height'**
  String get birthHeight;

  /// No description provided for @downgradeAccount.
  ///
  /// In en, this message translates to:
  /// **'Downgrade Account'**
  String get downgradeAccount;

  /// No description provided for @noKey.
  ///
  /// In en, this message translates to:
  /// **'No Key'**
  String get noKey;

  /// No description provided for @editAccount.
  ///
  /// In en, this message translates to:
  /// **'Edit Account'**
  String get editAccount;

  /// No description provided for @tooManyNotes.
  ///
  /// In en, this message translates to:
  /// **'Too Many Notes'**
  String get tooManyNotes;

  /// No description provided for @addresses.
  ///
  /// In en, this message translates to:
  /// **'Addresses'**
  String get addresses;

  /// No description provided for @utxo.
  ///
  /// In en, this message translates to:
  /// **'UTXO'**
  String get utxo;

  /// No description provided for @addAddressConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to add a new transparent address?'**
  String get addAddressConfirm;

  /// No description provided for @scanTransparentAddresses.
  ///
  /// In en, this message translates to:
  /// **'Scan Transparent Addresses'**
  String get scanTransparentAddresses;

  /// No description provided for @contactsSaved.
  ///
  /// In en, this message translates to:
  /// **'Contacts Saved'**
  String get contactsSaved;

  /// No description provided for @warpURL.
  ///
  /// In en, this message translates to:
  /// **'Warp URL'**
  String get warpURL;

  /// No description provided for @endWarpHeight.
  ///
  /// In en, this message translates to:
  /// **'End Warp Height'**
  String get endWarpHeight;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es', 'fr', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return SEn();
    case 'es': return SEs();
    case 'fr': return SFr();
    case 'pt': return SPt();
  }

  throw FlutterError(
    'S.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
