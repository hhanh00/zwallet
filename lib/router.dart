import 'dart:io';

import 'package:YWallet/pages/more/cold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:warp_api/warp_api.dart';
import 'package:protobuf/protobuf.dart';

import 'accounts.dart';
import 'appsettings.dart';
import 'coin/coins.dart';
import 'generated/intl/messages.dart';
import 'main.dart';
import 'pages/accounts/manager.dart';
import 'pages/accounts/multipay.dart';
import 'pages/accounts/new_import.dart';
import 'pages/accounts/pay_uri.dart';
import 'pages/accounts/rescan.dart';
import 'pages/accounts/send.dart';
import 'pages/accounts/submit.dart';
import 'pages/accounts/txplan.dart';
import 'pages/dblogin.dart';
import 'pages/main/home.dart';
import 'pages/more/about.dart';
import 'pages/more/backup.dart';
import 'pages/more/batch.dart';
import 'pages/more/budget.dart';
import 'pages/more/coin.dart';
import 'pages/more/contacts.dart';
import 'pages/more/keytool.dart';
import 'pages/more/more.dart';
import 'pages/more/pool.dart';
import 'pages/more/tx.dart';
import 'pages/more/quotes.dart';
import 'pages/scan.dart';
import 'pages/splash.dart';
import 'pages/welcome.dart';
import 'pages/settings.dart';
import 'pages/messages.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final _accountNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/splash',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(path: '/', redirect: (context, state) => '/account'),
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => ScaffoldBar(shell: shell),
      branches: [
        StatefulShellBranch(
          navigatorKey: _accountNavigatorKey,
          routes: [
            GoRoute(
              path: '/account',
              builder: (context, state) => HomePage(),
              redirect: (context, state) {
                if (aa.id == 0) return '/welcome';
                return null;
              },
              routes: [
                GoRoute(
                    path: 'account_manager',
                    builder: (context, state) => AccountManagerPage(),
                    routes: [
                      GoRoute(
                          path: 'new',
                          builder: (context, state) =>
                              NewImportAccountPage(first: false)),
                    ]),
                GoRoute(
                    path: 'multi_pay',
                    builder: (context, state) => MultiPayPage(),
                    routes: [
                      GoRoute(
                          path: 'new',
                          builder: (context, state) => SendPage(single: false)),
                    ]),
                GoRoute(
                  path: 'txplan',
                  builder: (context, state) => TxPlanPage(
                    state.extra as String,
                    tab: state.uri.queryParameters['tab']!,
                    signOnly: state.uri.queryParameters['sign'] != null,
                  ),
                ),
                GoRoute(
                  path: 'submit_tx',
                  builder: (context, state) =>
                      SubmitTxPage(state.extra as String),
                ),
                GoRoute(
                  path: 'rescan',
                  builder: (context, state) => RescanPage(),
                ),
                GoRoute(
                  path: 'send',
                  builder: (context, state) => SendPage(single: true),
                ),
                GoRoute(
                  path: 'pay_uri',
                  builder: (context, state) => PaymentURIPage(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
                path: '/messages',
                builder: (context, state) => MessagePage(),
                routes: [
                  GoRoute(
                      path: 'details',
                      builder: (context, state) => MessageItemPage(
                          int.parse(state.uri.queryParameters["index"]!))),
                ]),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
                path: '/history',
                builder: (context, state) => TxPage(),
                routes: [
                  GoRoute(
                      path: 'details',
                      builder: (context, state) => TransactionPage(
                          int.parse(state.uri.queryParameters["index"]!))),
                ]),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
                path: '/more',
                builder: (context, state) => MorePage(),
                routes: [
                  GoRoute(
                    path: 'submit_tx',
                    builder: (context, state) =>
                        SubmitTxPage(state.extra as String),
                  ),
                  GoRoute(
                      path: 'contacts',
                      builder: (context, state) => ContactsPage(),
                      routes: [
                        GoRoute(
                          path: 'add',
                          builder: (context, state) => ContactAddPage(),
                        ),
                        GoRoute(
                          path: 'edit',
                          builder: (context, state) => ContactEditPage(
                              int.parse(state.uri.queryParameters['id']!)),
                        ),
                      ]),
                  GoRoute(
                      path: 'cold',
                      builder: (context, state) => ColdStoragePage(),
                      routes: [
                        GoRoute(
                          path: 'batch_backup',
                          builder: (context, state) => BatchBackupPage(),
                        ),
                      ]),
                  GoRoute(
                    path: 'batch_backup',
                    builder: (context, state) => BatchBackupPage(),
                  ),
                  GoRoute(
                    path: 'coins',
                    builder: (context, state) => CoinControlPage(),
                  ),
                  GoRoute(
                    path: 'backup',
                    builder: (context, state) => BackupPage(),
                  ),
                  GoRoute(
                    path: 'rescan',
                    builder: (context, state) => RescanPage(),
                  ),
                  GoRoute(
                    path: 'rewind',
                    builder: (context, state) => RewindPage(),
                  ),
                  GoRoute(
                    path: 'budget',
                    builder: (context, state) => BudgetPage(),
                  ),
                  GoRoute(
                    path: 'market',
                    builder: (context, state) => MarketQuotes(),
                  ),
                  GoRoute(
                    path: 'transfer',
                    builder: (context, state) => PoolTransferPage(),
                  ),
                  GoRoute(
                    path: 'keytool',
                    builder: (context, state) => KeyToolPage(),
                  ),
                  GoRoute(
                      path: 'about',
                      builder: (context, state) {
                        return AboutPage(state.extra as String);
                      }),
                ]),
          ],
        ),
      ],
    ),
    GoRoute(path: '/decrypt_db', builder: (context, state) => DbLoginPage()),
    GoRoute(
      path: '/splash',
      builder: (context, state) => SplashPage(),
      redirect: (context, state) {
        final c = coins.first;
        if (isMobile()) return null; // db encryption is only for desktop
        if (!File(c.dbFullPath).existsSync()) return null; // fresh install
        if (WarpApi.decryptDb(c.dbFullPath, appStore.dbPassword))
          return null; // not encrypted
        return '/decrypt_db';
      },
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => WelcomePage(),
    ),
    GoRoute(
      path: '/first_account',
      builder: (context, state) => NewImportAccountPage(first: true),
    ),
    GoRoute(
      path: '/settings',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        final coin =
            state.uri.queryParameters['coin']?.let(int.parse) ?? aa.coin;
        return SettingsPage(coin: coin);
      },
    ),
    GoRoute(
      path: '/scan',
      builder: (context, state) => ScanQRCodePage(state.extra as ScanQRContext),
    ),
  ],
);

class ScaffoldBar extends StatefulWidget {
  final StatefulNavigationShell shell;

  const ScaffoldBar({required this.shell, Key? key});

  @override
  State<ScaffoldBar> createState() => _ScaffoldBar();
}

class _ScaffoldBar extends State<ScaffoldBar> {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(aa.name),
        centerTitle: true,
        actions: [
          IconButton(onPressed: help, icon: Icon(Icons.help)),
          IconButton(onPressed: settings, icon: Icon(Icons.settings)),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance), label: s.balance),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: s.messages),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: s.history),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: s.more),
        ],
        currentIndex: widget.shell.currentIndex,
        onTap: (index) {
          widget.shell.goBranch(index);
        },
      ),
      body: Padding(padding: EdgeInsets.all(8), child: widget.shell),
    );
  }

  help() {
    launchUrl(Uri.https('ywallet.app'));
  }

  settings() {
    GoRouter.of(context).push('/settings');
  }
}

class PlaceHolderPage extends StatelessWidget {
  final String title;
  final Widget? child;
  PlaceHolderPage(this.title, {this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(title)), body: child);
  }
}
