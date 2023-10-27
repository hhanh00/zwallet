import 'messages.dart';

/// The translations for French (`fr`).
class SFr extends S {
  SFr([String locale = 'fr']) : super(locale);

  @override
  String get version => 'Version';

  @override
  String get about => 'A propos';

  @override
  String get ok => 'OK';

  @override
  String get account => 'Compte';

  @override
  String get notes => 'Billets';

  @override
  String get history => 'Historique';

  @override
  String get budget => 'Budget';

  @override
  String get tradingPl => 'Profit et Pertes';

  @override
  String get contacts => 'Mes Contacts';

  @override
  String get accounts => 'Comptes';

  @override
  String get backup => 'Sauvegarde';

  @override
  String get rescan => 'Parcourir à nouveau';

  @override
  String get catchup => 'Catch up';

  @override
  String get coldStorage => 'Stockage à froid';

  @override
  String get multipay => 'Envoyer à plusieurs';

  @override
  String get broadcast => 'Diffusion';

  @override
  String get settings => 'Paramètres';

  @override
  String get synching => 'Synchronisation en cours';

  @override
  String get tapQrCodeForShieldedAddress => 'Appuyez sur le code QR pour l\'adresse protégée';

  @override
  String get tapQrCodeForTransparentAddress => 'Appuyez sur le code QR pour l\'adresse transparente';

  @override
  String get addressCopiedToClipboard => 'Adresse copiée dans le presse-papier';

  @override
  String get shieldTransparentBalance => 'Masquer le solde transparent';

  @override
  String doYouWantToTransferYourEntireTransparentBalanceTo(Object ticker) {
    return 'Voulez-vous transférer l\'intégralité de votre solde transparent à votre adresse protégée?';
  }

  @override
  String get shieldingInProgress => 'Masquage en cours...';

  @override
  String txId(Object txid) {
    return 'ID de tx: $txid';
  }

  @override
  String get txID => 'TXID';

  @override
  String get pleaseAuthenticateToShowAccountSeed => 'Veuillez vous authentifier pour voir la graine du compte';

  @override
  String get noAuthenticationMethod => 'Pas de méthode d\'authentification';

  @override
  String get rescanFrom => 'Reparcourir à partir de...?';

  @override
  String get cancel => 'Annuler';

  @override
  String rescanRequested(Object height) {
    return 'Parcours demandé à partir de $height...';
  }

  @override
  String get doYouWantToDeleteTheSecretKeyAndConvert => 'Voulez-vous SUPPRIMER la clé secrète et convertir ce compte en un compte d\'observation ? Vous ne pourrez plus dépenser depuis cet appareil. Cette opération n\'est PAS réversible.';

  @override
  String get delete => 'SUPPRIMER';

  @override
  String get confs => 'Confs';

  @override
  String get height => 'Hauteur';

  @override
  String get datetime => 'Jour/Heure';

  @override
  String get amount => 'Montant';

  @override
  String get selectNotesToExcludeFromPayments => 'Sélectionnez les billets à EXCLURE des paiements';

  @override
  String get largestSpendingsByAddress => 'Dépenses les plus importantes par adresse';

  @override
  String get tapChartToToggleBetweenAddressAndAmount => 'Appuyez sur le graphique pour basculer entre l\'adresse et le montant';

  @override
  String get accountBalanceHistory => 'Historique du solde du compte';

  @override
  String get noSpendingInTheLast30Days => 'Aucune dépense au cours des 30 derniers jours';

  @override
  String get largestSpendingLastMonth => 'Dépenses les plus importantes le mois dernier';

  @override
  String get balance => 'Solde';

  @override
  String get pnl => 'P/P';

  @override
  String get mm => 'Virtuel';

  @override
  String get total => 'Total';

  @override
  String get price => 'Prix';

  @override
  String get qty => 'Quantité';

  @override
  String get table => 'Tableau';

  @override
  String get pl => 'Profit/Perte';

  @override
  String get realized => 'Réalisé';

  @override
  String get toMakeAContactSendThemAMemoWithContact => 'Pour établir un contact, envoyez-lui un mémo avec Contact:';

  @override
  String get newSnapAddress => 'Nouvelle adresse instantanée';

  @override
  String get shieldTranspBalance => 'Masquer le Solde Transparent';

  @override
  String get send => 'Envoyer';

  @override
  String get noAccount => 'Pas de compte';

  @override
  String get seed => 'Graine';

  @override
  String get confirmDeleteAccount => 'Êtes-vous SUR de vouloir SUPPRIMER ce compte ? Vous DEVEZ avoir une SAUVEGARDE pour le récupérer. Cette opération n\'est PAS réversible.';

  @override
  String get confirmDeleteContact => 'Are you SURE you want to DELETE this contact?';

  @override
  String get changeAccountName => 'Modifier le nom du compte';

  @override
  String backupDataRequiredForRestore(Object name) {
    return 'Données de sauvegarde - $name - requises pour la restauration';
  }

  @override
  String get secretKey => 'Clé secrète';

  @override
  String get publicKey => 'Public Key';

  @override
  String get viewingKey => 'Clé publique';

  @override
  String get tapAnIconToShowTheQrCode => 'Appuyez sur une icône pour afficher le code QR';

  @override
  String get multiPay => 'Envoyer à plusieurs';

  @override
  String get pleaseConfirm => 'Veuillez confirmer';

  @override
  String sendingATotalOfAmountCointickerToCountRecipients(Object amount, Object count, Object ticker) {
    return 'Envoi d\'un total de $amount $ticker à $count destinataires';
  }

  @override
  String get preparingTransaction => 'Préparation de la transaction...';

  @override
  String sendCointickerTo(Object ticker) {
    return 'Envoyer $ticker à...';
  }

  @override
  String get addressIsEmpty => 'L\'adresse est vide';

  @override
  String get invalidAddress => 'Adresse invalide';

  @override
  String get amountMustBeANumber => 'Le montant doit être un nombre';

  @override
  String get amountMustBePositive => 'Le montant doit être positif';

  @override
  String get accountName => 'Nom du compte';

  @override
  String get accountNameIsRequired => 'Le nom du compte est requis';

  @override
  String get enterSeed => 'Entrez la graine, la clé secrète ou la clé de visualisation. Laissez vide pour un nouveau compte';

  @override
  String get scanStartingMomentarily => 'Le scan démarre momentanément';

  @override
  String get key => 'Clé';

  @override
  String sendCointicker(Object ticker) {
    return 'Envoyer $ticker';
  }

  @override
  String get max => 'MAX';

  @override
  String get advancedOptions => 'Options avancées';

  @override
  String get memo => 'Mémo';

  @override
  String get roundToMillis => 'Arrondir au millième';

  @override
  String useSettingscurrency(Object currency) {
    return 'Utiliser $currency';
  }

  @override
  String get includeFeeInAmount => 'Inclure les frais dans le montant';

  @override
  String get maxAmountPerNote => 'Montant maximum par note';

  @override
  String get spendable => 'Dépensable';

  @override
  String get notEnoughBalance => 'Solde insuffisant';

  @override
  String get approve => 'APPROUVER';

  @override
  String sendingAzecCointickerToAddress(Object aZEC, Object address, Object ticker) {
    return 'Envoi de $aZEC $ticker à $address';
  }

  @override
  String get unsignedTransactionFile => 'Fichier de transaction non signée';

  @override
  String amountInSettingscurrency(Object currency) {
    return 'Montant en $currency';
  }

  @override
  String get custom => 'Personnaliser';

  @override
  String get server => 'Serveur';

  @override
  String get blue => 'Bleu';

  @override
  String get pink => 'Rose';

  @override
  String get coffee => 'Café';

  @override
  String get light => 'Clair';

  @override
  String get dark => 'Sombre';

  @override
  String get currency => 'Devise';

  @override
  String get numberOfConfirmationsNeededBeforeSpending => 'Nombre de confirmations nécessaires avant de dépenser';

  @override
  String get retrieveTransactionDetails => 'Récupérer les détails de la transaction';

  @override
  String get theme => 'Thème';

  @override
  String get transactionDetails => 'Détails de la transaction';

  @override
  String get timestamp => 'Date/Heure';

  @override
  String get address => 'adresse';

  @override
  String get openInExplorer => 'Ouvrir dans l\'explorateur';

  @override
  String get restore => 'Restore';

  @override
  String get na => 'N/D';

  @override
  String get add => 'AJOUTER';

  @override
  String get tradingChartRange => 'Domaine de temps des graphiques';

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
  String get useUa => 'Utiliser UA';

  @override
  String get createANewAccount => 'Créez un nouveau compte et il apparaîtra ici';

  @override
  String get duplicateAccount => 'Compte en double';

  @override
  String get thisAccountAlreadyExists => 'Ce Compte existe déjà';

  @override
  String get selectAccount => 'Choisissez un compte';

  @override
  String get nameIsEmpty => 'Le nom est vide';

  @override
  String get deleteContact => 'Effacer un contact';

  @override
  String get areYouSureYouWantToDeleteThisContact => 'Voulez vous effacer ce contact?';

  @override
  String get saveToBlockchain => 'Sauver les contacts dans la blockchaine';

  @override
  String areYouSureYouWantToSaveYourContactsIt(Object ticker) {
    return 'Voulez vous sauver vos contacts? Ceci coute 0.01 m$ticker';
  }

  @override
  String get confirmSaveContacts => 'Are you sure you want to save your contacts?';

  @override
  String get backupWarning => 'Vos clés ne sont pas récupérables. Si vous n\'avez pas de sauvegarde, vous pouvez PERDREZ VOTRE ARGENT. Cette page est accessible par Menu ... / Sauvegarde';

  @override
  String get contactName => 'Nom du Contact';

  @override
  String get date => 'Date';

  @override
  String get duplicateContact => 'Another contact has this address';

  @override
  String get autoHideBalance => 'Cacher le solde';

  @override
  String get tiltYourDeviceUpToRevealYourBalance => 'Redressez votre mobile pour révéler votre solde';

  @override
  String get noContacts => 'Pas de Contacts';

  @override
  String get createANewContactAndItWillShowUpHere => 'Créez un nouveau contact et il apparaîtra ici';

  @override
  String get addContact => 'Ajouter un contact';

  @override
  String get accountHasSomeBalanceAreYouSureYouWantTo => 'Ce compte a un solde. Voulez vous l\'effacer?';

  @override
  String get deleteAccount => 'Effacer un compte';

  @override
  String get gold => 'Or';

  @override
  String get purple => 'Violet';

  @override
  String get noRecipient => 'Pas de receveur';

  @override
  String get addARecipientAndItWillShowHere => 'Ajoutez un receveur et il sera ici';

  @override
  String get receivePayment => 'Recevoir un payment';

  @override
  String get amountTooHigh => 'Montant trop haut';

  @override
  String get protectSend => 'PIN avant envoi';

  @override
  String get protectSendSettingChanged => 'Changement de PIN avant envoi';

  @override
  String get pleaseAuthenticateToSend => 'Veillez vous authentifier avant l\'envoi';

  @override
  String get unshielded => 'Transparent';

  @override
  String get unshieldedBalance => 'Solde Transparent';

  @override
  String get totalBalance => 'Solde Total';

  @override
  String get underConfirmed => 'Pas assez de confs';

  @override
  String get excludedNotes => 'Billets exclus';

  @override
  String get spendableBalance => 'Montant dépensable';

  @override
  String get rescanNeeded => 'Scan nécessaire';

  @override
  String get tapTransactionForDetails => 'Presser sur une Transaction pour plus de details';

  @override
  String get transactionHistory => 'Historique des Transactions';

  @override
  String get help => 'Aide';

  @override
  String receive(Object ticker) {
    return 'Recevoir $ticker';
  }

  @override
  String get pnlHistory => 'Historique des P/P';

  @override
  String get useTransparentBalance => 'Utiliser le Solde Transparent';

  @override
  String get themeEditor => 'Editeur de Thème';

  @override
  String get color => 'Couleur';

  @override
  String get accentColor => 'Couleur d\'accent';

  @override
  String get primary => 'Primaire';

  @override
  String get secondary => 'Secondaire';

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
  String get sign => 'Sign';

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
  String get copy => 'Copier';

  @override
  String textCopiedToClipboard(Object text) {
    return '$text copié au presse-papier';
  }

  @override
  String get multipleAddresses => 'plusieurs adresses';

  @override
  String get addnew => 'Ajouter';

  @override
  String get applicationReset => 'Réinitialisation';

  @override
  String get confirmResetApp => 'Etes vous sur de vouloir réinitialiser. Vos comptes ne seront PAS perdus ';

  @override
  String get reset => 'Reset';

  @override
  String get loading => 'Chargement...';

  @override
  String get restart => 'Redémarrage';

  @override
  String get pleaseQuitAndRestartTheAppNow => 'Please Quit and Restart the app in order for these changes to take effect';

  @override
  String get mode => 'Mode';

  @override
  String get simple => 'Simple';

  @override
  String get advanced => 'Avancé';

  @override
  String sendFrom(Object app) {
    return 'Envoyé via $app';
  }

  @override
  String get defaultMemo => 'Memo';

  @override
  String get fullBackup => 'Sauvegarde complète';

  @override
  String get backupEncryptionKey => 'Clé de chiffrage';

  @override
  String get saveBackup => 'Sauvegarder les comptes';

  @override
  String encryptedBackup(Object app) {
    return 'Sauvegarde de $app ';
  }

  @override
  String get fullRestore => 'Restauration complète';

  @override
  String get loadBackup => 'Recharger une sauvegarde';

  @override
  String get backupAllAccounts => 'Sauver tous les comptes';

  @override
  String get simpleMode => 'Mode Simple';

  @override
  String get accountIndex => 'Index du Compte';

  @override
  String subAccountOf(Object name) {
    return 'Sous Compte de $name';
  }

  @override
  String subAccountIndexOf(Object index, Object name) {
    return 'Sous Compte $index de $name';
  }

  @override
  String get newSubAccount => 'Nouveau Sous Compte';

  @override
  String get noActiveAccount => 'Aucun Compte sélectionné';

  @override
  String get closeApplication => 'Close Application';

  @override
  String get disconnected => 'Déconnecté';

  @override
  String get ledger => 'Ledger';

  @override
  String get mobileCharges => 'Sans Wi-fi, les frais peuvent être élevés. Voulez vous continuer?';

  @override
  String get iHaveMadeABackup => 'J\'ai fait une sauvegarde';

  @override
  String get barcodeScannerIsNotAvailableOnDesktop => 'Le Barcode scanner est seulement disponible sur mobile';

  @override
  String get signOffline => 'Signer';

  @override
  String get rawTransaction => 'Transaction Signée';

  @override
  String get convertToWatchonly => 'Convertir en Non-Dépensable';

  @override
  String get messages => 'Messages';

  @override
  String get body => 'Contenu';

  @override
  String get subject => 'Sujet';

  @override
  String get includeReplyTo => 'Inclure mon Adresse de Réponse';

  @override
  String get sender => 'Envoyeur';

  @override
  String get message => 'Message';

  @override
  String get reply => 'Répondre';

  @override
  String get recipient => 'Destinataire';

  @override
  String get fromto => 'Env/Dest.';

  @override
  String get rescanning => 'Rescannage en cours...';

  @override
  String get markAllAsRead => 'Marquer tous lus';

  @override
  String get showMessagesAsTable => 'Messages vus en table';

  @override
  String get editContact => 'Changer le Contact';

  @override
  String get now => 'Maintenant';

  @override
  String get protectOpen => 'Ouverture protégée';

  @override
  String get gapLimit => 'Ecart Limite';

  @override
  String get error => 'ERROR';

  @override
  String get paymentInProgress => 'Payment en cours...';

  @override
  String get useQrForOfflineSigning => 'Utiliser des QR pour signer sans connexion';

  @override
  String get unsignedTx => 'Tx non signée';

  @override
  String get signOnYourOfflineDevice => 'Signer avec l\'appareil sans connexion';

  @override
  String get signedTx => 'Tx signée';

  @override
  String get broadcastFromYourOnlineDevice => 'Diffuser avec l\'appareil connecté en ligne';

  @override
  String get checkTransaction => 'Vérifier la Transaction';

  @override
  String get crypto => 'Crypto';

  @override
  String get restoreAnAccount => 'Récuperation d\'un Compte?';

  @override
  String get welcomeToYwallet => 'Bienvenue à YWallet';

  @override
  String get thePrivateWalletMessenger => 'Le Portefeuille et Messagerie Privé';

  @override
  String get newAccount => 'Nouveau Compte';

  @override
  String get invalidKey => 'Clé invalide';

  @override
  String get barcode => 'Code Barre';

  @override
  String get inputBarcodeValue => 'Entrer le Code Barre';

  @override
  String get auto => 'Auto';

  @override
  String get count => 'Nombre';

  @override
  String get close => 'Fermer';

  @override
  String get changeTransparentKey => 'Changer la clé';

  @override
  String get cancelScan => 'Suspendre Sync';

  @override
  String get resumeScan => 'Continuer Sync';

  @override
  String get syncPaused => 'Sync en Pause';

  @override
  String get derivationPath => 'Chemin de Dérivation';

  @override
  String get privateKey => 'Clé Privée';

  @override
  String get keyTool => 'Clés Utilitaires';

  @override
  String get update => 'Recalculer';

  @override
  String get antispamFilter => 'Anti-Spam Filter';

  @override
  String get doYouWantToRestore => 'Voulez vous restaurer vos données? CECI VA EFFACER VOS COMPTES.';

  @override
  String get useGpu => 'Utiliser le GPU';

  @override
  String get import => 'Importer';

  @override
  String get newLabel => 'Nouveau';

  @override
  String invalidQrCode(Object message) {
    return 'QR code invalide: $message';
  }

  @override
  String get expert => 'Expert';

  @override
  String blockReorgDetectedRewind(Object rewindHeight) {
    return 'Réorganisation détectée. Retour à $rewindHeight';
  }

  @override
  String get goToTransaction => 'Voir la Transaction';

  @override
  String get transactions => 'Transactions';

  @override
  String get synchronizationInProgress => 'Synchronization en Cours';

  @override
  String get incomingFunds => 'Payment Reçu';

  @override
  String get paymentMade => 'Payment Envoyé';

  @override
  String received(Object amount, Object ticker) {
    return 'Reçu $amount $ticker';
  }

  @override
  String spent(Object amount, Object ticker) {
    return 'Envoyé $amount $ticker';
  }

  @override
  String get set => 'Utiliser';

  @override
  String get encryptionKey => 'Clé Publique';

  @override
  String get dbImportSuccessful => 'Sauvegarde importée';

  @override
  String get pools => 'Echanger entre Fonds';

  @override
  String get poolTransfer => 'Pool Transfer';

  @override
  String get fromPool => 'A partir du Fond';

  @override
  String get toPool => 'Vers le Fond';

  @override
  String maxSpendableAmount(Object amount, Object ticker) {
    return 'Max dépensable: $amount $ticker';
  }

  @override
  String get splitNotes => 'Diviser Billets';

  @override
  String get transfer => 'Transférer';

  @override
  String get template => 'Modèle';

  @override
  String get newTemplate => 'Nouveau modèle';

  @override
  String get name => 'Nom';

  @override
  String get deleteTemplate => 'Effacer ce modèle?';

  @override
  String get areYouSureYouWantToDeleteThisSendTemplate => 'Voulez-vous vraiment supprimer ce modèle?';

  @override
  String get rewindToCheckpoint => 'Revenir au Bloc';

  @override
  String get selectCheckpoint => 'Selectionner la date du bloc';

  @override
  String get scanQrCode => 'Scanner le QR Code';

  @override
  String get minPrivacy => 'Niveau de Secret Minimum';

  @override
  String get privacyLevelTooLow => 'Transaction pas assez secrète';

  @override
  String get veryLow => 'Très bas';

  @override
  String get low => 'Bas';

  @override
  String get medium => 'Moyen';

  @override
  String get high => 'Haut';

  @override
  String privacy(Object level) {
    return 'SECRET: $level';
  }

  @override
  String get save => 'Sauver';

  @override
  String get signingPleaseWait => 'Signature en cours...';

  @override
  String get sweep => 'Balayer';

  @override
  String get transparentKey => 'Clé Transparente';

  @override
  String get unifiedViewingKey => 'Clé publique unifiée';

  @override
  String get encryptDatabase => 'Encrypter la BD';

  @override
  String get currentPassword => 'Mot de Passe courrant';

  @override
  String get newPassword => 'Nouveau Mot de Passe';

  @override
  String get repeatNewPassword => 'Répéter le Nouveau Mot de Passe';

  @override
  String get databasePassword => 'Mot de Passe de la BD';

  @override
  String get currentPasswordIncorrect => 'Mot de Passe incorrect';

  @override
  String get newPasswordsDoNotMatch => 'Les nouveaux Mots de Passe ne correspondent pas';

  @override
  String get databaseEncrypted => 'BD encryptée';

  @override
  String get invalidPassword => 'Mot de Passe incorrect';

  @override
  String get databaseRestored => 'BD Récupèrée';

  @override
  String get never => 'Jamais';

  @override
  String get always => 'Toujours';

  @override
  String get scanTransparentAddresses => 'Scan Transparent Addresses';

  @override
  String get scanningAddresses => 'Scanning addresses';

  @override
  String get blockExplorer => 'Block Explorer';

  @override
  String get tapQrCodeForSaplingAddress => 'Tap QR Code for Sapling Address';

  @override
  String get playSound => 'Effets Sonores';

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
  String get marketPrice => 'Historical Prices';

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
  String get receivers => 'UA Receivers';

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
}
