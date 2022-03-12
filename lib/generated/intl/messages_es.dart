// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es locale. All the
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
  String get localeName => 'es';

  static String m0(currency) => "Cantidad en ${currency}";

  static String m1(ticker) =>
      "Estás seguro de que quieres guardar tus contactos? Costará 0,01 mZEC ";

  static String m2(name) =>
      "Copia De Seguridad - ${name} - Requerido Para Restaurar";

  static String m3(address, amount) =>
      "Do you want to sign a transaction to ${address} for ${amount}";

  static String m4(ticker) =>
      "¿Quiere transferir su saldo transparente a su dirección blindada? ";

  static String m5(app) => "${app} Encrypted Backup";

  static String m7(ticker) => "Recibir ${ticker}";

  static String m8(ticker) => "Enviar ${ticker}";

  static String m9(ticker) => "Enviar ${ticker} a…";

  static String m10(app) => "Enviado desde ${app}";

  static String m11(amount, ticker, count) =>
      "Enviando un total de ${amount} ${ticker} a ${count} direcciones";

  static String m12(aZEC, ticker, address) =>
      "Enviado ${aZEC} ${ticker} a ${address}";

  static String m13(name) => "Sub Account of ${name}";

  static String m14(text) => "${text} copied to clipboard";

  static String m15(currency) => "Utilizar ${currency}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "M1": MessageLookupByLibrary.simpleMessage("1 M"),
        "M3": MessageLookupByLibrary.simpleMessage("3 M"),
        "M6": MessageLookupByLibrary.simpleMessage("6 M"),
        "Y1": MessageLookupByLibrary.simpleMessage("1 A"),
        "about": MessageLookupByLibrary.simpleMessage("Acerca"),
        "accentColor": MessageLookupByLibrary.simpleMessage("Acento Color"),
        "account": MessageLookupByLibrary.simpleMessage("Cuenta"),
        "accountBalanceHistory":
            MessageLookupByLibrary.simpleMessage("Historial De Cuenta"),
        "accountHasSomeBalanceAreYouSureYouWantTo":
            MessageLookupByLibrary.simpleMessage(
                "La cuenta tiene un saldo. ¿Estás seguro de que quieres eliminarlo?"),
        "accountIndex": MessageLookupByLibrary.simpleMessage("Account Index"),
        "accountName": MessageLookupByLibrary.simpleMessage("Nombre de Cuenta"),
        "accountNameIsRequired": MessageLookupByLibrary.simpleMessage(
            "Se requiere el nombre de cuenta"),
        "accounts": MessageLookupByLibrary.simpleMessage("Cuentas"),
        "add": MessageLookupByLibrary.simpleMessage("AGREGAR"),
        "addARecipientAndItWillShowHere": MessageLookupByLibrary.simpleMessage(
            "Agregar un destinatario y se mostrará aquí"),
        "addContact": MessageLookupByLibrary.simpleMessage("Agregar Contacto"),
        "addnew": MessageLookupByLibrary.simpleMessage("AGGREGAR"),
        "address": MessageLookupByLibrary.simpleMessage("Dirección"),
        "addressCopiedToClipboard": MessageLookupByLibrary.simpleMessage(
            "Dirección copiada al portapapeles"),
        "addressIsEmpty":
            MessageLookupByLibrary.simpleMessage("Dirección está vacía"),
        "advanced": MessageLookupByLibrary.simpleMessage("Avanzado"),
        "advancedOptions":
            MessageLookupByLibrary.simpleMessage("Opciones Avanzadas"),
        "amount": MessageLookupByLibrary.simpleMessage("Monto"),
        "amountInSettingscurrency": m0,
        "amountMustBeANumber":
            MessageLookupByLibrary.simpleMessage("Cantidad debe ser un número"),
        "amountMustBePositive": MessageLookupByLibrary.simpleMessage(
            "Cantidad debe ser un positivo"),
        "amountTooHigh":
            MessageLookupByLibrary.simpleMessage("Cantidad demasiado alta"),
        "applicationReset":
            MessageLookupByLibrary.simpleMessage("Application Reset"),
        "approve": MessageLookupByLibrary.simpleMessage("APROBAR"),
        "areYouSureYouWantToDeleteThisContact":
            MessageLookupByLibrary.simpleMessage(
                "Estás seguro de que deseas eliminar este contacto?"),
        "areYouSureYouWantToSaveYourContactsIt": m1,
        "autoHideBalance": MessageLookupByLibrary.simpleMessage(
            "Ocultar Saldo Automáticamente"),
        "backup": MessageLookupByLibrary.simpleMessage("Copia De Seguridad"),
        "backupAllAccounts":
            MessageLookupByLibrary.simpleMessage("Backup All Accounts"),
        "backupDataRequiredForRestore": m2,
        "backupEncryptionKey":
            MessageLookupByLibrary.simpleMessage("Backup Encryption Key"),
        "backupWarning": MessageLookupByLibrary.simpleMessage(
            "Nadie puede recuperar sus claves secretas. Si no tiene una copia de seguridad, PERDERÁ SU DINERO si su teléfono se avería. Puede acceder a esta página mediante el menú de la aplicación y luego \'Copia de Seguridad\'"),
        "balance": MessageLookupByLibrary.simpleMessage("Saldo"),
        "blue": MessageLookupByLibrary.simpleMessage("Azul"),
        "broadcast": MessageLookupByLibrary.simpleMessage("Transmisión"),
        "budget": MessageLookupByLibrary.simpleMessage("Presupuesto"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancelar"),
        "changeAccountName":
            MessageLookupByLibrary.simpleMessage("Cambiar nombre de la cuenta"),
        "changingTheModeWillTakeEffectAtNextRestart":
            MessageLookupByLibrary.simpleMessage(
                "Cambiar el modo tendrá efecto en el próximo reinicio"),
        "closeApplication":
            MessageLookupByLibrary.simpleMessage("Close Application"),
        "coffee": MessageLookupByLibrary.simpleMessage("Café"),
        "coldStorage": MessageLookupByLibrary.simpleMessage("Billetera Fría"),
        "color": MessageLookupByLibrary.simpleMessage("Color"),
        "confirmDeleteAccount": MessageLookupByLibrary.simpleMessage(
            "¿Está SEGURO de que desea BORRAR esta cuenta? DEBE tener una COPIA DE SEGURIDAD para recuperarla. Esta operación NO es reversible."),
        "confirmResetApp": MessageLookupByLibrary.simpleMessage(
            "¿Seguro que quieres restablecer la aplicación? Sus cuentas NO serán eliminadas"),
        "confirmSignATransactionToAddressFor": m3,
        "confirmSigning":
            MessageLookupByLibrary.simpleMessage("Confirm Signing"),
        "confs": MessageLookupByLibrary.simpleMessage("Confs"),
        "contactName":
            MessageLookupByLibrary.simpleMessage("Nombre de contacto"),
        "contacts": MessageLookupByLibrary.simpleMessage("Contactos"),
        "copy": MessageLookupByLibrary.simpleMessage("Copy"),
        "createANewAccount": MessageLookupByLibrary.simpleMessage(
            "Crea una cuenta y aparecerá aquí."),
        "createANewContactAndItWillShowUpHere":
            MessageLookupByLibrary.simpleMessage(
                "Crea un contacto y aparecerá aquí."),
        "currency": MessageLookupByLibrary.simpleMessage("Moneda"),
        "custom": MessageLookupByLibrary.simpleMessage("Custom"),
        "dark": MessageLookupByLibrary.simpleMessage("Noche"),
        "date": MessageLookupByLibrary.simpleMessage("Fecha"),
        "datetime": MessageLookupByLibrary.simpleMessage("Fecha/Hora"),
        "defaultMemo": MessageLookupByLibrary.simpleMessage("Nota"),
        "delete": MessageLookupByLibrary.simpleMessage("ELIMINAR"),
        "deleteAccount": MessageLookupByLibrary.simpleMessage("Borrar Cuenta"),
        "deleteContact":
            MessageLookupByLibrary.simpleMessage("Borrar contacto"),
        "doYouWantToDeleteTheSecretKeyAndConvert":
            MessageLookupByLibrary.simpleMessage(
                "¿Quiere BORRAR la clave secreta y convertir esta cuenta a solo lectura? Ya no podrá gastar desde este dispositivo. Esta operación NO es reversible."),
        "doYouWantToTransferYourEntireTransparentBalanceTo": m4,
        "duplicateAccount":
            MessageLookupByLibrary.simpleMessage("Cuenta duplicada"),
        "encryptedBackup": m5,
        "enterSecretShareIfAccountIsMultisignature":
            MessageLookupByLibrary.simpleMessage(
                "Enter secret share if account is multi-signature"),
        "enterSeed": MessageLookupByLibrary.simpleMessage(
            "Ingrese Semilla, Clave Secreta o Clave Lectura. Dejar en blanco para una nueva cuenta "),
        "excludedNotes":
            MessageLookupByLibrary.simpleMessage("Notas Excluidas"),
        "fileSaved": MessageLookupByLibrary.simpleMessage("File saved"),
        "fullBackup": MessageLookupByLibrary.simpleMessage("Full Backup"),
        "fullRestore": MessageLookupByLibrary.simpleMessage("Full Restore"),
        "gold": MessageLookupByLibrary.simpleMessage("Oro"),
        "height": MessageLookupByLibrary.simpleMessage("Altura"),
        "help": MessageLookupByLibrary.simpleMessage("Ayuda"),
        "history": MessageLookupByLibrary.simpleMessage("Historia"),
        "includeFeeInAmount": MessageLookupByLibrary.simpleMessage(
            "Incluir tarifa en la cantidad"),
        "invalidAddress":
            MessageLookupByLibrary.simpleMessage("Dirección no es válida"),
        "key": MessageLookupByLibrary.simpleMessage("Llave"),
        "largestSpendingLastMonth":
            MessageLookupByLibrary.simpleMessage("Pago Más Grande Mes Pasado"),
        "largestSpendingsByAddress": MessageLookupByLibrary.simpleMessage(
            "Pagos más grandes por dirección"),
        "light": MessageLookupByLibrary.simpleMessage("Día"),
        "loadBackup": MessageLookupByLibrary.simpleMessage("Load Backup"),
        "loading": MessageLookupByLibrary.simpleMessage("Cargando..."),
        "max": MessageLookupByLibrary.simpleMessage("MAX"),
        "maxAmountPerNote":
            MessageLookupByLibrary.simpleMessage("Monto máximo por nota"),
        "memo": MessageLookupByLibrary.simpleMessage("Nota"),
        "mm": MessageLookupByLibrary.simpleMessage("M/M"),
        "mode": MessageLookupByLibrary.simpleMessage("Modo"),
        "multiPay": MessageLookupByLibrary.simpleMessage("Multi Pagos"),
        "multipay": MessageLookupByLibrary.simpleMessage("MultiPagos"),
        "multipleAddresses":
            MessageLookupByLibrary.simpleMessage("multiple addresses"),
        "multisig": MessageLookupByLibrary.simpleMessage("Multisig"),
        "multisigShares":
            MessageLookupByLibrary.simpleMessage("Multisig Shares"),
        "na": MessageLookupByLibrary.simpleMessage("N/A"),
        "nameIsEmpty": MessageLookupByLibrary.simpleMessage("Nombre vacio"),
        "newSnapAddress":
            MessageLookupByLibrary.simpleMessage("Nueva Dirección Instantánea"),
        "newSubAccount":
            MessageLookupByLibrary.simpleMessage("New Sub Account"),
        "noAccount": MessageLookupByLibrary.simpleMessage("Sin Cuenta"),
        "noActiveAccount":
            MessageLookupByLibrary.simpleMessage("No active account"),
        "noAuthenticationMethod":
            MessageLookupByLibrary.simpleMessage("Sin método de autenticación"),
        "noContacts": MessageLookupByLibrary.simpleMessage("Sin Contactos"),
        "noRecipient": MessageLookupByLibrary.simpleMessage("Sin Destinatario"),
        "noSpendingInTheLast30Days":
            MessageLookupByLibrary.simpleMessage("Sin Pagos En 30 Días"),
        "notEnoughBalance":
            MessageLookupByLibrary.simpleMessage("Saldo Insuficiente"),
        "notes": MessageLookupByLibrary.simpleMessage("Notas"),
        "numberOfConfirmationsNeededBeforeSpending":
            MessageLookupByLibrary.simpleMessage(
                "Número de confirmaciones necesarias antes de gastar"),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "openInExplorer":
            MessageLookupByLibrary.simpleMessage("Abre con Explorador"),
        "pink": MessageLookupByLibrary.simpleMessage("Rosado"),
        "pl": MessageLookupByLibrary.simpleMessage("G/P"),
        "pleaseAuthenticateToSend": MessageLookupByLibrary.simpleMessage(
            "Por favor autentíquese para enviar"),
        "pleaseAuthenticateToShowAccountSeed":
            MessageLookupByLibrary.simpleMessage(
                "Autentíquese para ver la semilla de la cuenta"),
        "pleaseConfirm":
            MessageLookupByLibrary.simpleMessage("Por favor, confirmar"),
        "pleaseRestartNow":
            MessageLookupByLibrary.simpleMessage("Please Restart now"),
        "pnl": MessageLookupByLibrary.simpleMessage("G&P"),
        "pnlHistory": MessageLookupByLibrary.simpleMessage("Historia de G&P"),
        "preparingTransaction":
            MessageLookupByLibrary.simpleMessage("Preparando la transacción…"),
        "price": MessageLookupByLibrary.simpleMessage("Precio"),
        "primary": MessageLookupByLibrary.simpleMessage("Primario"),
        "protectSend": MessageLookupByLibrary.simpleMessage("Proteger enviar"),
        "protectSendSettingChanged": MessageLookupByLibrary.simpleMessage(
            "La configuración de envío protegido ha cambiado"),
        "purple": MessageLookupByLibrary.simpleMessage("Morada"),
        "qty": MessageLookupByLibrary.simpleMessage("Cantidad"),
        "realized": MessageLookupByLibrary.simpleMessage("Dio Cuenta"),
        "receive": m7,
        "receivePayment":
            MessageLookupByLibrary.simpleMessage("Recibir un pago"),
        "rescan": MessageLookupByLibrary.simpleMessage("Escanear"),
        "rescanNeeded":
            MessageLookupByLibrary.simpleMessage("Necesita Escanear"),
        "rescanRequested":
            MessageLookupByLibrary.simpleMessage("Escaneo solicitado…"),
        "rescanWalletFromTheFirstBlock": MessageLookupByLibrary.simpleMessage(
            "¿Escanear billetera desde el primer bloque?"),
        "reset": MessageLookupByLibrary.simpleMessage("RESET"),
        "restart": MessageLookupByLibrary.simpleMessage("Reiniciar"),
        "retrieveTransactionDetails": MessageLookupByLibrary.simpleMessage(
            "Obtener detalles de la transacción"),
        "roundToMillis":
            MessageLookupByLibrary.simpleMessage("Redonda a millis"),
        "saveBackup": MessageLookupByLibrary.simpleMessage("Save Backup"),
        "saveToBlockchain":
            MessageLookupByLibrary.simpleMessage("Guardar en blockchain?"),
        "scanStartingMomentarily": MessageLookupByLibrary.simpleMessage(
            "Escaneo comenzando momentáneamente "),
        "secondary": MessageLookupByLibrary.simpleMessage("Secundario"),
        "secretKey": MessageLookupByLibrary.simpleMessage("Llave Secreta"),
        "secretShare": MessageLookupByLibrary.simpleMessage("Secret Share"),
        "seed": MessageLookupByLibrary.simpleMessage("Semilla"),
        "selectAccount":
            MessageLookupByLibrary.simpleMessage("Seleccionar cuenta"),
        "selectNotesToExcludeFromPayments":
            MessageLookupByLibrary.simpleMessage(
                "Seleccionar Notas a EXCLUIR de los pagos"),
        "send": MessageLookupByLibrary.simpleMessage("Enviar"),
        "sendCointicker": m8,
        "sendCointickerTo": m9,
        "sendFrom": m10,
        "sendingATotalOfAmountCointickerToCountRecipients": m11,
        "sendingAzecCointickerToAddress": m12,
        "server": MessageLookupByLibrary.simpleMessage("Servidor"),
        "settings": MessageLookupByLibrary.simpleMessage("Ajustes"),
        "shieldTranspBalance":
            MessageLookupByLibrary.simpleMessage("Blindar Saldo Transp."),
        "shieldTransparentBalance":
            MessageLookupByLibrary.simpleMessage("Blindar Saldo Transparente"),
        "shieldingInProgress":
            MessageLookupByLibrary.simpleMessage("Blindaje en progreso…"),
        "sign": MessageLookupByLibrary.simpleMessage("Sign"),
        "simple": MessageLookupByLibrary.simpleMessage("Sencillo"),
        "simpleMode": MessageLookupByLibrary.simpleMessage("Simple Mode"),
        "spendable": MessageLookupByLibrary.simpleMessage("Gastable"),
        "spendableBalance":
            MessageLookupByLibrary.simpleMessage("Saldo Gastable"),
        "splitAccount": MessageLookupByLibrary.simpleMessage("Split Account"),
        "subAccountOf": m13,
        "synching": MessageLookupByLibrary.simpleMessage("Sincronizando"),
        "table": MessageLookupByLibrary.simpleMessage("Lista"),
        "tapAnIconToShowTheQrCode": MessageLookupByLibrary.simpleMessage(
            "Pinchar icono para mostrar código QR"),
        "tapChartToToggleBetweenAddressAndAmount":
            MessageLookupByLibrary.simpleMessage(
                "Toque gráfico para alternar entre dirección y cantidad"),
        "tapQrCodeForShieldedAddress": MessageLookupByLibrary.simpleMessage(
            "Pinchar QR para Dirección Blindada"),
        "tapQrCodeForTransparentAddress": MessageLookupByLibrary.simpleMessage(
            "Pinchar QR para Dirección Transparente"),
        "tapTransactionForDetails": MessageLookupByLibrary.simpleMessage(
            "Toque Transacción para detalles"),
        "textCopiedToClipboard": m14,
        "theme": MessageLookupByLibrary.simpleMessage("Tema"),
        "themeEditor": MessageLookupByLibrary.simpleMessage("Editora de temas"),
        "thisAccountAlreadyExists":
            MessageLookupByLibrary.simpleMessage("Esta cuenta ya existe."),
        "tiltYourDeviceUpToRevealYourBalance":
            MessageLookupByLibrary.simpleMessage(
                "Incline su dispositivo hacia arriba para revelar su saldo"),
        "timestamp": MessageLookupByLibrary.simpleMessage("Fecha/Hora"),
        "toMakeAContactSendThemAMemoWithContact":
            MessageLookupByLibrary.simpleMessage(
                "Para hacer un contacto, enviarles una nota con ‘Contact:’"),
        "total": MessageLookupByLibrary.simpleMessage("Total"),
        "totalBalance": MessageLookupByLibrary.simpleMessage("Saldo Total"),
        "tradingChartRange":
            MessageLookupByLibrary.simpleMessage("Rango de Gráfico"),
        "tradingPl": MessageLookupByLibrary.simpleMessage("Intercambio G&P"),
        "transactionDetails":
            MessageLookupByLibrary.simpleMessage("Detalles de transacción"),
        "transactionHistory":
            MessageLookupByLibrary.simpleMessage("Historia de transacciones"),
        "txId": MessageLookupByLibrary.simpleMessage("TX ID:"),
        "underConfirmed":
            MessageLookupByLibrary.simpleMessage("Confirmaciones Insuficiente"),
        "unshielded": MessageLookupByLibrary.simpleMessage("Sin blindaje"),
        "unshieldedBalance":
            MessageLookupByLibrary.simpleMessage("Saldo sin blindaje"),
        "unsignedTransactionFile": MessageLookupByLibrary.simpleMessage(
            "Archivo de transaccion sin firmar"),
        "useSettingscurrency": m15,
        "useTransparentBalance":
            MessageLookupByLibrary.simpleMessage("Usar Saldo Transp"),
        "useUa": MessageLookupByLibrary.simpleMessage("Usar UA"),
        "version": MessageLookupByLibrary.simpleMessage("Versión"),
        "viewingKey": MessageLookupByLibrary.simpleMessage("Llave Lectura")
      };
}
