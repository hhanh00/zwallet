import 'messages.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class SFr extends S {
  SFr([String locale = 'fr']) : super(locale);

  @override
  String get about => 'À propos de';

  @override
  String get account => 'Compte client';

  @override
  String get accountBalanceHistory => 'Historique du solde du compte';

  @override
  String get accountIndex => 'Index du Compte';

  @override
  String get accountManager => 'Gestionnaire de compte';

  @override
  String get accountName => 'Nom du compte';

  @override
  String get accounts => 'Comptes';

  @override
  String get add => 'Ajouter';

  @override
  String get addContact => 'Ajouter un contact';

  @override
  String get address => 'Adresse';

  @override
  String get addressCopiedToClipboard => 'Adresse copiée dans le presse-papiers';

  @override
  String get addressIndex => 'Index de l\'adresse';

  @override
  String get addressIsEmpty => 'L\'adresse est vide';

  @override
  String get amount => 'Montant';

  @override
  String get amountCurrency => 'Montant en Fiat';

  @override
  String get amountMustBePositive => 'Le montant doit être positif';

  @override
  String get amountSlider => 'Curseur de montant';

  @override
  String get antispamFilter => 'Filtre anti-spam';

  @override
  String get any => 'Toujours';

  @override
  String get appData => 'Données de l\'application';

  @override
  String get auto => 'Automatique';

  @override
  String get autoFee => 'Frais calculés automatiquement';

  @override
  String get autoHide => 'Masquage automatique';

  @override
  String get autoHideBalance => 'Cacher le solde';

  @override
  String get autoView => 'Orientation';

  @override
  String get backgroundSync => 'Synchronisation en arrière-plan';

  @override
  String get backup => 'Sauvegarde';

  @override
  String get backupAllAccounts => 'Sauvegarder tous les comptes';

  @override
  String get backupMissing => 'SAUVEGARDE MANQUANTE';

  @override
  String get balance => 'Solde';

  @override
  String get barcode => 'Code-barres';

  @override
  String get blockExplorer => 'Explorateur de blocs';

  @override
  String get body => 'Corps du message';

  @override
  String get broadcast => 'Diffusion';

  @override
  String get budget => 'Budget';

  @override
  String get cancel => 'Abandonner';

  @override
  String get cannotDeleteActive => 'Impossible de supprimer le compte actif sauf s\'il est le dernier';

  @override
  String get cannotUseTKey => 'Impossible d\'importer une clé privée transparente. Utilisez BALAYER à la place';

  @override
  String get catchup => 'Rattraper';

  @override
  String get close => 'Fermer';

  @override
  String get coldStorage => 'Stockage froid';

  @override
  String get configure => 'Configurer';

  @override
  String get confirmDeleteAccount => 'Êtes-vous sûr de vouloir SUPPRIMER ce compte ? Vous DEVEZ avoir une SAUVEGARDE pour le récupérer. Cette opération n\'est PAS réversible.';

  @override
  String get confirmDeleteContact => 'Êtes-vous sûr de vouloir SUPPRIMER ce contact ?';

  @override
  String confirmRescanFrom(Object height) {
    return 'Voulez-vous rescanner depuis le bloc $height?';
  }

  @override
  String confirmRewind(Object height) {
    return 'Voulez-vous revenir en arrière pour bloquer $height?';
  }

  @override
  String get confirmSaveContacts => 'Êtes-vous sûr de vouloir enregistrer vos contacts ?';

  @override
  String get confirmSaveKeys => 'Avez-vous enregistré vos clés ?';

  @override
  String get confirmWatchOnly => 'Voulez-vous SUPPRIMER la clé secrète et convertir ce compte en un compte en lecture seule ? Vous ne pourrez plus dépenser depuis cet appareil. Cette opération n\'est PAS réversible.';

  @override
  String get confirmations => 'Confirmations minimum';

  @override
  String get confs => 'Confirmations';

  @override
  String get connectionError => 'DÉCONNECTÉ';

  @override
  String get contactName => 'Nom du contact';

  @override
  String get contacts => 'Contacts';

  @override
  String get convertToWatchonly => 'À la lecture seule';

  @override
  String get copiedToClipboard => 'Copier dans le presse-papier';

  @override
  String get copy => 'Copie';

  @override
  String get count => 'Nombre';

  @override
  String get crypto => 'Crypto';

  @override
  String get currency => 'Devise';

  @override
  String get currentPassword => 'Mot de passe actuel';

  @override
  String get custom => 'Personnalisé';

  @override
  String get customSend => 'Utiliser l\'envoi personnalisé';

  @override
  String get customSendSettings => 'Paramètres d\'envoi personnalisés';

  @override
  String get dark => 'Sombre';

  @override
  String get databasePassword => 'Mot de passe de la base de données';

  @override
  String get databaseRestored => 'Base de données restaurée';

  @override
  String get date => 'Date';

  @override
  String get datetime => 'Date/Heure';

  @override
  String get deductFee => 'Déduire les frais du montant';

  @override
  String get defaultMemo => 'Mémo par défaut';

  @override
  String get delete => 'SUPPRIMER';

  @override
  String deleteAccount(Object name) {
    return 'Supprimer le compte $name';
  }

  @override
  String get deletePayment => 'Êtes-vous sûr de vouloir supprimer ce destinataire';

  @override
  String get derpath => 'Chemin de dérivation';

  @override
  String get destination => 'Destination';

  @override
  String get disclaimer => 'Clause de non-responsabilité';

  @override
  String get disclaimerText => 'SELF-CUSTODY';

  @override
  String get disclaimer_1 => 'Je comprends que je suis responsable de la sécurisation de ma phrase de graine';

  @override
  String get disclaimer_2 => 'Je comprends que YWallet ne puisse pas récupérer ma phrase de graine';

  @override
  String get disclaimer_3 => 'Je comprends que qui connaît ma phrase de graine peut obtenir mes fonds';

  @override
  String get diversified => 'Diversifié';

  @override
  String get editContact => 'Modifier le contact';

  @override
  String get encryptDatabase => 'Chiffrer la base de données';

  @override
  String get encryptionKey => 'Clé de chiffrement';

  @override
  String get error => 'ERREUR';

  @override
  String get change => 'Change';

  @override
  String get fee => 'Frais';

  @override
  String get fromPool => 'Depuis le type de fonds';

  @override
  String get fromto => 'De/Vers';

  @override
  String get fullBackup => 'Sauvegarde complète';

  @override
  String get fullRestore => 'Restauration complète';

  @override
  String get gapLimit => 'Limite d\'écart';

  @override
  String get general => 'Général';

  @override
  String get height => 'Hauteur';

  @override
  String get help => 'Aide';

  @override
  String get hidden => 'Masqué';

  @override
  String get high => 'Élevé';

  @override
  String get history => 'Historique';

  @override
  String get import => 'Importation';

  @override
  String get includeReplyTo => 'Inclure mon adresse dans le Mémo';

  @override
  String get incomingFunds => 'Fonds entrants';

  @override
  String get index => 'Indice';

  @override
  String get interval => 'Intervalle';

  @override
  String get invalidAddress => 'Adresse invalide';

  @override
  String get invalidKey => 'Clé invalide';

  @override
  String get invalidPassword => 'Mot de passe invalide';

  @override
  String get invalidPaymentURI => 'Paiement URI invalide';

  @override
  String get key => 'Graine, clé secrète ou clé de vue (optionnel)';

  @override
  String get keyTool => 'Outil clé';

  @override
  String get keygen => 'Générateur de clés de sauvegarde';

  @override
  String get keygenHelp => 'Les sauvegardes utilisent le système de chiffrage AGE. La clé de chiffrage est utilisée pour faire la sauvegarde, mais ne peut PAS le déchiffrer. La clé secrète est nécessaire pour recharger la sauvegarde.\n\nVous devez garder les DEUX clés';

  @override
  String get largestSpendingsByAddress => 'Les plus grandes dépenses par adresse';

  @override
  String get ledger => 'Ledger';

  @override
  String get light => 'Clair';

  @override
  String get list => 'Liste';

  @override
  String get loading => 'Chargement en cours...';

  @override
  String get low => 'Bas';

  @override
  String get mainReceivers => 'Receveurs inclus dans l\'adresse principale';

  @override
  String get market => 'Marché';

  @override
  String get marketPrice => 'Prix de Marché';

  @override
  String get max => 'Maximum';

  @override
  String get maxAmountPerNote => 'Montant maximum par note';

  @override
  String get medium => 'Moyenne';

  @override
  String get memo => 'Mémo';

  @override
  String get memoTooLong => 'Mémo trop long';

  @override
  String get message => 'Message';

  @override
  String get messages => 'Messages';

  @override
  String get minPrivacy => 'Confidentialité minimale';

  @override
  String get mode => 'Mode Avancé';

  @override
  String get more => 'Plus';

  @override
  String get multiPay => 'Multi Paiement';

  @override
  String get na => 'N/D';

  @override
  String get name => 'Nom';

  @override
  String get nan => 'Pas un nombre';

  @override
  String get netOrchard => 'Changement net de Orchard';

  @override
  String get netSapling => 'Changement net de Sapling';

  @override
  String get newAccount => 'Nouveau compte';

  @override
  String get newPassword => 'Nouveau mot de passe';

  @override
  String get newPasswordsDoNotMatch => 'Les nouveaux mots de passe ne correspondent pas';

  @override
  String get next => 'Suivant';

  @override
  String get noAuthenticationMethod => 'Aucune méthode d\'authentification';

  @override
  String get noDbPassword => 'La base de données doit être chiffrée pour protéger l\'ouverture/dépense';

  @override
  String get noRemindBackup => 'Ne pas me le rappeler';

  @override
  String get notEnoughBalance => 'Solde insuffisant';

  @override
  String get notes => 'Billets';

  @override
  String get now => 'Maintenant';

  @override
  String get off => 'Désactivé';

  @override
  String get ok => 'Ok';

  @override
  String get openInExplorer => 'Ouvrir dans l\'explorateur';

  @override
  String get or => 'ou';

  @override
  String get orchard => 'Orchard';

  @override
  String get orchardInput => 'Source Orchard';

  @override
  String get paymentMade => 'Paiement effectué';

  @override
  String get paymentURI => 'URI de paiement';

  @override
  String get ping => 'Test du ping';

  @override
  String get pleaseAuthenticate => 'Veuillez vous authentifier';

  @override
  String get pleaseQuitAndRestartTheAppNow => 'Veuillez quitter et redémarrer l\'application pour que ces modifications prennent effet';

  @override
  String get pool => 'Type de fonds';

  @override
  String get poolTransfer => 'Transfert de type de fonds';

  @override
  String get pools => 'Types de fonds';

  @override
  String get prev => 'Précédent';

  @override
  String get priv => 'Confidentialité';

  @override
  String privacy(Object level) {
    return 'CONFIDENTIALITÉ : $level';
  }

  @override
  String get privacyLevelTooLow => 'Confidentialité insuffisante - Appui longuement pour continuer';

  @override
  String get privateKey => 'Clé privée';

  @override
  String get protectOpen => 'Protéger l\'ouverture';

  @override
  String get protectSend => 'Protéger l\'envoi';

  @override
  String get publicKey => 'Clé publique';

  @override
  String get qr => 'Code QR';

  @override
  String get rawTransaction => 'Transaction brute';

  @override
  String receive(Object ticker) {
    return 'Recevoir $ticker';
  }

  @override
  String received(Object amount, Object ticker) {
    return 'Reçu $amount $ticker';
  }

  @override
  String get receivers => 'Récepteurs';

  @override
  String get recipient => 'Destinataire';

  @override
  String get repeatNewPassword => 'Répéter le nouveau mot de passe';

  @override
  String get reply => 'Répondre';

  @override
  String get replyUA => 'Receveurs UA inclus dans l\'adresse de l\'envoyeur';

  @override
  String get required => 'Valeur requise';

  @override
  String get rescan => 'Rescanner';

  @override
  String get rescanFrom => 'Rescanner depuis...';

  @override
  String get rescanWarning => 'RESCANNER réinitialise tous vos comptes. Vous pouvez envisager d\'utiliser REMBOBINER à la place';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get restart => 'Redémarrer';

  @override
  String get restore => 'Restaurer';

  @override
  String get restoreAnAccount => 'Restaurer un compte ?';

  @override
  String get retrieveTransactionDetails => 'Récupérer les détails de la transaction';

  @override
  String get rewind => 'Rembobiner';

  @override
  String get sapling => 'Sapling';

  @override
  String get saplingInput => 'Source Sapling';

  @override
  String get save => 'Enregistrer';

  @override
  String get scanQrCode => 'Scanner le QR code';

  @override
  String get scanRawTx => 'Scannez les codes QR de la Tx non signée';

  @override
  String get scanSignedTx => 'Scannez les codes QR de la Tx signée';

  @override
  String get secretKey => 'Clé secrète';

  @override
  String get secured => 'Sécurisé';

  @override
  String get seed => 'Graine';

  @override
  String get seedKeys => 'Graine et clés';

  @override
  String get seedOrKeyRequired => 'Graine ou clé privée requise';

  @override
  String get selectNotesToExcludeFromPayments => 'Sélectionnez les notes à EXCLUDE dans les paiements';

  @override
  String get send => 'Envoyer';

  @override
  String sendCointicker(Object ticker) {
    return 'Envoyer $ticker';
  }

  @override
  String sendFrom(Object app) {
    return 'Envoyé depuis $app';
  }

  @override
  String get sender => 'Expéditeur';

  @override
  String get sending => 'Envoi de la transaction';

  @override
  String get sent => 'Transaction envoyée';

  @override
  String get sent_failed => 'La transaction a échoué';

  @override
  String get server => 'Serveur';

  @override
  String get set => 'Régler';

  @override
  String get settings => 'Réglages';

  @override
  String get shielded => 'Bouclier';

  @override
  String get showSubKeys => 'Afficher les sous-clés';

  @override
  String get sign => 'Signer la transaction';

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
    return 'Dépensé $amount $ticker';
  }

  @override
  String get subject => 'Sujet';

  @override
  String get sweep => 'Balayage';

  @override
  String get sync => 'Synchronisation';

  @override
  String get syncPaused => 'PAUSE - Appuyez pour reprendre';

  @override
  String get table => 'Tableau';

  @override
  String get template => 'Gabarit';

  @override
  String textCopiedToClipboard(Object text) {
    return '$text copié dans le presse-papiers';
  }

  @override
  String get thePrivateWalletMessenger => 'Le portefeuille privé et la messagerie';

  @override
  String get theme => 'Thème';

  @override
  String get thisAccountAlreadyExists => 'Un autre compte a la même adresse';

  @override
  String get timestamp => 'Horodatage';

  @override
  String get toPool => 'Vers le type de fonds';

  @override
  String get tools => 'Outils';

  @override
  String get totalBalance => 'Solde total';

  @override
  String get transactionDetails => 'Détails de la transaction';

  @override
  String get transactionHistory => 'Historique des transactions';

  @override
  String get transactions => 'Transactions';

  @override
  String get transfer => 'Transférer';

  @override
  String get transparent => 'Transparence';

  @override
  String get transparentInput => 'Entrée transparente';

  @override
  String get transparentKey => 'Clé transparente';

  @override
  String get txID => 'TX ID';

  @override
  String txId(Object txid) {
    return 'TX ID: $txid';
  }

  @override
  String get txPlan => 'Plan de transaction';

  @override
  String get mainAddress => 'Adresse Principale';

  @override
  String get unifiedViewingKey => 'Clé de vue unifiée';

  @override
  String get unsignedTx => 'Tx non signée';

  @override
  String get update => 'Recalculer';

  @override
  String get useZats => 'Utiliser Zats (8 décimales)';

  @override
  String get version => 'Version';

  @override
  String get veryLow => 'Très faible';

  @override
  String get viewingKey => 'Clé de visualisation';

  @override
  String get views => 'Vues';

  @override
  String get welcomeToYwallet => 'Bienvenue sur YWallet';

  @override
  String get wifi => 'Wi-Fi';

  @override
  String get dontShowAnymore => 'Ne plus afficher';

  @override
  String get swapDisclaimer => 'Les swaps sont offerts par des services tiers. Utilisez à votre propre risque et faites votre propre recherche.';

  @override
  String get swap => 'Swap';

  @override
  String get swapProviders => 'Fournisseurs de Swaps';

  @override
  String get stealthEx => 'StealthEX';

  @override
  String get getQuote => 'Cotation';

  @override
  String get invalidSwapCurrencies => 'Swap doit inclure ZEC';

  @override
  String get checkSwapAddress => 'Vérifier que l\'adresse est correcte!';

  @override
  String get swapSend => 'Envoyer';

  @override
  String get swapReceive => 'Recevoir';

  @override
  String get swapFromTip => 'Aide : Envoyez des fonds vers l\'adresse du haut pour recevoir des fonds a l\'adresse du bas.';

  @override
  String get swapToTip => 'Aide : Appuyez sur le bouton pour envoyer des fonds a l\'adresse du haut';

  @override
  String get confirm => 'Veuillez confirmer';

  @override
  String get confirmClearSwapHistory => 'Êtes-vous sûr de vouloir effacer l\'historique des swaps ?';

  @override
  String get retry => 'Refaire';

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
