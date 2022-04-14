// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
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
  String get localeName => 'fr';

  static String m0(currency) => "Montant en ${currency}";

  static String m1(ticker) =>
      "Voulez vous sauver vos contacts? Ceci coute 0.01 m${ticker}";

  static String m2(name) =>
      "Données de sauvegarde - ${name} - requises pour la restauration";

  static String m3(address, amount) =>
      "Do you want to sign a transaction to ${address} for ${amount}";

  static String m4(ticker) =>
      "Voulez-vous transférer l\'intégralité de votre solde transparent à votre adresse protégée?";

  static String m5(app) => "Sauvegarde de ${app} ";

  static String m7(ticker) => "Recevoir ${ticker}";

  static String m8(height) => "Parcours demandé à partir de ${height}...";

  static String m9(ticker) => "Envoyer ${ticker}";

  static String m10(ticker) => "Envoyer ${ticker} à...";

  static String m11(app) => "Envoyé via ${app}";

  static String m12(amount, ticker, count) =>
      "Envoi d\'un total de ${amount} ${ticker} à ${count} destinataires";

  static String m13(aZEC, ticker, address) =>
      "Envoi de ${aZEC} ${ticker} à ${address}";

  static String m14(name) => "Sous Compte de ${name}";

  static String m15(text) => "${text} copied to clipboard";

  static String m16(currency) => "Utiliser ${currency}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "M1": MessageLookupByLibrary.simpleMessage("1 M"),
        "M3": MessageLookupByLibrary.simpleMessage("3 M"),
        "M6": MessageLookupByLibrary.simpleMessage("6 M"),
        "Y1": MessageLookupByLibrary.simpleMessage("1 A"),
        "about": MessageLookupByLibrary.simpleMessage("A propos"),
        "accentColor":
            MessageLookupByLibrary.simpleMessage("Couleur d\'accent"),
        "account": MessageLookupByLibrary.simpleMessage("Compte"),
        "accountBalanceHistory": MessageLookupByLibrary.simpleMessage(
            "Historique du solde du compte"),
        "accountHasSomeBalanceAreYouSureYouWantTo":
            MessageLookupByLibrary.simpleMessage(
                "Ce compte a un solde. Voulez vous l\'effacer?"),
        "accountIndex": MessageLookupByLibrary.simpleMessage("Index du Compte"),
        "accountName": MessageLookupByLibrary.simpleMessage("Nom du compte"),
        "accountNameIsRequired":
            MessageLookupByLibrary.simpleMessage("Le nom du compte est requis"),
        "accounts": MessageLookupByLibrary.simpleMessage("Comptes"),
        "add": MessageLookupByLibrary.simpleMessage("AJOUTER"),
        "addARecipientAndItWillShowHere": MessageLookupByLibrary.simpleMessage(
            "Ajoutez un receveur et il sera ici"),
        "addContact":
            MessageLookupByLibrary.simpleMessage("Ajouter un contact"),
        "addnew": MessageLookupByLibrary.simpleMessage("AJOUTER"),
        "address": MessageLookupByLibrary.simpleMessage("adresse"),
        "addressCopiedToClipboard": MessageLookupByLibrary.simpleMessage(
            "Adresse copiée dans le presse-papier"),
        "addressIsEmpty":
            MessageLookupByLibrary.simpleMessage("L\'adresse est vide"),
        "advanced": MessageLookupByLibrary.simpleMessage("Avancé"),
        "advancedOptions":
            MessageLookupByLibrary.simpleMessage("Options avancées"),
        "amount": MessageLookupByLibrary.simpleMessage("Montant"),
        "amountInSettingscurrency": m0,
        "amountMustBeANumber": MessageLookupByLibrary.simpleMessage(
            "Le montant doit être un nombre"),
        "amountMustBePositive": MessageLookupByLibrary.simpleMessage(
            "Le montant doit être positif"),
        "amountTooHigh":
            MessageLookupByLibrary.simpleMessage("Montant trop haut"),
        "applicationReset":
            MessageLookupByLibrary.simpleMessage("Réinitialisation"),
        "approve": MessageLookupByLibrary.simpleMessage("APPROUVER"),
        "areYouSureYouWantToDeleteThisContact":
            MessageLookupByLibrary.simpleMessage(
                "Voulez vous effacer ce contact?"),
        "areYouSureYouWantToSaveYourContactsIt": m1,
        "autoHideBalance": MessageLookupByLibrary.simpleMessage(
            "Cacher le solde automatiquement"),
        "backup": MessageLookupByLibrary.simpleMessage("Sauvegarde"),
        "backupAllAccounts":
            MessageLookupByLibrary.simpleMessage("Sauver tous les comptes"),
        "backupDataRequiredForRestore": m2,
        "backupEncryptionKey":
            MessageLookupByLibrary.simpleMessage("Clé de chiffrage"),
        "backupWarning": MessageLookupByLibrary.simpleMessage(
            "Vos clés ne sont pas récupérables. Si vous n\'avez pas de sauvegarde, vous pouvez PERDREZ VOTRE ARGENT. Cette page est accessible par Menu ... / Sauvegarde"),
        "balance": MessageLookupByLibrary.simpleMessage("Solde"),
        "barcodeScannerIsNotAvailableOnDesktop":
            MessageLookupByLibrary.simpleMessage(
                "Le Barcode scanner est seulement disponible sur mobile"),
        "blue": MessageLookupByLibrary.simpleMessage("Bleu"),
        "broadcast": MessageLookupByLibrary.simpleMessage("Diffusion"),
        "budget": MessageLookupByLibrary.simpleMessage("Budget"),
        "cancel": MessageLookupByLibrary.simpleMessage("Annuler"),
        "changeAccountName":
            MessageLookupByLibrary.simpleMessage("Modifier le nom du compte"),
        "changingTheModeWillTakeEffectAtNextRestart":
            MessageLookupByLibrary.simpleMessage(
                "Changer le mode prendra effet au prochain démarrage"),
        "closeApplication":
            MessageLookupByLibrary.simpleMessage("Close Application"),
        "coffee": MessageLookupByLibrary.simpleMessage("Café"),
        "coldStorage": MessageLookupByLibrary.simpleMessage("Stockage à froid"),
        "color": MessageLookupByLibrary.simpleMessage("Couleur"),
        "confirmDeleteAccount": MessageLookupByLibrary.simpleMessage(
            "Êtes-vous SUR de vouloir SUPPRIMER ce compte ? Vous DEVEZ avoir une SAUVEGARDE pour le récupérer. Cette opération n\'est PAS réversible."),
        "confirmResetApp": MessageLookupByLibrary.simpleMessage(
            "Etes vous sur de vouloir réinitialiser. Vos comptes ne seront PAS perdus "),
        "confirmSignATransactionToAddressFor": m3,
        "confirmSigning":
            MessageLookupByLibrary.simpleMessage("Confirm Signing"),
        "confs": MessageLookupByLibrary.simpleMessage("Confs"),
        "contactName": MessageLookupByLibrary.simpleMessage("Nom du Contact"),
        "contacts": MessageLookupByLibrary.simpleMessage("Mes Contacts"),
        "convertToWatchonly":
            MessageLookupByLibrary.simpleMessage("Convertir en Non-Depensable"),
        "copy": MessageLookupByLibrary.simpleMessage("Copy"),
        "createANewAccount": MessageLookupByLibrary.simpleMessage(
            "Créez un nouveau compte et il apparaîtra ici"),
        "createANewContactAndItWillShowUpHere":
            MessageLookupByLibrary.simpleMessage(
                "Créez un nouveau contact et il apparaîtra ici"),
        "currency": MessageLookupByLibrary.simpleMessage("Devise"),
        "custom": MessageLookupByLibrary.simpleMessage("Personnaliser"),
        "dark": MessageLookupByLibrary.simpleMessage("Sombre"),
        "date": MessageLookupByLibrary.simpleMessage("Date"),
        "datetime": MessageLookupByLibrary.simpleMessage("Jour/Heure"),
        "defaultMemo": MessageLookupByLibrary.simpleMessage("Memo"),
        "delete": MessageLookupByLibrary.simpleMessage("SUPPRIMER"),
        "deleteAccount":
            MessageLookupByLibrary.simpleMessage("Effacer un compte"),
        "deleteContact":
            MessageLookupByLibrary.simpleMessage("Effacer un contact"),
        "disconnected": MessageLookupByLibrary.simpleMessage("Déconnecté"),
        "doYouWantToDeleteTheSecretKeyAndConvert":
            MessageLookupByLibrary.simpleMessage(
                "Voulez-vous SUPPRIMER la clé secrète et convertir ce compte en un compte d\'observation ? Vous ne pourrez plus dépenser depuis cet appareil. Cette opération n\'est PAS réversible."),
        "doYouWantToTransferYourEntireTransparentBalanceTo": m4,
        "duplicateAccount":
            MessageLookupByLibrary.simpleMessage("Compte en double"),
        "encryptedBackup": m5,
        "enterSecretShareIfAccountIsMultisignature":
            MessageLookupByLibrary.simpleMessage(
                "Enter secret share if account is multi-signature"),
        "enterSeed": MessageLookupByLibrary.simpleMessage(
            "Entrez la graine, la clé secrète ou la clé de visualisation. Laissez vide pour un nouveau compte"),
        "excludedNotes": MessageLookupByLibrary.simpleMessage("Billets exclus"),
        "fileSaved": MessageLookupByLibrary.simpleMessage("File saved"),
        "fullBackup":
            MessageLookupByLibrary.simpleMessage("Sauvegarde complète"),
        "fullRestore":
            MessageLookupByLibrary.simpleMessage("Restauration complète"),
        "gold": MessageLookupByLibrary.simpleMessage("Or"),
        "height": MessageLookupByLibrary.simpleMessage("Hauteur"),
        "help": MessageLookupByLibrary.simpleMessage("Aide"),
        "history": MessageLookupByLibrary.simpleMessage("Historique"),
        "iHaveMadeABackup":
            MessageLookupByLibrary.simpleMessage("J\'ai fait une sauvegarde"),
        "includeFeeInAmount": MessageLookupByLibrary.simpleMessage(
            "Inclure les frais dans le montant"),
        "invalidAddress":
            MessageLookupByLibrary.simpleMessage("Adresse invalide"),
        "key": MessageLookupByLibrary.simpleMessage("Clé"),
        "largestSpendingLastMonth": MessageLookupByLibrary.simpleMessage(
            "Dépenses les plus importantes le mois dernier"),
        "largestSpendingsByAddress": MessageLookupByLibrary.simpleMessage(
            "Dépenses les plus importantes par adresse"),
        "ledger": MessageLookupByLibrary.simpleMessage("Ledger"),
        "light": MessageLookupByLibrary.simpleMessage("Clair"),
        "loadBackup":
            MessageLookupByLibrary.simpleMessage("Recharger une sauvegarde"),
        "loading": MessageLookupByLibrary.simpleMessage("Chargement..."),
        "max": MessageLookupByLibrary.simpleMessage("MAX"),
        "maxAmountPerNote":
            MessageLookupByLibrary.simpleMessage("Montant maximum par note"),
        "memo": MessageLookupByLibrary.simpleMessage("Mémo"),
        "mm": MessageLookupByLibrary.simpleMessage("Virtuel"),
        "mobileCharges": MessageLookupByLibrary.simpleMessage(
            "Sans Wi-fi, les frais peuvent être élevés. Voulez vous continuer?"),
        "mode": MessageLookupByLibrary.simpleMessage("Mode"),
        "multiPay": MessageLookupByLibrary.simpleMessage("Envoyer à plusieurs"),
        "multipay": MessageLookupByLibrary.simpleMessage("Envoyer à plusieurs"),
        "multipleAddresses":
            MessageLookupByLibrary.simpleMessage("multiple addresses"),
        "multisig": MessageLookupByLibrary.simpleMessage("Multisig"),
        "multisigShares":
            MessageLookupByLibrary.simpleMessage("Multisig Shares"),
        "na": MessageLookupByLibrary.simpleMessage("N/D"),
        "nameIsEmpty": MessageLookupByLibrary.simpleMessage("Le nom est vide"),
        "newSnapAddress": MessageLookupByLibrary.simpleMessage(
            "Nouvelle adresse instantanée"),
        "newSubAccount":
            MessageLookupByLibrary.simpleMessage("Nouveau Sous Compte"),
        "noAccount": MessageLookupByLibrary.simpleMessage("Pas de compte"),
        "noActiveAccount":
            MessageLookupByLibrary.simpleMessage("Aucun Compte sélectionné"),
        "noAuthenticationMethod": MessageLookupByLibrary.simpleMessage(
            "Pas de méthode d\'authentification"),
        "noContacts": MessageLookupByLibrary.simpleMessage("Pas de Contacts"),
        "noRecipient": MessageLookupByLibrary.simpleMessage("Pas de receveur"),
        "noSpendingInTheLast30Days": MessageLookupByLibrary.simpleMessage(
            "Aucune dépense au cours des 30 derniers jours"),
        "notEnoughBalance":
            MessageLookupByLibrary.simpleMessage("Solde insuffisant"),
        "notes": MessageLookupByLibrary.simpleMessage("Billets"),
        "numberOfConfirmationsNeededBeforeSpending":
            MessageLookupByLibrary.simpleMessage(
                "Nombre de confirmations nécessaires avant de dépenser"),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "openInExplorer":
            MessageLookupByLibrary.simpleMessage("Ouvrir dans l\'explorateur"),
        "pink": MessageLookupByLibrary.simpleMessage("Rose"),
        "pl": MessageLookupByLibrary.simpleMessage("Profit/Perte"),
        "pleaseAuthenticateToSend": MessageLookupByLibrary.simpleMessage(
            "Veillez vous authentifier avant l\'envoi"),
        "pleaseAuthenticateToShowAccountSeed":
            MessageLookupByLibrary.simpleMessage(
                "Veuillez vous authentifier pour voir la graine du compte"),
        "pleaseConfirm":
            MessageLookupByLibrary.simpleMessage("Veuillez confirmer"),
        "pleaseRestartNow":
            MessageLookupByLibrary.simpleMessage("Please Restart now"),
        "pnl": MessageLookupByLibrary.simpleMessage("P/P"),
        "pnlHistory":
            MessageLookupByLibrary.simpleMessage("Historique des P/P"),
        "preparingTransaction": MessageLookupByLibrary.simpleMessage(
            "Préparation de la transaction..."),
        "price": MessageLookupByLibrary.simpleMessage("Prix"),
        "primary": MessageLookupByLibrary.simpleMessage("Primaire"),
        "protectSend": MessageLookupByLibrary.simpleMessage("PIN avant envoi"),
        "protectSendSettingChanged": MessageLookupByLibrary.simpleMessage(
            "Changement de PIN avant envoi"),
        "purple": MessageLookupByLibrary.simpleMessage("Violet"),
        "qty": MessageLookupByLibrary.simpleMessage("Quantité"),
        "rawTransaction":
            MessageLookupByLibrary.simpleMessage("Transaction Signée"),
        "realized": MessageLookupByLibrary.simpleMessage("Réalisé"),
        "receive": m7,
        "receivePayment":
            MessageLookupByLibrary.simpleMessage("Recevoir un payment"),
        "rescan": MessageLookupByLibrary.simpleMessage("Parcourir à nouveau"),
        "rescanFrom":
            MessageLookupByLibrary.simpleMessage("Reparcourir à partir de...?"),
        "rescanNeeded": MessageLookupByLibrary.simpleMessage("Scan nécessaire"),
        "rescanRequested": m8,
        "reset": MessageLookupByLibrary.simpleMessage("RESET"),
        "restart": MessageLookupByLibrary.simpleMessage("Redémarrage"),
        "retrieveTransactionDetails": MessageLookupByLibrary.simpleMessage(
            "Récupérer les détails de la transaction"),
        "roundToMillis":
            MessageLookupByLibrary.simpleMessage("Arrondir au millième"),
        "saveBackup":
            MessageLookupByLibrary.simpleMessage("Sauvegarder les comptes"),
        "saveToBlockchain": MessageLookupByLibrary.simpleMessage(
            "Sauver les contacts dans la blockchaine"),
        "scanStartingMomentarily": MessageLookupByLibrary.simpleMessage(
            "Le scan démarre momentanément"),
        "secondary": MessageLookupByLibrary.simpleMessage("Secondaire"),
        "secretKey": MessageLookupByLibrary.simpleMessage("Clé secrète"),
        "secretShare": MessageLookupByLibrary.simpleMessage("Secret Share"),
        "seed": MessageLookupByLibrary.simpleMessage("Graine"),
        "selectAccount":
            MessageLookupByLibrary.simpleMessage("Choisissez un compte"),
        "selectNotesToExcludeFromPayments":
            MessageLookupByLibrary.simpleMessage(
                "Sélectionnez les billets à EXCLURE des paiements"),
        "send": MessageLookupByLibrary.simpleMessage("Envoyer"),
        "sendCointicker": m9,
        "sendCointickerTo": m10,
        "sendFrom": m11,
        "sendingATotalOfAmountCointickerToCountRecipients": m12,
        "sendingAzecCointickerToAddress": m13,
        "server": MessageLookupByLibrary.simpleMessage("Serveur"),
        "settings": MessageLookupByLibrary.simpleMessage("Paramètres"),
        "shieldTranspBalance": MessageLookupByLibrary.simpleMessage(
            "Masquer le Solde Transparent"),
        "shieldTransparentBalance": MessageLookupByLibrary.simpleMessage(
            "Masquer le solde transparent"),
        "shieldingInProgress":
            MessageLookupByLibrary.simpleMessage("Masquage en cours..."),
        "sign": MessageLookupByLibrary.simpleMessage("Sign"),
        "signOffline": MessageLookupByLibrary.simpleMessage("Signer"),
        "simple": MessageLookupByLibrary.simpleMessage("Simple"),
        "simpleMode": MessageLookupByLibrary.simpleMessage("Mode Simple"),
        "spendable": MessageLookupByLibrary.simpleMessage("Dépensable"),
        "spendableBalance":
            MessageLookupByLibrary.simpleMessage("Montant dépensable"),
        "splitAccount": MessageLookupByLibrary.simpleMessage("Split Account"),
        "subAccountOf": m14,
        "synching":
            MessageLookupByLibrary.simpleMessage("Synchronisation en cours"),
        "table": MessageLookupByLibrary.simpleMessage("Tableau"),
        "tapAnIconToShowTheQrCode": MessageLookupByLibrary.simpleMessage(
            "Appuyez sur une icône pour afficher le code QR"),
        "tapChartToToggleBetweenAddressAndAmount":
            MessageLookupByLibrary.simpleMessage(
                "Appuyez sur le graphique pour basculer entre l\'adresse et le montant"),
        "tapQrCodeForShieldedAddress": MessageLookupByLibrary.simpleMessage(
            "Appuyez sur le code QR pour l\'adresse protégée"),
        "tapQrCodeForTransparentAddress": MessageLookupByLibrary.simpleMessage(
            "Appuyez sur le code QR pour l\'adresse transparente"),
        "tapTransactionForDetails": MessageLookupByLibrary.simpleMessage(
            "Presser sur une Transaction pour plus de details"),
        "textCopiedToClipboard": m15,
        "theme": MessageLookupByLibrary.simpleMessage("Thème"),
        "themeEditor": MessageLookupByLibrary.simpleMessage("Editeur de Thème"),
        "thisAccountAlreadyExists":
            MessageLookupByLibrary.simpleMessage("Ce Compte existe déjà"),
        "tiltYourDeviceUpToRevealYourBalance":
            MessageLookupByLibrary.simpleMessage(
                "Redressez votre mobile pour révéler votre solde"),
        "timestamp": MessageLookupByLibrary.simpleMessage("Date/Heure"),
        "toMakeAContactSendThemAMemoWithContact":
            MessageLookupByLibrary.simpleMessage(
                "Pour établir un contact, envoyez-lui un mémo avec Contact:"),
        "total": MessageLookupByLibrary.simpleMessage("Total"),
        "totalBalance": MessageLookupByLibrary.simpleMessage("Solde Total"),
        "tradingChartRange": MessageLookupByLibrary.simpleMessage(
            "Domaine de temps des graphiques"),
        "tradingPl": MessageLookupByLibrary.simpleMessage("Profit et Pertes"),
        "transactionDetails":
            MessageLookupByLibrary.simpleMessage("Détails de la transaction"),
        "transactionHistory":
            MessageLookupByLibrary.simpleMessage("Historique des Transactions"),
        "txId": MessageLookupByLibrary.simpleMessage("ID de tx"),
        "underConfirmed":
            MessageLookupByLibrary.simpleMessage("Pas assez de confs"),
        "unshielded": MessageLookupByLibrary.simpleMessage("Transparent"),
        "unshieldedBalance":
            MessageLookupByLibrary.simpleMessage("Solde Transparent"),
        "unsignedTransactionFile": MessageLookupByLibrary.simpleMessage(
            "Fichier de transaction non signée"),
        "useSettingscurrency": m16,
        "useTransparentBalance": MessageLookupByLibrary.simpleMessage(
            "Utiliser le Solde Transparent"),
        "useUa": MessageLookupByLibrary.simpleMessage("Utiliser UA"),
        "version": MessageLookupByLibrary.simpleMessage("Version"),
        "viewingKey":
            MessageLookupByLibrary.simpleMessage("Affichage de la clé")
      };
}
