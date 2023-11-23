import 'messages.dart';

/// The translations for English (`en`).
class SEn extends S {
  SEn([String locale = 'en']) : super(locale);

  @override
  String get version => 'Version';

  @override
  String get about => 'About';

  @override
  String get ok => 'OK';

  @override
  String get account => 'Account';

  @override
  String get notes => 'Notes';

  @override
  String get history => 'History';

  @override
  String get budget => 'Budget';

  @override
  String get tradingPl => 'Wallet P&L';

  @override
  String get contacts => 'Contacts';

  @override
  String get accounts => 'Accounts';

  @override
  String get backup => 'Backup';

  @override
  String get rescan => 'Rescan';

  @override
  String get catchup => 'Catch up';

  @override
  String get coldStorage => 'Cold Storage';

  @override
  String get multipay => 'MultiPay';

  @override
  String get broadcast => 'Broadcast';

  @override
  String get settings => 'Settings';

  @override
  String get synching => 'Synching';

  @override
  String get tapQrCodeForShieldedAddress => 'Tap QR Code for Shielded Address';

  @override
  String get tapQrCodeForTransparentAddress => 'Tap QR Code for Transparent Address';

  @override
  String get addressCopiedToClipboard => 'Address copied to clipboard';

  @override
  String get shieldTransparentBalance => 'Shield Transparent Balance';

  @override
  String doYouWantToTransferYourEntireTransparentBalanceTo(Object ticker) {
    return 'Do you want to transfer your entire transparent balance to your shielded address? A Network fee of 0.01 m$ticker will be deducted.';
  }

  @override
  String get shieldingInProgress => 'Shielding in progress...';

  @override
  String txId(Object txid) {
    return 'TX ID: $txid';
  }

  @override
  String get txID => 'TXID';

  @override
  String get pleaseAuthenticateToShowAccountSeed => 'Please authenticate to show account seed';

  @override
  String get noAuthenticationMethod => 'No Authentication Method';

  @override
  String get rescanFrom => 'Rescan from...';

  @override
  String get cancel => 'Cancel';

  @override
  String rescanRequested(Object height) {
    return 'Rescan Requested from $height...';
  }

  @override
  String get confirmWatchOnly => 'Do you want to DELETE the secret key and convert this account to a watch-only account? You will not be able to spend from this device anymore. This operation is NOT reversible.';

  @override
  String get delete => 'DELETE';

  @override
  String get confs => 'Confs';

  @override
  String get height => 'Height';

  @override
  String get datetime => 'Date/Time';

  @override
  String get amount => 'Amount';

  @override
  String get selectNotesToExcludeFromPayments => 'Select notes to EXCLUDE from payments';

  @override
  String get largestSpendingsByAddress => 'Largest Spendings by Address';

  @override
  String get tapChartToToggleBetweenAddressAndAmount => 'Tap Chart to Toggle between Address and Amount';

  @override
  String get accountBalanceHistory => 'Account Balance History';

  @override
  String get noSpendingInTheLast30Days => 'No Spending in the Last 30 Days';

  @override
  String get largestSpendingLastMonth => 'Largest Spending Last Month';

  @override
  String get balance => 'Balance';

  @override
  String get pnl => 'Pnl';

  @override
  String get mm => 'M/M';

  @override
  String get total => 'Total';

  @override
  String get price => 'Price';

  @override
  String get qty => 'Qty';

  @override
  String get table => 'Table';

  @override
  String get pl => 'P/L';

  @override
  String get realized => 'Realized';

  @override
  String get toMakeAContactSendThemAMemoWithContact => 'To make a contact, send them a memo with Contact:';

  @override
  String get newSnapAddress => 'New Snap Address';

  @override
  String get shieldTranspBalance => 'Shield Transp. Balance';

  @override
  String get send => 'Send';

  @override
  String get noAccount => 'No account';

  @override
  String get seed => 'Seed';

  @override
  String get confirmDeleteAccount => 'Are you SURE you want to DELETE this account? You MUST have a BACKUP to recover it. This operation is NOT reversible.';

  @override
  String get confirmDeleteContact => 'Are you SURE you want to DELETE this contact?';

  @override
  String get changeAccountName => 'Change Account Name';

  @override
  String backupDataRequiredForRestore(Object name) {
    return 'Backup Data - $name - Required for Restore';
  }

  @override
  String get secretKey => 'Secret Key';

  @override
  String get publicKey => 'Public Key';

  @override
  String get viewingKey => 'Viewing Key';

  @override
  String get tapAnIconToShowTheQrCode => 'Tap an icon to show the QR code';

  @override
  String get multiPay => 'Multi Pay';

  @override
  String get pleaseConfirm => 'Please Confirm';

  @override
  String sendingATotalOfAmountCointickerToCountRecipients(Object amount, Object count, Object ticker) {
    return 'Sending a total of $amount $ticker to $count recipients';
  }

  @override
  String get preparingTransaction => 'Preparing transaction...';

  @override
  String sendCointickerTo(Object ticker) {
    return 'Send $ticker to...';
  }

  @override
  String get addressIsEmpty => 'Address is empty';

  @override
  String get invalidAddress => 'Invalid Address';

  @override
  String get amountMustBeANumber => 'Amount must be a number';

  @override
  String get amountMustBePositive => 'Amount must be positive';

  @override
  String get accountName => 'Account Name';

  @override
  String get accountNameIsRequired => 'Account name is required';

  @override
  String get enterSeed => 'Enter Seed, Secret Key or Viewing Key. Leave blank for a new account';

  @override
  String get scanStartingMomentarily => 'Scan starting momentarily';

  @override
  String get key => 'Seed, Secret Key or View Key (optional)';

  @override
  String sendCointicker(Object ticker) {
    return 'Send $ticker';
  }

  @override
  String get max => 'MAX';

  @override
  String get advancedOptions => 'Advanced Options';

  @override
  String get memo => 'Memo';

  @override
  String get roundToMillis => 'Round to millis';

  @override
  String useSettingscurrency(Object currency) {
    return 'Use $currency';
  }

  @override
  String get includeFeeInAmount => 'Include Fee in Amount';

  @override
  String get maxAmountPerNote => 'Max Amount per Note';

  @override
  String get spendable => 'Spendable';

  @override
  String get notEnoughBalance => 'Not enough balance';

  @override
  String get approve => 'APPROVE';

  @override
  String sendingAzecCointickerToAddress(Object aZEC, Object address, Object ticker) {
    return 'Sending $aZEC $ticker to $address';
  }

  @override
  String get unsignedTransactionFile => 'Unsigned Transaction File';

  @override
  String amountInSettingscurrency(Object currency) {
    return 'Amount in $currency';
  }

  @override
  String get custom => 'Custom';

  @override
  String get server => 'Server';

  @override
  String get blue => 'Blue';

  @override
  String get pink => 'Pink';

  @override
  String get coffee => 'Coffee';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get currency => 'Currency';

  @override
  String get numberOfConfirmationsNeededBeforeSpending => 'Number of Confirmations Needed before Spending';

  @override
  String get retrieveTransactionDetails => 'Retrieve Transaction Details';

  @override
  String get theme => 'Theme';

  @override
  String get transactionDetails => 'Transaction Details';

  @override
  String get timestamp => 'Timestamp';

  @override
  String get address => 'Address';

  @override
  String get openInExplorer => 'Open in Explorer';

  @override
  String get restore => 'Restore';

  @override
  String get na => 'N/A';

  @override
  String get add => 'Add';

  @override
  String get tradingChartRange => 'Trading Chart Range';

  @override
  String get m1 => '1 M';

  @override
  String get m3 => '3 M';

  @override
  String get m6 => '6 M';

  @override
  String get y1 => '1 Y';

  @override
  String get shieldTransparentBalanceWithSending => 'Shield Transparent Balance When Sending';

  @override
  String get useUa => 'Use UA';

  @override
  String get createANewAccount => 'Tap + to add a new account';

  @override
  String get duplicateAccount => 'Duplicate Account';

  @override
  String get thisAccountAlreadyExists => 'Another account has the same address';

  @override
  String get selectAccount => 'Select Account';

  @override
  String get nameIsEmpty => 'Name is empty';

  @override
  String get deleteContact => 'Delete contact';

  @override
  String get areYouSureYouWantToDeleteThisContact => 'Are you sure you want to delete this contact?';

  @override
  String get saveToBlockchain => 'Save to Blockchain';

  @override
  String areYouSureYouWantToSaveYourContactsIt(Object ticker) {
    return 'Are you sure you want to save your contacts? It will cost 0.01 m$ticker';
  }

  @override
  String get confirmSaveContacts => 'Are you sure you want to save your contacts?';

  @override
  String get backupWarning => 'No one can recover your secret keys. If you don\'t have a backup and your phone breaks down, you WILL LOSE YOUR MONEY. You can reach this page by the app menu then Backup';

  @override
  String get contactName => 'Contact Name';

  @override
  String get date => 'Date';

  @override
  String get duplicateContact => 'Another contact has this address';

  @override
  String get autoHideBalance => 'Hide Balance';

  @override
  String get tiltYourDeviceUpToRevealYourBalance => 'Tilt your device up to reveal your balance';

  @override
  String get noContacts => 'No Contacts';

  @override
  String get createANewContactAndItWillShowUpHere => 'Tap + to add a new contact';

  @override
  String get addContact => 'Add Contact';

  @override
  String get accountHasSomeBalanceAreYouSureYouWantTo => 'Account has some BALANCE. Are you sure you want to delete it?';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get gold => 'Gold';

  @override
  String get purple => 'Purple';

  @override
  String get noRecipient => 'No Recipient';

  @override
  String get addARecipientAndItWillShowHere => 'Add a recipient and it will show here';

  @override
  String get receivePayment => 'Receive Payment';

  @override
  String get amountTooHigh => 'Amount too high';

  @override
  String get protectSend => 'Protect Send';

  @override
  String get protectSendSettingChanged => 'Protect Send setting changed';

  @override
  String get pleaseAuthenticateToSend => 'Please authenticate to Send';

  @override
  String get unshielded => 'Unshielded';

  @override
  String get unshieldedBalance => 'Unshielded Balance';

  @override
  String get totalBalance => 'Total Balance';

  @override
  String get underConfirmed => 'Under Confirmed';

  @override
  String get excludedNotes => 'Excluded Notes';

  @override
  String get spendableBalance => 'Spendable Balance';

  @override
  String get rescanNeeded => 'Rescan Needed';

  @override
  String get tapTransactionForDetails => 'Tap Transaction for Details';

  @override
  String get transactionHistory => 'Transaction History';

  @override
  String get help => 'Help';

  @override
  String receive(Object ticker) {
    return 'Receive $ticker';
  }

  @override
  String get pnlHistory => 'PNL History';

  @override
  String get useTransparentBalance => 'Use Transparent Balance';

  @override
  String get themeEditor => 'Theme Editor';

  @override
  String get color => 'Color';

  @override
  String get accentColor => 'Accent Color';

  @override
  String get primary => 'Primary';

  @override
  String get secondary => 'Secondary';

  @override
  String get multisig => 'Multisig';

  @override
  String get enterSecretShareIfAccountIsMultisignature => 'Enter secret share if account is multi-signature';

  @override
  String get secretShare => 'Secret Share';

  @override
  String get fileSaved => 'File saved';

  @override
  String numMoreSignersNeeded(Object num) {
    return '$num more signers needed';
  }

  @override
  String get sign => 'Sign Transaction';

  @override
  String get splitAccount => 'Split Account';

  @override
  String get confirmSigning => 'Confirm Signing';

  @override
  String confirmSignATransactionToAddressFor(Object address, Object amount) {
    return 'Do you want to sign a transaction to $address for $amount';
  }

  @override
  String get multisigShares => 'Multisig Shares';

  @override
  String get copy => 'Copy';

  @override
  String textCopiedToClipboard(Object text) {
    return '$text copied to clipboard';
  }

  @override
  String get multipleAddresses => 'multiple addresses';

  @override
  String get addnew => 'New/Restore';

  @override
  String get applicationReset => 'Application Reset';

  @override
  String get confirmResetApp => 'Are you sure you want to reset the app? Your accounts will NOT be deleted';

  @override
  String get reset => 'Reset';

  @override
  String get loading => 'Loading...';

  @override
  String get restart => 'Restart';

  @override
  String get pleaseQuitAndRestartTheAppNow => 'Please Quit and Restart the app in order for these changes to take effect';

  @override
  String get mode => 'Advanced Mode';

  @override
  String get simple => 'Simple';

  @override
  String get advanced => 'Advanced';

  @override
  String sendFrom(Object app) {
    return 'Sent from $app';
  }

  @override
  String get defaultMemo => 'Default Memo';

  @override
  String get fullBackup => 'Full Backup';

  @override
  String get backupEncryptionKey => 'Backup Encryption Key';

  @override
  String get saveBackup => 'Save Backup';

  @override
  String encryptedBackup(Object app) {
    return '$app Encrypted Backup';
  }

  @override
  String get fullRestore => 'Full Restore';

  @override
  String get loadBackup => 'Load Backup';

  @override
  String get backupAllAccounts => 'Backup All Accounts';

  @override
  String get simpleMode => 'Simple Mode';

  @override
  String get accountIndex => 'Account Index';

  @override
  String subAccountOf(Object name) {
    return 'Sub Account of $name';
  }

  @override
  String subAccountIndexOf(Object index, Object name) {
    return 'Sub Account $index of $name';
  }

  @override
  String get newSubAccount => 'New Sub Account';

  @override
  String get noActiveAccount => 'No active account';

  @override
  String get closeApplication => 'Close Application';

  @override
  String get disconnected => 'Disconnected';

  @override
  String get ledger => 'Ledger';

  @override
  String get mobileCharges => 'On Mobile Data, scanning may incur additional charges. Do you want to proceed?';

  @override
  String get iHaveMadeABackup => 'I have made a backup';

  @override
  String get barcodeScannerIsNotAvailableOnDesktop => 'Barcode scanner is not available on desktop';

  @override
  String get signOffline => 'Sign';

  @override
  String get rawTransaction => 'Raw Transaction';

  @override
  String get convertToWatchonly => 'To Watch-Only';

  @override
  String get messages => 'Messages';

  @override
  String get body => 'Body';

  @override
  String get subject => 'Subject';

  @override
  String get includeReplyTo => 'Include My Address in Memo';

  @override
  String get sender => 'Sender';

  @override
  String get message => 'Message';

  @override
  String get reply => 'Reply';

  @override
  String get recipient => 'Recipient';

  @override
  String get fromto => 'From/To';

  @override
  String get rescanning => 'Rescanning...';

  @override
  String get markAllAsRead => 'Mark All as Read';

  @override
  String get showMessagesAsTable => 'Show Messages as Table';

  @override
  String get editContact => 'Edit Contact';

  @override
  String get now => 'Now';

  @override
  String get protectOpen => 'Protect Open';

  @override
  String get gapLimit => 'Gap Limit';

  @override
  String get error => 'ERROR';

  @override
  String get paymentInProgress => 'Payment in progress...';

  @override
  String get useQrForOfflineSigning => 'Use QR for offline signing';

  @override
  String get unsignedTx => 'Unsigned Tx';

  @override
  String get signOnYourOfflineDevice => 'Sign on your offline device';

  @override
  String get signedTx => 'Signed Tx';

  @override
  String get broadcastFromYourOnlineDevice => 'Broadcast from your online device';

  @override
  String get checkTransaction => 'Check Transaction';

  @override
  String get crypto => 'Crypto';

  @override
  String get restoreAnAccount => 'Restore an account?';

  @override
  String get welcomeToYwallet => 'Welcome to YWallet';

  @override
  String get thePrivateWalletMessenger => 'The private wallet & messenger';

  @override
  String get newAccount => 'New Account';

  @override
  String get invalidKey => 'Invalid Key';

  @override
  String get barcode => 'Barcode';

  @override
  String get inputBarcodeValue => 'Input barcode';

  @override
  String get auto => 'Auto';

  @override
  String get count => 'Count';

  @override
  String get close => 'Close';

  @override
  String get changeTransparentKey => 'Change Transparent Key';

  @override
  String get cancelScan => 'Cancel Scan';

  @override
  String get resumeScan => 'Resume Scan';

  @override
  String get syncPaused => 'Sync Paused';

  @override
  String get derivationPath => 'Derivation Path';

  @override
  String get privateKey => 'Private Key';

  @override
  String get keyTool => 'Key Tool';

  @override
  String get update => 'Recalc';

  @override
  String get antispamFilter => 'Anti-Spam Filter';

  @override
  String get doYouWantToRestore => 'Do you want to restore your database? THIS WILL ERASE YOUR CURRENT DATA';

  @override
  String get useGpu => 'Use GPU';

  @override
  String get import => 'Import';

  @override
  String get newLabel => 'New';

  @override
  String invalidQrCode(Object message) {
    return 'Invalid QR code: $message';
  }

  @override
  String get expert => 'Expert';

  @override
  String blockReorgDetectedRewind(Object rewindHeight) {
    return 'Block reorg detected. Rewind to $rewindHeight';
  }

  @override
  String get goToTransaction => 'Show Transaction';

  @override
  String get transactions => 'Transactions';

  @override
  String get synchronizationInProgress => 'Synchronization in Progress';

  @override
  String get incomingFunds => 'Incoming funds';

  @override
  String get paymentMade => 'Payment made';

  @override
  String received(Object amount, Object ticker) {
    return 'Received $amount $ticker';
  }

  @override
  String spent(Object amount, Object ticker) {
    return 'Spent $amount $ticker';
  }

  @override
  String get set => 'Set';

  @override
  String get encryptionKey => 'Encryption Key';

  @override
  String get dbImportSuccessful => 'Db Import Successful';

  @override
  String get pools => 'Pools';

  @override
  String get poolTransfer => 'Pool Transfer';

  @override
  String get fromPool => 'From Pool';

  @override
  String get toPool => 'To Pool';

  @override
  String maxSpendableAmount(Object amount, Object ticker) {
    return 'Max spendable: $amount $ticker';
  }

  @override
  String get splitNotes => 'Split Notes';

  @override
  String get transfer => 'Transfer';

  @override
  String get template => 'Template';

  @override
  String get newTemplate => 'New Template';

  @override
  String get name => 'Name';

  @override
  String get deleteTemplate => 'Delete Template?';

  @override
  String get areYouSureYouWantToDeleteThisSendTemplate => 'Are you sure you want to delete this send template?';

  @override
  String get rewindToCheckpoint => 'Rewind to Checkpoint';

  @override
  String get selectCheckpoint => 'Select Checkpoint';

  @override
  String get scanQrCode => 'Scan QR Code';

  @override
  String get minPrivacy => 'Min Privacy';

  @override
  String get privacyLevelTooLow => 'Privacy Too LOW - Long press to override';

  @override
  String get veryLow => 'Very Low';

  @override
  String get low => 'Low';

  @override
  String get medium => 'Medium';

  @override
  String get high => 'High';

  @override
  String privacy(Object level) {
    return 'PRIVACY: $level';
  }

  @override
  String get save => 'Save';

  @override
  String get signingPleaseWait => 'Signing, please wait...';

  @override
  String get sweep => 'Sweep';

  @override
  String get transparentKey => 'Transparent Key';

  @override
  String get unifiedViewingKey => 'Unified Viewing Key';

  @override
  String get encryptDatabase => 'Encrypt Database';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get repeatNewPassword => 'Repeat New Password';

  @override
  String get databasePassword => 'Database Password';

  @override
  String get currentPasswordIncorrect => 'Current password incorrect';

  @override
  String get newPasswordsDoNotMatch => 'New passwords do not match';

  @override
  String get databaseEncrypted => 'Database Encrypted';

  @override
  String get invalidPassword => 'Invalid Password';

  @override
  String get databaseRestored => 'Database Restored';

  @override
  String get never => 'Never';

  @override
  String get always => 'Always';

  @override
  String get scanTransparentAddresses => 'Scan Transparent Addresses';

  @override
  String get scanningAddresses => 'Scanning addresses';

  @override
  String get blockExplorer => 'Block Explorer';

  @override
  String get tapQrCodeForSaplingAddress => 'Tap QR Code for Sapling Address';

  @override
  String get playSound => 'Play Sound Effects';

  @override
  String get fee => 'Fee';

  @override
  String get coins => 'Coins';

  @override
  String get rewind => 'Rewind';

  @override
  String get more => 'More';

  @override
  String get or => 'or';

  @override
  String get marketPrice => 'Mkt Prices';

  @override
  String get txPlan => 'Transaction Plan';

  @override
  String get pool => 'Pool';

  @override
  String get transparentInput => 'Transparent Input';

  @override
  String get saplingInput => 'Sapling Input';

  @override
  String get orchardInput => 'Orchard Input';

  @override
  String get netSapling => 'Net Sapling Change';

  @override
  String get netOrchard => 'Net Orchard Change';

  @override
  String get transparent => 'Transparent';

  @override
  String get sapling => 'Sapling';

  @override
  String get orchard => 'Orchard';

  @override
  String get paymentURI => 'Payment URI';

  @override
  String get lastPayment => 'Repeat Last Payment';

  @override
  String get next => 'Next';

  @override
  String get prev => 'Prev';

  @override
  String get nan => 'Not a number';

  @override
  String get memoTooLong => 'Memo too long';

  @override
  String get sending => 'Sending Transaction';

  @override
  String get sent => 'Transaction Sent';

  @override
  String get sent_failed => 'Transaction Failed';

  @override
  String get invalidPaymentURI => 'Invalid Payment URI';

  @override
  String get noSelection => 'Nothing Selected';

  @override
  String get confirmations => 'Min. Confirmations';

  @override
  String get hidden => 'Hidden';

  @override
  String get autoHide => 'Auto Hide';

  @override
  String get shown => 'Shown';

  @override
  String get useZats => 'Use Zats (8 decimals)';

  @override
  String get mainUA => 'Main UA Receivers';

  @override
  String get replyUA => 'Reply UA Receivers';

  @override
  String get uaReceivers => 'UA Receivers';

  @override
  String get list => 'List';

  @override
  String get autoView => 'Orientation';

  @override
  String get general => 'General';

  @override
  String get priv => 'Privacy';

  @override
  String get views => 'Views';

  @override
  String get autoFee => 'Automatic Fee';

  @override
  String get accountManager => 'Account Manager';

  @override
  String get pleaseWaitPlan => 'Computing Transaction';

  @override
  String get deletePayment => 'Are you sure you want to delete this recipient';

  @override
  String get ua => 'UA';

  @override
  String get receivers => 'Receivers';

  @override
  String get secured => 'Secured';

  @override
  String get external => 'External';

  @override
  String get derpath => 'Derivation Path';

  @override
  String get shielded => 'Shielded';

  @override
  String get addressIndex => 'Address Index';

  @override
  String get index => 'Index';

  @override
  String get pleaseAuthenticate => 'Please Authenticate';

  @override
  String get diversified => 'Diversified';

  @override
  String get source => 'Source';

  @override
  String get destination => 'Destination';

  @override
  String get scanRawTx => 'Scan the Unsigned Tx QR codes';

  @override
  String get scanSignedTx => 'Scan the Signed Tx QR codes';

  @override
  String get pickColor => 'Pick a Color';

  @override
  String get qr => 'QR Code';

  @override
  String get rescanWarning => 'RESCAN resets all your accounts. You may want to consider using REWIND instead';

  @override
  String get cannotUseTKey => 'Cannot import transparent private key. Use SWEEP instead';

  @override
  String get noDbPassword => 'Database must be encrypted to protect open/spend';

  @override
  String get seedOrKeyRequired => 'Seed or Private Key required';

  @override
  String get keygen => 'Backup Keygen';

  @override
  String get keygenHelp => 'Full backups use the AGE encryption system. The encryption key is used to encrypt the backup but CANNOT decrypt it. The SECRET key is needed to restore the backup.\nThe app will not store the keys. Every time this keygen will produce a DIFFERENT pair of keys.\n\nYou MUST save BOTH keys that you use';

  @override
  String get confirmSaveKeys => 'Have you saved your keys?';

  @override
  String get deductFee => 'Deduct fee from amount';
}
