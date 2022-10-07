// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Version`
  String get version {
    return Intl.message(
      'Version',
      name: 'version',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get about {
    return Intl.message(
      'About',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get account {
    return Intl.message(
      'Account',
      name: 'account',
      desc: '',
      args: [],
    );
  }

  /// `Notes`
  String get notes {
    return Intl.message(
      'Notes',
      name: 'notes',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get history {
    return Intl.message(
      'History',
      name: 'history',
      desc: '',
      args: [],
    );
  }

  /// `Budget`
  String get budget {
    return Intl.message(
      'Budget',
      name: 'budget',
      desc: '',
      args: [],
    );
  }

  /// `Wallet P&L`
  String get tradingPl {
    return Intl.message(
      'Wallet P&L',
      name: 'tradingPl',
      desc: '',
      args: [],
    );
  }

  /// `Contacts`
  String get contacts {
    return Intl.message(
      'Contacts',
      name: 'contacts',
      desc: '',
      args: [],
    );
  }

  /// `Accounts`
  String get accounts {
    return Intl.message(
      'Accounts',
      name: 'accounts',
      desc: '',
      args: [],
    );
  }

  /// `Backup`
  String get backup {
    return Intl.message(
      'Backup',
      name: 'backup',
      desc: '',
      args: [],
    );
  }

  /// `Rescan`
  String get rescan {
    return Intl.message(
      'Rescan',
      name: 'rescan',
      desc: '',
      args: [],
    );
  }

  /// `Cold Storage`
  String get coldStorage {
    return Intl.message(
      'Cold Storage',
      name: 'coldStorage',
      desc: '',
      args: [],
    );
  }

  /// `MultiPay`
  String get multipay {
    return Intl.message(
      'MultiPay',
      name: 'multipay',
      desc: '',
      args: [],
    );
  }

  /// `Broadcast`
  String get broadcast {
    return Intl.message(
      'Broadcast',
      name: 'broadcast',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Synching`
  String get synching {
    return Intl.message(
      'Synching',
      name: 'synching',
      desc: '',
      args: [],
    );
  }

  /// `Tap QR Code for Shielded Address`
  String get tapQrCodeForShieldedAddress {
    return Intl.message(
      'Tap QR Code for Shielded Address',
      name: 'tapQrCodeForShieldedAddress',
      desc: '',
      args: [],
    );
  }

  /// `Tap QR Code for Transparent Address`
  String get tapQrCodeForTransparentAddress {
    return Intl.message(
      'Tap QR Code for Transparent Address',
      name: 'tapQrCodeForTransparentAddress',
      desc: '',
      args: [],
    );
  }

  /// `Address copied to clipboard`
  String get addressCopiedToClipboard {
    return Intl.message(
      'Address copied to clipboard',
      name: 'addressCopiedToClipboard',
      desc: '',
      args: [],
    );
  }

  /// `Shield Transparent Balance`
  String get shieldTransparentBalance {
    return Intl.message(
      'Shield Transparent Balance',
      name: 'shieldTransparentBalance',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to transfer your entire transparent balance to your shielded address? A Network fee of 0.01 m{ticker} will be deducted.`
  String doYouWantToTransferYourEntireTransparentBalanceTo(Object ticker) {
    return Intl.message(
      'Do you want to transfer your entire transparent balance to your shielded address? A Network fee of 0.01 m$ticker will be deducted.',
      name: 'doYouWantToTransferYourEntireTransparentBalanceTo',
      desc: '',
      args: [ticker],
    );
  }

  /// `Shielding in progress...`
  String get shieldingInProgress {
    return Intl.message(
      'Shielding in progress...',
      name: 'shieldingInProgress',
      desc: '',
      args: [],
    );
  }

  /// `TX ID: {txid}`
  String txId(Object txid) {
    return Intl.message(
      'TX ID: $txid',
      name: 'txId',
      desc: '',
      args: [txid],
    );
  }

  /// `Please authenticate to show account seed`
  String get pleaseAuthenticateToShowAccountSeed {
    return Intl.message(
      'Please authenticate to show account seed',
      name: 'pleaseAuthenticateToShowAccountSeed',
      desc: '',
      args: [],
    );
  }

  /// `No Authentication Method`
  String get noAuthenticationMethod {
    return Intl.message(
      'No Authentication Method',
      name: 'noAuthenticationMethod',
      desc: '',
      args: [],
    );
  }

  /// `Rescan from...`
  String get rescanFrom {
    return Intl.message(
      'Rescan from...',
      name: 'rescanFrom',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Rescan Requested from {height}...`
  String rescanRequested(Object height) {
    return Intl.message(
      'Rescan Requested from $height...',
      name: 'rescanRequested',
      desc: '',
      args: [height],
    );
  }

  /// `Do you want to DELETE the secret key and convert this account to a watch-only account? You will not be able to spend from this device anymore. This operation is NOT reversible.`
  String get doYouWantToDeleteTheSecretKeyAndConvert {
    return Intl.message(
      'Do you want to DELETE the secret key and convert this account to a watch-only account? You will not be able to spend from this device anymore. This operation is NOT reversible.',
      name: 'doYouWantToDeleteTheSecretKeyAndConvert',
      desc: '',
      args: [],
    );
  }

  /// `DELETE`
  String get delete {
    return Intl.message(
      'DELETE',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Confs`
  String get confs {
    return Intl.message(
      'Confs',
      name: 'confs',
      desc: '',
      args: [],
    );
  }

  /// `Height`
  String get height {
    return Intl.message(
      'Height',
      name: 'height',
      desc: '',
      args: [],
    );
  }

  /// `Date/Time`
  String get datetime {
    return Intl.message(
      'Date/Time',
      name: 'datetime',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get amount {
    return Intl.message(
      'Amount',
      name: 'amount',
      desc: '',
      args: [],
    );
  }

  /// `Select notes to EXCLUDE from payments`
  String get selectNotesToExcludeFromPayments {
    return Intl.message(
      'Select notes to EXCLUDE from payments',
      name: 'selectNotesToExcludeFromPayments',
      desc: '',
      args: [],
    );
  }

  /// `Largest Spendings by Address`
  String get largestSpendingsByAddress {
    return Intl.message(
      'Largest Spendings by Address',
      name: 'largestSpendingsByAddress',
      desc: '',
      args: [],
    );
  }

  /// `Tap Chart to Toggle between Address and Amount`
  String get tapChartToToggleBetweenAddressAndAmount {
    return Intl.message(
      'Tap Chart to Toggle between Address and Amount',
      name: 'tapChartToToggleBetweenAddressAndAmount',
      desc: '',
      args: [],
    );
  }

  /// `Account Balance History`
  String get accountBalanceHistory {
    return Intl.message(
      'Account Balance History',
      name: 'accountBalanceHistory',
      desc: '',
      args: [],
    );
  }

  /// `No Spending in the Last 30 Days`
  String get noSpendingInTheLast30Days {
    return Intl.message(
      'No Spending in the Last 30 Days',
      name: 'noSpendingInTheLast30Days',
      desc: '',
      args: [],
    );
  }

  /// `Largest Spending Last Month`
  String get largestSpendingLastMonth {
    return Intl.message(
      'Largest Spending Last Month',
      name: 'largestSpendingLastMonth',
      desc: '',
      args: [],
    );
  }

  /// `Balance`
  String get balance {
    return Intl.message(
      'Balance',
      name: 'balance',
      desc: '',
      args: [],
    );
  }

  /// `Pnl`
  String get pnl {
    return Intl.message(
      'Pnl',
      name: 'pnl',
      desc: '',
      args: [],
    );
  }

  /// `M/M`
  String get mm {
    return Intl.message(
      'M/M',
      name: 'mm',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get total {
    return Intl.message(
      'Total',
      name: 'total',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get price {
    return Intl.message(
      'Price',
      name: 'price',
      desc: '',
      args: [],
    );
  }

  /// `Qty`
  String get qty {
    return Intl.message(
      'Qty',
      name: 'qty',
      desc: '',
      args: [],
    );
  }

  /// `Table`
  String get table {
    return Intl.message(
      'Table',
      name: 'table',
      desc: '',
      args: [],
    );
  }

  /// `P/L`
  String get pl {
    return Intl.message(
      'P/L',
      name: 'pl',
      desc: '',
      args: [],
    );
  }

  /// `Realized`
  String get realized {
    return Intl.message(
      'Realized',
      name: 'realized',
      desc: '',
      args: [],
    );
  }

  /// `To make a contact, send them a memo with Contact:`
  String get toMakeAContactSendThemAMemoWithContact {
    return Intl.message(
      'To make a contact, send them a memo with Contact:',
      name: 'toMakeAContactSendThemAMemoWithContact',
      desc: '',
      args: [],
    );
  }

  /// `New Snap Address`
  String get newSnapAddress {
    return Intl.message(
      'New Snap Address',
      name: 'newSnapAddress',
      desc: '',
      args: [],
    );
  }

  /// `Shield Transp. Balance`
  String get shieldTranspBalance {
    return Intl.message(
      'Shield Transp. Balance',
      name: 'shieldTranspBalance',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message(
      'Send',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `No account`
  String get noAccount {
    return Intl.message(
      'No account',
      name: 'noAccount',
      desc: '',
      args: [],
    );
  }

  /// `Seed`
  String get seed {
    return Intl.message(
      'Seed',
      name: 'seed',
      desc: '',
      args: [],
    );
  }

  /// `Are you SURE you want to DELETE this account? You MUST have a BACKUP to recover it. This operation is NOT reversible.`
  String get confirmDeleteAccount {
    return Intl.message(
      'Are you SURE you want to DELETE this account? You MUST have a BACKUP to recover it. This operation is NOT reversible.',
      name: 'confirmDeleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Change Account Name`
  String get changeAccountName {
    return Intl.message(
      'Change Account Name',
      name: 'changeAccountName',
      desc: '',
      args: [],
    );
  }

  /// `Backup Data - {name} - Required for Restore`
  String backupDataRequiredForRestore(Object name) {
    return Intl.message(
      'Backup Data - $name - Required for Restore',
      name: 'backupDataRequiredForRestore',
      desc: '',
      args: [name],
    );
  }

  /// `Secret Key`
  String get secretKey {
    return Intl.message(
      'Secret Key',
      name: 'secretKey',
      desc: '',
      args: [],
    );
  }

  /// `Viewing Key`
  String get viewingKey {
    return Intl.message(
      'Viewing Key',
      name: 'viewingKey',
      desc: '',
      args: [],
    );
  }

  /// `Tap an icon to show the QR code`
  String get tapAnIconToShowTheQrCode {
    return Intl.message(
      'Tap an icon to show the QR code',
      name: 'tapAnIconToShowTheQrCode',
      desc: '',
      args: [],
    );
  }

  /// `Multi Pay`
  String get multiPay {
    return Intl.message(
      'Multi Pay',
      name: 'multiPay',
      desc: '',
      args: [],
    );
  }

  /// `Please Confirm`
  String get pleaseConfirm {
    return Intl.message(
      'Please Confirm',
      name: 'pleaseConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Sending a total of {amount} {ticker} to {count} recipients`
  String sendingATotalOfAmountCointickerToCountRecipients(
      Object amount, Object ticker, Object count) {
    return Intl.message(
      'Sending a total of $amount $ticker to $count recipients',
      name: 'sendingATotalOfAmountCointickerToCountRecipients',
      desc: '',
      args: [amount, ticker, count],
    );
  }

  /// `Preparing transaction...`
  String get preparingTransaction {
    return Intl.message(
      'Preparing transaction...',
      name: 'preparingTransaction',
      desc: '',
      args: [],
    );
  }

  /// `Send {ticker} to...`
  String sendCointickerTo(Object ticker) {
    return Intl.message(
      'Send $ticker to...',
      name: 'sendCointickerTo',
      desc: '',
      args: [ticker],
    );
  }

  /// `Address is empty`
  String get addressIsEmpty {
    return Intl.message(
      'Address is empty',
      name: 'addressIsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Address`
  String get invalidAddress {
    return Intl.message(
      'Invalid Address',
      name: 'invalidAddress',
      desc: '',
      args: [],
    );
  }

  /// `Amount must be a number`
  String get amountMustBeANumber {
    return Intl.message(
      'Amount must be a number',
      name: 'amountMustBeANumber',
      desc: '',
      args: [],
    );
  }

  /// `Amount must be positive`
  String get amountMustBePositive {
    return Intl.message(
      'Amount must be positive',
      name: 'amountMustBePositive',
      desc: '',
      args: [],
    );
  }

  /// `Account Name`
  String get accountName {
    return Intl.message(
      'Account Name',
      name: 'accountName',
      desc: '',
      args: [],
    );
  }

  /// `Account name is required`
  String get accountNameIsRequired {
    return Intl.message(
      'Account name is required',
      name: 'accountNameIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Enter Seed, Secret Key or Viewing Key. Leave blank for a new account`
  String get enterSeed {
    return Intl.message(
      'Enter Seed, Secret Key or Viewing Key. Leave blank for a new account',
      name: 'enterSeed',
      desc: '',
      args: [],
    );
  }

  /// `Scan starting momentarily`
  String get scanStartingMomentarily {
    return Intl.message(
      'Scan starting momentarily',
      name: 'scanStartingMomentarily',
      desc: '',
      args: [],
    );
  }

  /// `Seed, Secret Key or View Key (optional)`
  String get key {
    return Intl.message(
      'Seed, Secret Key or View Key (optional)',
      name: 'key',
      desc: '',
      args: [],
    );
  }

  /// `Send {ticker}`
  String sendCointicker(Object ticker) {
    return Intl.message(
      'Send $ticker',
      name: 'sendCointicker',
      desc: '',
      args: [ticker],
    );
  }

  /// `MAX`
  String get max {
    return Intl.message(
      'MAX',
      name: 'max',
      desc: '',
      args: [],
    );
  }

  /// `Advanced Options`
  String get advancedOptions {
    return Intl.message(
      'Advanced Options',
      name: 'advancedOptions',
      desc: '',
      args: [],
    );
  }

  /// `Memo`
  String get memo {
    return Intl.message(
      'Memo',
      name: 'memo',
      desc: '',
      args: [],
    );
  }

  /// `Round to millis`
  String get roundToMillis {
    return Intl.message(
      'Round to millis',
      name: 'roundToMillis',
      desc: '',
      args: [],
    );
  }

  /// `Use {currency}`
  String useSettingscurrency(Object currency) {
    return Intl.message(
      'Use $currency',
      name: 'useSettingscurrency',
      desc: '',
      args: [currency],
    );
  }

  /// `Include Fee in Amount`
  String get includeFeeInAmount {
    return Intl.message(
      'Include Fee in Amount',
      name: 'includeFeeInAmount',
      desc: '',
      args: [],
    );
  }

  /// `Max Amount per Note`
  String get maxAmountPerNote {
    return Intl.message(
      'Max Amount per Note',
      name: 'maxAmountPerNote',
      desc: '',
      args: [],
    );
  }

  /// `Spendable`
  String get spendable {
    return Intl.message(
      'Spendable',
      name: 'spendable',
      desc: '',
      args: [],
    );
  }

  /// `Not enough balance`
  String get notEnoughBalance {
    return Intl.message(
      'Not enough balance',
      name: 'notEnoughBalance',
      desc: '',
      args: [],
    );
  }

  /// `APPROVE`
  String get approve {
    return Intl.message(
      'APPROVE',
      name: 'approve',
      desc: '',
      args: [],
    );
  }

  /// `Sending {aZEC} {ticker} to {address}`
  String sendingAzecCointickerToAddress(
      Object aZEC, Object ticker, Object address) {
    return Intl.message(
      'Sending $aZEC $ticker to $address',
      name: 'sendingAzecCointickerToAddress',
      desc: '',
      args: [aZEC, ticker, address],
    );
  }

  /// `Unsigned Transaction File`
  String get unsignedTransactionFile {
    return Intl.message(
      'Unsigned Transaction File',
      name: 'unsignedTransactionFile',
      desc: '',
      args: [],
    );
  }

  /// `Amount in {currency}`
  String amountInSettingscurrency(Object currency) {
    return Intl.message(
      'Amount in $currency',
      name: 'amountInSettingscurrency',
      desc: '',
      args: [currency],
    );
  }

  /// `Custom`
  String get custom {
    return Intl.message(
      'Custom',
      name: 'custom',
      desc: '',
      args: [],
    );
  }

  /// `Server`
  String get server {
    return Intl.message(
      'Server',
      name: 'server',
      desc: '',
      args: [],
    );
  }

  /// `Blue`
  String get blue {
    return Intl.message(
      'Blue',
      name: 'blue',
      desc: '',
      args: [],
    );
  }

  /// `Pink`
  String get pink {
    return Intl.message(
      'Pink',
      name: 'pink',
      desc: '',
      args: [],
    );
  }

  /// `Coffee`
  String get coffee {
    return Intl.message(
      'Coffee',
      name: 'coffee',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get light {
    return Intl.message(
      'Light',
      name: 'light',
      desc: '',
      args: [],
    );
  }

  /// `Dark`
  String get dark {
    return Intl.message(
      'Dark',
      name: 'dark',
      desc: '',
      args: [],
    );
  }

  /// `Currency`
  String get currency {
    return Intl.message(
      'Currency',
      name: 'currency',
      desc: '',
      args: [],
    );
  }

  /// `Number of Confirmations Needed before Spending`
  String get numberOfConfirmationsNeededBeforeSpending {
    return Intl.message(
      'Number of Confirmations Needed before Spending',
      name: 'numberOfConfirmationsNeededBeforeSpending',
      desc: '',
      args: [],
    );
  }

  /// `Retrieve Transaction Details`
  String get retrieveTransactionDetails {
    return Intl.message(
      'Retrieve Transaction Details',
      name: 'retrieveTransactionDetails',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get theme {
    return Intl.message(
      'Theme',
      name: 'theme',
      desc: '',
      args: [],
    );
  }

  /// `Transaction Details`
  String get transactionDetails {
    return Intl.message(
      'Transaction Details',
      name: 'transactionDetails',
      desc: '',
      args: [],
    );
  }

  /// `Timestamp`
  String get timestamp {
    return Intl.message(
      'Timestamp',
      name: 'timestamp',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Open in Explorer`
  String get openInExplorer {
    return Intl.message(
      'Open in Explorer',
      name: 'openInExplorer',
      desc: '',
      args: [],
    );
  }

  /// `N/A`
  String get na {
    return Intl.message(
      'N/A',
      name: 'na',
      desc: '',
      args: [],
    );
  }

  /// `ADD`
  String get add {
    return Intl.message(
      'ADD',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Trading Chart Range`
  String get tradingChartRange {
    return Intl.message(
      'Trading Chart Range',
      name: 'tradingChartRange',
      desc: '',
      args: [],
    );
  }

  /// `1 M`
  String get M1 {
    return Intl.message(
      '1 M',
      name: 'M1',
      desc: '',
      args: [],
    );
  }

  /// `3 M`
  String get M3 {
    return Intl.message(
      '3 M',
      name: 'M3',
      desc: '',
      args: [],
    );
  }

  /// `6 M`
  String get M6 {
    return Intl.message(
      '6 M',
      name: 'M6',
      desc: '',
      args: [],
    );
  }

  /// `1 Y`
  String get Y1 {
    return Intl.message(
      '1 Y',
      name: 'Y1',
      desc: '',
      args: [],
    );
  }

  /// `Shield Transparent Balance When Sending`
  String get shieldTransparentBalanceWithSending {
    return Intl.message(
      'Shield Transparent Balance When Sending',
      name: 'shieldTransparentBalanceWithSending',
      desc: '',
      args: [],
    );
  }

  /// `Use UA`
  String get useUa {
    return Intl.message(
      'Use UA',
      name: 'useUa',
      desc: '',
      args: [],
    );
  }

  /// `Tap + to add a new account`
  String get createANewAccount {
    return Intl.message(
      'Tap + to add a new account',
      name: 'createANewAccount',
      desc: '',
      args: [],
    );
  }

  /// `Duplicate Account`
  String get duplicateAccount {
    return Intl.message(
      'Duplicate Account',
      name: 'duplicateAccount',
      desc: '',
      args: [],
    );
  }

  /// `Another account has the same address`
  String get thisAccountAlreadyExists {
    return Intl.message(
      'Another account has the same address',
      name: 'thisAccountAlreadyExists',
      desc: '',
      args: [],
    );
  }

  /// `Select Account`
  String get selectAccount {
    return Intl.message(
      'Select Account',
      name: 'selectAccount',
      desc: '',
      args: [],
    );
  }

  /// `Name is empty`
  String get nameIsEmpty {
    return Intl.message(
      'Name is empty',
      name: 'nameIsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Delete contact`
  String get deleteContact {
    return Intl.message(
      'Delete contact',
      name: 'deleteContact',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this contact?`
  String get areYouSureYouWantToDeleteThisContact {
    return Intl.message(
      'Are you sure you want to delete this contact?',
      name: 'areYouSureYouWantToDeleteThisContact',
      desc: '',
      args: [],
    );
  }

  /// `Save to Blockchain`
  String get saveToBlockchain {
    return Intl.message(
      'Save to Blockchain',
      name: 'saveToBlockchain',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to save your contacts? It will cost 0.01 m{ticker}`
  String areYouSureYouWantToSaveYourContactsIt(Object ticker) {
    return Intl.message(
      'Are you sure you want to save your contacts? It will cost 0.01 m$ticker',
      name: 'areYouSureYouWantToSaveYourContactsIt',
      desc: '',
      args: [ticker],
    );
  }

  /// `No one can recover your secret keys. If you don't have a backup and your phone breaks down, you WILL LOSE YOUR MONEY. You can reach this page by the app menu then Backup`
  String get backupWarning {
    return Intl.message(
      'No one can recover your secret keys. If you don\'t have a backup and your phone breaks down, you WILL LOSE YOUR MONEY. You can reach this page by the app menu then Backup',
      name: 'backupWarning',
      desc: '',
      args: [],
    );
  }

  /// `Contact Name`
  String get contactName {
    return Intl.message(
      'Contact Name',
      name: 'contactName',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message(
      'Date',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `Another contact has this address`
  String get duplicateContact {
    return Intl.message(
      'Another contact has this address',
      name: 'duplicateContact',
      desc: '',
      args: [],
    );
  }

  /// `Auto Hide Balance`
  String get autoHideBalance {
    return Intl.message(
      'Auto Hide Balance',
      name: 'autoHideBalance',
      desc: '',
      args: [],
    );
  }

  /// `Tilt your device up to reveal your balance`
  String get tiltYourDeviceUpToRevealYourBalance {
    return Intl.message(
      'Tilt your device up to reveal your balance',
      name: 'tiltYourDeviceUpToRevealYourBalance',
      desc: '',
      args: [],
    );
  }

  /// `No Contacts`
  String get noContacts {
    return Intl.message(
      'No Contacts',
      name: 'noContacts',
      desc: '',
      args: [],
    );
  }

  /// `Tap + to add a new contact`
  String get createANewContactAndItWillShowUpHere {
    return Intl.message(
      'Tap + to add a new contact',
      name: 'createANewContactAndItWillShowUpHere',
      desc: '',
      args: [],
    );
  }

  /// `Add Contact`
  String get addContact {
    return Intl.message(
      'Add Contact',
      name: 'addContact',
      desc: '',
      args: [],
    );
  }

  /// `Account has some BALANCE. Are you sure you want to delete it?`
  String get accountHasSomeBalanceAreYouSureYouWantTo {
    return Intl.message(
      'Account has some BALANCE. Are you sure you want to delete it?',
      name: 'accountHasSomeBalanceAreYouSureYouWantTo',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get deleteAccount {
    return Intl.message(
      'Delete Account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Gold`
  String get gold {
    return Intl.message(
      'Gold',
      name: 'gold',
      desc: '',
      args: [],
    );
  }

  /// `Purple`
  String get purple {
    return Intl.message(
      'Purple',
      name: 'purple',
      desc: '',
      args: [],
    );
  }

  /// `No Recipient`
  String get noRecipient {
    return Intl.message(
      'No Recipient',
      name: 'noRecipient',
      desc: '',
      args: [],
    );
  }

  /// `Add a recipient and it will show here`
  String get addARecipientAndItWillShowHere {
    return Intl.message(
      'Add a recipient and it will show here',
      name: 'addARecipientAndItWillShowHere',
      desc: '',
      args: [],
    );
  }

  /// `Receive Payment`
  String get receivePayment {
    return Intl.message(
      'Receive Payment',
      name: 'receivePayment',
      desc: '',
      args: [],
    );
  }

  /// `Amount too high`
  String get amountTooHigh {
    return Intl.message(
      'Amount too high',
      name: 'amountTooHigh',
      desc: '',
      args: [],
    );
  }

  /// `Protect Send`
  String get protectSend {
    return Intl.message(
      'Protect Send',
      name: 'protectSend',
      desc: '',
      args: [],
    );
  }

  /// `Protect Send setting changed`
  String get protectSendSettingChanged {
    return Intl.message(
      'Protect Send setting changed',
      name: 'protectSendSettingChanged',
      desc: '',
      args: [],
    );
  }

  /// `Please authenticate to Send`
  String get pleaseAuthenticateToSend {
    return Intl.message(
      'Please authenticate to Send',
      name: 'pleaseAuthenticateToSend',
      desc: '',
      args: [],
    );
  }

  /// `Unshielded`
  String get unshielded {
    return Intl.message(
      'Unshielded',
      name: 'unshielded',
      desc: '',
      args: [],
    );
  }

  /// `Unshielded Balance`
  String get unshieldedBalance {
    return Intl.message(
      'Unshielded Balance',
      name: 'unshieldedBalance',
      desc: '',
      args: [],
    );
  }

  /// `Total Balance`
  String get totalBalance {
    return Intl.message(
      'Total Balance',
      name: 'totalBalance',
      desc: '',
      args: [],
    );
  }

  /// `Under Confirmed`
  String get underConfirmed {
    return Intl.message(
      'Under Confirmed',
      name: 'underConfirmed',
      desc: '',
      args: [],
    );
  }

  /// `Excluded Notes`
  String get excludedNotes {
    return Intl.message(
      'Excluded Notes',
      name: 'excludedNotes',
      desc: '',
      args: [],
    );
  }

  /// `Spendable Balance`
  String get spendableBalance {
    return Intl.message(
      'Spendable Balance',
      name: 'spendableBalance',
      desc: '',
      args: [],
    );
  }

  /// `Rescan Needed`
  String get rescanNeeded {
    return Intl.message(
      'Rescan Needed',
      name: 'rescanNeeded',
      desc: '',
      args: [],
    );
  }

  /// `Tap Transaction for Details`
  String get tapTransactionForDetails {
    return Intl.message(
      'Tap Transaction for Details',
      name: 'tapTransactionForDetails',
      desc: '',
      args: [],
    );
  }

  /// `Transaction History`
  String get transactionHistory {
    return Intl.message(
      'Transaction History',
      name: 'transactionHistory',
      desc: '',
      args: [],
    );
  }

  /// `Help`
  String get help {
    return Intl.message(
      'Help',
      name: 'help',
      desc: '',
      args: [],
    );
  }

  /// `Receive {ticker}`
  String receive(Object ticker) {
    return Intl.message(
      'Receive $ticker',
      name: 'receive',
      desc: '',
      args: [ticker],
    );
  }

  /// `PNL History`
  String get pnlHistory {
    return Intl.message(
      'PNL History',
      name: 'pnlHistory',
      desc: '',
      args: [],
    );
  }

  /// `Use Transparent Balance`
  String get useTransparentBalance {
    return Intl.message(
      'Use Transparent Balance',
      name: 'useTransparentBalance',
      desc: '',
      args: [],
    );
  }

  /// `Theme Editor`
  String get themeEditor {
    return Intl.message(
      'Theme Editor',
      name: 'themeEditor',
      desc: '',
      args: [],
    );
  }

  /// `Color`
  String get color {
    return Intl.message(
      'Color',
      name: 'color',
      desc: '',
      args: [],
    );
  }

  /// `Accent Color`
  String get accentColor {
    return Intl.message(
      'Accent Color',
      name: 'accentColor',
      desc: '',
      args: [],
    );
  }

  /// `Primary`
  String get primary {
    return Intl.message(
      'Primary',
      name: 'primary',
      desc: '',
      args: [],
    );
  }

  /// `Secondary`
  String get secondary {
    return Intl.message(
      'Secondary',
      name: 'secondary',
      desc: '',
      args: [],
    );
  }

  /// `Multisig`
  String get multisig {
    return Intl.message(
      'Multisig',
      name: 'multisig',
      desc: '',
      args: [],
    );
  }

  /// `Enter secret share if account is multi-signature`
  String get enterSecretShareIfAccountIsMultisignature {
    return Intl.message(
      'Enter secret share if account is multi-signature',
      name: 'enterSecretShareIfAccountIsMultisignature',
      desc: '',
      args: [],
    );
  }

  /// `Secret Share`
  String get secretShare {
    return Intl.message(
      'Secret Share',
      name: 'secretShare',
      desc: '',
      args: [],
    );
  }

  /// `File saved`
  String get fileSaved {
    return Intl.message(
      'File saved',
      name: 'fileSaved',
      desc: '',
      args: [],
    );
  }

  /// `{num} more signers needed`
  String numMoreSignersNeeded(Object num) {
    return Intl.message(
      '$num more signers needed',
      name: 'numMoreSignersNeeded',
      desc: '',
      args: [num],
    );
  }

  /// `Sign Transaction`
  String get sign {
    return Intl.message(
      'Sign Transaction',
      name: 'sign',
      desc: '',
      args: [],
    );
  }

  /// `Split Account`
  String get splitAccount {
    return Intl.message(
      'Split Account',
      name: 'splitAccount',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Signing`
  String get confirmSigning {
    return Intl.message(
      'Confirm Signing',
      name: 'confirmSigning',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to sign a transaction to {address} for {amount}`
  String confirmSignATransactionToAddressFor(Object address, Object amount) {
    return Intl.message(
      'Do you want to sign a transaction to $address for $amount',
      name: 'confirmSignATransactionToAddressFor',
      desc: '',
      args: [address, amount],
    );
  }

  /// `Multisig Shares`
  String get multisigShares {
    return Intl.message(
      'Multisig Shares',
      name: 'multisigShares',
      desc: '',
      args: [],
    );
  }

  /// `Copy`
  String get copy {
    return Intl.message(
      'Copy',
      name: 'copy',
      desc: '',
      args: [],
    );
  }

  /// `{text} copied to clipboard`
  String textCopiedToClipboard(Object text) {
    return Intl.message(
      '$text copied to clipboard',
      name: 'textCopiedToClipboard',
      desc: '',
      args: [text],
    );
  }

  /// `multiple addresses`
  String get multipleAddresses {
    return Intl.message(
      'multiple addresses',
      name: 'multipleAddresses',
      desc: '',
      args: [],
    );
  }

  /// `NEW/RESTORE`
  String get addnew {
    return Intl.message(
      'NEW/RESTORE',
      name: 'addnew',
      desc: '',
      args: [],
    );
  }

  /// `Application Reset`
  String get applicationReset {
    return Intl.message(
      'Application Reset',
      name: 'applicationReset',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to reset the app? Your accounts will NOT be deleted`
  String get confirmResetApp {
    return Intl.message(
      'Are you sure you want to reset the app? Your accounts will NOT be deleted',
      name: 'confirmResetApp',
      desc: '',
      args: [],
    );
  }

  /// `RESET`
  String get reset {
    return Intl.message(
      'RESET',
      name: 'reset',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message(
      'Loading...',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Restart`
  String get restart {
    return Intl.message(
      'Restart',
      name: 'restart',
      desc: '',
      args: [],
    );
  }

  /// `Please Quit and Restart the app now`
  String get pleaseQuitAndRestartTheAppNow {
    return Intl.message(
      'Please Quit and Restart the app now',
      name: 'pleaseQuitAndRestartTheAppNow',
      desc: '',
      args: [],
    );
  }

  /// `Mode`
  String get mode {
    return Intl.message(
      'Mode',
      name: 'mode',
      desc: '',
      args: [],
    );
  }

  /// `Simple`
  String get simple {
    return Intl.message(
      'Simple',
      name: 'simple',
      desc: '',
      args: [],
    );
  }

  /// `Advanced`
  String get advanced {
    return Intl.message(
      'Advanced',
      name: 'advanced',
      desc: '',
      args: [],
    );
  }

  /// `Changing the mode will take effect at next restart`
  String get changingTheModeWillTakeEffectAtNextRestart {
    return Intl.message(
      'Changing the mode will take effect at next restart',
      name: 'changingTheModeWillTakeEffectAtNextRestart',
      desc: '',
      args: [],
    );
  }

  /// `Sent from {app}`
  String sendFrom(Object app) {
    return Intl.message(
      'Sent from $app',
      name: 'sendFrom',
      desc: '',
      args: [app],
    );
  }

  /// `Default Memo`
  String get defaultMemo {
    return Intl.message(
      'Default Memo',
      name: 'defaultMemo',
      desc: '',
      args: [],
    );
  }

  /// `Full Backup`
  String get fullBackup {
    return Intl.message(
      'Full Backup',
      name: 'fullBackup',
      desc: '',
      args: [],
    );
  }

  /// `Backup Encryption Key`
  String get backupEncryptionKey {
    return Intl.message(
      'Backup Encryption Key',
      name: 'backupEncryptionKey',
      desc: '',
      args: [],
    );
  }

  /// `Save Backup`
  String get saveBackup {
    return Intl.message(
      'Save Backup',
      name: 'saveBackup',
      desc: '',
      args: [],
    );
  }

  /// `{app} Encrypted Backup`
  String encryptedBackup(Object app) {
    return Intl.message(
      '$app Encrypted Backup',
      name: 'encryptedBackup',
      desc: '',
      args: [app],
    );
  }

  /// `Full Restore`
  String get fullRestore {
    return Intl.message(
      'Full Restore',
      name: 'fullRestore',
      desc: '',
      args: [],
    );
  }

  /// `Load Backup`
  String get loadBackup {
    return Intl.message(
      'Load Backup',
      name: 'loadBackup',
      desc: '',
      args: [],
    );
  }

  /// `Backup All Accounts`
  String get backupAllAccounts {
    return Intl.message(
      'Backup All Accounts',
      name: 'backupAllAccounts',
      desc: '',
      args: [],
    );
  }

  /// `Simple Mode`
  String get simpleMode {
    return Intl.message(
      'Simple Mode',
      name: 'simpleMode',
      desc: '',
      args: [],
    );
  }

  /// `Account Index`
  String get accountIndex {
    return Intl.message(
      'Account Index',
      name: 'accountIndex',
      desc: '',
      args: [],
    );
  }

  /// `Sub Account of {name}`
  String subAccountOf(Object name) {
    return Intl.message(
      'Sub Account of $name',
      name: 'subAccountOf',
      desc: '',
      args: [name],
    );
  }

  /// `Sub Account {index} of {name}`
  String subAccountIndexOf(Object index, Object name) {
    return Intl.message(
      'Sub Account $index of $name',
      name: 'subAccountIndexOf',
      desc: '',
      args: [index, name],
    );
  }

  /// `New Sub Account`
  String get newSubAccount {
    return Intl.message(
      'New Sub Account',
      name: 'newSubAccount',
      desc: '',
      args: [],
    );
  }

  /// `No active account`
  String get noActiveAccount {
    return Intl.message(
      'No active account',
      name: 'noActiveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Close Application`
  String get closeApplication {
    return Intl.message(
      'Close Application',
      name: 'closeApplication',
      desc: '',
      args: [],
    );
  }

  /// `Please Restart now`
  String get pleaseRestartNow {
    return Intl.message(
      'Please Restart now',
      name: 'pleaseRestartNow',
      desc: '',
      args: [],
    );
  }

  /// `Disconnected`
  String get disconnected {
    return Intl.message(
      'Disconnected',
      name: 'disconnected',
      desc: '',
      args: [],
    );
  }

  /// `Ledger`
  String get ledger {
    return Intl.message(
      'Ledger',
      name: 'ledger',
      desc: '',
      args: [],
    );
  }

  /// `On Mobile Data, scanning may incur additional charges. Do you want to proceed?`
  String get mobileCharges {
    return Intl.message(
      'On Mobile Data, scanning may incur additional charges. Do you want to proceed?',
      name: 'mobileCharges',
      desc: '',
      args: [],
    );
  }

  /// `I have made a backup`
  String get iHaveMadeABackup {
    return Intl.message(
      'I have made a backup',
      name: 'iHaveMadeABackup',
      desc: '',
      args: [],
    );
  }

  /// `Barcode scanner is not available on desktop`
  String get barcodeScannerIsNotAvailableOnDesktop {
    return Intl.message(
      'Barcode scanner is not available on desktop',
      name: 'barcodeScannerIsNotAvailableOnDesktop',
      desc: '',
      args: [],
    );
  }

  /// `Sign`
  String get signOffline {
    return Intl.message(
      'Sign',
      name: 'signOffline',
      desc: '',
      args: [],
    );
  }

  /// `Raw Transaction`
  String get rawTransaction {
    return Intl.message(
      'Raw Transaction',
      name: 'rawTransaction',
      desc: '',
      args: [],
    );
  }

  /// `Convert to Watch-Only`
  String get convertToWatchonly {
    return Intl.message(
      'Convert to Watch-Only',
      name: 'convertToWatchonly',
      desc: '',
      args: [],
    );
  }

  /// `Messages`
  String get messages {
    return Intl.message(
      'Messages',
      name: 'messages',
      desc: '',
      args: [],
    );
  }

  /// `Body`
  String get body {
    return Intl.message(
      'Body',
      name: 'body',
      desc: '',
      args: [],
    );
  }

  /// `Subject`
  String get subject {
    return Intl.message(
      'Subject',
      name: 'subject',
      desc: '',
      args: [],
    );
  }

  /// `Include My Address in Memo`
  String get includeReplyTo {
    return Intl.message(
      'Include My Address in Memo',
      name: 'includeReplyTo',
      desc: '',
      args: [],
    );
  }

  /// `Sender`
  String get sender {
    return Intl.message(
      'Sender',
      name: 'sender',
      desc: '',
      args: [],
    );
  }

  /// `Message`
  String get message {
    return Intl.message(
      'Message',
      name: 'message',
      desc: '',
      args: [],
    );
  }

  /// `Reply`
  String get reply {
    return Intl.message(
      'Reply',
      name: 'reply',
      desc: '',
      args: [],
    );
  }

  /// `Recipient`
  String get recipient {
    return Intl.message(
      'Recipient',
      name: 'recipient',
      desc: '',
      args: [],
    );
  }

  /// `From/To`
  String get fromto {
    return Intl.message(
      'From/To',
      name: 'fromto',
      desc: '',
      args: [],
    );
  }

  /// `Rescanning...`
  String get rescanning {
    return Intl.message(
      'Rescanning...',
      name: 'rescanning',
      desc: '',
      args: [],
    );
  }

  /// `Mark All as Read`
  String get markAllAsRead {
    return Intl.message(
      'Mark All as Read',
      name: 'markAllAsRead',
      desc: '',
      args: [],
    );
  }

  /// `Show Messages as Table`
  String get showMessagesAsTable {
    return Intl.message(
      'Show Messages as Table',
      name: 'showMessagesAsTable',
      desc: '',
      args: [],
    );
  }

  /// `Edit Contact`
  String get editContact {
    return Intl.message(
      'Edit Contact',
      name: 'editContact',
      desc: '',
      args: [],
    );
  }

  /// `Now`
  String get now {
    return Intl.message(
      'Now',
      name: 'now',
      desc: '',
      args: [],
    );
  }

  /// `Protect Open`
  String get protectOpen {
    return Intl.message(
      'Protect Open',
      name: 'protectOpen',
      desc: '',
      args: [],
    );
  }

  /// `Gap Limit`
  String get gapLimit {
    return Intl.message(
      'Gap Limit',
      name: 'gapLimit',
      desc: '',
      args: [],
    );
  }

  /// `ERROR: {msg}`
  String error(Object msg) {
    return Intl.message(
      'ERROR: $msg',
      name: 'error',
      desc: '',
      args: [msg],
    );
  }

  /// `Payment in progress...`
  String get paymentInProgress {
    return Intl.message(
      'Payment in progress...',
      name: 'paymentInProgress',
      desc: '',
      args: [],
    );
  }

  /// `Use QR for offline signing`
  String get useQrForOfflineSigning {
    return Intl.message(
      'Use QR for offline signing',
      name: 'useQrForOfflineSigning',
      desc: '',
      args: [],
    );
  }

  /// `Unsigned Tx`
  String get unsignedTx {
    return Intl.message(
      'Unsigned Tx',
      name: 'unsignedTx',
      desc: '',
      args: [],
    );
  }

  /// `Sign on your offline device`
  String get signOnYourOfflineDevice {
    return Intl.message(
      'Sign on your offline device',
      name: 'signOnYourOfflineDevice',
      desc: '',
      args: [],
    );
  }

  /// `Signed Tx`
  String get signedTx {
    return Intl.message(
      'Signed Tx',
      name: 'signedTx',
      desc: '',
      args: [],
    );
  }

  /// `Broadcast from your online device`
  String get broadcastFromYourOnlineDevice {
    return Intl.message(
      'Broadcast from your online device',
      name: 'broadcastFromYourOnlineDevice',
      desc: '',
      args: [],
    );
  }

  /// `Check Transaction`
  String get checkTransaction {
    return Intl.message(
      'Check Transaction',
      name: 'checkTransaction',
      desc: '',
      args: [],
    );
  }

  /// `Crypto`
  String get crypto {
    return Intl.message(
      'Crypto',
      name: 'crypto',
      desc: '',
      args: [],
    );
  }

  /// `Restore an account?`
  String get restoreAnAccount {
    return Intl.message(
      'Restore an account?',
      name: 'restoreAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to YWallet`
  String get welcomeToYwallet {
    return Intl.message(
      'Welcome to YWallet',
      name: 'welcomeToYwallet',
      desc: '',
      args: [],
    );
  }

  /// `The private wallet & messenger`
  String get thePrivateWalletMessenger {
    return Intl.message(
      'The private wallet & messenger',
      name: 'thePrivateWalletMessenger',
      desc: '',
      args: [],
    );
  }

  /// `New Account`
  String get newAccount {
    return Intl.message(
      'New Account',
      name: 'newAccount',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Key`
  String get invalidKey {
    return Intl.message(
      'Invalid Key',
      name: 'invalidKey',
      desc: '',
      args: [],
    );
  }

  /// `Barcode`
  String get barcode {
    return Intl.message(
      'Barcode',
      name: 'barcode',
      desc: '',
      args: [],
    );
  }

  /// `Input barcode`
  String get inputBarcodeValue {
    return Intl.message(
      'Input barcode',
      name: 'inputBarcodeValue',
      desc: '',
      args: [],
    );
  }

  /// `Auto`
  String get auto {
    return Intl.message(
      'Auto',
      name: 'auto',
      desc: '',
      args: [],
    );
  }

  /// `Count`
  String get count {
    return Intl.message(
      'Count',
      name: 'count',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Change Transparent Key`
  String get changeTransparentKey {
    return Intl.message(
      'Change Transparent Key',
      name: 'changeTransparentKey',
      desc: '',
      args: [],
    );
  }

  /// `Cancel Scan`
  String get cancelScan {
    return Intl.message(
      'Cancel Scan',
      name: 'cancelScan',
      desc: '',
      args: [],
    );
  }

  /// `Resume Scan`
  String get resumeScan {
    return Intl.message(
      'Resume Scan',
      name: 'resumeScan',
      desc: '',
      args: [],
    );
  }

  /// `Sync Paused`
  String get syncPaused {
    return Intl.message(
      'Sync Paused',
      name: 'syncPaused',
      desc: '',
      args: [],
    );
  }

  /// `Derivation Path`
  String get derivationPath {
    return Intl.message(
      'Derivation Path',
      name: 'derivationPath',
      desc: '',
      args: [],
    );
  }

  /// `Private Key`
  String get privateKey {
    return Intl.message(
      'Private Key',
      name: 'privateKey',
      desc: '',
      args: [],
    );
  }

  /// `Key Tool`
  String get keyTool {
    return Intl.message(
      'Key Tool',
      name: 'keyTool',
      desc: '',
      args: [],
    );
  }

  /// `Recalc`
  String get update {
    return Intl.message(
      'Recalc',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `Anti-Spam Filter`
  String get antispamFilter {
    return Intl.message(
      'Anti-Spam Filter',
      name: 'antispamFilter',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to restore your database? THIS WILL ERASE YOUR CURRENT DATA`
  String get doYouWantToRestore {
    return Intl.message(
      'Do you want to restore your database? THIS WILL ERASE YOUR CURRENT DATA',
      name: 'doYouWantToRestore',
      desc: '',
      args: [],
    );
  }

  /// `Use GPU`
  String get useGpu {
    return Intl.message(
      'Use GPU',
      name: 'useGpu',
      desc: '',
      args: [],
    );
  }

  /// `Import`
  String get import {
    return Intl.message(
      'Import',
      name: 'import',
      desc: '',
      args: [],
    );
  }

  /// `New`
  String get newLabel {
    return Intl.message(
      'New',
      name: 'newLabel',
      desc: '',
      args: [],
    );
  }

  /// `Invalid QR code: {message}`
  String invalidQrCode(Object message) {
    return Intl.message(
      'Invalid QR code: $message',
      name: 'invalidQrCode',
      desc: '',
      args: [message],
    );
  }

  /// `Expert`
  String get expert {
    return Intl.message(
      'Expert',
      name: 'expert',
      desc: '',
      args: [],
    );
  }

  /// `Block reorg detected. Rewind to {rewindHeight}`
  String blockReorgDetectedRewind(Object rewindHeight) {
    return Intl.message(
      'Block reorg detected. Rewind to $rewindHeight',
      name: 'blockReorgDetectedRewind',
      desc: '',
      args: [rewindHeight],
    );
  }

  /// `Show Transaction`
  String get goToTransaction {
    return Intl.message(
      'Show Transaction',
      name: 'goToTransaction',
      desc: '',
      args: [],
    );
  }

  /// `Transactions`
  String get transactions {
    return Intl.message(
      'Transactions',
      name: 'transactions',
      desc: '',
      args: [],
    );
  }

  /// `Synchronization in Progress`
  String get synchronizationInProgress {
    return Intl.message(
      'Synchronization in Progress',
      name: 'synchronizationInProgress',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
