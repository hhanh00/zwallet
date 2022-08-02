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

  static String m5(app) => "${app} Copia completa";

  static String m6(msg) => "FALTA: ${msg}";

  static String m8(ticker) => "Recibir ${ticker}";

  static String m9(height) => "Escaneo solicitado desde ${height}…";

  static String m10(ticker) => "Enviar ${ticker}";

  static String m11(ticker) => "Enviar ${ticker} a…";

  static String m12(app) => "Enviado desde ${app}";

  static String m13(amount, ticker, count) =>
      "Enviando un total de ${amount} ${ticker} a ${count} direcciones";

  static String m14(aZEC, ticker, address) =>
      "Enviado ${aZEC} ${ticker} a ${address}";

  static String m15(index, name) => "Subcuenta ${index} de ${name}";

  static String m16(name) => "Subcuenta de ${name}";

  static String m17(text) => "${text} copiado al portapapeles";

  static String m18(txid) => "TX ID: ${txid}";

  static String m19(currency) => "Utilizar ${currency}";

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
        "accountIndex":
            MessageLookupByLibrary.simpleMessage("Índice de cuenta"),
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
        "antispamFilter":
            MessageLookupByLibrary.simpleMessage("Anti-Spam Filter"),
        "applicationReset":
            MessageLookupByLibrary.simpleMessage("Application Reset"),
        "approve": MessageLookupByLibrary.simpleMessage("APROBAR"),
        "areYouSureYouWantToDeleteThisContact":
            MessageLookupByLibrary.simpleMessage(
                "Estás seguro de que deseas eliminar este contacto?"),
        "areYouSureYouWantToSaveYourContactsIt": m1,
        "auto": MessageLookupByLibrary.simpleMessage("Auto"),
        "autoHideBalance": MessageLookupByLibrary.simpleMessage(
            "Ocultar Saldo Automáticamente"),
        "backup": MessageLookupByLibrary.simpleMessage("Copia De Seguridad"),
        "backupAllAccounts":
            MessageLookupByLibrary.simpleMessage("Copia de seguridad completa"),
        "backupDataRequiredForRestore": m2,
        "backupEncryptionKey":
            MessageLookupByLibrary.simpleMessage("Clave de cifrado"),
        "backupWarning": MessageLookupByLibrary.simpleMessage(
            "Nadie puede recuperar sus claves secretas. Si no tiene una copia de seguridad, PERDERÁ SU DINERO si su teléfono se avería. Puede acceder a esta página mediante el menú de la aplicación y luego \'Copia de Seguridad\'"),
        "balance": MessageLookupByLibrary.simpleMessage("Saldo"),
        "barcode": MessageLookupByLibrary.simpleMessage("Código de Barras"),
        "barcodeScannerIsNotAvailableOnDesktop":
            MessageLookupByLibrary.simpleMessage(
                "El escáner de código de barras no está disponible en el escritorio"),
        "blue": MessageLookupByLibrary.simpleMessage("Azul"),
        "body": MessageLookupByLibrary.simpleMessage("Body"),
        "broadcast": MessageLookupByLibrary.simpleMessage("Transmisión"),
        "broadcastFromYourOnlineDevice": MessageLookupByLibrary.simpleMessage(
            "Transmite desde tu dispositivo en línea"),
        "budget": MessageLookupByLibrary.simpleMessage("Presupuesto"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancelar"),
        "cancelScan": MessageLookupByLibrary.simpleMessage("Cancelar Escaneo"),
        "changeAccountName":
            MessageLookupByLibrary.simpleMessage("Cambiar nombre de la cuenta"),
        "changeTransparentKey":
            MessageLookupByLibrary.simpleMessage("Change Transparent Key"),
        "changingTheModeWillTakeEffectAtNextRestart":
            MessageLookupByLibrary.simpleMessage(
                "Cambiar el modo tendrá efecto en el próximo reinicio"),
        "checkTransaction":
            MessageLookupByLibrary.simpleMessage("Controlar la Transacción"),
        "close": MessageLookupByLibrary.simpleMessage("Cambiar la Clave"),
        "closeApplication":
            MessageLookupByLibrary.simpleMessage("Cierra la aplicación"),
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
        "convertToWatchonly":
            MessageLookupByLibrary.simpleMessage("Convertir en solo vista"),
        "copy": MessageLookupByLibrary.simpleMessage("Copy"),
        "count": MessageLookupByLibrary.simpleMessage("Cuenta"),
        "createANewAccount": MessageLookupByLibrary.simpleMessage(
            "Crea una cuenta y aparecerá aquí."),
        "createANewContactAndItWillShowUpHere":
            MessageLookupByLibrary.simpleMessage(
                "Crea un contacto y aparecerá aquí."),
        "crypto": MessageLookupByLibrary.simpleMessage("Crypto"),
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
        "derivationPath":
            MessageLookupByLibrary.simpleMessage("Ruta de Derivación"),
        "disconnected": MessageLookupByLibrary.simpleMessage("Desconectado"),
        "doYouWantToDeleteTheSecretKeyAndConvert":
            MessageLookupByLibrary.simpleMessage(
                "¿Quiere BORRAR la clave secreta y convertir esta cuenta a solo lectura? Ya no podrá gastar desde este dispositivo. Esta operación NO es reversible."),
        "doYouWantToTransferYourEntireTransparentBalanceTo": m4,
        "duplicateAccount":
            MessageLookupByLibrary.simpleMessage("Cuenta duplicada"),
        "editContact": MessageLookupByLibrary.simpleMessage("Editar Contacto"),
        "encryptedBackup": m5,
        "enterSecretShareIfAccountIsMultisignature":
            MessageLookupByLibrary.simpleMessage(
                "Enter secret share if account is multi-signature"),
        "enterSeed": MessageLookupByLibrary.simpleMessage(
            "Ingrese Semilla, Clave Secreta o Clave Lectura. Dejar en blanco para una nueva cuenta "),
        "error": m6,
        "excludedNotes":
            MessageLookupByLibrary.simpleMessage("Notas Excluidas"),
        "fileSaved": MessageLookupByLibrary.simpleMessage("File saved"),
        "fromto": MessageLookupByLibrary.simpleMessage("Rem/Dest."),
        "fullBackup": MessageLookupByLibrary.simpleMessage("Copia completa"),
        "fullRestore": MessageLookupByLibrary.simpleMessage(
            "Restauración copia de seguridad completa"),
        "gapLimit": MessageLookupByLibrary.simpleMessage("Brecha"),
        "gold": MessageLookupByLibrary.simpleMessage("Oro"),
        "height": MessageLookupByLibrary.simpleMessage("Altura"),
        "help": MessageLookupByLibrary.simpleMessage("Ayuda"),
        "history": MessageLookupByLibrary.simpleMessage("Historia"),
        "iHaveMadeABackup": MessageLookupByLibrary.simpleMessage(
            "He hecho una copia de seguridad"),
        "includeFeeInAmount": MessageLookupByLibrary.simpleMessage(
            "Incluir tarifa en la cantidad"),
        "includeReplyTo":
            MessageLookupByLibrary.simpleMessage("Include My Address in Memo"),
        "inputBarcodeValue":
            MessageLookupByLibrary.simpleMessage("Escriba el Código de Barras"),
        "invalidAddress":
            MessageLookupByLibrary.simpleMessage("Dirección no es válida"),
        "invalidKey": MessageLookupByLibrary.simpleMessage("Tecla inválida"),
        "key": MessageLookupByLibrary.simpleMessage("Llave"),
        "keyTool": MessageLookupByLibrary.simpleMessage("Clave Utilidad"),
        "largestSpendingLastMonth":
            MessageLookupByLibrary.simpleMessage("Pago Más Grande Mes Pasado"),
        "largestSpendingsByAddress": MessageLookupByLibrary.simpleMessage(
            "Pagos más grandes por dirección"),
        "ledger": MessageLookupByLibrary.simpleMessage("Ledger"),
        "light": MessageLookupByLibrary.simpleMessage("Día"),
        "loadBackup":
            MessageLookupByLibrary.simpleMessage("Respaldo copia de seguridad"),
        "loading": MessageLookupByLibrary.simpleMessage("Cargando..."),
        "markAllAsRead":
            MessageLookupByLibrary.simpleMessage("Marcar Todo como Leido"),
        "max": MessageLookupByLibrary.simpleMessage("MAX"),
        "maxAmountPerNote":
            MessageLookupByLibrary.simpleMessage("Monto máximo por nota"),
        "memo": MessageLookupByLibrary.simpleMessage("Nota"),
        "message": MessageLookupByLibrary.simpleMessage("Mensaje"),
        "messages": MessageLookupByLibrary.simpleMessage("Messages"),
        "mm": MessageLookupByLibrary.simpleMessage("M/M"),
        "mobileCharges": MessageLookupByLibrary.simpleMessage(
            "En datos móviles, el escaneo puede incurrir en cargos adicionales. Quieres proceder?"),
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
        "newAccount": MessageLookupByLibrary.simpleMessage("Nueva Cuenta"),
        "newSnapAddress":
            MessageLookupByLibrary.simpleMessage("Nueva Dirección Instantánea"),
        "newSubAccount":
            MessageLookupByLibrary.simpleMessage("Nueva subcuenta"),
        "noAccount": MessageLookupByLibrary.simpleMessage("Sin Cuenta"),
        "noActiveAccount":
            MessageLookupByLibrary.simpleMessage("Sin cuenta activa"),
        "noAuthenticationMethod":
            MessageLookupByLibrary.simpleMessage("Sin método de autenticación"),
        "noContacts": MessageLookupByLibrary.simpleMessage("Sin Contactos"),
        "noRecipient": MessageLookupByLibrary.simpleMessage("Sin Destinatario"),
        "noSpendingInTheLast30Days":
            MessageLookupByLibrary.simpleMessage("Sin Pagos En 30 Días"),
        "notEnoughBalance":
            MessageLookupByLibrary.simpleMessage("Saldo Insuficiente"),
        "notes": MessageLookupByLibrary.simpleMessage("Notas"),
        "now": MessageLookupByLibrary.simpleMessage("Ahora"),
        "numberOfConfirmationsNeededBeforeSpending":
            MessageLookupByLibrary.simpleMessage(
                "Número de confirmaciones necesarias antes de gastar"),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "openInExplorer":
            MessageLookupByLibrary.simpleMessage("Abre con Explorador"),
        "paymentInProgress":
            MessageLookupByLibrary.simpleMessage("Pago en curso..."),
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
            MessageLookupByLibrary.simpleMessage("Reinicie ahora"),
        "pnl": MessageLookupByLibrary.simpleMessage("G&P"),
        "pnlHistory": MessageLookupByLibrary.simpleMessage("Historia de G&P"),
        "preparingTransaction":
            MessageLookupByLibrary.simpleMessage("Preparando la transacción…"),
        "price": MessageLookupByLibrary.simpleMessage("Precio"),
        "primary": MessageLookupByLibrary.simpleMessage("Primario"),
        "privateKey": MessageLookupByLibrary.simpleMessage("Clave Privada"),
        "protectOpen":
            MessageLookupByLibrary.simpleMessage("Proteger presentar"),
        "protectSend": MessageLookupByLibrary.simpleMessage("Proteger enviar"),
        "protectSendSettingChanged": MessageLookupByLibrary.simpleMessage(
            "La configuración de envío protegido ha cambiado"),
        "purple": MessageLookupByLibrary.simpleMessage("Morada"),
        "qty": MessageLookupByLibrary.simpleMessage("Cantidad"),
        "rawTransaction":
            MessageLookupByLibrary.simpleMessage("Transacción con firmar"),
        "realized": MessageLookupByLibrary.simpleMessage("Dio Cuenta"),
        "receive": m8,
        "receivePayment":
            MessageLookupByLibrary.simpleMessage("Recibir un pago"),
        "recipient": MessageLookupByLibrary.simpleMessage("Destinatario"),
        "reply": MessageLookupByLibrary.simpleMessage("Respuesta"),
        "rescan": MessageLookupByLibrary.simpleMessage("Escanear"),
        "rescanFrom": MessageLookupByLibrary.simpleMessage("¿Escanear desde?"),
        "rescanNeeded":
            MessageLookupByLibrary.simpleMessage("Necesita Escanear"),
        "rescanRequested": m9,
        "rescanning": MessageLookupByLibrary.simpleMessage("Escanear..."),
        "reset": MessageLookupByLibrary.simpleMessage("RESET"),
        "restart": MessageLookupByLibrary.simpleMessage("Reiniciar"),
        "restoreAnAccount":
            MessageLookupByLibrary.simpleMessage("Restaurar una Cuenta?"),
        "resumeScan": MessageLookupByLibrary.simpleMessage("Reanudar Escaneo"),
        "retrieveTransactionDetails": MessageLookupByLibrary.simpleMessage(
            "Obtener detalles de la transacción"),
        "roundToMillis":
            MessageLookupByLibrary.simpleMessage("Redonda a millis"),
        "saveBackup":
            MessageLookupByLibrary.simpleMessage("Guardar copia de seguridad"),
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
        "sendCointicker": m10,
        "sendCointickerTo": m11,
        "sendFrom": m12,
        "sender": MessageLookupByLibrary.simpleMessage("Remitente"),
        "sendingATotalOfAmountCointickerToCountRecipients": m13,
        "sendingAzecCointickerToAddress": m14,
        "server": MessageLookupByLibrary.simpleMessage("Servidor"),
        "settings": MessageLookupByLibrary.simpleMessage("Ajustes"),
        "shieldTranspBalance":
            MessageLookupByLibrary.simpleMessage("Blindar Saldo Transp."),
        "shieldTransparentBalance":
            MessageLookupByLibrary.simpleMessage("Blindar Saldo Transparente"),
        "shieldingInProgress":
            MessageLookupByLibrary.simpleMessage("Blindaje en progreso…"),
        "showMessagesAsTable":
            MessageLookupByLibrary.simpleMessage("Mostrar mensajes como Tabla"),
        "sign": MessageLookupByLibrary.simpleMessage("Sign"),
        "signOffline": MessageLookupByLibrary.simpleMessage("Firmar"),
        "signOnYourOfflineDevice": MessageLookupByLibrary.simpleMessage(
            "Firme con tu dispositivo fuera de línea"),
        "signedTx": MessageLookupByLibrary.simpleMessage("Firmado Tx"),
        "simple": MessageLookupByLibrary.simpleMessage("Sencillo"),
        "simpleMode": MessageLookupByLibrary.simpleMessage("Modo simple"),
        "spendable": MessageLookupByLibrary.simpleMessage("Gastable"),
        "spendableBalance":
            MessageLookupByLibrary.simpleMessage("Saldo Gastable"),
        "splitAccount": MessageLookupByLibrary.simpleMessage("Split Account"),
        "subAccountIndexOf": m15,
        "subAccountOf": m16,
        "subject": MessageLookupByLibrary.simpleMessage("Subject"),
        "syncPaused": MessageLookupByLibrary.simpleMessage("Escaneo en pausa"),
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
        "textCopiedToClipboard": m17,
        "thePrivateWalletMessenger": MessageLookupByLibrary.simpleMessage(
            "La Cartera & Mensajero Privado"),
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
        "txId": m18,
        "underConfirmed":
            MessageLookupByLibrary.simpleMessage("Confirmaciones Insuficiente"),
        "unshielded": MessageLookupByLibrary.simpleMessage("Sin blindaje"),
        "unshieldedBalance":
            MessageLookupByLibrary.simpleMessage("Saldo sin blindaje"),
        "unsignedTransactionFile": MessageLookupByLibrary.simpleMessage(
            "Archivo de transaccion sin firmar"),
        "unsignedTx": MessageLookupByLibrary.simpleMessage("No firmado Tx"),
        "update": MessageLookupByLibrary.simpleMessage("Recalcular"),
        "useQrForOfflineSigning": MessageLookupByLibrary.simpleMessage(
            "Use QR para firmar sin conexión"),
        "useSettingscurrency": m19,
        "useTransparentBalance":
            MessageLookupByLibrary.simpleMessage("Usar Saldo Transp"),
        "useUa": MessageLookupByLibrary.simpleMessage("Usar UA"),
        "version": MessageLookupByLibrary.simpleMessage("Versión"),
        "viewingKey": MessageLookupByLibrary.simpleMessage("Llave Lectura"),
        "welcomeToYwallet":
            MessageLookupByLibrary.simpleMessage("Bienvenido a YWallet")
      };
}
