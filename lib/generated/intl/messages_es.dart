import 'messages.dart';

/// The translations for Spanish Castilian (`es`).
class SEs extends S {
  SEs([String locale = 'es']) : super(locale);

  @override
  String get about => 'Acerca de';

  @override
  String get account => 'Cuenta';

  @override
  String get accountBalanceHistory => 'Historial de saldo de cuenta';

  @override
  String get accountIndex => 'Índice de cuenta';

  @override
  String get accountManager => 'Gestor de cuentas';

  @override
  String get accountName => 'Nombre de cuenta';

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
  String get advanced => 'Avanzado';

  @override
  String get amount => 'Cantidad';

  @override
  String get amountCurrency => 'Cantidad en Fiat';

  @override
  String get amountMustBePositive => 'La cantidad debe ser positiva';

  @override
  String get amountSlider => 'Monto deslizador';

  @override
  String get antispamFilter => 'Filtro Antispam';

  @override
  String get any => 'Cualquier';

  @override
  String get appData => 'Datos de App';

  @override
  String get auto => 'Auto';

  @override
  String get autoFee => 'Tarifa automática';

  @override
  String get autoHide => 'Auto Ocultar';

  @override
  String get autoHideBalance => 'Ocultar saldo';

  @override
  String get autoView => 'Orientación';

  @override
  String get backgroundSync => 'Sincronización de fondo';

  @override
  String get backup => 'Respaldo';

  @override
  String get backupAllAccounts => 'Copia de seguridad de todas las cuentas';

  @override
  String get backupMissing => 'FALLO DE BACKUP';

  @override
  String get balance => 'Saldo';

  @override
  String get barcode => 'Barcode';

  @override
  String get blockExplorer => 'Explorador de bloques';

  @override
  String get body => 'Cuerpo';

  @override
  String get broadcast => 'Transmisión';

  @override
  String get budget => 'Presupuestario';

  @override
  String get cancel => 'Cancelar';

  @override
  String get cannotDeleteActive => 'No se puede eliminar la cuenta activa a menos que sea la última';

  @override
  String get cannotUseTKey => 'No se puede importar la clave privada transparente. Utilice SWEEP en su lugar';

  @override
  String get catchup => 'Poner al día';

  @override
  String get close => 'Cerrar';

  @override
  String get coldStorage => 'Almacenamiento frío';

  @override
  String get configure => 'Configurar';

  @override
  String get confirmDeleteAccount => '¿Estás seguro de que quieres eliminar esta cuenta? DEBES tener un BACKUP para recuperarla. Esta operación no es reversible.';

  @override
  String get confirmDeleteContact => '¿Estás seguro de que quieres ELIMINAR este contacto?';

  @override
  String confirmRescanFrom(Object height) {
    return '¿Quieres volver a escanear del bloque $height?';
  }

  @override
  String confirmRewind(Object height) {
    return '¿Quieres rebobinar para bloquear la $height?';
  }

  @override
  String get confirmSaveContacts => '¿Estás seguro de que quieres guardar tus contactos?';

  @override
  String get confirmSaveKeys => '¿Ha guardado sus llaves?';

  @override
  String get confirmWatchOnly => '¿Quiere ELIMINAR la clave secreta y convertir esta cuenta en una cuenta de sólo reloj? Ya no podrás gastar desde este dispositivo. Esta operación NO es reversible.';

  @override
  String get confirmations => 'Mínimo de confirmaciones';

  @override
  String get confs => 'Confos';

  @override
  String get connectionError => 'DISCONECTADO';

  @override
  String get contactName => 'Nombre de contacto';

  @override
  String get contacts => 'Contactos';

  @override
  String get convertToWatchonly => 'Sólo a Watch';

  @override
  String get copiedToClipboard => 'Copiar al portapapeles';

  @override
  String get copy => 'Copiar';

  @override
  String get count => 'Contador';

  @override
  String get crypto => 'Crypto';

  @override
  String get currency => 'Moneda';

  @override
  String get currentPassword => 'Contraseña actual';

  @override
  String get custom => 'Personalizado';

  @override
  String get customSend => 'Usar envío personalizado';

  @override
  String get customSendSettings => 'Configuración de envío personalizada';

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
  String get deletePayment => '¿Está seguro de que desea eliminar este destinatario';

  @override
  String get derpath => 'Ruta de derivación';

  @override
  String get destination => 'Destino';

  @override
  String get disclaimer => 'Descargo de responsabilidad';

  @override
  String get disclaimerText => 'SELF-CLIENTE';

  @override
  String get disclaimer_1 => 'Entiendo que soy responsable de asegurar mi frase de semilla';

  @override
  String get disclaimer_2 => 'Entiendo que YWallet no puede recuperar mi frase de semilla';

  @override
  String get disclaimer_3 => 'Entiendo a quien conozca mi frase de semilla puede obtener mis fondos';

  @override
  String get diversified => 'Diversificado';

  @override
  String get editContact => 'Editar contacto';

  @override
  String get encryptDatabase => 'Cifrar base de datos';

  @override
  String get encryptionKey => 'Clave de cifrado';

  @override
  String get error => 'ERROR';

  @override
  String get external => 'Externo';

  @override
  String get fee => 'Cuota';

  @override
  String get fromPool => 'Desde Pool';

  @override
  String get fromto => 'Desde/Hasta';

  @override
  String get fullBackup => 'Copia de seguridad';

  @override
  String get fullRestore => 'Restauración completa';

  @override
  String get gapLimit => 'Límite de brechas';

  @override
  String get general => 'General';

  @override
  String get height => 'Altura';

  @override
  String get help => 'Ayuda';

  @override
  String get hidden => 'Hidden';

  @override
  String get high => 'Alta';

  @override
  String get history => 'Historial';

  @override
  String get import => 'Importar';

  @override
  String get includeReplyTo => 'Incluye mi dirección en la nota';

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
  String get invalidPassword => 'Contraseña no válida';

  @override
  String get invalidPaymentURI => 'Invalid Payment URI';

  @override
  String get key => 'Semilla, Clave secreta o Clave de vista (opcional)';

  @override
  String get keyTool => 'Herramienta de clave';

  @override
  String get keygen => 'Respaldar Keygen';

  @override
  String get keygenHelp => 'Full backups use the AGE encryption system. The encryption key is used to encrypt the backup but CANNOT decrypt it. The SECRET key is needed to restore the backup.\nThe app will not store the keys. Every time this keygen will produce a DIFFERENT pair of keys.\n\nYou MUST save BOTH keys that you use';

  @override
  String get largestSpendingsByAddress => 'Mayor gasto por dirección';

  @override
  String get ledger => 'Libro';

  @override
  String get light => 'Claro';

  @override
  String get list => 'Lista';

  @override
  String get loading => 'Cargando...';

  @override
  String get low => 'Baja';

  @override
  String get mainUA => 'Destinatarios principales de UA';

  @override
  String get market => 'Mercado';

  @override
  String get marketPrice => 'Precios Mkt';

  @override
  String get max => 'Máx';

  @override
  String get maxAmountPerNote => 'Cantidad máxima por nota';

  @override
  String get medium => 'Medio';

  @override
  String get memo => 'Nota';

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
  String get multiPay => 'Pago múltiple';

  @override
  String get na => 'N/A';

  @override
  String get name => 'Nombre';

  @override
  String get nan => 'No un número';

  @override
  String get netOrchard => 'Cambio neto de Orchard';

  @override
  String get netSapling => 'Cambio de Brote Neto';

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
  String get noRemindBackup => 'No me lo recuerde';

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
  String get pool => 'Herramienta';

  @override
  String get poolTransfer => 'Transferencia de Pool';

  @override
  String get pools => 'Piscinas';

  @override
  String get prev => 'Anterior';

  @override
  String get priv => 'Privacidad';

  @override
  String privacy(Object level) {
    return 'PRIVACIA: $level';
  }

  @override
  String get privacyLevelTooLow => 'Privacidad demasiado LOW - Pulsación larga para anular';

  @override
  String get privateKey => 'Clave Privada';

  @override
  String get protectOpen => 'Proteger abrir';

  @override
  String get protectSend => 'Proteger envío';

  @override
  String get publicKey => 'Clave pública';

  @override
  String get qr => 'QR Code';

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
  String get receivers => 'Receptores';

  @override
  String get recipient => 'Destinatario';

  @override
  String get repeatNewPassword => 'Repetir nueva contraseña';

  @override
  String get reply => 'Responder';

  @override
  String get replyUA => 'Responder destinatarios de UA';

  @override
  String get required => 'Valor requerido';

  @override
  String get rescan => 'Reescanear';

  @override
  String get rescanFrom => 'Reescanear desde...';

  @override
  String get rescanWarning => 'RESCAN restablece todas sus cuentas. Puede que quiera considerar usar REWIND en su lugar';

  @override
  String get reset => 'Reset';

  @override
  String get restart => 'Reiniciar';

  @override
  String get restore => 'Restaurar';

  @override
  String get restoreAnAccount => '¿Restaurar una cuenta?';

  @override
  String get retrieveTransactionDetails => 'Recuperar detalles de la transacción';

  @override
  String get rewind => 'Rewind';

  @override
  String get sapling => 'Brote';

  @override
  String get saplingInput => 'Sapling Input';

  @override
  String get save => 'Guardar';

  @override
  String get scanQrCode => 'Scan QR Code';

  @override
  String get scanRawTx => 'Escanear los códigos QR Tx no firmados';

  @override
  String get scanSignedTx => 'Escanear los códigos QR Tx firmados';

  @override
  String get secretKey => 'Clave secreta';

  @override
  String get secured => 'Asegurado';

  @override
  String get seed => 'Semilla';

  @override
  String get seedKeys => 'Semilla y llaves';

  @override
  String get seedOrKeyRequired => 'Semilla o clave privada requerida';

  @override
  String get selectNotesToExcludeFromPayments => 'Seleccionar notas a EXCLUDE de los pagos';

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
  String get set => 'Fijar';

  @override
  String get settings => 'Ajustes';

  @override
  String get shielded => 'Protegido';

  @override
  String get showSubKeys => 'Mostrar subclaves';

  @override
  String get sign => 'Firmar transacción';

  @override
  String get signOffline => 'Signo';

  @override
  String get signedTx => 'Tx firmado';

  @override
  String get source => 'Fuente';

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
  String get syncPaused => 'PASADO - Toca para Reanudar';

  @override
  String get table => 'Tabla';

  @override
  String get template => 'Plantilla';

  @override
  String textCopiedToClipboard(Object text) {
    return '$text copied to clipboard';
  }

  @override
  String get thePrivateWalletMessenger => 'El monedero privado y mensajero';

  @override
  String get theme => 'Tema';

  @override
  String get thisAccountAlreadyExists => 'Otra cuenta tiene la misma dirección';

  @override
  String get timestamp => 'Timestamp';

  @override
  String get toPool => 'A Pool';

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
  String get ua => 'UA';

  @override
  String get unifiedViewingKey => 'Clave de visualización unificada';

  @override
  String get unsignedTx => 'Tx sin firmar';

  @override
  String get update => 'Recalcar';

  @override
  String get useZats => 'Usar Zats (8 decimales)';

  @override
  String get version => 'Versión';

  @override
  String get veryLow => 'Muy bajo';

  @override
  String get viewingKey => 'Viendo clave';

  @override
  String get views => 'Vistas';

  @override
  String get welcomeToYwallet => 'Bienvenido a YWallet';

  @override
  String get wifi => 'WiFi';
}
