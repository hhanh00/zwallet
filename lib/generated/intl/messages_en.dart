import 'messages.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SEn extends S {
  SEn([String locale = 'en']) : super(locale);

  @override
  String get about => 'About';

  @override
  String get account => 'Account';

  @override
  String get accountBalanceHistory => 'Account Balance History';

  @override
  String get accountIndex => 'Account Index';

  @override
  String get accountManager => 'Account Manager';

  @override
  String get accountName => 'Account Name';

  @override
  String get accounts => 'Accounts';

  @override
  String get add => 'Add';

  @override
  String get addContact => 'Add Contact';

  @override
  String get address => 'Address';

  @override
  String get addressCopiedToClipboard => 'Address copied to clipboard';

  @override
  String get addressIndex => 'Address Index';

  @override
  String get addressIsEmpty => 'Address is empty';

  @override
  String get amount => 'Amount';

  @override
  String get amountCurrency => 'Amount in Fiat';

  @override
  String get amountMustBePositive => 'Amount must be positive';

  @override
  String get amountSlider => 'Amount Slider';

  @override
  String get antispamFilter => 'Anti-Spam Filter';

  @override
  String get any => 'Any';

  @override
  String get appData => 'App Data';

  @override
  String get auto => 'Auto';

  @override
  String get autoFee => 'Automatic Fee';

  @override
  String get autoHide => 'Auto Hide';

  @override
  String get autoHideBalance => 'Hide Balance';

  @override
  String get autoView => 'Orientation';

  @override
  String get backgroundSync => 'Background Sync';

  @override
  String get backup => 'Backup';

  @override
  String get backupAllAccounts => 'Backup All Accounts';

  @override
  String get backupMissing => 'BACKUP MISSING';

  @override
  String get balance => 'Balance';

  @override
  String get barcode => 'Barcode';

  @override
  String get blockExplorer => 'Block Explorer';

  @override
  String get body => 'Body';

  @override
  String get broadcast => 'Broadcast';

  @override
  String get budget => 'Budget';

  @override
  String get cancel => 'Cancel';

  @override
  String get cannotDeleteActive => 'Cannot delete the active account unless it is the last one';

  @override
  String get cannotUseTKey => 'Cannot import transparent private key. Use SWEEP instead';

  @override
  String get catchup => 'Catch up';

  @override
  String get close => 'Close';

  @override
  String get coldStorage => 'Cold Storage';

  @override
  String get configure => 'Configure';

  @override
  String get confirmDeleteAccount => 'Are you SURE you want to DELETE this account? You MUST have a BACKUP to recover it. This operation is NOT reversible.';

  @override
  String get confirmDeleteContact => 'Are you SURE you want to DELETE this contact?';

  @override
  String confirmRescanFrom(Object height) {
    return 'Do you want to rescan from block $height?';
  }

  @override
  String confirmRewind(Object height) {
    return 'Do you want to rewind to block $height?';
  }

  @override
  String get confirmSaveContacts => 'Are you sure you want to save your contacts?';

  @override
  String get confirmSaveKeys => 'Have you saved your keys?';

  @override
  String get confirmWatchOnly => 'Deleting or converting to viewing key is NOT reversible. You CANNOT upgrade back to using a secret key.';

  @override
  String get confirmations => 'Min. Confirmations';

  @override
  String get confs => 'Confs';

  @override
  String get connectionError => 'DISCONNECTED';

  @override
  String get contactName => 'Contact Name';

  @override
  String get contacts => 'Contacts';

  @override
  String get convertToWatchonly => 'To Watch-Only';

  @override
  String get copiedToClipboard => 'Copy to Clipboard';

  @override
  String get copy => 'Copy';

  @override
  String get count => 'Count';

  @override
  String get crypto => 'Crypto';

  @override
  String get currency => 'Currency';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get custom => 'Custom';

  @override
  String get customSend => 'Use Custom Send';

  @override
  String get customSendSettings => 'Custom Send Settings';

  @override
  String get dark => 'Dark';

  @override
  String get databasePassword => 'Database Password';

  @override
  String get databaseRestored => 'Database Restored';

  @override
  String get date => 'Date';

  @override
  String get datetime => 'Date/Time';

  @override
  String get deductFee => 'Deduct fee from amount';

  @override
  String get defaultMemo => 'Default Memo';

  @override
  String get delete => 'DELETE';

  @override
  String deleteAccount(Object name) {
    return 'Delete Account $name';
  }

  @override
  String get deletePayment => 'Are you sure you want to delete this recipient';

  @override
  String get derpath => 'Derivation Path';

  @override
  String get destination => 'Destination';

  @override
  String get disclaimer => 'Disclaimer';

  @override
  String get disclaimerText => 'SELF-CUSTODY';

  @override
  String get disclaimer_1 => 'I understand I am responsible for securing my seed phrase';

  @override
  String get disclaimer_2 => 'I understand YWallet cannot recover my seed phrase';

  @override
  String get disclaimer_3 => 'I understand whoever knows my seed phrase can get my funds';

  @override
  String get diversified => 'Diversified';

  @override
  String get editContact => 'Edit Contact';

  @override
  String get encryptDatabase => 'Encrypt Database';

  @override
  String get encryptionKey => 'Encryption Key';

  @override
  String get error => 'ERROR';

  @override
  String get change => 'Change';

  @override
  String get fee => 'Fee';

  @override
  String get fromPool => 'From Pool';

  @override
  String get fromto => 'From/To';

  @override
  String get fullBackup => 'Full Backup';

  @override
  String get fullRestore => 'Full Restore';

  @override
  String get gapLimit => 'Gap Limit';

  @override
  String get general => 'General';

  @override
  String get height => 'Height';

  @override
  String get help => 'Help';

  @override
  String get hidden => 'Hidden';

  @override
  String get high => 'High';

  @override
  String get history => 'History';

  @override
  String get import => 'Import';

  @override
  String get includeReplyTo => 'Include My Address in Memo';

  @override
  String get incomingFunds => 'Incoming funds';

  @override
  String get index => 'Index';

  @override
  String get interval => 'Interval';

  @override
  String get invalidAddress => 'Invalid Address';

  @override
  String get invalidKey => 'Invalid Key';

  @override
  String get invalidPassword => 'Invalid Password';

  @override
  String get invalidPaymentURI => 'Invalid Payment URI';

  @override
  String get key => 'Seed, Secret Key or View Key (optional)';

  @override
  String get keyTool => 'Key Tool';

  @override
  String get keygen => 'Backup Keygen';

  @override
  String get keygenHelp => 'Full backups use the AGE encryption system. The encryption key is used to encrypt the backup but CANNOT decrypt it. The SECRET key is needed to restore the backup.\nThe app will not store the keys. Every time this keygen will produce a DIFFERENT pair of keys.\n\nYou MUST save BOTH keys that you use';

  @override
  String get largestSpendingsByAddress => 'Largest Spendings by Address';

  @override
  String get ledger => 'Ledger';

  @override
  String get light => 'Light';

  @override
  String get list => 'List';

  @override
  String get loading => 'Loading...';

  @override
  String get low => 'Low';

  @override
  String get mainReceivers => 'Main Receivers';

  @override
  String get market => 'Market';

  @override
  String get marketPrice => 'Mkt Prices';

  @override
  String get max => 'Max';

  @override
  String get maxAmountPerNote => 'Max Amount per Note';

  @override
  String get medium => 'Medium';

  @override
  String get memo => 'Memo';

  @override
  String get memoTooLong => 'Memo too long';

  @override
  String get message => 'Message';

  @override
  String get messages => 'Messages';

  @override
  String get minPrivacy => 'Min Privacy';

  @override
  String get mode => 'Advanced Mode';

  @override
  String get more => 'More';

  @override
  String get multiPay => 'Multi Pay';

  @override
  String get na => 'N/A';

  @override
  String get name => 'Name';

  @override
  String get nan => 'Not a number';

  @override
  String get netOrchard => 'Net Orchard Change';

  @override
  String get netSapling => 'Net Sapling Change';

  @override
  String get newAccount => 'New Account';

  @override
  String get newPassword => 'New Password';

  @override
  String get newPasswordsDoNotMatch => 'New passwords do not match';

  @override
  String get next => 'Next';

  @override
  String get noAuthenticationMethod => 'No Authentication Method';

  @override
  String get noDbPassword => 'Database must be encrypted to protect open/spend';

  @override
  String get noRemindBackup => 'Do not remind me';

  @override
  String get notEnoughBalance => 'Not enough balance';

  @override
  String get notes => 'Notes';

  @override
  String get now => 'Now';

  @override
  String get off => 'Off';

  @override
  String get ok => 'OK';

  @override
  String get openInExplorer => 'Open in Explorer';

  @override
  String get or => 'or';

  @override
  String get orchard => 'Orchard';

  @override
  String get orchardInput => 'Orchard Input';

  @override
  String get paymentMade => 'Payment made';

  @override
  String get paymentURI => 'Payment URI';

  @override
  String get ping => 'Ping Test';

  @override
  String get pleaseAuthenticate => 'Please Authenticate';

  @override
  String get pleaseQuitAndRestartTheAppNow => 'Please Quit and Restart the app in order for these changes to take effect';

  @override
  String get pool => 'Pool';

  @override
  String get poolTransfer => 'Pool Transfer';

  @override
  String get pools => 'Pools';

  @override
  String get prev => 'Prev';

  @override
  String get priv => 'Privacy';

  @override
  String privacy(Object level) {
    return 'PRIVACY: $level';
  }

  @override
  String get privacyLevelTooLow => 'Privacy Too LOW - Long press to override';

  @override
  String get privateKey => 'Private Key';

  @override
  String get protectOpen => 'Protect Open';

  @override
  String get protectSend => 'Protect Send';

  @override
  String get publicKey => 'Public Key';

  @override
  String get qr => 'QR Code';

  @override
  String get rawTransaction => 'Raw Transaction';

  @override
  String receive(Object ticker) {
    return 'Receive $ticker';
  }

  @override
  String received(Object amount, Object ticker) {
    return 'Received $amount $ticker';
  }

  @override
  String get receivers => 'Receivers';

  @override
  String get recipient => 'Recipient';

  @override
  String get repeatNewPassword => 'Repeat New Password';

  @override
  String get reply => 'Reply';

  @override
  String get replyUA => 'Reply UA Receivers';

  @override
  String get required => 'Value Required';

  @override
  String get rescan => 'Rescan';

  @override
  String get rescanFrom => 'Rescan from...';

  @override
  String get rescanWarning => 'RESCAN resets all your accounts. You may want to consider using REWIND instead';

  @override
  String get reset => 'Reset';

  @override
  String get restart => 'Restart';

  @override
  String get restore => 'Restore';

  @override
  String get restoreAnAccount => 'Restore an account?';

  @override
  String get retrieveTransactionDetails => 'Retrieve Transaction Details';

  @override
  String get rewind => 'Rewind';

  @override
  String get sapling => 'Sapling';

  @override
  String get saplingInput => 'Sapling Input';

  @override
  String get save => 'Save';

  @override
  String get scanQrCode => 'Scan QR Code';

  @override
  String get scanRawTx => 'Scan the Unsigned Tx QR codes';

  @override
  String get scanSignedTx => 'Scan the Signed Tx QR codes';

  @override
  String get secretKey => 'Secret Key';

  @override
  String get secured => 'Secured';

  @override
  String get seed => 'Seed';

  @override
  String get seedKeys => 'Seed & Keys';

  @override
  String get seedOrKeyRequired => 'Seed or Private Key required';

  @override
  String get selectNotesToExcludeFromPayments => 'Select notes to EXCLUDE from payments';

  @override
  String get send => 'Send';

  @override
  String sendCointicker(Object ticker) {
    return 'Send $ticker';
  }

  @override
  String sendFrom(Object app) {
    return 'Sent from $app';
  }

  @override
  String get sender => 'Sender';

  @override
  String get sending => 'Sending Transaction';

  @override
  String get sent => 'Transaction Sent';

  @override
  String get sent_failed => 'Transaction Failed';

  @override
  String get server => 'Server';

  @override
  String get set => 'Set';

  @override
  String get settings => 'Settings';

  @override
  String get shielded => 'Shielded';

  @override
  String get showSubKeys => 'Show Sub Keys';

  @override
  String get sign => 'Sign Transaction';

  @override
  String get signOffline => 'Sign';

  @override
  String get signedTx => 'Signed Tx';

  @override
  String get source => 'Source';

  @override
  String get spendable => 'Spendable';

  @override
  String spent(Object amount, Object ticker) {
    return 'Spent $amount $ticker';
  }

  @override
  String get subject => 'Subject';

  @override
  String get sweep => 'Sweep';

  @override
  String get sync => 'Synchronization';

  @override
  String get syncPaused => 'PAUSED - Tap to Resume';

  @override
  String get table => 'Table';

  @override
  String get template => 'Template';

  @override
  String textCopiedToClipboard(Object text) {
    return '$text copied to clipboard';
  }

  @override
  String get thePrivateWalletMessenger => 'The private wallet & messenger';

  @override
  String get theme => 'Theme';

  @override
  String get thisAccountAlreadyExists => 'Another account has the same address';

  @override
  String get timestamp => 'Timestamp';

  @override
  String get toPool => 'To Pool';

  @override
  String get tools => 'Tools';

  @override
  String get totalBalance => 'Total Balance';

  @override
  String get transactionDetails => 'Transaction Details';

  @override
  String get transactionHistory => 'Transaction History';

  @override
  String get transactions => 'Transactions';

  @override
  String get transfer => 'Transfer';

  @override
  String get transparent => 'Transparent';

  @override
  String get transparentInput => 'Transparent Input';

  @override
  String get transparentKey => 'Transparent Key';

  @override
  String get txID => 'TXID';

  @override
  String txId(Object txid) {
    return 'TX ID: $txid';
  }

  @override
  String get txPlan => 'Transaction Plan';

  @override
  String get mainAddress => 'Main Address';

  @override
  String get unifiedViewingKey => 'Unified Viewing Key';

  @override
  String get unsignedTx => 'Unsigned Tx';

  @override
  String get update => 'Recalc';

  @override
  String get useZats => 'Use Zats (8 decimals)';

  @override
  String get version => 'Version';

  @override
  String get veryLow => 'Very Low';

  @override
  String get viewingKey => 'Viewing Key';

  @override
  String get views => 'Views';

  @override
  String get welcomeToYwallet => 'Welcome to YWallet';

  @override
  String get wifi => 'WiFi';

  @override
  String get dontShowAnymore => 'Do not show anymore';

  @override
  String get swapDisclaimer => 'Swaps are offered by third-party providers. Use at your own risk and do your own research.';

  @override
  String get swap => 'Swap';

  @override
  String get swapProviders => 'Swap Providers';

  @override
  String get stealthEx => 'StealthEX';

  @override
  String get getQuote => 'Get Quote';

  @override
  String get invalidSwapCurrencies => 'Swap must include ZEC';

  @override
  String get checkSwapAddress => 'Make sure that the destination address is valid!';

  @override
  String get swapSend => 'Send';

  @override
  String get swapReceive => 'Receive';

  @override
  String get swapFromTip => 'Tip: Send the funds to the address in the upper box and you will receive the ZEC in your transparent address.';

  @override
  String get swapToTip => 'Tip: Tap the Send Button and receive the other currency';

  @override
  String get confirm => 'Please Confirm';

  @override
  String get confirmClearSwapHistory => 'Are you sure you want to clear the swap history?';

  @override
  String get retry => 'Retry';

  @override
  String get vote => 'Vote';

  @override
  String get birthHeight => 'Birth Height';

  @override
  String get downgradeAccount => 'Downgrade Account';

  @override
  String get noKey => 'No Key';

  @override
  String get editAccount => 'Edit Account';

  @override
  String get tooManyNotes => 'Too Many Notes';

  @override
  String get addresses => 'Addresses';

  @override
  String get utxo => 'UTXO';

  @override
  String get addAddressConfirm => 'Are you sure you want to add a new transparent address?';

  @override
  String get scanTransparentAddresses => 'Scan Transparent Addresses';

  @override
  String get contactsSaved => 'Contacts Saved';

  @override
  String get warpURL => 'Warp URL';

  @override
  String get endWarpHeight => 'End Warp Height';
}
