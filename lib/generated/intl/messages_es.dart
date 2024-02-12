import 'messages.dart';

/// The translations for Spanish Castilian (`es`).
class SEs extends S {
  SEs([String locale = 'es']) : super(locale);

  @override
  String get about => 'Acerca';

  @override
  String get account => 'Cuenta';

  @override
  String get accountBalanceHistory => 'Historial de la cuenta';

  @override
  String get accountIndex => 'Índice de cuenta';

  @override
  String get accountManager => 'Account Manager';

  @override
  String get accountName => 'Nombre de la cuenta';

  @override
  String get accounts => 'Cuentas';

  @override
  String get add => 'Agregar';

  @override
  String get addContact => 'Agregar Contacto';

  @override
  String get address => 'Dirección';

  @override
  String get addressCopiedToClipboard => 'Dirección copiada al portapapeles';

  @override
  String get addressIndex => 'Address Index';

  @override
  String get addressIsEmpty => 'La Dirección está vacía';

  @override
  String get advanced => 'Advanced';

  @override
  String get amount => 'Monto';

  @override
  String get amountCurrency => 'Amount in Fiat';

  @override
  String get amountMustBePositive => 'La cantidad debe ser positiva';

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
  String get autoHideBalance => 'Ocultar saldo';

  @override
  String get autoView => 'Orientation';

  @override
  String get backgroundSync => 'Background Sync';

  @override
  String get backup => 'Copia de seguridad';

  @override
  String get backupAllAccounts => 'Copia de seguridad completa';

  @override
  String get backupMissing => 'BACKUP MISSING';

  @override
  String get balance => 'Saldo';

  @override
  String get barcode => 'Código de barras';

  @override
  String get blockExplorer => 'Block Explorer';

  @override
  String get body => 'Cuerpo';

  @override
  String get broadcast => 'Transmisión';

  @override
  String get budget => 'Presupuesto';

  @override
  String get cancel => 'Cancelar';

  @override
  String get cannotDeleteActive => 'Cannot delete the active account unless it is the last one';

  @override
  String get cannotUseTKey => 'Cannot import transparent private key. Use SWEEP instead';

  @override
  String get catchup => 'Catch up';

  @override
  String get close => 'Cerrar';

  @override
  String get coldStorage => 'Billetera fría';

  @override
  String get configure => 'Configure';

  @override
  String get confirmDeleteAccount => '¿Está SEGURO de que desea BORRAR esta cuenta? DEBE tener una COPIA DE SEGURIDAD para recuperarla. Esta operación NO es reversible.';

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
  String get confs => 'Confir';

  @override
  String get connectionError => 'DISCONNECTED';

  @override
  String get contactName => 'Nombre del contacto';

  @override
  String get contacts => 'Contactos';

  @override
  String get convertToWatchonly => 'Convertir en solo vista';

  @override
  String get copiedToClipboard => 'Copy to Clipboard';

  @override
  String get copy => 'Copiar';

  @override
  String get count => 'Cuenta';

  @override
  String get crypto => 'Crypto';

  @override
  String get currency => 'Moneda';

  @override
  String get currentPassword => 'Current password';

  @override
  String get custom => 'Personalizado';

  @override
  String get customSend => 'Use Custom Send';

  @override
  String get customSendSettings => 'Custom Send Settings';

  @override
  String get dark => 'Noche';

  @override
  String get databasePassword => 'Database Password';

  @override
  String get databaseRestored => 'Database Restored';

  @override
  String get date => 'Fecha';

  @override
  String get datetime => 'Fecha/Hora';

  @override
  String get deductFee => 'Deduct fee from amount';

  @override
  String get defaultMemo => 'Nota';

  @override
  String get delete => 'ELIMINAR';

  @override
  String deleteAccount(Object name) {
    return 'Borrar Cuenta';
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
  String get editContact => 'Editar contacto';

  @override
  String get encryptDatabase => 'Encrypt Database';

  @override
  String get encryptionKey => 'Clave de encriptación';

  @override
  String get error => 'ERROR';

  @override
  String get external => 'External';

  @override
  String get fee => 'Fee';

  @override
  String get fromPool => 'Del Suministro';

  @override
  String get fromto => 'Rem/Dest.';

  @override
  String get fullBackup => 'Copia completa';

  @override
  String get fullRestore => 'Restauración de la copia de seguridad completada';

  @override
  String get gapLimit => 'Brecha';

  @override
  String get general => 'General';

  @override
  String get height => 'Altura';

  @override
  String get help => 'Ayuda';

  @override
  String get hidden => 'Hidden';

  @override
  String get high => 'Alto';

  @override
  String get history => 'Historial';

  @override
  String get import => 'Importar';

  @override
  String get includeReplyTo => 'Incluir mi dirección en el memo';

  @override
  String get incomingFunds => 'Pago recibido';

  @override
  String get index => 'Index';

  @override
  String get interval => 'Interval';

  @override
  String get invalidAddress => 'La Dirección no es válida';

  @override
  String get invalidKey => 'Tecla inválida';

  @override
  String get invalidPassword => 'Invalid Password';

  @override
  String get invalidPaymentURI => 'Invalid Payment URI';

  @override
  String get key => 'Clave';

  @override
  String get keyTool => 'Clave Utilidad';

  @override
  String get keygen => 'Backup Keygen';

  @override
  String get keygenHelp => 'Full backups use the AGE encryption system. The encryption key is used to encrypt the backup but CANNOT decrypt it. The SECRET key is needed to restore the backup.\nThe app will not store the keys. Every time this keygen will produce a DIFFERENT pair of keys.\n\nYou MUST save BOTH keys that you use';

  @override
  String get largestSpendingsByAddress => 'Pagos más grandes por dirección';

  @override
  String get ledger => 'Ledger';

  @override
  String get light => 'Día';

  @override
  String get list => 'List';

  @override
  String get loading => 'Cargando...';

  @override
  String get low => 'Bajo';

  @override
  String get mainUA => 'Main UA Receivers';

  @override
  String get market => 'Market';

  @override
  String get marketPrice => 'Mkt Prices';

  @override
  String get max => 'MAX';

  @override
  String get maxAmountPerNote => 'Monto máximo por nota';

  @override
  String get medium => 'Medio';

  @override
  String get memo => 'Nota';

  @override
  String get memoTooLong => 'Memo too long';

  @override
  String get message => 'Mensaje';

  @override
  String get messages => 'Mensajes';

  @override
  String get minPrivacy => 'Privacidad Mínima';

  @override
  String get mode => 'Advanced Mode';

  @override
  String get more => 'More';

  @override
  String get multiPay => 'Multi-Pagos';

  @override
  String get na => 'N/A';

  @override
  String get name => 'Nombre';

  @override
  String get nan => 'Not a number';

  @override
  String get netOrchard => 'Net Orchard Change';

  @override
  String get netSapling => 'Net Sapling Change';

  @override
  String get newAccount => 'Nueva cuenta';

  @override
  String get newPassword => 'New Password';

  @override
  String get newPasswordsDoNotMatch => 'New passwords do not match';

  @override
  String get next => 'Next';

  @override
  String get noAuthenticationMethod => 'Sin método de autenticación';

  @override
  String get noDbPassword => 'Database must be encrypted to protect open/spend';

  @override
  String get noRemindBackup => 'Do not remind me';

  @override
  String get notEnoughBalance => 'Saldo insuficiente';

  @override
  String get notes => 'Notas';

  @override
  String get now => 'Ahora';

  @override
  String get off => 'Off';

  @override
  String get ok => 'OK';

  @override
  String get openInExplorer => 'Abrir en el Explorador';

  @override
  String get or => 'or';

  @override
  String get orchard => 'Orchard';

  @override
  String get orchardInput => 'Orchard Input';

  @override
  String get paymentMade => 'Pago enviado';

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
  String get pools => 'Transferir Suministros';

  @override
  String get prev => 'Prev';

  @override
  String get priv => 'Privacy';

  @override
  String privacy(Object level) {
    return 'PRIVACIDAD: $level';
  }

  @override
  String get privacyLevelTooLow => 'Nivel de Privacidad muy BAJO';

  @override
  String get privateKey => 'Clave Privada';

  @override
  String get protectOpen => 'Bloquer al abrir';

  @override
  String get protectSend => 'Autenticar al enviar';

  @override
  String get publicKey => 'Public Key';

  @override
  String get qr => 'QR Code';

  @override
  String get rawTransaction => 'Transacción con Firmar';

  @override
  String receive(Object ticker) {
    return 'Recibir $ticker';
  }

  @override
  String received(Object amount, Object ticker) {
    return 'Recibido $amount $ticker';
  }

  @override
  String get receivers => 'Receivers';

  @override
  String get recipient => 'Destinatario';

  @override
  String get repeatNewPassword => 'Repeat New Password';

  @override
  String get reply => 'Responder';

  @override
  String get replyUA => 'Reply UA Receivers';

  @override
  String get required => 'Value Required';

  @override
  String get rescan => 'Escanear';

  @override
  String get rescanFrom => '¿Escanear desde...?';

  @override
  String get rescanWarning => 'RESCAN resets all your accounts. You may want to consider using REWIND instead';

  @override
  String get reset => 'Restablecer';

  @override
  String get restart => 'Reiniciar';

  @override
  String get restore => 'Restore';

  @override
  String get restoreAnAccount => '¿Restaurar una Cuenta?';

  @override
  String get retrieveTransactionDetails => 'Obtener detalles de la transacción';

  @override
  String get rewind => 'Rewind';

  @override
  String get sapling => 'Sapling';

  @override
  String get saplingInput => 'Sapling Input';

  @override
  String get save => 'Guardar';

  @override
  String get scanQrCode => 'Escanear Código QR';

  @override
  String get scanRawTx => 'Scan the Unsigned Tx QR codes';

  @override
  String get scanSignedTx => 'Scan the Signed Tx QR codes';

  @override
  String get secretKey => 'Clave secreta';

  @override
  String get secured => 'Secured';

  @override
  String get seed => 'Semilla';

  @override
  String get seedKeys => 'Seed & Keys';

  @override
  String get seedOrKeyRequired => 'Seed or Private Key required';

  @override
  String get selectNotesToExcludeFromPayments => 'Seleccionar Notas a EXCLUIR de los pagos';

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
  String get sending => 'Sending Transaction';

  @override
  String get sent => 'Transaction Sent';

  @override
  String get sent_failed => 'Transaction Failed';

  @override
  String get server => 'Servidor';

  @override
  String get set => 'Utilizar';

  @override
  String get settings => 'Ajustes';

  @override
  String get shielded => 'Shielded';

  @override
  String get showSubKeys => 'Show Sub Keys';

  @override
  String get sign => 'Firmar';

  @override
  String get signOffline => 'Firmar';

  @override
  String get signedTx => 'Tx firmada';

  @override
  String get source => 'Source';

  @override
  String get spendable => 'Disponible';

  @override
  String spent(Object amount, Object ticker) {
    return 'Enviado $amount $ticker';
  }

  @override
  String get subject => 'Asunto';

  @override
  String get sweep => 'Barrer';

  @override
  String get sync => 'Synchronization';

  @override
  String get syncPaused => 'Escaneo en pausa';

  @override
  String get table => 'Lista';

  @override
  String get template => 'Plantilla';

  @override
  String textCopiedToClipboard(Object text) {
    return '$text copiado al portapapeles';
  }

  @override
  String get thePrivateWalletMessenger => 'Billetera & Mensajería Privada';

  @override
  String get theme => 'Tema';

  @override
  String get thisAccountAlreadyExists => 'Esta cuenta ya existe.';

  @override
  String get timestamp => 'Fecha/Hora';

  @override
  String get toPool => 'Para Suministro';

  @override
  String get tools => 'Tools';

  @override
  String get totalBalance => 'Saldo Total';

  @override
  String get transactionDetails => 'Detalles de la transacción';

  @override
  String get transactionHistory => 'Historial de transacciones';

  @override
  String get transactions => 'Transacciónes';

  @override
  String get transfer => 'Transferir';

  @override
  String get transparent => 'Transparent';

  @override
  String get transparentInput => 'Transparent Input';

  @override
  String get transparentKey => 'Transparente Clavo';

  @override
  String get txID => 'TXID';

  @override
  String txId(Object txid) {
    return 'TX ID: $txid';
  }

  @override
  String get txPlan => 'Transaction Plan';

  @override
  String get ua => 'UA';

  @override
  String get unifiedViewingKey => 'Clave de visualización Unidad';

  @override
  String get unsignedTx => 'Tx no firmada';

  @override
  String get update => 'Recalcular';

  @override
  String get useZats => 'Use Zats (8 decimals)';

  @override
  String get version => 'Versión';

  @override
  String get veryLow => 'Muy Bajo';

  @override
  String get viewingKey => 'Clave de visualización';

  @override
  String get views => 'Views';

  @override
  String get welcomeToYwallet => 'Bienvenido a YWallet';

  @override
  String get wifi => 'WiFi';
}
