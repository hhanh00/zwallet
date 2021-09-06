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
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
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

  /// `TX ID`
  String get txId {
    return Intl.message(
      'TX ID',
      name: 'txId',
      desc: '',
      args: [],
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

  /// `Rescan wallet from the first block?`
  String get rescanWalletFromTheFirstBlock {
    return Intl.message(
      'Rescan wallet from the first block?',
      name: 'rescanWalletFromTheFirstBlock',
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

  /// `Rescan Requested...`
  String get rescanRequested {
    return Intl.message(
      'Rescan Requested...',
      name: 'rescanRequested',
      desc: '',
      args: [],
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

  /// `Backup Data - Required for Restore`
  String get backupDataRequiredForRestore {
    return Intl.message(
      'Backup Data - Required for Restore',
      name: 'backupDataRequiredForRestore',
      desc: '',
      args: [],
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
  String sendingATotalOfAmountCointickerToCountRecipients(Object amount, Object ticker, Object count) {
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

  /// `Seed, Secret Key or View Key`
  String get key {
    return Intl.message(
      'Seed, Secret Key or View Key',
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

  /// `Spendable:`
  String get spendable {
    return Intl.message(
      'Spendable:',
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
  String sendingAzecCointickerToAddress(Object aZEC, Object ticker, Object address) {
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

  /// `Create a new account and it will show up here`
  String get createANewAccount {
    return Intl.message(
      'Create a new account and it will show up here',
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
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}