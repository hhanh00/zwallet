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
      "¿Estás seguro de que quieres guardar tus contactos? Costará 0,01 mZEC ";

  static String m2(name) =>
      "Copia de seguridad - ${name} - Requerida para restaurar";

  static String m3(rewindHeight) =>
      "Block reorg detected. Rewind to ${rewindHeight}";

  static String m4(address, amount) =>
      "Desea firmar una transacción a ${address} por ${amount}";

  static String m5(ticker) =>
      "¿Quiere transferir su saldo transparente a su dirección blindada? ";

  static String m6(app) => "${app} Copia completa";

  static String m7(msg) => "ERROR: ${msg}";

  static String m8(message) => "QR inválido: ${message}";

  static String m10(ticker) => "Recibir ${ticker}";

  static String m11(amount, ticker) => "Recibido ${amount} ${ticker}";

  static String m12(height) => "Escaneo solicitado desde ${height}…";

  static String m13(ticker) => "Enviar ${ticker}";

  static String m14(ticker) => "Enviar ${ticker} a…";

  static String m15(app) => "Enviado desde ${app}";

  static String m16(amount, ticker, count) =>
      "Enviando un total de ${amount} ${ticker} a ${count} direcciones";

  static String m17(aZEC, ticker, address) =>
      "Enviado ${aZEC} ${ticker} a ${address}";

  static String m18(amount, ticker) => "Enviado ${amount} ${ticker}";

  static String m19(index, name) => "Subcuenta ${index} de ${name}";

  static String m20(name) => "Subcuenta de ${name}";

  static String m21(text) => "${text} copiado al portapapeles";

  static String m22(txid) => "TX ID: ${txid}";

  static String m23(currency) => "Utilizar ${currency}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "M1": MessageLookupByLibrary.simpleMessage("1 M"),
        "M3": MessageLookupByLibrary.simpleMessage("3 M"),
        "M6": MessageLookupByLibrary.simpleMessage("6 M"),
        "Y1": MessageLookupByLibrary.simpleMessage("1 A"),
        "about": MessageLookupByLibrary.simpleMessage("Acerca"),
        "accentColor": MessageLookupByLibrary.simpleMessage("Color de acento"),
        "account": MessageLookupByLibrary.simpleMessage("Cuenta"),
        "accountBalanceHistory":
            MessageLookupByLibrary.simpleMessage("Historial de la cuenta"),
        "accountHasSomeBalanceAreYouSureYouWantTo":
            MessageLookupByLibrary.simpleMessage(
                "La cuenta tiene un saldo. ¿Estás seguro de que quieres eliminarlo?"),
        "accountIndex":
            MessageLookupByLibrary.simpleMessage("Índice de cuenta"),
        "accountName":
            MessageLookupByLibrary.simpleMessage("Nombre de la cuenta"),
        "accountNameIsRequired": MessageLookupByLibrary.simpleMessage(
            "Se requiere el nombre de la cuenta"),
        "accounts": MessageLookupByLibrary.simpleMessage("Cuentas"),
        "add": MessageLookupByLibrary.simpleMessage("AGREGAR"),
        "addARecipientAndItWillShowHere": MessageLookupByLibrary.simpleMessage(
            "Agregar un destinatario y se mostrará aquí"),
        "addContact": MessageLookupByLibrary.simpleMessage("Agregar Contacto"),
        "addnew": MessageLookupByLibrary.simpleMessage("AGREGAR"),
        "address": MessageLookupByLibrary.simpleMessage("Dirección"),
        "addressCopiedToClipboard": MessageLookupByLibrary.simpleMessage(
            "Dirección copiada al portapapeles"),
        "addressIsEmpty":
            MessageLookupByLibrary.simpleMessage("La Dirección está vacía"),
        "advanced": MessageLookupByLibrary.simpleMessage("Avanzado"),
        "advancedOptions":
            MessageLookupByLibrary.simpleMessage("Opciones Avanzadas"),
        "amount": MessageLookupByLibrary.simpleMessage("Monto"),
        "amountInSettingscurrency": m0,
        "amountMustBeANumber": MessageLookupByLibrary.simpleMessage(
            "La cantidad debe ser un número"),
        "amountMustBePositive": MessageLookupByLibrary.simpleMessage(
            "La cantidad debe ser positiva"),
        "amountTooHigh":
            MessageLookupByLibrary.simpleMessage("Cantidad demasiado alta"),
        "antispamFilter":
            MessageLookupByLibrary.simpleMessage("Anti-Spam Filter"),
        "applicationReset":
            MessageLookupByLibrary.simpleMessage("Restablecer la aplicación"),
        "approve": MessageLookupByLibrary.simpleMessage("APROBAR"),
        "areYouSureYouWantToDeleteThisContact":
            MessageLookupByLibrary.simpleMessage(
                "¿Estás seguro de que deseas eliminar este contacto?"),
        "areYouSureYouWantToSaveYourContactsIt": m1,
        "auto": MessageLookupByLibrary.simpleMessage("Auto"),
        "autoHideBalance": MessageLookupByLibrary.simpleMessage(
            "Ocultar saldo automáticamente"),
        "backup": MessageLookupByLibrary.simpleMessage("Copia de seguridad"),
        "backupAllAccounts":
            MessageLookupByLibrary.simpleMessage("Copia de seguridad completa"),
        "backupDataRequiredForRestore": m2,
        "backupEncryptionKey":
            MessageLookupByLibrary.simpleMessage("Clave de cifrado"),
        "backupWarning": MessageLookupByLibrary.simpleMessage(
            "Nadie puede recuperar sus claves secretas. Si no tiene una copia de seguridad, PERDERÁ SU DINERO si su teléfono se avería. Puede acceder a esta página mediante el menú de la aplicación y luego \'Copia de Seguridad\'"),
        "balance": MessageLookupByLibrary.simpleMessage("Saldo"),
        "barcode": MessageLookupByLibrary.simpleMessage("Código de barras"),
        "barcodeScannerIsNotAvailableOnDesktop":
            MessageLookupByLibrary.simpleMessage(
                "El escáner de código de barras no está disponible en el escritorio"),
        "blockReorgDetectedRewind": m3,
        "blue": MessageLookupByLibrary.simpleMessage("Azul"),
        "body": MessageLookupByLibrary.simpleMessage("Cuerpo"),
        "broadcast": MessageLookupByLibrary.simpleMessage("Transmisión"),
        "broadcastFromYourOnlineDevice": MessageLookupByLibrary.simpleMessage(
            "Transmite desde tu dispositivo en línea"),
        "budget": MessageLookupByLibrary.simpleMessage("Presupuesto"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancelar"),
        "cancelScan": MessageLookupByLibrary.simpleMessage("Cancelar Escaneo"),
        "changeAccountName":
            MessageLookupByLibrary.simpleMessage("Cambiar nombre de la cuenta"),
        "changeTransparentKey": MessageLookupByLibrary.simpleMessage(
            "Cambiar la clave transparente"),
        "changingTheModeWillTakeEffectAtNextRestart":
            MessageLookupByLibrary.simpleMessage(
                "Cambiar el modo tendrá efecto en el próximo reinicio"),
        "checkTransaction":
            MessageLookupByLibrary.simpleMessage("Verificar la transacción"),
        "close": MessageLookupByLibrary.simpleMessage("Cerrar"),
        "closeApplication":
            MessageLookupByLibrary.simpleMessage("Cierra la aplicación"),
        "coffee": MessageLookupByLibrary.simpleMessage("Café"),
        "coldStorage": MessageLookupByLibrary.simpleMessage("Billetera fría"),
        "color": MessageLookupByLibrary.simpleMessage("Color"),
        "confirmDeleteAccount": MessageLookupByLibrary.simpleMessage(
            "¿Está SEGURO de que desea BORRAR esta cuenta? DEBE tener una COPIA DE SEGURIDAD para recuperarla. Esta operación NO es reversible."),
        "confirmResetApp": MessageLookupByLibrary.simpleMessage(
            "¿Seguro que quieres restablecer la aplicación? Sus cuentas NO serán eliminadas"),
        "confirmSignATransactionToAddressFor": m4,
        "confirmSigning":
            MessageLookupByLibrary.simpleMessage("Confirmar firma"),
        "confs": MessageLookupByLibrary.simpleMessage("Confir"),
        "contactName":
            MessageLookupByLibrary.simpleMessage("Nombre del contacto"),
        "contacts": MessageLookupByLibrary.simpleMessage("Contactos"),
        "convertToWatchonly":
            MessageLookupByLibrary.simpleMessage("Convertir en solo vista"),
        "copy": MessageLookupByLibrary.simpleMessage("Copiar"),
        "count": MessageLookupByLibrary.simpleMessage("Cuenta"),
        "createANewAccount": MessageLookupByLibrary.simpleMessage(
            "Crea una nueva cuenta y aparecerá aquí."),
        "createANewContactAndItWillShowUpHere":
            MessageLookupByLibrary.simpleMessage(
                "Crea un contacto y aparecerá aquí."),
        "crypto": MessageLookupByLibrary.simpleMessage("Crypto"),
        "currency": MessageLookupByLibrary.simpleMessage("Moneda"),
        "custom": MessageLookupByLibrary.simpleMessage("Personalizado"),
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
        "doYouWantToRestore": MessageLookupByLibrary.simpleMessage(
            "Do you want to restore your database? THIS WILL ERASE YOUR CURRENT DATA"),
        "doYouWantToTransferYourEntireTransparentBalanceTo": m5,
        "duplicateAccount":
            MessageLookupByLibrary.simpleMessage("Cuenta duplicada"),
        "editContact": MessageLookupByLibrary.simpleMessage("Editar contacto"),
        "encryptedBackup": m6,
        "enterSecretShareIfAccountIsMultisignature":
            MessageLookupByLibrary.simpleMessage(
                "Introduzca la clave secreta si la cuenta es multi-firma"),
        "enterSeed": MessageLookupByLibrary.simpleMessage(
            "Ingrese la Semilla, Clave secreta o Clave de visualización. Dejar en blanco para una nueva cuenta"),
        "error": m7,
        "excludedNotes":
            MessageLookupByLibrary.simpleMessage("Notas excluidas"),
        "expert": MessageLookupByLibrary.simpleMessage("Expert"),
        "fileSaved": MessageLookupByLibrary.simpleMessage("Archivo guardado"),
        "fromto": MessageLookupByLibrary.simpleMessage("Rem/Dest."),
        "fullBackup": MessageLookupByLibrary.simpleMessage("Copia completa"),
        "fullRestore": MessageLookupByLibrary.simpleMessage(
            "Restauración de la copia de seguridad completada"),
        "gapLimit": MessageLookupByLibrary.simpleMessage("Brecha"),
        "goToTransaction":
            MessageLookupByLibrary.simpleMessage("Ver Transacción"),
        "gold": MessageLookupByLibrary.simpleMessage("Oro"),
        "height": MessageLookupByLibrary.simpleMessage("Altura"),
        "help": MessageLookupByLibrary.simpleMessage("Ayuda"),
        "history": MessageLookupByLibrary.simpleMessage("Historial"),
        "iHaveMadeABackup": MessageLookupByLibrary.simpleMessage(
            "He hecho una copia de seguridad"),
        "import": MessageLookupByLibrary.simpleMessage("Importar"),
        "includeFeeInAmount": MessageLookupByLibrary.simpleMessage(
            "Incluir comisión en la cantidad"),
        "includeReplyTo": MessageLookupByLibrary.simpleMessage(
            "Incluir mi dirección en el memo"),
        "incomingFunds": MessageLookupByLibrary.simpleMessage("Pago recibido"),
        "inputBarcodeValue":
            MessageLookupByLibrary.simpleMessage("Escriba el Código de barras"),
        "invalidAddress":
            MessageLookupByLibrary.simpleMessage("La Dirección no es válida"),
        "invalidKey": MessageLookupByLibrary.simpleMessage("Tecla inválida"),
        "invalidQrCode": m8,
        "key": MessageLookupByLibrary.simpleMessage("Clave"),
        "keyTool": MessageLookupByLibrary.simpleMessage("Clave Utilidad"),
        "largestSpendingLastMonth": MessageLookupByLibrary.simpleMessage(
            "Principales pagos del último mes"),
        "largestSpendingsByAddress": MessageLookupByLibrary.simpleMessage(
            "Pagos más grandes por dirección"),
        "ledger": MessageLookupByLibrary.simpleMessage("Ledger"),
        "light": MessageLookupByLibrary.simpleMessage("Día"),
        "loadBackup": MessageLookupByLibrary.simpleMessage(
            "Respaldar copia de seguridad"),
        "loading": MessageLookupByLibrary.simpleMessage("Cargando..."),
        "markAllAsRead":
            MessageLookupByLibrary.simpleMessage("Marcar todo como leído"),
        "max": MessageLookupByLibrary.simpleMessage("MAX"),
        "maxAmountPerNote":
            MessageLookupByLibrary.simpleMessage("Monto máximo por nota"),
        "memo": MessageLookupByLibrary.simpleMessage("Nota"),
        "message": MessageLookupByLibrary.simpleMessage("Mensaje"),
        "messages": MessageLookupByLibrary.simpleMessage("Mensajes"),
        "mm": MessageLookupByLibrary.simpleMessage("M/M"),
        "mobileCharges": MessageLookupByLibrary.simpleMessage(
            "Con datos móviles, el escaneo puede incurrir en cargos adicionales. ¿Quieres proceder?"),
        "mode": MessageLookupByLibrary.simpleMessage("Modo"),
        "multiPay": MessageLookupByLibrary.simpleMessage("Multi-Pagos"),
        "multipay": MessageLookupByLibrary.simpleMessage("Multi-Pagos"),
        "multipleAddresses":
            MessageLookupByLibrary.simpleMessage("Múltiples direcciones"),
        "multisig": MessageLookupByLibrary.simpleMessage("Multi-firma"),
        "multisigShares":
            MessageLookupByLibrary.simpleMessage("Acciones multi-firmas"),
        "na": MessageLookupByLibrary.simpleMessage("N/A"),
        "nameIsEmpty": MessageLookupByLibrary.simpleMessage("Nombre vacío"),
        "newAccount": MessageLookupByLibrary.simpleMessage("Nueva cuenta"),
        "newLabel": MessageLookupByLibrary.simpleMessage("Nueva"),
        "newSnapAddress":
            MessageLookupByLibrary.simpleMessage("Nueva Dirección instantánea"),
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
            MessageLookupByLibrary.simpleMessage("Sin pagos en 30 días"),
        "notEnoughBalance":
            MessageLookupByLibrary.simpleMessage("Saldo insuficiente"),
        "notes": MessageLookupByLibrary.simpleMessage("Notas"),
        "now": MessageLookupByLibrary.simpleMessage("Ahora"),
        "numberOfConfirmationsNeededBeforeSpending":
            MessageLookupByLibrary.simpleMessage(
                "Número de confirmaciones necesarias antes de gastar"),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "openInExplorer":
            MessageLookupByLibrary.simpleMessage("Abrir en el Explorador"),
        "paymentInProgress":
            MessageLookupByLibrary.simpleMessage("Pago en curso..."),
        "paymentMade": MessageLookupByLibrary.simpleMessage("Payment enviado"),
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
            MessageLookupByLibrary.simpleMessage("Reiniciar ahora"),
        "pnl": MessageLookupByLibrary.simpleMessage("G&P"),
        "pnlHistory": MessageLookupByLibrary.simpleMessage("Historia de G&P"),
        "preparingTransaction":
            MessageLookupByLibrary.simpleMessage("Preparando la transacción…"),
        "price": MessageLookupByLibrary.simpleMessage("Precio"),
        "primary": MessageLookupByLibrary.simpleMessage("Primario"),
        "privateKey": MessageLookupByLibrary.simpleMessage("Clave Privada"),
        "protectOpen": MessageLookupByLibrary.simpleMessage("Bloquer al abrir"),
        "protectSend":
            MessageLookupByLibrary.simpleMessage("Autenticar al enviar"),
        "protectSendSettingChanged": MessageLookupByLibrary.simpleMessage(
            "La configuración de Autenticar al enviar ha cambiado"),
        "purple": MessageLookupByLibrary.simpleMessage("Morado"),
        "qty": MessageLookupByLibrary.simpleMessage("Cantidad"),
        "rawTransaction":
            MessageLookupByLibrary.simpleMessage("Transacción con Firmar"),
        "realized": MessageLookupByLibrary.simpleMessage("Realizado"),
        "receive": m10,
        "receivePayment":
            MessageLookupByLibrary.simpleMessage("Recibir un pago"),
        "received": m11,
        "recipient": MessageLookupByLibrary.simpleMessage("Destinatario"),
        "reply": MessageLookupByLibrary.simpleMessage("Responder"),
        "rescan": MessageLookupByLibrary.simpleMessage("Escanear"),
        "rescanFrom":
            MessageLookupByLibrary.simpleMessage("¿Escanear desde...?"),
        "rescanNeeded":
            MessageLookupByLibrary.simpleMessage("Necesita escanear"),
        "rescanRequested": m12,
        "rescanning": MessageLookupByLibrary.simpleMessage("Escanear..."),
        "reset": MessageLookupByLibrary.simpleMessage("RESTABLECER"),
        "restart": MessageLookupByLibrary.simpleMessage("Reiniciar"),
        "restoreAnAccount":
            MessageLookupByLibrary.simpleMessage("¿Restaurar una Cuenta?"),
        "resumeScan": MessageLookupByLibrary.simpleMessage("Reanudar Escaneo"),
        "retrieveTransactionDetails": MessageLookupByLibrary.simpleMessage(
            "Obtener detalles de la transacción"),
        "roundToMillis":
            MessageLookupByLibrary.simpleMessage("Redondear a milésimas"),
        "saveBackup":
            MessageLookupByLibrary.simpleMessage("Guardar copia de seguridad"),
        "saveToBlockchain":
            MessageLookupByLibrary.simpleMessage("Guardar en la blockchain?"),
        "scanStartingMomentarily": MessageLookupByLibrary.simpleMessage(
            "Escaneo iniciado momentáneamente"),
        "secondary": MessageLookupByLibrary.simpleMessage("Secundario"),
        "secretKey": MessageLookupByLibrary.simpleMessage("Clave secreta"),
        "secretShare": MessageLookupByLibrary.simpleMessage("Clave secreta"),
        "seed": MessageLookupByLibrary.simpleMessage("Semilla"),
        "selectAccount":
            MessageLookupByLibrary.simpleMessage("Seleccionar cuenta"),
        "selectNotesToExcludeFromPayments":
            MessageLookupByLibrary.simpleMessage(
                "Seleccionar Notas a EXCLUIR de los pagos"),
        "send": MessageLookupByLibrary.simpleMessage("Enviar"),
        "sendCointicker": m13,
        "sendCointickerTo": m14,
        "sendFrom": m15,
        "sender": MessageLookupByLibrary.simpleMessage("Remitente"),
        "sendingATotalOfAmountCointickerToCountRecipients": m16,
        "sendingAzecCointickerToAddress": m17,
        "server": MessageLookupByLibrary.simpleMessage("Servidor"),
        "settings": MessageLookupByLibrary.simpleMessage("Ajustes"),
        "shieldTranspBalance":
            MessageLookupByLibrary.simpleMessage("Blindar Saldo transp."),
        "shieldTransparentBalance":
            MessageLookupByLibrary.simpleMessage("Blindar saldo transparente"),
        "shieldingInProgress":
            MessageLookupByLibrary.simpleMessage("Blindaje en progreso…"),
        "showMessagesAsTable":
            MessageLookupByLibrary.simpleMessage("Mostrar mensajes como tabla"),
        "sign": MessageLookupByLibrary.simpleMessage("Firma"),
        "signOffline": MessageLookupByLibrary.simpleMessage("Firmar"),
        "signOnYourOfflineDevice": MessageLookupByLibrary.simpleMessage(
            "Firmar con tu dispositivo fuera de línea"),
        "signedTx": MessageLookupByLibrary.simpleMessage("Tx firmada"),
        "simple": MessageLookupByLibrary.simpleMessage("Básico"),
        "simpleMode": MessageLookupByLibrary.simpleMessage("Modo básico"),
        "spendable": MessageLookupByLibrary.simpleMessage("Disponible"),
        "spendableBalance":
            MessageLookupByLibrary.simpleMessage("Saldo disponible"),
        "spent": m18,
        "splitAccount": MessageLookupByLibrary.simpleMessage("Cuenta dividida"),
        "subAccountIndexOf": m19,
        "subAccountOf": m20,
        "subject": MessageLookupByLibrary.simpleMessage("Asunto"),
        "syncPaused": MessageLookupByLibrary.simpleMessage("Escaneo en pausa"),
        "synching": MessageLookupByLibrary.simpleMessage("Sincronizando"),
        "synchronizationInProgress":
            MessageLookupByLibrary.simpleMessage("Sincronización en progreso"),
        "table": MessageLookupByLibrary.simpleMessage("Lista"),
        "tapAnIconToShowTheQrCode": MessageLookupByLibrary.simpleMessage(
            "Tocar el icono para mostrar el código QR"),
        "tapChartToToggleBetweenAddressAndAmount":
            MessageLookupByLibrary.simpleMessage(
                "Tocar gráfica para alternar entre dirección y cantidad"),
        "tapQrCodeForShieldedAddress": MessageLookupByLibrary.simpleMessage(
            "Toca el QR para Dirección blindada"),
        "tapQrCodeForTransparentAddress": MessageLookupByLibrary.simpleMessage(
            "Toca el QR para Dirección transparente"),
        "tapTransactionForDetails": MessageLookupByLibrary.simpleMessage(
            "Toca una Transacción para ver detalles"),
        "textCopiedToClipboard": m21,
        "thePrivateWalletMessenger": MessageLookupByLibrary.simpleMessage(
            "Billetera & Mensajería Privada"),
        "theme": MessageLookupByLibrary.simpleMessage("Tema"),
        "themeEditor": MessageLookupByLibrary.simpleMessage("Editor de temas"),
        "thisAccountAlreadyExists":
            MessageLookupByLibrary.simpleMessage("Esta cuenta ya existe."),
        "tiltYourDeviceUpToRevealYourBalance":
            MessageLookupByLibrary.simpleMessage(
                "Incline su dispositivo hacia arriba para revelar su saldo"),
        "timestamp": MessageLookupByLibrary.simpleMessage("Fecha/Hora"),
        "toMakeAContactSendThemAMemoWithContact":
            MessageLookupByLibrary.simpleMessage(
                "Para contactar, enviar un memo con \'Contact:\'"),
        "total": MessageLookupByLibrary.simpleMessage("Total"),
        "totalBalance": MessageLookupByLibrary.simpleMessage("Saldo Total"),
        "tradingChartRange":
            MessageLookupByLibrary.simpleMessage("Rango del gráfico"),
        "tradingPl": MessageLookupByLibrary.simpleMessage("Intercambio G&P"),
        "transactionDetails":
            MessageLookupByLibrary.simpleMessage("Detalles de la transacción"),
        "transactionHistory":
            MessageLookupByLibrary.simpleMessage("Historial de transacciones"),
        "transactions": MessageLookupByLibrary.simpleMessage("Transacciónes"),
        "txId": m22,
        "underConfirmed":
            MessageLookupByLibrary.simpleMessage("Confirmaciones insuficiente"),
        "unshielded": MessageLookupByLibrary.simpleMessage("Sin blindaje"),
        "unshieldedBalance":
            MessageLookupByLibrary.simpleMessage("Saldo sin blindaje"),
        "unsignedTransactionFile": MessageLookupByLibrary.simpleMessage(
            "Archivo de transacción sin firmar"),
        "unsignedTx": MessageLookupByLibrary.simpleMessage("Tx no firmada"),
        "update": MessageLookupByLibrary.simpleMessage("Recalcular"),
        "useGpu": MessageLookupByLibrary.simpleMessage("Utilizar GPU"),
        "useQrForOfflineSigning": MessageLookupByLibrary.simpleMessage(
            "Usar QR para firmar sin conexión"),
        "useSettingscurrency": m23,
        "useTransparentBalance":
            MessageLookupByLibrary.simpleMessage("Usar saldo transp."),
        "useUa": MessageLookupByLibrary.simpleMessage("Usar DU"),
        "version": MessageLookupByLibrary.simpleMessage("Versión"),
        "viewingKey":
            MessageLookupByLibrary.simpleMessage("Clave de visualización"),
        "welcomeToYwallet":
            MessageLookupByLibrary.simpleMessage("Bienvenido a YWallet")
      };
}
