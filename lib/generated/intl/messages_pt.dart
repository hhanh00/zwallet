import 'messages.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class SPt extends S {
  SPt([String locale = 'pt']) : super(locale);

  @override
  String get about => 'Sobre';

  @override
  String get account => 'Conta';

  @override
  String get accountBalanceHistory => 'Histórico do Saldo da Conta';

  @override
  String get accountIndex => 'Índice da Conta';

  @override
  String get accountManager => 'Gerente de Conta';

  @override
  String get accountName => 'Nome da Conta';

  @override
  String get accounts => 'Contas';

  @override
  String get add => 'Adicionar';

  @override
  String get addContact => 'Adicionar contacto';

  @override
  String get address => 'Endereço';

  @override
  String get addressCopiedToClipboard => 'Endereço copiado para área de transferência';

  @override
  String get addressIndex => 'Índice de endereço';

  @override
  String get addressIsEmpty => 'Endereço vazio';

  @override
  String get amount => 'Quantidade';

  @override
  String get amountCurrency => 'Valor em Fiat';

  @override
  String get amountMustBePositive => 'O valor deve ser positivo';

  @override
  String get amountSlider => 'Quantidade de controle deslizante';

  @override
  String get antispamFilter => 'Filtro Anti-Spam';

  @override
  String get any => 'Qualquer';

  @override
  String get appData => 'Dados do aplicativo';

  @override
  String get auto => 'Automático';

  @override
  String get autoFee => 'Taxa Automática';

  @override
  String get autoHide => 'Ocultar automaticamente';

  @override
  String get autoHideBalance => 'Ocultar Saldo';

  @override
  String get autoView => 'Orientação';

  @override
  String get backgroundSync => 'Sincronização de fundo';

  @override
  String get backup => 'Backup';

  @override
  String get backupAllAccounts => 'Cópia de Todas as Contas';

  @override
  String get backupMissing => 'MISSÃO DO BACKUP';

  @override
  String get balance => 'Saldo';

  @override
  String get barcode => 'Código de Barras';

  @override
  String get blockExplorer => 'Explorador de Bloco';

  @override
  String get body => 'Conteúdo';

  @override
  String get broadcast => 'Transmissão';

  @override
  String get budget => 'Orçamento';

  @override
  String get cancel => 'Cancelar';

  @override
  String get cannotDeleteActive => 'Não é possível excluir a conta ativa a menos que seja a última';

  @override
  String get cannotUseTKey => 'Não é possível importar uma chave privada transparente. Use SWEEP em vez disso';

  @override
  String get catchup => 'Capturar até';

  @override
  String get close => 'Fechar';

  @override
  String get coldStorage => 'Armazenamento Frio';

  @override
  String get configure => 'Configurar';

  @override
  String get confirmDeleteAccount => 'Você tem CERTEZA que deseja EXCLUIR esta conta? Você PRECISA ter um BACKUP para recuperá-la. Esta operação NÃO é reversível.';

  @override
  String get confirmDeleteContact => 'Você tem CERTEZA que quer EXCLUIR este contato?';

  @override
  String confirmRescanFrom(Object height) {
    return 'Você quer reescanear do bloco $height?';
  }

  @override
  String confirmRewind(Object height) {
    return 'Você quer retroceder para bloquear $height?';
  }

  @override
  String get confirmSaveContacts => 'Você tem certeza que deseja salvar seus contatos?';

  @override
  String get confirmSaveKeys => 'Você salvou suas chaves?';

  @override
  String get confirmWatchOnly => 'Você deseja EXCLUIR a chave secreta e converter essa conta em uma conta somente watch? Você não poderá mais gastar deste dispositivo. Esta operação NÃO é reversível.';

  @override
  String get confirmations => 'Mín. Confirmações';

  @override
  String get confs => 'Conf.';

  @override
  String get connectionError => 'DESCONECTADO';

  @override
  String get contactName => 'Nome do contato';

  @override
  String get contacts => 'Contatos';

  @override
  String get convertToWatchonly => 'Apenas para Watch-';

  @override
  String get copiedToClipboard => 'Copiar para Área de Transferência';

  @override
  String get copy => 'copiar';

  @override
  String get count => 'Quantidade';

  @override
  String get crypto => 'Crypto';

  @override
  String get currency => 'moeda';

  @override
  String get currentPassword => 'Palavra-passe Atual';

  @override
  String get custom => 'Personalizado';

  @override
  String get customSend => 'Usar um envio personalizado';

  @override
  String get customSendSettings => 'Configurações de envio personalizado';

  @override
  String get dark => 'Escuro';

  @override
  String get databasePassword => 'Senha do banco';

  @override
  String get databaseRestored => 'Banco de dados restaurado';

  @override
  String get date => 'Encontro';

  @override
  String get datetime => 'Data/Hora';

  @override
  String get deductFee => 'Deduzir taxa a partir do valor';

  @override
  String get defaultMemo => 'Memo Padrão';

  @override
  String get delete => 'EXCLUIR';

  @override
  String deleteAccount(Object name) {
    return 'Excluir Conta $name';
  }

  @override
  String get deletePayment => 'Tem certeza de que deseja excluir este destinatário';

  @override
  String get derpath => 'Caminho de derivação';

  @override
  String get destination => 'Destino';

  @override
  String get disclaimer => 'Renúncia';

  @override
  String get disclaimerText => 'SEF-CUSTODADE';

  @override
  String get disclaimer_1 => 'Eu entendo que sou responsável por proteger minha seed phrase';

  @override
  String get disclaimer_2 => 'Eu entendo que o YWallet não pode recuperar minha semente';

  @override
  String get disclaimer_3 => 'Eu entendo quem sabe minha seed phrase pode receber meus fundos';

  @override
  String get diversified => 'Diversificado';

  @override
  String get editContact => 'Editar contato';

  @override
  String get encryptDatabase => 'Criptografar base de dados';

  @override
  String get encryptionKey => 'Chave de Criptografia';

  @override
  String get error => 'ERRO';

  @override
  String get change => 'Change';

  @override
  String get fee => 'Tarifa';

  @override
  String get fromPool => 'Da Piscina';

  @override
  String get fromto => 'De/Para';

  @override
  String get fullBackup => 'Backup completo';

  @override
  String get fullRestore => 'Restauração completa';

  @override
  String get gapLimit => 'Limite de fractura';

  @override
  String get general => 'Gerais';

  @override
  String get height => 'Altura';

  @override
  String get help => 'Socorro';

  @override
  String get hidden => 'Ocultas';

  @override
  String get high => 'Alta';

  @override
  String get history => 'Histórico';

  @override
  String get import => 'Importação';

  @override
  String get includeReplyTo => 'Incluir Meu Endereço em Lembrete';

  @override
  String get incomingFunds => 'Fundos recebidos';

  @override
  String get index => 'Indexação';

  @override
  String get interval => 'Intervalo';

  @override
  String get invalidAddress => 'Endereço Inválido';

  @override
  String get invalidKey => 'Chave inválida';

  @override
  String get invalidPassword => 'Senha inválida';

  @override
  String get invalidPaymentURI => 'Pagamento URI inválido';

  @override
  String get key => 'Seed, Segredo ou Chave de Visualização (opcional)';

  @override
  String get keyTool => 'Ferramenta Chave';

  @override
  String get keygen => 'Chave de Backup';

  @override
  String get keygenHelp => 'Os backups completos usam o sistema de criptografia AGE. A chave de criptografia é usada para criptografar o backup, mas NÃO PODEM descriptografá-lo. A chave SECRET é necessária para restaurar o backup.\nO aplicativo não armazenará as chaves. Toda vez que este keygen produzir um par de chaves.\n\nVocê DEVE salvar as chaves BOTH que você usar';

  @override
  String get largestSpendingsByAddress => 'Maior pendências por endereço';

  @override
  String get ledger => 'Ledger';

  @override
  String get light => 'Fino';

  @override
  String get list => 'Lista';

  @override
  String get loading => 'Carregando...';

  @override
  String get low => 'Baixa';

  @override
  String get mainReceivers => 'Principais Receptores';

  @override
  String get market => 'Mercado';

  @override
  String get marketPrice => 'Preços';

  @override
  String get max => 'Máximo';

  @override
  String get maxAmountPerNote => 'Valor Máximo por Nota';

  @override
  String get medium => 'Média';

  @override
  String get memo => 'Lembrete';

  @override
  String get memoTooLong => 'Memorando muito longo';

  @override
  String get message => 'Mensagem';

  @override
  String get messages => 'Mensagens';

  @override
  String get minPrivacy => 'Privacidade Mínima';

  @override
  String get mode => 'Modo Avançado';

  @override
  String get more => 'Mais';

  @override
  String get multiPay => 'Pagamento múltiplo';

  @override
  String get na => 'N/D';

  @override
  String get name => 'Nome';

  @override
  String get nan => 'Não é um número';

  @override
  String get netOrchard => 'Variação de Orchard';

  @override
  String get netSapling => 'Variação de Sapling';

  @override
  String get newAccount => 'Nova conta';

  @override
  String get newPassword => 'Nova Palavra-Passe';

  @override
  String get newPasswordsDoNotMatch => 'As novas senhas não coincidem';

  @override
  String get next => 'Próximo';

  @override
  String get noAuthenticationMethod => 'Nenhum método de autenticação';

  @override
  String get noDbPassword => 'A base de dados deve ser criptografada para proteger aberto/gasto';

  @override
  String get noRemindBackup => 'Não me lembre';

  @override
  String get notEnoughBalance => 'Saldo insuficiente';

  @override
  String get notes => 'Notas';

  @override
  String get now => 'Agora';

  @override
  String get off => 'Desligado';

  @override
  String get ok => 'Certo';

  @override
  String get openInExplorer => 'Abrir no Explorer';

  @override
  String get or => 'ou';

  @override
  String get orchard => 'Orchard';

  @override
  String get orchardInput => 'Entrada de Orchard';

  @override
  String get paymentMade => 'Pagamento feito';

  @override
  String get paymentURI => 'URI do pagamento';

  @override
  String get ping => 'Teste de ping';

  @override
  String get pleaseAuthenticate => 'Por favor, autentique-se';

  @override
  String get pleaseQuitAndRestartTheAppNow => 'Por favor, saia e reinicie o aplicativo para que essas alterações entrem em vigor';

  @override
  String get pool => 'Banco';

  @override
  String get poolTransfer => 'Transferência de Banco';

  @override
  String get pools => 'Bancos';

  @override
  String get prev => 'Anterior';

  @override
  String get priv => 'Privacidade';

  @override
  String privacy(Object level) {
    return 'PRIVACIDADE: $level';
  }

  @override
  String get privacyLevelTooLow => 'Privacidade muito BAIXA - Pressione e segure para substituir';

  @override
  String get privateKey => 'Chave Privada';

  @override
  String get protectOpen => 'Proteger Aberto';

  @override
  String get protectSend => 'Proteger o Envio';

  @override
  String get publicKey => 'Chave Pública';

  @override
  String get qr => 'Código QR';

  @override
  String get rawTransaction => 'Transação em bruto';

  @override
  String receive(Object ticker) {
    return 'Receber $ticker';
  }

  @override
  String received(Object amount, Object ticker) {
    return 'Recebido $amount $ticker';
  }

  @override
  String get receivers => 'Receptores';

  @override
  String get recipient => 'Destinatário';

  @override
  String get repeatNewPassword => 'Repita a nova senha';

  @override
  String get reply => 'Responder';

  @override
  String get replyUA => 'Responder destinatários de UA';

  @override
  String get required => 'Valor Obrigatório';

  @override
  String get rescan => 'Reescanear';

  @override
  String get rescanFrom => 'Reescanear de...';

  @override
  String get rescanWarning => 'RESCAN redefine todas as suas contas. Você pode considerar usar REWIND';

  @override
  String get reset => 'Reset';

  @override
  String get restart => 'Reiniciar';

  @override
  String get restore => 'Restaurar';

  @override
  String get restoreAnAccount => 'Restaurar uma conta?';

  @override
  String get retrieveTransactionDetails => 'Recuperar detalhes da transação';

  @override
  String get rewind => 'Rebobinar';

  @override
  String get sapling => 'Sapling';

  @override
  String get saplingInput => 'Entrada de Sapling';

  @override
  String get save => 'Guardar';

  @override
  String get scanQrCode => 'Ler código QR';

  @override
  String get scanRawTx => 'Digitalize os códigos QR Tx não assinados';

  @override
  String get scanSignedTx => 'Escaneie os códigos QR Tx assinados';

  @override
  String get secretKey => 'Chave secreta';

  @override
  String get secured => 'Protegido';

  @override
  String get seed => 'Semente';

  @override
  String get seedKeys => 'Semente & Chaves';

  @override
  String get seedOrKeyRequired => 'É necessária uma chave privada ou de semente';

  @override
  String get selectNotesToExcludeFromPayments => 'Selecione notas para EXCLUDE dos pagamentos';

  @override
  String get send => 'Mandar';

  @override
  String sendCointicker(Object ticker) {
    return 'Enviar $ticker';
  }

  @override
  String sendFrom(Object app) {
    return 'Enviado de $app';
  }

  @override
  String get sender => 'Remetente';

  @override
  String get sending => 'Enviando transação';

  @override
  String get sent => 'Transação Enviada';

  @override
  String get sent_failed => 'Transação Falhou';

  @override
  String get server => 'Servidor';

  @override
  String get set => 'Definir';

  @override
  String get settings => 'Confirgurações';

  @override
  String get shielded => 'Protegido';

  @override
  String get showSubKeys => 'Mostrar subchaves';

  @override
  String get sign => 'Assinar a transação';

  @override
  String get signOffline => 'Assinar';

  @override
  String get signedTx => 'Tx Assinado';

  @override
  String get source => 'fonte';

  @override
  String get spendable => 'Gasto';

  @override
  String spent(Object amount, Object ticker) {
    return 'Gasto $amount $ticker';
  }

  @override
  String get subject => 'Cargo';

  @override
  String get sweep => 'Varredura';

  @override
  String get sync => 'Sincronização';

  @override
  String get syncPaused => 'PAUSADO - Toque para Retomar';

  @override
  String get table => 'Classificações';

  @override
  String get template => 'Modelo';

  @override
  String textCopiedToClipboard(Object text) {
    return '$text copiado para área de transferência';
  }

  @override
  String get thePrivateWalletMessenger => 'A carteira privada e mensageiro';

  @override
  String get theme => 'Tema';

  @override
  String get thisAccountAlreadyExists => 'Outra conta tem o mesmo endereço';

  @override
  String get timestamp => 'Timestamp';

  @override
  String get toPool => 'Para o Banco';

  @override
  String get tools => 'Ferramentas';

  @override
  String get totalBalance => 'Saldo Total';

  @override
  String get transactionDetails => 'Detalhes da transação';

  @override
  String get transactionHistory => 'Histórico de transações';

  @override
  String get transactions => 'Transações';

  @override
  String get transfer => 'Transferência';

  @override
  String get transparent => 'Transparente';

  @override
  String get transparentInput => 'Entrada transparente';

  @override
  String get transparentKey => 'Chave transparente';

  @override
  String get txID => 'TXID';

  @override
  String txId(Object txid) {
    return 'TX ID: $txid';
  }

  @override
  String get txPlan => 'Plano de transação';

  @override
  String get mainAddress => 'Endereço Principal';

  @override
  String get unifiedViewingKey => 'Chave de visualização unificada';

  @override
  String get unsignedTx => 'Tx não assinado';

  @override
  String get update => 'Recalcular';

  @override
  String get useZats => 'Usar Zats (8 casas decimais)';

  @override
  String get version => 'Versão';

  @override
  String get veryLow => 'Muito baixo';

  @override
  String get viewingKey => 'Visualizando Chave';

  @override
  String get views => 'Visualizações';

  @override
  String get welcomeToYwallet => 'Bem-vindo ao YWallet';

  @override
  String get wifi => 'Wi-Fi';

  @override
  String get dontShowAnymore => 'Não mostrar mais';

  @override
  String get swapDisclaimer => 'Os swaps são oferecidos por provedores de terceiros. Use por sua conta e risco e faça a sua própria pesquisa.';

  @override
  String get swap => 'Trocar';

  @override
  String get swapProviders => 'Trocar provedores';

  @override
  String get stealthEx => 'Furto';

  @override
  String get getQuote => 'Obter cotação';

  @override
  String get invalidSwapCurrencies => 'Trocar deve incluir ZEC';

  @override
  String get checkSwapAddress => 'Certifique-se de que o endereço de destino é válido!';

  @override
  String get swapSend => 'Mandar';

  @override
  String get swapReceive => 'Receber';

  @override
  String get swapFromTip => 'Dica: Envie os fundos para o endereço na caixa superior e você receberá o ZEC no seu endereço transparente.';

  @override
  String get swapToTip => 'Dica: Toque no botão enviar e receba a outra moeda';

  @override
  String get confirm => 'Por favor confirme';

  @override
  String get confirmClearSwapHistory => 'Tem certeza de que deseja limpar o histórico de trocas?';

  @override
  String get retry => 'Repetir';

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
