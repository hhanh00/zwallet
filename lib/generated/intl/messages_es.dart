// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es locale. All the
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
  String get localeName => 'es';

  static String m0(currency) => "Cantidad en ${currency}";

  static String m1(ticker) =>
      "Estás seguro de que quieres guardar tus contactos? Costará 0,01 mZEC ";

  static String m2(ticker) =>
      "¿Quiere transferir su saldo transparente a su dirección blindada? ";

  static String m3(ticker) => "Receive ${ticker}";

  static String m4(ticker) => "Enviar ${ticker}";

  static String m5(ticker) => "Enviar ${ticker} a…";

  static String m6(amount, ticker, count) =>
      "Enviando un total de ${amount} ${ticker} a ${count} direcciones";

  static String m7(aZEC, ticker, address) =>
      "Enviado ${aZEC} ${ticker} a ${address}";

  static String m8(currency) => "Utilizar ${currency}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "M1": MessageLookupByLibrary.simpleMessage("1 M"),
        "M3": MessageLookupByLibrary.simpleMessage("3 M"),
        "M6": MessageLookupByLibrary.simpleMessage("6 M"),
        "Y1": MessageLookupByLibrary.simpleMessage("1 A"),
        "about": MessageLookupByLibrary.simpleMessage("Acerca"),
        "account": MessageLookupByLibrary.simpleMessage("Cuenta"),
        "accountBalanceHistory":
            MessageLookupByLibrary.simpleMessage("Historial De Cuenta"),
        "accountHasSomeBalanceAreYouSureYouWantTo":
            MessageLookupByLibrary.simpleMessage(
                "La cuenta tiene un saldo. ¿Estás seguro de que quieres eliminarlo?"),
        "accountName": MessageLookupByLibrary.simpleMessage("Nombre de Cuenta"),
        "accountNameIsRequired": MessageLookupByLibrary.simpleMessage(
            "Se requiere el nombre de cuenta"),
        "accounts": MessageLookupByLibrary.simpleMessage("Cuentas"),
        "add": MessageLookupByLibrary.simpleMessage("AGREGAR"),
        "addARecipientAndItWillShowHere": MessageLookupByLibrary.simpleMessage(
            "Agregar un destinatario y se mostrará aquí"),
        "addContact": MessageLookupByLibrary.simpleMessage("Agregar Contacto"),
        "address": MessageLookupByLibrary.simpleMessage("Dirección"),
        "addressCopiedToClipboard": MessageLookupByLibrary.simpleMessage(
            "Dirección copiada al portapapeles"),
        "addressIsEmpty":
            MessageLookupByLibrary.simpleMessage("Dirección está vacía"),
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
        "approve": MessageLookupByLibrary.simpleMessage("APROBAR"),
        "areYouSureYouWantToDeleteThisContact":
            MessageLookupByLibrary.simpleMessage(
                "Estás seguro de que deseas eliminar este contacto?"),
        "areYouSureYouWantToSaveYourContactsIt": m1,
        "autoHideBalance": MessageLookupByLibrary.simpleMessage(
            "Ocultar Saldo Automáticamente"),
        "backup": MessageLookupByLibrary.simpleMessage("Copia De Seguridad"),
        "backupDataRequiredForRestore": MessageLookupByLibrary.simpleMessage(
            "Copia De Seguridad - Requerido Para Restaurar"),
        "backupWarning": MessageLookupByLibrary.simpleMessage(
            "Nadie puede recuperar sus claves secretas. Si no tiene una copia de seguridad, PERDERÁ SU DINERO si su teléfono se avería. Puede acceder a esta página mediante el menú de la aplicación y luego \'Copia de Seguridad\'"),
        "balance": MessageLookupByLibrary.simpleMessage("Saldo"),
        "blue": MessageLookupByLibrary.simpleMessage("Azul"),
        "broadcast": MessageLookupByLibrary.simpleMessage("Transmisión"),
        "budget": MessageLookupByLibrary.simpleMessage("Presupuesto"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancelar"),
        "changeAccountName":
            MessageLookupByLibrary.simpleMessage("Cambiar nombre de la cuenta"),
        "coffee": MessageLookupByLibrary.simpleMessage("Café"),
        "coldStorage": MessageLookupByLibrary.simpleMessage("Billetera Fría"),
        "confirmDeleteAccount": MessageLookupByLibrary.simpleMessage(
            "¿Está SEGURO de que desea BORRAR esta cuenta? DEBE tener una COPIA DE SEGURIDAD para recuperarla. Esta operación NO es reversible."),
        "confs": MessageLookupByLibrary.simpleMessage("Confs"),
        "contactName":
            MessageLookupByLibrary.simpleMessage("Nombre de contacto"),
        "contacts": MessageLookupByLibrary.simpleMessage("Contactos"),
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
        "delete": MessageLookupByLibrary.simpleMessage("ELIMINAR"),
        "deleteAccount": MessageLookupByLibrary.simpleMessage("Borrar Cuenta"),
        "deleteContact":
            MessageLookupByLibrary.simpleMessage("Borrar contacto"),
        "doYouWantToDeleteTheSecretKeyAndConvert":
            MessageLookupByLibrary.simpleMessage(
                "¿Quiere BORRAR la clave secreta y convertir esta cuenta a solo lectura? Ya no podrá gastar desde este dispositivo. Esta operación NO es reversible."),
        "doYouWantToTransferYourEntireTransparentBalanceTo": m2,
        "duplicateAccount":
            MessageLookupByLibrary.simpleMessage("Cuenta duplicada"),
        "enterSeed": MessageLookupByLibrary.simpleMessage(
            "Ingrese Semilla, Clave Secreta o Clave Lectura. Dejar en blanco para una nueva cuenta "),
        "excludedNotes":
            MessageLookupByLibrary.simpleMessage("Notas Excluidas"),
        "gold": MessageLookupByLibrary.simpleMessage("Oro"),
        "height": MessageLookupByLibrary.simpleMessage("Altura"),
        "help": MessageLookupByLibrary.simpleMessage("Help"),
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
        "max": MessageLookupByLibrary.simpleMessage("MAX"),
        "maxAmountPerNote":
            MessageLookupByLibrary.simpleMessage("Monto máximo por nota"),
        "memo": MessageLookupByLibrary.simpleMessage("Nota"),
        "mm": MessageLookupByLibrary.simpleMessage("M/M"),
        "multiPay": MessageLookupByLibrary.simpleMessage("Multi Pagos"),
        "multipay": MessageLookupByLibrary.simpleMessage("MultiPagos"),
        "na": MessageLookupByLibrary.simpleMessage("N/A"),
        "nameIsEmpty": MessageLookupByLibrary.simpleMessage("Nombre vacio"),
        "newSnapAddress":
            MessageLookupByLibrary.simpleMessage("Nueva Dirección Instantánea"),
        "noAccount": MessageLookupByLibrary.simpleMessage("Sin Cuenta"),
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
        "pnl": MessageLookupByLibrary.simpleMessage("Pnl"),
        "pnlHistory": MessageLookupByLibrary.simpleMessage("PNL History"),
        "preparingTransaction":
            MessageLookupByLibrary.simpleMessage("Preparando la transacción…"),
        "price": MessageLookupByLibrary.simpleMessage("Precio"),
        "protectSend": MessageLookupByLibrary.simpleMessage("Proteger enviar"),
        "protectSendSettingChanged": MessageLookupByLibrary.simpleMessage(
            "La configuración de envío protegido ha cambiado"),
        "purple": MessageLookupByLibrary.simpleMessage("Morada"),
        "qty": MessageLookupByLibrary.simpleMessage("Cantidad"),
        "realized": MessageLookupByLibrary.simpleMessage("Dio Cuenta"),
        "receive": m3,
        "receivePayment":
            MessageLookupByLibrary.simpleMessage("Recibir un pago"),
        "rescan": MessageLookupByLibrary.simpleMessage("Escanear"),
        "rescanNeeded":
            MessageLookupByLibrary.simpleMessage("Necesita Escanear"),
        "rescanRequested":
            MessageLookupByLibrary.simpleMessage("Escaneo solicitado…"),
        "rescanWalletFromTheFirstBlock": MessageLookupByLibrary.simpleMessage(
            "¿Escanear billetera desde el primer bloque?"),
        "retrieveTransactionDetails": MessageLookupByLibrary.simpleMessage(
            "Obtener detalles de la transacción"),
        "roundToMillis":
            MessageLookupByLibrary.simpleMessage("Redonda a millis"),
        "saveToBlockchain":
            MessageLookupByLibrary.simpleMessage("Guardar en blockchain?"),
        "scanStartingMomentarily": MessageLookupByLibrary.simpleMessage(
            "Escaneo comenzando momentáneamente "),
        "secretKey": MessageLookupByLibrary.simpleMessage("Llave Secreta"),
        "seed": MessageLookupByLibrary.simpleMessage("Semilla"),
        "selectAccount":
            MessageLookupByLibrary.simpleMessage("Seleccionar cuenta"),
        "selectNotesToExcludeFromPayments":
            MessageLookupByLibrary.simpleMessage(
                "Seleccionar Notas a EXCLUIR de los pagos"),
        "send": MessageLookupByLibrary.simpleMessage("Enviar"),
        "sendCointicker": m4,
        "sendCointickerTo": m5,
        "sendingATotalOfAmountCointickerToCountRecipients": m6,
        "sendingAzecCointickerToAddress": m7,
        "server": MessageLookupByLibrary.simpleMessage("Servidor"),
        "settings": MessageLookupByLibrary.simpleMessage("Ajustes"),
        "shieldTranspBalance":
            MessageLookupByLibrary.simpleMessage("Blindar Saldo Transp."),
        "shieldTransparentBalance":
            MessageLookupByLibrary.simpleMessage("Blindar Saldo Transparente"),
        "shieldingInProgress":
            MessageLookupByLibrary.simpleMessage("Blindaje en progreso…"),
        "spendable": MessageLookupByLibrary.simpleMessage("Gastable"),
        "spendableBalance":
            MessageLookupByLibrary.simpleMessage("Saldo Gastable"),
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
        "tapTransactionForDetails":
            MessageLookupByLibrary.simpleMessage("Tap Transaction for Details"),
        "theme": MessageLookupByLibrary.simpleMessage("Tema"),
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
            MessageLookupByLibrary.simpleMessage("Transaction History"),
        "txId": MessageLookupByLibrary.simpleMessage("TX ID:"),
        "underConfirmed":
            MessageLookupByLibrary.simpleMessage("Confirmaciones Insuficiente"),
        "unshielded": MessageLookupByLibrary.simpleMessage("Sin blindaje"),
        "unshieldedBalance":
            MessageLookupByLibrary.simpleMessage("Saldo sin blindaje"),
        "unsignedTransactionFile": MessageLookupByLibrary.simpleMessage(
            "Archivo de transaccion sin firmar"),
        "useSettingscurrency": m8,
        "useUa": MessageLookupByLibrary.simpleMessage("Usar UA"),
        "version": MessageLookupByLibrary.simpleMessage("Versión"),
        "viewingKey": MessageLookupByLibrary.simpleMessage("Llave Lectura")
      };
}
