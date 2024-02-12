import 'messages.dart';

/// The translations for French (`fr`).
class SFr extends S {
  SFr([String locale = 'fr']) : super(locale);

  @override
  String get about => 'A propos';

  @override
  String get account => 'Compte';

  @override
  String get accountBalanceHistory => 'Historique du solde du compte';

  @override
  String get accountIndex => 'Index du Compte';

  @override
  String get accountManager => 'Account Manager';

  @override
  String get accountName => 'Nom du compte';

  @override
  String get accounts => 'Comptes';

  @override
  String get add => 'AJOUTER';

  @override
  String get addContact => 'Ajouter un contact';

  @override
  String get address => 'adresse';

  @override
  String get addressCopiedToClipboard => 'Adresse copiée dans le presse-papier';

  @override
  String get addressIndex => 'Address Index';

  @override
  String get addressIsEmpty => 'L\'adresse est vide';

  @override
  String get advanced => 'Advanced';

  @override
  String get amount => 'Montant';

  @override
  String get amountCurrency => 'Amount in Fiat';

  @override
  String get amountMustBePositive => 'Le montant doit être positif';

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
  String get autoHideBalance => 'Cacher le solde';

  @override
  String get autoView => 'Orientation';

  @override
  String get backgroundSync => 'Background Sync';

  @override
  String get backup => 'Sauvegarde';

  @override
  String get backupAllAccounts => 'Sauver tous les comptes';

  @override
  String get backupMissing => 'BACKUP MISSING';

  @override
  String get balance => 'Solde';

  @override
  String get barcode => 'Code Barre';

  @override
  String get blockExplorer => 'Block Explorer';

  @override
  String get body => 'Contenu';

  @override
  String get broadcast => 'Diffusion';

  @override
  String get budget => 'Budget';

  @override
  String get cancel => 'Annuler';

  @override
  String get cannotDeleteActive => 'Cannot delete the active account unless it is the last one';

  @override
  String get cannotUseTKey => 'Cannot import transparent private key. Use SWEEP instead';

  @override
  String get catchup => 'Catch up';

  @override
  String get close => 'Fermer';

  @override
  String get coldStorage => 'Stockage à froid';

  @override
  String get configure => 'Configure';

  @override
  String get confirmDeleteAccount => 'Êtes-vous SUR de vouloir SUPPRIMER ce compte ? Vous DEVEZ avoir une SAUVEGARDE pour le récupérer. Cette opération n\'est PAS réversible.';

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
  String get confirmWatchOnly => 'Do you want to DELETE the secret key and convert this account to a watch-only account? You will not be able to spend from this device anymore. This operation is NOT reversible.';

  @override
  String get confirmations => 'Min. Confirmations';

  @override
  String get confs => 'Confs';

  @override
  String get connectionError => 'DISCONNECTED';

  @override
  String get contactName => 'Nom du Contact';

  @override
  String get contacts => 'Mes Contacts';

  @override
  String get convertToWatchonly => 'Convertir en Non-Dépensable';

  @override
  String get copiedToClipboard => 'Copy to Clipboard';

  @override
  String get copy => 'Copier';

  @override
  String get count => 'Nombre';

  @override
  String get crypto => 'Crypto';

  @override
  String get currency => 'Devise';

  @override
  String get currentPassword => 'Mot de Passe courrant';

  @override
  String get custom => 'Personnaliser';

  @override
  String get customSend => 'Use Custom Send';

  @override
  String get customSendSettings => 'Custom Send Settings';

  @override
  String get dark => 'Sombre';

  @override
  String get databasePassword => 'Mot de Passe de la BD';

  @override
  String get databaseRestored => 'BD Récupèrée';

  @override
  String get date => 'Date';

  @override
  String get datetime => 'Jour/Heure';

  @override
  String get deductFee => 'Deduct fee from amount';

  @override
  String get defaultMemo => 'Memo';

  @override
  String get delete => 'SUPPRIMER';

  @override
  String deleteAccount(Object name) {
    return 'Effacer un compte';
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
  String get editContact => 'Changer le Contact';

  @override
  String get encryptDatabase => 'Encrypter la BD';

  @override
  String get encryptionKey => 'Clé Publique';

  @override
  String get error => 'ERROR';

  @override
  String get external => 'External';

  @override
  String get fee => 'Fee';

  @override
  String get fromPool => 'A partir du Fond';

  @override
  String get fromto => 'Env/Dest.';

  @override
  String get fullBackup => 'Sauvegarde complète';

  @override
  String get fullRestore => 'Restauration complète';

  @override
  String get gapLimit => 'Ecart Limite';

  @override
  String get general => 'General';

  @override
  String get height => 'Hauteur';

  @override
  String get help => 'Aide';

  @override
  String get hidden => 'Hidden';

  @override
  String get high => 'Haut';

  @override
  String get history => 'Historique';

  @override
  String get import => 'Importer';

  @override
  String get includeReplyTo => 'Inclure mon Adresse de Réponse';

  @override
  String get incomingFunds => 'Payment Reçu';

  @override
  String get index => 'Index';

  @override
  String get interval => 'Interval';

  @override
  String get invalidAddress => 'Adresse invalide';

  @override
  String get invalidKey => 'Clé invalide';

  @override
  String get invalidPassword => 'Mot de Passe incorrect';

  @override
  String get invalidPaymentURI => 'Invalid Payment URI';

  @override
  String get key => 'Clé';

  @override
  String get keyTool => 'Clés Utilitaires';

  @override
  String get keygen => 'Backup Keygen';

  @override
  String get keygenHelp => 'Full backups use the AGE encryption system. The encryption key is used to encrypt the backup but CANNOT decrypt it. The SECRET key is needed to restore the backup.\nThe app will not store the keys. Every time this keygen will produce a DIFFERENT pair of keys.\n\nYou MUST save BOTH keys that you use';

  @override
  String get largestSpendingsByAddress => 'Dépenses les plus importantes par adresse';

  @override
  String get ledger => 'Ledger';

  @override
  String get light => 'Clair';

  @override
  String get list => 'List';

  @override
  String get loading => 'Chargement...';

  @override
  String get low => 'Bas';

  @override
  String get mainUA => 'Main UA Receivers';

  @override
  String get market => 'Market';

  @override
  String get marketPrice => 'Mkt Prices';

  @override
  String get max => 'MAX';

  @override
  String get maxAmountPerNote => 'Montant maximum par note';

  @override
  String get medium => 'Moyen';

  @override
  String get memo => 'Mémo';

  @override
  String get memoTooLong => 'Memo too long';

  @override
  String get message => 'Message';

  @override
  String get messages => 'Messages';

  @override
  String get minPrivacy => 'Niveau de Secret Minimum';

  @override
  String get mode => 'Advanced Mode';

  @override
  String get more => 'More';

  @override
  String get multiPay => 'Envoyer à plusieurs';

  @override
  String get na => 'N/D';

  @override
  String get name => 'Nom';

  @override
  String get nan => 'Not a number';

  @override
  String get netOrchard => 'Net Orchard Change';

  @override
  String get netSapling => 'Net Sapling Change';

  @override
  String get newAccount => 'Nouveau Compte';

  @override
  String get newPassword => 'Nouveau Mot de Passe';

  @override
  String get newPasswordsDoNotMatch => 'Les nouveaux Mots de Passe ne correspondent pas';

  @override
  String get next => 'Next';

  @override
  String get noAuthenticationMethod => 'Pas de méthode d\'authentification';

  @override
  String get noDbPassword => 'Database must be encrypted to protect open/spend';

  @override
  String get noRemindBackup => 'Do not remind me';

  @override
  String get notEnoughBalance => 'Solde insuffisant';

  @override
  String get notes => 'Billets';

  @override
  String get now => 'Maintenant';

  @override
  String get off => 'Off';

  @override
  String get ok => 'OK';

  @override
  String get openInExplorer => 'Ouvrir dans l\'explorateur';

  @override
  String get or => 'or';

  @override
  String get orchard => 'Orchard';

  @override
  String get orchardInput => 'Orchard Input';

  @override
  String get paymentMade => 'Payment Envoyé';

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
  String get pools => 'Echanger entre Fonds';

  @override
  String get prev => 'Prev';

  @override
  String get priv => 'Privacy';

  @override
  String privacy(Object level) {
    return 'SECRET: $level';
  }

  @override
  String get privacyLevelTooLow => 'Transaction pas assez secrète';

  @override
  String get privateKey => 'Clé Privée';

  @override
  String get protectOpen => 'Ouverture protégée';

  @override
  String get protectSend => 'PIN avant envoi';

  @override
  String get publicKey => 'Public Key';

  @override
  String get qr => 'QR Code';

  @override
  String get rawTransaction => 'Transaction Signée';

  @override
  String receive(Object ticker) {
    return 'Recevoir $ticker';
  }

  @override
  String received(Object amount, Object ticker) {
    return 'Reçu $amount $ticker';
  }

  @override
  String get receivers => 'Receivers';

  @override
  String get recipient => 'Destinataire';

  @override
  String get repeatNewPassword => 'Répéter le Nouveau Mot de Passe';

  @override
  String get reply => 'Répondre';

  @override
  String get replyUA => 'Reply UA Receivers';

  @override
  String get required => 'Value Required';

  @override
  String get rescan => 'Parcourir à nouveau';

  @override
  String get rescanFrom => 'Reparcourir à partir de...?';

  @override
  String get rescanWarning => 'RESCAN resets all your accounts. You may want to consider using REWIND instead';

  @override
  String get reset => 'Reset';

  @override
  String get restart => 'Redémarrage';

  @override
  String get restore => 'Restore';

  @override
  String get restoreAnAccount => 'Récuperation d\'un Compte?';

  @override
  String get retrieveTransactionDetails => 'Récupérer les détails de la transaction';

  @override
  String get rewind => 'Rewind';

  @override
  String get sapling => 'Sapling';

  @override
  String get saplingInput => 'Sapling Input';

  @override
  String get save => 'Sauver';

  @override
  String get scanQrCode => 'Scanner le QR Code';

  @override
  String get scanRawTx => 'Scan the Unsigned Tx QR codes';

  @override
  String get scanSignedTx => 'Scan the Signed Tx QR codes';

  @override
  String get secretKey => 'Clé secrète';

  @override
  String get secured => 'Secured';

  @override
  String get seed => 'Graine';

  @override
  String get seedKeys => 'Seed & Keys';

  @override
  String get seedOrKeyRequired => 'Seed or Private Key required';

  @override
  String get selectNotesToExcludeFromPayments => 'Sélectionnez les billets à EXCLURE des paiements';

  @override
  String get send => 'Envoyer';

  @override
  String sendCointicker(Object ticker) {
    return 'Envoyer $ticker';
  }

  @override
  String sendFrom(Object app) {
    return 'Envoyé via $app';
  }

  @override
  String get sender => 'Envoyeur';

  @override
  String get sending => 'Sending Transaction';

  @override
  String get sent => 'Transaction Sent';

  @override
  String get sent_failed => 'Transaction Failed';

  @override
  String get server => 'Serveur';

  @override
  String get set => 'Utiliser';

  @override
  String get settings => 'Paramètres';

  @override
  String get shielded => 'Shielded';

  @override
  String get showSubKeys => 'Show Sub Keys';

  @override
  String get sign => 'Sign';

  @override
  String get signOffline => 'Signer';

  @override
  String get signedTx => 'Tx signée';

  @override
  String get source => 'Source';

  @override
  String get spendable => 'Dépensable';

  @override
  String spent(Object amount, Object ticker) {
    return 'Envoyé $amount $ticker';
  }

  @override
  String get subject => 'Sujet';

  @override
  String get sweep => 'Balayer';

  @override
  String get sync => 'Synchronization';

  @override
  String get syncPaused => 'Sync en Pause';

  @override
  String get table => 'Tableau';

  @override
  String get template => 'Modèle';

  @override
  String textCopiedToClipboard(Object text) {
    return '$text copié au presse-papier';
  }

  @override
  String get thePrivateWalletMessenger => 'Le Portefeuille et Messagerie Privé';

  @override
  String get theme => 'Thème';

  @override
  String get thisAccountAlreadyExists => 'Ce Compte existe déjà';

  @override
  String get timestamp => 'Date/Heure';

  @override
  String get toPool => 'Vers le Fond';

  @override
  String get tools => 'Tools';

  @override
  String get totalBalance => 'Solde Total';

  @override
  String get transactionDetails => 'Détails de la transaction';

  @override
  String get transactionHistory => 'Historique des Transactions';

  @override
  String get transactions => 'Transactions';

  @override
  String get transfer => 'Transférer';

  @override
  String get transparent => 'Transparent';

  @override
  String get transparentInput => 'Transparent Input';

  @override
  String get transparentKey => 'Clé Transparente';

  @override
  String get txID => 'TXID';

  @override
  String txId(Object txid) {
    return 'ID de tx: $txid';
  }

  @override
  String get txPlan => 'Transaction Plan';

  @override
  String get ua => 'UA';

  @override
  String get unifiedViewingKey => 'Clé publique unifiée';

  @override
  String get unsignedTx => 'Tx non signée';

  @override
  String get update => 'Recalculer';

  @override
  String get useZats => 'Use Zats (8 decimals)';

  @override
  String get version => 'Version';

  @override
  String get veryLow => 'Très bas';

  @override
  String get viewingKey => 'Clé publique';

  @override
  String get views => 'Views';

  @override
  String get welcomeToYwallet => 'Bienvenue à YWallet';

  @override
  String get wifi => 'WiFi';
}
