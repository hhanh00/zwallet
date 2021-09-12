// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
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
  String get localeName => 'fr';

  static String m0(currency) => "Montant en ${currency}";

  static String m1(ticker) =>
      "Are you sure you want to save your contacts? It will cost 0.01 mZEC";

  static String m2(ticker) =>
      "Voulez-vous transférer l\'intégralité de votre solde transparent à votre adresse protégée?";

  static String m3(ticker) => "Envoyer ${ticker}";

  static String m4(ticker) => "Envoyer ${ticker} à...";

  static String m5(amount, ticker, count) =>
      "Envoi d\'un total de ${amount} ${ticker} à ${count} destinataires";

  static String m6(aZEC, ticker, address) =>
      "Envoi de ${aZEC} ${ticker} à ${address}";

  static String m7(currency) => "Utiliser ${currency}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "M1": MessageLookupByLibrary.simpleMessage("1 M"),
        "M3": MessageLookupByLibrary.simpleMessage("3 M"),
        "M6": MessageLookupByLibrary.simpleMessage("6 M"),
        "Y1": MessageLookupByLibrary.simpleMessage("1 A"),
        "about": MessageLookupByLibrary.simpleMessage("A propos"),
        "account": MessageLookupByLibrary.simpleMessage("Compte"),
        "accountBalanceHistory": MessageLookupByLibrary.simpleMessage(
            "Historique du solde du compte"),
        "accountName": MessageLookupByLibrary.simpleMessage("Nom du compte"),
        "accountNameIsRequired":
            MessageLookupByLibrary.simpleMessage("Le nom du compte est requis"),
        "accounts": MessageLookupByLibrary.simpleMessage("Comptes"),
        "add": MessageLookupByLibrary.simpleMessage("AJOUTER"),
        "address": MessageLookupByLibrary.simpleMessage("adresse"),
        "addressCopiedToClipboard": MessageLookupByLibrary.simpleMessage(
            "Adresse copiée dans le presse-papier"),
        "addressIsEmpty":
            MessageLookupByLibrary.simpleMessage("L\'adresse est vide"),
        "advancedOptions":
            MessageLookupByLibrary.simpleMessage("Options avancées"),
        "amount": MessageLookupByLibrary.simpleMessage("Montant"),
        "amountInSettingscurrency": m0,
        "amountMustBeANumber": MessageLookupByLibrary.simpleMessage(
            "Le montant doit être un nombre"),
        "amountMustBePositive": MessageLookupByLibrary.simpleMessage(
            "Le montant doit être positif"),
        "approve": MessageLookupByLibrary.simpleMessage("APPROUVER"),
        "areYouSureYouWantToDeleteThisContact":
            MessageLookupByLibrary.simpleMessage(
                "Are you sure you want to delete this contact?"),
        "areYouSureYouWantToSaveYourContactsIt": m1,
        "backup": MessageLookupByLibrary.simpleMessage("Sauvegarde"),
        "backupDataRequiredForRestore": MessageLookupByLibrary.simpleMessage(
            "Données de sauvegarde - requises pour la restauration"),
        "backupWarning": MessageLookupByLibrary.simpleMessage(
            "No one can recover your secret keys. If you don\'t have a backup, you WILL LOSE YOUR MONEY if your phone breaks down. You can reach this page by the app menu then Backup"),
        "balance": MessageLookupByLibrary.simpleMessage("Solde"),
        "blue": MessageLookupByLibrary.simpleMessage("Bleu"),
        "broadcast": MessageLookupByLibrary.simpleMessage("Diffusion"),
        "budget": MessageLookupByLibrary.simpleMessage("Budget"),
        "cancel": MessageLookupByLibrary.simpleMessage("Annuler"),
        "changeAccountName":
            MessageLookupByLibrary.simpleMessage("Modifier le nom du compte"),
        "coffee": MessageLookupByLibrary.simpleMessage("Café"),
        "coldStorage": MessageLookupByLibrary.simpleMessage("Stockage à froid"),
        "confirmDeleteAccount": MessageLookupByLibrary.simpleMessage(
            "Êtes-vous SUR de vouloir SUPPRIMER ce compte ? Vous DEVEZ avoir une SAUVEGARDE pour le récupérer. Cette opération n\'est PAS réversible."),
        "confs": MessageLookupByLibrary.simpleMessage("Confs"),
        "contactName": MessageLookupByLibrary.simpleMessage("Contact Name"),
        "contacts": MessageLookupByLibrary.simpleMessage("Mes Contacts"),
        "createANewAccount": MessageLookupByLibrary.simpleMessage(
            "Create a new account and it will show up here"),
        "currency": MessageLookupByLibrary.simpleMessage("Devise"),
        "custom": MessageLookupByLibrary.simpleMessage("Personnaliser"),
        "dark": MessageLookupByLibrary.simpleMessage("Sombre"),
        "date": MessageLookupByLibrary.simpleMessage("Date"),
        "datetime": MessageLookupByLibrary.simpleMessage("Jour/Heure"),
        "delete": MessageLookupByLibrary.simpleMessage("SUPPRIMER"),
        "deleteContact": MessageLookupByLibrary.simpleMessage("Delete contact"),
        "doYouWantToDeleteTheSecretKeyAndConvert":
            MessageLookupByLibrary.simpleMessage(
                "Voulez-vous SUPPRIMER la clé secrète et convertir ce compte en un compte d\'observation ? Vous ne pourrez plus dépenser depuis cet appareil. Cette opération n\'est PAS réversible."),
        "doYouWantToTransferYourEntireTransparentBalanceTo": m2,
        "duplicateAccount":
            MessageLookupByLibrary.simpleMessage("Duplicate Account"),
        "enterSeed": MessageLookupByLibrary.simpleMessage(
            "Entrez la graine, la clé secrète ou la clé de visualisation. Laissez vide pour un nouveau compte"),
        "height": MessageLookupByLibrary.simpleMessage("Hauteur"),
        "history": MessageLookupByLibrary.simpleMessage("Historique"),
        "includeFeeInAmount": MessageLookupByLibrary.simpleMessage(
            "Inclure les frais dans le montant"),
        "invalidAddress":
            MessageLookupByLibrary.simpleMessage("Adresse invalide"),
        "key": MessageLookupByLibrary.simpleMessage("Clé"),
        "largestSpendingLastMonth": MessageLookupByLibrary.simpleMessage(
            "Dépenses les plus importantes le mois dernier"),
        "largestSpendingsByAddress": MessageLookupByLibrary.simpleMessage(
            "Dépenses les plus importantes par adresse"),
        "light": MessageLookupByLibrary.simpleMessage("Clair"),
        "max": MessageLookupByLibrary.simpleMessage("MAX"),
        "maxAmountPerNote":
            MessageLookupByLibrary.simpleMessage("Montant maximum par note"),
        "memo": MessageLookupByLibrary.simpleMessage("Mémo"),
        "mm": MessageLookupByLibrary.simpleMessage("Virtuel"),
        "multiPay": MessageLookupByLibrary.simpleMessage("Envoyer à plusieurs"),
        "multipay": MessageLookupByLibrary.simpleMessage("Envoyer à plusieurs"),
        "na": MessageLookupByLibrary.simpleMessage("N/A"),
        "nameIsEmpty": MessageLookupByLibrary.simpleMessage("Name is empty"),
        "newSnapAddress": MessageLookupByLibrary.simpleMessage(
            "Nouvelle adresse instantanée"),
        "noAccount": MessageLookupByLibrary.simpleMessage("Pas de compte"),
        "noAuthenticationMethod": MessageLookupByLibrary.simpleMessage(
            "Pas de méthode d\'authentification"),
        "noSpendingInTheLast30Days": MessageLookupByLibrary.simpleMessage(
            "Aucune dépense au cours des 30 derniers jours"),
        "notEnoughBalance":
            MessageLookupByLibrary.simpleMessage("Solde insuffisant"),
        "notes": MessageLookupByLibrary.simpleMessage("Bileets"),
        "numberOfConfirmationsNeededBeforeSpending":
            MessageLookupByLibrary.simpleMessage(
                "Nombre de confirmations nécessaires avant de dépenser"),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "openInExplorer":
            MessageLookupByLibrary.simpleMessage("Ouvrir dans l\'explorateur"),
        "pink": MessageLookupByLibrary.simpleMessage("Rose"),
        "pl": MessageLookupByLibrary.simpleMessage("Profit/Perte"),
        "pleaseAuthenticateToShowAccountSeed":
            MessageLookupByLibrary.simpleMessage(
                "Veuillez vous authentifier pour voir la graine du compte"),
        "pleaseConfirm":
            MessageLookupByLibrary.simpleMessage("Veuillez confirmer"),
        "pnl": MessageLookupByLibrary.simpleMessage("P/P"),
        "preparingTransaction": MessageLookupByLibrary.simpleMessage(
            "Préparation de la transaction..."),
        "price": MessageLookupByLibrary.simpleMessage("Prix"),
        "qty": MessageLookupByLibrary.simpleMessage("Quantité"),
        "realized": MessageLookupByLibrary.simpleMessage("Réalisé"),
        "rescan": MessageLookupByLibrary.simpleMessage("Parcourir à nouveau"),
        "rescanRequested":
            MessageLookupByLibrary.simpleMessage("Parcours demandé..."),
        "rescanWalletFromTheFirstBlock": MessageLookupByLibrary.simpleMessage(
            "Reparcourir la chaine à partir du premier bloc?"),
        "retrieveTransactionDetails": MessageLookupByLibrary.simpleMessage(
            "Récupérer les détails de la transaction"),
        "roundToMillis":
            MessageLookupByLibrary.simpleMessage("Arrondir au millième"),
        "saveToBlockchain":
            MessageLookupByLibrary.simpleMessage("Save to Blockchain"),
        "scanStartingMomentarily": MessageLookupByLibrary.simpleMessage(
            "Le scan démarre momentanément"),
        "secretKey": MessageLookupByLibrary.simpleMessage("Clé secrète"),
        "seed": MessageLookupByLibrary.simpleMessage("Graine"),
        "selectAccount": MessageLookupByLibrary.simpleMessage("Select Account"),
        "selectNotesToExcludeFromPayments":
            MessageLookupByLibrary.simpleMessage(
                "Sélectionnez les billets à EXCLURE des paiements"),
        "send": MessageLookupByLibrary.simpleMessage("Envoyer"),
        "sendCointicker": m3,
        "sendCointickerTo": m4,
        "sendingATotalOfAmountCointickerToCountRecipients": m5,
        "sendingAzecCointickerToAddress": m6,
        "server": MessageLookupByLibrary.simpleMessage("Serveur"),
        "settings": MessageLookupByLibrary.simpleMessage("Paramètres"),
        "shieldTranspBalance": MessageLookupByLibrary.simpleMessage(
            "Masquer le Solde Transparent"),
        "shieldTransparentBalance": MessageLookupByLibrary.simpleMessage(
            "Masquer le solde transparent"),
        "shieldingInProgress":
            MessageLookupByLibrary.simpleMessage("Masquage en cours..."),
        "spendable": MessageLookupByLibrary.simpleMessage("Dépensable:"),
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
        "theme": MessageLookupByLibrary.simpleMessage("Thème"),
        "thisAccountAlreadyExists": MessageLookupByLibrary.simpleMessage(
            "This account already exists."),
        "timestamp": MessageLookupByLibrary.simpleMessage("Date/Heure"),
        "toMakeAContactSendThemAMemoWithContact":
            MessageLookupByLibrary.simpleMessage(
                "Pour établir un contact, envoyez-lui un mémo avec Contact:"),
        "total": MessageLookupByLibrary.simpleMessage("Total"),
        "tradingChartRange": MessageLookupByLibrary.simpleMessage(
            "Domaine de temps des graphiques"),
        "tradingPl": MessageLookupByLibrary.simpleMessage("Profit et Pertes"),
        "transactionDetails":
            MessageLookupByLibrary.simpleMessage("Détails de la transaction"),
        "txId": MessageLookupByLibrary.simpleMessage("ID de tx :"),
        "unsignedTransactionFile": MessageLookupByLibrary.simpleMessage(
            "Fichier de transaction non signée"),
        "useSettingscurrency": m7,
        "useUa": MessageLookupByLibrary.simpleMessage("Use UA"),
        "version": MessageLookupByLibrary.simpleMessage("Version"),
        "viewingKey":
            MessageLookupByLibrary.simpleMessage("Affichage de la clé")
      };
}
