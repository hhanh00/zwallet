import 'messages.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class SEs extends S {
  SEs([String locale = 'es']) : super(locale);

  @override
  String get about => 'Acerca de';

  @override
  String get account => 'Cuenta';

  @override
  String get accountBalanceHistory => 'Historial del saldo de la cuenta';

  @override
  String get accountIndex => 'Índice de la cuenta';

  @override
  String get accountManager => 'Gestor de cuentas';

  @override
  String get accountName => 'Nombre de la cuenta';

  @override
  String get accounts => 'Cuentas';

  @override
  String get add => 'Añadir';

  @override
  String get addContact => 'Añadir contacto';

  @override
  String get address => 'Dirección';

  @override
  String get addressCopiedToClipboard => 'Dirección copiada al portapapeles';

  @override
  String get addressIndex => 'Índice de dirección';

  @override
  String get addressIsEmpty => 'La dirección está vacía';

  @override
  String get amount => 'Cantidad';

  @override
  String get amountCurrency => 'Cantidad en Fiat';

  @override
  String get amountMustBePositive => 'La cantidad debe ser positiva';

  @override
  String get amountSlider => 'Deslizador de cantidad';

  @override
  String get antispamFilter => 'Filtro Antispam';

  @override
  String get any => 'WiFi y Datos';

  @override
  String get appData => 'Datos de la App';

  @override
  String get auto => 'Auto';

  @override
  String get autoFee => 'Comisión automática';

  @override
  String get autoHide => 'Auto Ocultar';

  @override
  String get autoHideBalance => 'Ocultar saldo';

  @override
  String get autoView => 'Orientación';

  @override
  String get backgroundSync => 'Sincronización en segundo plano';

  @override
  String get backup => 'Respaldo';

  @override
  String get backupAllAccounts => 'Copia de seguridad de todas las cuentas';

  @override
  String get backupMissing => 'COPIA DE SEGURIDAD';

  @override
  String get balance => 'Saldo';

  @override
  String get barcode => 'Código de barras';

  @override
  String get blockExplorer => 'Explorador de bloques';

  @override
  String get body => 'Cuerpo';

  @override
  String get broadcast => 'Transmitir';

  @override
  String get budget => 'Presupuesto';

  @override
  String get cancel => 'Cancelar';

  @override
  String get cannotDeleteActive => 'No se puede eliminar la cuenta activa a menos que sea la última';

  @override
  String get cannotUseTKey => 'No se puede importar la clave privada transparente. Utilice BARRIDO en su lugar';

  @override
  String get catchup => 'Poner al día';

  @override
  String get close => 'Cerrar';

  @override
  String get coldStorage => 'Billetera fría';

  @override
  String get configure => 'Configurar';

  @override
  String get confirmDeleteAccount => '¿Estás seguro de que quieres eliminar esta cuenta? DEBES tener un BACKUP para recuperarla. Esta operación no es reversible.';

  @override
  String get confirmDeleteContact => '¿Estás seguro de que quieres ELIMINAR este contacto?';

  @override
  String confirmRescanFrom(Object height) {
    return '¿Quieres volver a escanear desde el bloque $height?';
  }

  @override
  String confirmRewind(Object height) {
    return '¿Quieres rebobinar hasta el bloque $height?';
  }

  @override
  String get confirmSaveContacts => '¿Estás seguro de que quieres guardar tus contactos?';

  @override
  String get confirmSaveKeys => '¿Ha guardado sus claves?';

  @override
  String get confirmWatchOnly => '¿Quieres ELIMINAR la clave secreta y convertir esta cuenta en Sólo visualizción? Ya no podrás gastar desde este dispositivo. Esta operación NO es reversible.';

  @override
  String get confirmations => 'Mínimo de confirmaciones';

  @override
  String get confs => 'Confirmaciones';

  @override
  String get connectionError => 'DESCONECTADO';

  @override
  String get contactName => 'Nombre del contacto';

  @override
  String get contacts => 'Contactos';

  @override
  String get convertToWatchonly => 'Sólo visualización';

  @override
  String get copiedToClipboard => 'Copiar al portapapeles';

  @override
  String get copy => 'Copiar';

  @override
  String get count => 'Contador';

  @override
  String get crypto => 'Cripto';

  @override
  String get currency => 'Moneda';

  @override
  String get currentPassword => 'Contraseña actual';

  @override
  String get custom => 'Personalizar';

  @override
  String get customSend => 'Usar envío personalizado';

  @override
  String get customSendSettings => 'Configuración de envío personalizado';

  @override
  String get dark => 'Oscuro';

  @override
  String get databasePassword => 'Contraseña de la base de datos';

  @override
  String get databaseRestored => 'Base de datos restaurada';

  @override
  String get date => 'Fecha';

  @override
  String get datetime => 'Fecha/hora';

  @override
  String get deductFee => 'Deducir comisión del monto';

  @override
  String get defaultMemo => 'Memo por defecto';

  @override
  String get delete => 'BORRAR';

  @override
  String deleteAccount(Object name) {
    return 'Eliminar cuenta $name';
  }

  @override
  String get deletePayment => '¿Está seguro de que desea eliminar este destinatario?';

  @override
  String get derpath => 'Ruta de derivación';

  @override
  String get destination => 'Destino';

  @override
  String get disclaimer => 'Descargo de responsabilidad';

  @override
  String get disclaimerText => 'AUTOCUSTODIA';

  @override
  String get disclaimer_1 => 'Entiendo que soy responsable de asegurar mi frase de semilla';

  @override
  String get disclaimer_2 => 'Entiendo que YWallet no puede recuperar mi frase de semilla';

  @override
  String get disclaimer_3 => 'Entiendo que quien conozca mi frase semilla puede obtener mis fondos';

  @override
  String get diversified => 'Diversificada';

  @override
  String get editContact => 'Editar contacto';

  @override
  String get encryptDatabase => 'Cifrar base de datos';

  @override
  String get encryptionKey => 'Clave de cifrado';

  @override
  String get error => 'ERROR';

  @override
  String get change => 'Change';

  @override
  String get fee => 'Comisión';

  @override
  String get fromPool => 'Desde el Pool';

  @override
  String get fromto => 'Desde/Hasta';

  @override
  String get fullBackup => 'Copia de seguridad';

  @override
  String get fullRestore => 'Restaurar';

  @override
  String get gapLimit => 'Límite de brecha';

  @override
  String get general => 'General';

  @override
  String get height => 'Altura';

  @override
  String get help => 'Ayuda';

  @override
  String get hidden => 'Oculto';

  @override
  String get high => 'Alta';

  @override
  String get history => 'Historial';

  @override
  String get import => 'Importar';

  @override
  String get includeReplyTo => 'Incluir mi dirección';

  @override
  String get incomingFunds => 'Fondos entrantes';

  @override
  String get index => 'Índice';

  @override
  String get interval => 'Intervalo';

  @override
  String get invalidAddress => 'Dirección inválida';

  @override
  String get invalidKey => 'Clave inválida';

  @override
  String get invalidPassword => 'Contraseña inválida';

  @override
  String get invalidPaymentURI => 'URI de pago inválido';

  @override
  String get key => 'Semilla, Clave secreta o Clave de visualización (opcional)';

  @override
  String get keyTool => 'Herramienta de claves';

  @override
  String get keygen => 'Respaldar Keygen';

  @override
  String get keygenHelp => 'Las copias de seguridad completas utilizan el sistema de cifrado AGE. La clave de cifrado se utiliza para cifrar la copia de seguridad pero NO PUEDE descifrarla. La clave SECRETA es necesaria para restaurar la copia de seguridad.\nLa aplicación no guardará las claves cada vez que este keygen produzca un par de claves DIFERENTES.\n\nUsted DEBE guardar AMBAS claves.';

  @override
  String get largestSpendingsByAddress => 'Mayores gastos por dirección';

  @override
  String get ledger => 'Ledger';

  @override
  String get light => 'Claro';

  @override
  String get list => 'Lista';

  @override
  String get loading => 'Cargando...';

  @override
  String get low => 'Baja';

  @override
  String get mainReceivers => 'Dirección principal';

  @override
  String get market => 'Mercado';

  @override
  String get marketPrice => 'Precios Mkt';

  @override
  String get max => 'Máximo';

  @override
  String get maxAmountPerNote => 'Cantidad máxima por nota';

  @override
  String get medium => 'Medio';

  @override
  String get memo => 'Memo';

  @override
  String get memoTooLong => 'Memo demasiado largo';

  @override
  String get message => 'Mensaje';

  @override
  String get messages => 'Mensajes';

  @override
  String get minPrivacy => 'Privacidad mínima';

  @override
  String get mode => 'Modo avanzado';

  @override
  String get more => 'Más';

  @override
  String get multiPay => 'Multipagos';

  @override
  String get na => 'N/A';

  @override
  String get name => 'Nombre';

  @override
  String get nan => 'No es un número';

  @override
  String get netOrchard => 'Cambio neto de Orchard';

  @override
  String get netSapling => 'Cambio neto de Sapling';

  @override
  String get newAccount => 'Nueva cuenta';

  @override
  String get newPassword => 'Nueva contraseña';

  @override
  String get newPasswordsDoNotMatch => 'Las nuevas contraseñas no coinciden';

  @override
  String get next => 'Siguiente';

  @override
  String get noAuthenticationMethod => 'Sin Método de Autenticación';

  @override
  String get noDbPassword => 'La base de datos debe ser cifrada para proteger abrir/gastar';

  @override
  String get noRemindBackup => 'No me lo recuerdes';

  @override
  String get notEnoughBalance => 'No hay suficiente saldo';

  @override
  String get notes => 'Notas';

  @override
  String get now => 'Ahora';

  @override
  String get off => 'Apagado';

  @override
  String get ok => 'Ok';

  @override
  String get openInExplorer => 'Abrir en el Explorador';

  @override
  String get or => 'o';

  @override
  String get orchard => 'Orchard';

  @override
  String get orchardInput => 'Entrada Orchard';

  @override
  String get paymentMade => 'Pago realizado';

  @override
  String get paymentURI => 'URI de pago';

  @override
  String get ping => 'Prueba de ping';

  @override
  String get pleaseAuthenticate => 'Por favor autenticar';

  @override
  String get pleaseQuitAndRestartTheAppNow => 'Por favor, cierre y reinicie la aplicación para que estos cambios surtan efecto';

  @override
  String get pool => 'Pool';

  @override
  String get poolTransfer => 'Transferencia entre Pools';

  @override
  String get pools => 'Pools';

  @override
  String get prev => 'Anterior';

  @override
  String get priv => 'Privacidad';

  @override
  String privacy(Object level) {
    return 'PRIVACIDAD: $level';
  }

  @override
  String get privacyLevelTooLow => 'Privacidad demasiado BAJA - Pulsación larga para anular';

  @override
  String get privateKey => 'Clave Privada';

  @override
  String get protectOpen => 'Autenticar al abrir';

  @override
  String get protectSend => 'Autenticar al enviar';

  @override
  String get publicKey => 'Clave pública';

  @override
  String get qr => 'Código QR';

  @override
  String get rawTransaction => 'Transacción sin procesar';

  @override
  String receive(Object ticker) {
    return 'Recibir $ticker';
  }

  @override
  String received(Object amount, Object ticker) {
    return 'Recibida $amount $ticker';
  }

  @override
  String get receivers => 'Receptores al enviar';

  @override
  String get recipient => 'Destinatario';

  @override
  String get repeatNewPassword => 'Repetir nueva contraseña';

  @override
  String get reply => 'Responder';

  @override
  String get replyUA => 'Dirección de respuesta';

  @override
  String get required => 'Valor requerido';

  @override
  String get rescan => 'Rescanear';

  @override
  String get rescanFrom => 'Rescanear desde...';

  @override
  String get rescanWarning => 'RESCANEAR restablece todas sus cuentas. Puede que quiera considerar usar REBOBINAR en su lugar';

  @override
  String get reset => 'Restablecer';

  @override
  String get restart => 'Reiniciar';

  @override
  String get restore => 'Restaurar';

  @override
  String get restoreAnAccount => '¿Restaurar una cuenta?';

  @override
  String get retrieveTransactionDetails => 'Recuperar detalles de la transacción';

  @override
  String get rewind => 'Rebobinar';

  @override
  String get sapling => 'Sapling';

  @override
  String get saplingInput => 'Entrada Sapling';

  @override
  String get save => 'Guardar';

  @override
  String get scanQrCode => 'Escanear Código QR';

  @override
  String get scanRawTx => 'Escanear los códigos QR de la Tx sin firmar';

  @override
  String get scanSignedTx => 'Escanear los códigos QR de la Tx firmada';

  @override
  String get secretKey => 'Clave secreta';

  @override
  String get secured => 'Asegurado';

  @override
  String get seed => 'Semilla';

  @override
  String get seedKeys => 'Semilla y claves';

  @override
  String get seedOrKeyRequired => 'Semilla o clave privada requerida';

  @override
  String get selectNotesToExcludeFromPayments => 'Seleccione las notas a EXCLUIR de los pagos';

  @override
  String get send => 'Enviar';

  @override
  String sendCointicker(Object ticker) {
    return 'Enviar $ticker';
  }

  @override
  String sendFrom(Object app) {
    return 'Enviado desde $app';
  }

  @override
  String get sender => 'Remitente';

  @override
  String get sending => 'Enviando transacción';

  @override
  String get sent => 'Transacción enviada';

  @override
  String get sent_failed => 'Transacción fallida';

  @override
  String get server => 'Servidor';

  @override
  String get set => 'Establecer';

  @override
  String get settings => 'Ajustes';

  @override
  String get shielded => 'Protegido';

  @override
  String get showSubKeys => 'Mostrar subclaves';

  @override
  String get sign => 'Firmar transacción';

  @override
  String get signOffline => 'Firmar';

  @override
  String get signedTx => 'Tx firmado';

  @override
  String get source => 'Origen';

  @override
  String get spendable => 'Disponible';

  @override
  String spent(Object amount, Object ticker) {
    return 'Gastar $amount $ticker';
  }

  @override
  String get subject => 'Asunto';

  @override
  String get sweep => 'Barrido';

  @override
  String get sync => 'Sincronización';

  @override
  String get syncPaused => 'PAUSADO - Toca para Reanudar';

  @override
  String get table => 'Tabla';

  @override
  String get template => 'Plantilla';

  @override
  String textCopiedToClipboard(Object text) {
    return '$text copiado al portapapeles';
  }

  @override
  String get thePrivateWalletMessenger => 'Monedero y mensajería privada';

  @override
  String get theme => 'Tema';

  @override
  String get thisAccountAlreadyExists => 'Otra cuenta tiene la misma dirección';

  @override
  String get timestamp => 'Marca de tiempo';

  @override
  String get toPool => 'Al Pool';

  @override
  String get tools => 'Herramientas';

  @override
  String get totalBalance => 'Saldo total';

  @override
  String get transactionDetails => 'Detalles de la transacción';

  @override
  String get transactionHistory => 'Historial de transacciones';

  @override
  String get transactions => 'Transacciones';

  @override
  String get transfer => 'Transferir';

  @override
  String get transparent => 'Transparente';

  @override
  String get transparentInput => 'Entrada transparente';

  @override
  String get transparentKey => 'Clave transparente';

  @override
  String get txID => 'TXID';

  @override
  String txId(Object txid) {
    return 'TX ID: $txid';
  }

  @override
  String get txPlan => 'Plan de transacción';

  @override
  String get mainAddress => 'Principal';

  @override
  String get unifiedViewingKey => 'Clave de visualización unificada';

  @override
  String get unsignedTx => 'Tx sin firmar';

  @override
  String get update => 'Recalcular';

  @override
  String get useZats => 'Usar Zats (8 decimales)';

  @override
  String get version => 'Versión';

  @override
  String get veryLow => 'Muy bajo';

  @override
  String get viewingKey => 'Clave de visualización';

  @override
  String get views => 'Vistas';

  @override
  String get welcomeToYwallet => 'Bienvenido a YWallet';

  @override
  String get wifi => 'WiFi';

  @override
  String get dontShowAnymore => 'No mostrar más';

  @override
  String get swapDisclaimer => 'Los swaps son ofrecidos por proveedores externos. Utilice bajo su propio riesgo y realice sus propias investigaciones.';

  @override
  String get swap => 'Swap';

  @override
  String get swapProviders => 'Proveedores de Swap';

  @override
  String get stealthEx => 'StealthEX';

  @override
  String get getQuote => 'Obtener presupuesto';

  @override
  String get invalidSwapCurrencies => 'El intercambio debe incluir ZEC';

  @override
  String get checkSwapAddress => '¡Asegúrese de que la dirección de destino es válida!';

  @override
  String get swapSend => 'Enviar';

  @override
  String get swapReceive => 'Recibir';

  @override
  String get swapFromTip => 'Consejo: Envía los fondos a la dirección en la parte superior y recibirás el ZEC en tu dirección transparente.';

  @override
  String get swapToTip => 'Consejo: Toque el botón Enviar y reciba la otra moneda';

  @override
  String get confirm => 'Por favor, confirme';

  @override
  String get confirmClearSwapHistory => '¿Está seguro de que desea borrar el historial de intercambio?';

  @override
  String get retry => 'Reintentar';

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
