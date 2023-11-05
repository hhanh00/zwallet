import 'messages.dart';

/// The translations for Spanish Castilian (`es`).
class SEs extends S {
  SEs([String locale = 'es']) : super(locale);

  @override
  String get version => 'Versión';

  @override
  String get about => 'Acerca';

  @override
  String get ok => 'OK';

  @override
  String get account => 'Cuenta';

  @override
  String get notes => 'Notas';

  @override
  String get history => 'Historial';

  @override
  String get budget => 'Presupuesto';

  @override
  String get tradingPl => 'Intercambio G&P';

  @override
  String get contacts => 'Contactos';

  @override
  String get accounts => 'Cuentas';

  @override
  String get backup => 'Copia de seguridad';

  @override
  String get rescan => 'Escanear';

  @override
  String get catchup => 'Catch up';

  @override
  String get coldStorage => 'Billetera fría';

  @override
  String get multipay => 'Multi-Pagos';

  @override
  String get broadcast => 'Transmisión';

  @override
  String get settings => 'Ajustes';

  @override
  String get synching => 'Sincronizando';

  @override
  String get tapQrCodeForShieldedAddress => 'Toca el QR para Dirección blindada';

  @override
  String get tapQrCodeForTransparentAddress => 'Toca el QR para Dirección transparente';

  @override
  String get addressCopiedToClipboard => 'Dirección copiada al portapapeles';

  @override
  String get shieldTransparentBalance => 'Blindar saldo transparente';

  @override
  String doYouWantToTransferYourEntireTransparentBalanceTo(Object ticker) {
    return '¿Quiere transferir su saldo transparente a su dirección blindada? ';
  }

  @override
  String get shieldingInProgress => 'Blindaje en progreso…';

  @override
  String txId(Object txid) {
    return 'TX ID: $txid';
  }

  @override
  String get txID => 'TXID';

  @override
  String get pleaseAuthenticateToShowAccountSeed => 'Autentíquese para ver la semilla de la cuenta';

  @override
  String get noAuthenticationMethod => 'Sin método de autenticación';

  @override
  String get rescanFrom => '¿Escanear desde...?';

  @override
  String get cancel => 'Cancelar';

  @override
  String rescanRequested(Object height) {
    return 'Escaneo solicitado desde $height…';
  }

  @override
  String get doYouWantToDeleteTheSecretKeyAndConvert => '¿Quiere BORRAR la clave secreta y convertir esta cuenta a solo lectura? Ya no podrá gastar desde este dispositivo. Esta operación NO es reversible.';

  @override
  String get delete => 'ELIMINAR';

  @override
  String get confs => 'Confir';

  @override
  String get height => 'Altura';

  @override
  String get datetime => 'Fecha/Hora';

  @override
  String get amount => 'Monto';

  @override
  String get selectNotesToExcludeFromPayments => 'Seleccionar Notas a EXCLUIR de los pagos';

  @override
  String get largestSpendingsByAddress => 'Pagos más grandes por dirección';

  @override
  String get tapChartToToggleBetweenAddressAndAmount => 'Tocar gráfica para alternar entre dirección y cantidad';

  @override
  String get accountBalanceHistory => 'Historial de la cuenta';

  @override
  String get noSpendingInTheLast30Days => 'Sin pagos en 30 días';

  @override
  String get largestSpendingLastMonth => 'Principales pagos del último mes';

  @override
  String get balance => 'Saldo';

  @override
  String get pnl => 'G&P';

  @override
  String get mm => 'M/M';

  @override
  String get total => 'Total';

  @override
  String get price => 'Precio';

  @override
  String get qty => 'Cantidad';

  @override
  String get table => 'Lista';

  @override
  String get pl => 'G/P';

  @override
  String get realized => 'Realizado';

  @override
  String get toMakeAContactSendThemAMemoWithContact => 'Para contactar, enviar un memo con \'Contact:\'';

  @override
  String get newSnapAddress => 'Nueva Dirección instantánea';

  @override
  String get shieldTranspBalance => 'Blindar Saldo transp.';

  @override
  String get send => 'Enviar';

  @override
  String get noAccount => 'Sin Cuenta';

  @override
  String get seed => 'Semilla';

  @override
  String get confirmDeleteAccount => '¿Está SEGURO de que desea BORRAR esta cuenta? DEBE tener una COPIA DE SEGURIDAD para recuperarla. Esta operación NO es reversible.';

  @override
  String get confirmDeleteContact => 'Are you SURE you want to DELETE this contact?';

  @override
  String get changeAccountName => 'Cambiar nombre de la cuenta';

  @override
  String backupDataRequiredForRestore(Object name) {
    return 'Copia de seguridad - $name - Requerida para restaurar';
  }

  @override
  String get secretKey => 'Clave secreta';

  @override
  String get publicKey => 'Public Key';

  @override
  String get viewingKey => 'Clave de visualización';

  @override
  String get tapAnIconToShowTheQrCode => 'Tocar el icono para mostrar el código QR';

  @override
  String get multiPay => 'Multi-Pagos';

  @override
  String get pleaseConfirm => 'Por favor, confirmar';

  @override
  String sendingATotalOfAmountCointickerToCountRecipients(Object amount, Object count, Object ticker) {
    return 'Enviando un total de $amount $ticker a $count direcciones';
  }

  @override
  String get preparingTransaction => 'Preparando la transacción…';

  @override
  String sendCointickerTo(Object ticker) {
    return 'Enviar $ticker a…';
  }

  @override
  String get addressIsEmpty => 'La Dirección está vacía';

  @override
  String get invalidAddress => 'La Dirección no es válida';

  @override
  String get amountMustBeANumber => 'La cantidad debe ser un número';

  @override
  String get amountMustBePositive => 'La cantidad debe ser positiva';

  @override
  String get accountName => 'Nombre de la cuenta';

  @override
  String get accountNameIsRequired => 'Se requiere el nombre de la cuenta';

  @override
  String get enterSeed => 'Ingrese la Semilla, Clave secreta o Clave de visualización. Dejar en blanco para una nueva cuenta';

  @override
  String get scanStartingMomentarily => 'Escaneo iniciado momentáneamente';

  @override
  String get key => 'Clave';

  @override
  String sendCointicker(Object ticker) {
    return 'Enviar $ticker';
  }

  @override
  String get max => 'MAX';

  @override
  String get advancedOptions => 'Opciones Avanzadas';

  @override
  String get memo => 'Nota';

  @override
  String get roundToMillis => 'Redondear a milésimas';

  @override
  String useSettingscurrency(Object currency) {
    return 'Utilizar $currency';
  }

  @override
  String get includeFeeInAmount => 'Incluir comisión en la cantidad';

  @override
  String get maxAmountPerNote => 'Monto máximo por nota';

  @override
  String get spendable => 'Disponible';

  @override
  String get notEnoughBalance => 'Saldo insuficiente';

  @override
  String get approve => 'APROBAR';

  @override
  String sendingAzecCointickerToAddress(Object aZEC, Object address, Object ticker) {
    return 'Enviado $aZEC $ticker a $address';
  }

  @override
  String get unsignedTransactionFile => 'Archivo de transacción sin firmar';

  @override
  String amountInSettingscurrency(Object currency) {
    return 'Cantidad en $currency';
  }

  @override
  String get custom => 'Personalizado';

  @override
  String get server => 'Servidor';

  @override
  String get blue => 'Azul';

  @override
  String get pink => 'Rosado';

  @override
  String get coffee => 'Café';

  @override
  String get light => 'Día';

  @override
  String get dark => 'Noche';

  @override
  String get currency => 'Moneda';

  @override
  String get numberOfConfirmationsNeededBeforeSpending => 'Número de confirmaciones necesarias antes de gastar';

  @override
  String get retrieveTransactionDetails => 'Obtener detalles de la transacción';

  @override
  String get theme => 'Tema';

  @override
  String get transactionDetails => 'Detalles de la transacción';

  @override
  String get timestamp => 'Fecha/Hora';

  @override
  String get address => 'Dirección';

  @override
  String get openInExplorer => 'Abrir en el Explorador';

  @override
  String get restore => 'Restore';

  @override
  String get na => 'N/A';

  @override
  String get add => 'Agregar';

  @override
  String get tradingChartRange => 'Rango del gráfico';

  @override
  String get m1 => '1 M';

  @override
  String get m3 => '3 M';

  @override
  String get m6 => '6 M';

  @override
  String get y1 => '1 Y';

  @override
  String get shieldTransparentBalanceWithSending => 'Shield Transparent Balance When Sending';

  @override
  String get useUa => 'Usar DU';

  @override
  String get createANewAccount => 'Crea una nueva cuenta y aparecerá aquí.';

  @override
  String get duplicateAccount => 'Cuenta duplicada';

  @override
  String get thisAccountAlreadyExists => 'Esta cuenta ya existe.';

  @override
  String get selectAccount => 'Seleccionar cuenta';

  @override
  String get nameIsEmpty => 'Nombre vacío';

  @override
  String get deleteContact => 'Borrar contacto';

  @override
  String get areYouSureYouWantToDeleteThisContact => '¿Estás seguro de que deseas eliminar este contacto?';

  @override
  String get saveToBlockchain => 'Guardar en la blockchain?';

  @override
  String areYouSureYouWantToSaveYourContactsIt(Object ticker) {
    return '¿Estás seguro de que quieres guardar tus contactos? Costará 0,01 mZEC ';
  }

  @override
  String get confirmSaveContacts => 'Are you sure you want to save your contacts?';

  @override
  String get backupWarning => 'Nadie puede recuperar sus claves secretas. Si no tiene una copia de seguridad, PERDERÁ SU DINERO si su teléfono se avería. Puede acceder a esta página mediante el menú de la aplicación y luego \'Copia de Seguridad\'';

  @override
  String get contactName => 'Nombre del contacto';

  @override
  String get date => 'Fecha';

  @override
  String get duplicateContact => 'Another contact has this address';

  @override
  String get autoHideBalance => 'Ocultar saldo';

  @override
  String get tiltYourDeviceUpToRevealYourBalance => 'Incline su dispositivo hacia arriba para revelar su saldo';

  @override
  String get noContacts => 'Sin Contactos';

  @override
  String get createANewContactAndItWillShowUpHere => 'Crea un contacto y aparecerá aquí.';

  @override
  String get addContact => 'Agregar Contacto';

  @override
  String get accountHasSomeBalanceAreYouSureYouWantTo => 'La cuenta tiene un saldo. ¿Estás seguro de que quieres eliminarlo?';

  @override
  String get deleteAccount => 'Borrar Cuenta';

  @override
  String get gold => 'Oro';

  @override
  String get purple => 'Morado';

  @override
  String get noRecipient => 'Sin Destinatario';

  @override
  String get addARecipientAndItWillShowHere => 'Agregar un destinatario y se mostrará aquí';

  @override
  String get receivePayment => 'Recibir un pago';

  @override
  String get amountTooHigh => 'Cantidad demasiado alta';

  @override
  String get protectSend => 'Autenticar al enviar';

  @override
  String get protectSendSettingChanged => 'La configuración de Autenticar al enviar ha cambiado';

  @override
  String get pleaseAuthenticateToSend => 'Por favor autentíquese para enviar';

  @override
  String get unshielded => 'Sin blindaje';

  @override
  String get unshieldedBalance => 'Saldo sin blindaje';

  @override
  String get totalBalance => 'Saldo Total';

  @override
  String get underConfirmed => 'Confirmaciones insuficiente';

  @override
  String get excludedNotes => 'Notas excluidas';

  @override
  String get spendableBalance => 'Saldo disponible';

  @override
  String get rescanNeeded => 'Necesita escanear';

  @override
  String get tapTransactionForDetails => 'Toca una Transacción para ver detalles';

  @override
  String get transactionHistory => 'Historial de transacciones';

  @override
  String get help => 'Ayuda';

  @override
  String receive(Object ticker) {
    return 'Recibir $ticker';
  }

  @override
  String get pnlHistory => 'Historia de G&P';

  @override
  String get useTransparentBalance => 'Usar saldo transp.';

  @override
  String get themeEditor => 'Editor de temas';

  @override
  String get color => 'Color';

  @override
  String get accentColor => 'Color de acento';

  @override
  String get primary => 'Primario';

  @override
  String get secondary => 'Secundario';

  @override
  String get multisig => 'Multi-firma';

  @override
  String get enterSecretShareIfAccountIsMultisignature => 'Introduzca la clave secreta si la cuenta es multi-firma';

  @override
  String get secretShare => 'Clave secreta';

  @override
  String get fileSaved => 'Archivo guardado';

  @override
  String numMoreSignersNeeded(Object num) {
    return '$num more signers needed';
  }

  @override
  String get sign => 'Firmar';

  @override
  String get splitAccount => 'Cuenta dividida';

  @override
  String get confirmSigning => 'Confirmar firma';

  @override
  String confirmSignATransactionToAddressFor(Object address, Object amount) {
    return 'Desea firmar una transacción a $address por $amount';
  }

  @override
  String get multisigShares => 'Acciones multi-firmas';

  @override
  String get copy => 'Copiar';

  @override
  String textCopiedToClipboard(Object text) {
    return '$text copiado al portapapeles';
  }

  @override
  String get multipleAddresses => 'Múltiples direcciones';

  @override
  String get addnew => 'AGREGAR';

  @override
  String get applicationReset => 'Restablecer la aplicación';

  @override
  String get confirmResetApp => '¿Seguro que quieres restablecer la aplicación? Sus cuentas NO serán eliminadas';

  @override
  String get reset => 'Restablecer';

  @override
  String get loading => 'Cargando...';

  @override
  String get restart => 'Reiniciar';

  @override
  String get pleaseQuitAndRestartTheAppNow => 'Please Quit and Restart the app in order for these changes to take effect';

  @override
  String get mode => 'Modo';

  @override
  String get simple => 'Básico';

  @override
  String get advanced => 'Avanzado';

  @override
  String sendFrom(Object app) {
    return 'Enviado desde $app';
  }

  @override
  String get defaultMemo => 'Nota';

  @override
  String get fullBackup => 'Copia completa';

  @override
  String get backupEncryptionKey => 'Clave de cifrado';

  @override
  String get saveBackup => 'Guardar copia de seguridad';

  @override
  String encryptedBackup(Object app) {
    return '$app Copia completa';
  }

  @override
  String get fullRestore => 'Restauración de la copia de seguridad completada';

  @override
  String get loadBackup => 'Respaldar copia de seguridad';

  @override
  String get backupAllAccounts => 'Copia de seguridad completa';

  @override
  String get simpleMode => 'Modo básico';

  @override
  String get accountIndex => 'Índice de cuenta';

  @override
  String subAccountOf(Object name) {
    return 'Subcuenta de $name';
  }

  @override
  String subAccountIndexOf(Object index, Object name) {
    return 'Subcuenta $index de $name';
  }

  @override
  String get newSubAccount => 'Nueva subcuenta';

  @override
  String get noActiveAccount => 'Sin cuenta activa';

  @override
  String get closeApplication => 'Cierra la aplicación';

  @override
  String get disconnected => 'Desconectado';

  @override
  String get ledger => 'Ledger';

  @override
  String get mobileCharges => 'Con datos móviles, el escaneo puede incurrir en cargos adicionales. ¿Quieres proceder?';

  @override
  String get iHaveMadeABackup => 'He hecho una copia de seguridad';

  @override
  String get barcodeScannerIsNotAvailableOnDesktop => 'El escáner de código de barras no está disponible en el escritorio';

  @override
  String get signOffline => 'Firmar';

  @override
  String get rawTransaction => 'Transacción con Firmar';

  @override
  String get convertToWatchonly => 'Convertir en solo vista';

  @override
  String get messages => 'Mensajes';

  @override
  String get body => 'Cuerpo';

  @override
  String get subject => 'Asunto';

  @override
  String get includeReplyTo => 'Incluir mi dirección en el memo';

  @override
  String get sender => 'Remitente';

  @override
  String get message => 'Mensaje';

  @override
  String get reply => 'Responder';

  @override
  String get recipient => 'Destinatario';

  @override
  String get fromto => 'Rem/Dest.';

  @override
  String get rescanning => 'Escanear...';

  @override
  String get markAllAsRead => 'Marcar todo como leído';

  @override
  String get showMessagesAsTable => 'Mostrar mensajes como tabla';

  @override
  String get editContact => 'Editar contacto';

  @override
  String get now => 'Ahora';

  @override
  String get protectOpen => 'Bloquer al abrir';

  @override
  String get gapLimit => 'Brecha';

  @override
  String get error => 'ERROR';

  @override
  String get paymentInProgress => 'Pago en curso...';

  @override
  String get useQrForOfflineSigning => 'Usar QR para firmar sin conexión';

  @override
  String get unsignedTx => 'Tx no firmada';

  @override
  String get signOnYourOfflineDevice => 'Firmar con tu dispositivo fuera de línea';

  @override
  String get signedTx => 'Tx firmada';

  @override
  String get broadcastFromYourOnlineDevice => 'Transmite desde tu dispositivo en línea';

  @override
  String get checkTransaction => 'Verificar la transacción';

  @override
  String get crypto => 'Crypto';

  @override
  String get restoreAnAccount => '¿Restaurar una Cuenta?';

  @override
  String get welcomeToYwallet => 'Bienvenido a YWallet';

  @override
  String get thePrivateWalletMessenger => 'Billetera & Mensajería Privada';

  @override
  String get newAccount => 'Nueva cuenta';

  @override
  String get invalidKey => 'Tecla inválida';

  @override
  String get barcode => 'Código de barras';

  @override
  String get inputBarcodeValue => 'Escriba el Código de barras';

  @override
  String get auto => 'Auto';

  @override
  String get count => 'Cuenta';

  @override
  String get close => 'Cerrar';

  @override
  String get changeTransparentKey => 'Cambiar la clave transparente';

  @override
  String get cancelScan => 'Cancelar Escaneo';

  @override
  String get resumeScan => 'Reanudar Escaneo';

  @override
  String get syncPaused => 'Escaneo en pausa';

  @override
  String get derivationPath => 'Ruta de Derivación';

  @override
  String get privateKey => 'Clave Privada';

  @override
  String get keyTool => 'Clave Utilidad';

  @override
  String get update => 'Recalcular';

  @override
  String get antispamFilter => 'Anti-Spam Filter';

  @override
  String get doYouWantToRestore => '¿Desea restaurar la base de datos? ¡ESTO BORRARÁ SUS DATOS ACTUALES!';

  @override
  String get useGpu => 'Utilizar GPU';

  @override
  String get import => 'Importar';

  @override
  String get newLabel => 'Nueva';

  @override
  String invalidQrCode(Object message) {
    return 'QR inválido: $message';
  }

  @override
  String get expert => 'Modo Experto';

  @override
  String blockReorgDetectedRewind(Object rewindHeight) {
    return 'Se ha detectado una reorganización de la blockchain. Rebobinar hasta $rewindHeight';
  }

  @override
  String get goToTransaction => 'Ver Transacción';

  @override
  String get transactions => 'Transacciónes';

  @override
  String get synchronizationInProgress => 'Sincronización en progreso';

  @override
  String get incomingFunds => 'Pago recibido';

  @override
  String get paymentMade => 'Pago enviado';

  @override
  String received(Object amount, Object ticker) {
    return 'Recibido $amount $ticker';
  }

  @override
  String spent(Object amount, Object ticker) {
    return 'Enviado $amount $ticker';
  }

  @override
  String get set => 'Utilizar';

  @override
  String get encryptionKey => 'Clave de encriptación';

  @override
  String get dbImportSuccessful => 'Importación exitosa';

  @override
  String get pools => 'Transferir Suministros';

  @override
  String get poolTransfer => 'Pool Transfer';

  @override
  String get fromPool => 'Del Suministro';

  @override
  String get toPool => 'Para Suministro';

  @override
  String maxSpendableAmount(Object amount, Object ticker) {
    return 'Max Gastable: $amount $ticker';
  }

  @override
  String get splitNotes => 'Dividar Billetes';

  @override
  String get transfer => 'Transferir';

  @override
  String get template => 'Plantilla';

  @override
  String get newTemplate => 'Nueva plantilla';

  @override
  String get name => 'Nombre';

  @override
  String get deleteTemplate => 'Eliminar plantilla?';

  @override
  String get areYouSureYouWantToDeleteThisSendTemplate => '¿Está seguro de que desea eliminar esta plantilla de envío?';

  @override
  String get rewindToCheckpoint => 'Rebobinar';

  @override
  String get selectCheckpoint => 'Seleccionar Fetcha/Altura';

  @override
  String get scanQrCode => 'Escanear Código QR';

  @override
  String get minPrivacy => 'Privacidad Mínima';

  @override
  String get privacyLevelTooLow => 'Nivel de Privacidad muy BAJO';

  @override
  String get veryLow => 'Muy Bajo';

  @override
  String get low => 'Bajo';

  @override
  String get medium => 'Medio';

  @override
  String get high => 'Alto';

  @override
  String privacy(Object level) {
    return 'PRIVACIDAD: $level';
  }

  @override
  String get save => 'Guardar';

  @override
  String get signingPleaseWait => 'Firmando';

  @override
  String get sweep => 'Barrer';

  @override
  String get transparentKey => 'Transparente Clavo';

  @override
  String get unifiedViewingKey => 'Clave de visualización Unidad';

  @override
  String get encryptDatabase => 'Encrypt Database';

  @override
  String get currentPassword => 'Current password';

  @override
  String get newPassword => 'New Password';

  @override
  String get repeatNewPassword => 'Repeat New Password';

  @override
  String get databasePassword => 'Database Password';

  @override
  String get currentPasswordIncorrect => 'Current password incorrect';

  @override
  String get newPasswordsDoNotMatch => 'New passwords do not match';

  @override
  String get databaseEncrypted => 'Database Encrypted. Please Restart the App.';

  @override
  String get invalidPassword => 'Invalid Password';

  @override
  String get databaseRestored => 'Database Restored';

  @override
  String get never => 'Never';

  @override
  String get always => 'Always';

  @override
  String get scanTransparentAddresses => 'Scan Transparent Addresses';

  @override
  String get scanningAddresses => 'Scanning addresses';

  @override
  String get blockExplorer => 'Block Explorer';

  @override
  String get tapQrCodeForSaplingAddress => 'Tap QR Code for Sapling Address';

  @override
  String get playSound => 'Sonido';

  @override
  String get fee => 'Fee';

  @override
  String get coins => 'Coins';

  @override
  String get rewind => 'Rewind';

  @override
  String get more => 'More';

  @override
  String get or => 'or';

  @override
  String get marketPrice => 'Historical Prices';

  @override
  String get txPlan => 'Transaction Plan';

  @override
  String get pool => 'Pool';

  @override
  String get transparentInput => 'Transparent Input';

  @override
  String get saplingInput => 'Sapling Input';

  @override
  String get orchardInput => 'Orchard Input';

  @override
  String get netSapling => 'Net Sapling Change';

  @override
  String get netOrchard => 'Net Orchard Change';

  @override
  String get transparent => 'Transparent';

  @override
  String get sapling => 'Sapling';

  @override
  String get orchard => 'Orchard';

  @override
  String get paymentURI => 'Payment URI';

  @override
  String get lastPayment => 'Repeat Last Payment';

  @override
  String get next => 'Next';

  @override
  String get prev => 'Prev';

  @override
  String get nan => 'Not a number';

  @override
  String get memoTooLong => 'Memo too long';

  @override
  String get sending => 'Sending Transaction';

  @override
  String get sent => 'Transaction Sent';

  @override
  String get sent_failed => 'Transaction Failed';

  @override
  String get invalidPaymentURI => 'Invalid Payment URI';

  @override
  String get noSelection => 'Nothing Selected';

  @override
  String get confirmations => 'Min. Confirmations';

  @override
  String get hidden => 'Hidden';

  @override
  String get autoHide => 'Auto Hide';

  @override
  String get shown => 'Shown';

  @override
  String get useZats => 'Use Zats (8 decimals)';

  @override
  String get mainUA => 'Main UA Receivers';

  @override
  String get replyUA => 'Reply UA Receivers';

  @override
  String get uaReceivers => 'UA Receivers';

  @override
  String get list => 'List';

  @override
  String get autoView => 'Orientation';

  @override
  String get general => 'General';

  @override
  String get priv => 'Privacy';

  @override
  String get views => 'Views';

  @override
  String get autoFee => 'Automatic Fee';

  @override
  String get accountManager => 'Account Manager';

  @override
  String get pleaseWaitPlan => 'Computing Transaction';

  @override
  String get deletePayment => 'Are you sure you want to delete this recipient';

  @override
  String get ua => 'UA';

  @override
  String get receivers => 'Receivers';

  @override
  String get secured => 'Secured';

  @override
  String get external => 'External';

  @override
  String get derpath => 'Derivation Path';

  @override
  String get shielded => 'Shielded';

  @override
  String get addressIndex => 'Address Index';

  @override
  String get index => 'Index';

  @override
  String get pleaseAuthenticate => 'Please Authenticate';

  @override
  String get diversified => 'Diversified';

  @override
  String get source => 'Source';

  @override
  String get destination => 'Destination';

  @override
  String get scanRawTx => 'Scan the Unsigned Tx QR codes';

  @override
  String get scanSignedTx => 'Scan the Signed Tx QR codes';
}
