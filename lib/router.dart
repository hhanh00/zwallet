import 'dart:typed_data';

import 'package:get_it/get_it.dart';

import 'generated/intl/messages.dart';
import 'pages/more/cold.dart';
import 'pages/more/transparent.dart';
import 'pages/more/vote.dart';
import 'pages/widgets.dart';
import 'settings.pb.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:warp/data_fb_generated.dart';

import 'accounts.dart';
import 'pages/accounts/manager.dart';
import 'pages/accounts/multipay.dart';
import 'pages/accounts/new_import.dart';
import 'pages/accounts/pay_uri.dart';
import 'pages/accounts/rescan.dart';
import 'pages/accounts/send.dart';
import 'pages/accounts/submit.dart';
import 'pages/accounts/txplan.dart';
import 'pages/dblogin.dart';
import 'pages/encrypt.dart';
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
import 'pages/tx.dart';
import 'pages/more/quotes.dart';
import 'pages/scan.dart';
import 'pages/showqr.dart';
import 'pages/splash.dart';
import 'pages/welcome.dart';
import 'pages/settings.dart';
import 'pages/messages.dart';
import 'pages/utils.dart';
import 'store.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final _accountNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/decrypt_db',
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
                print('/account ${aa.id}');
                if (aa.id == 0) return '/welcome';
                return null;
              },
              routes: [
                GoRoute(
                    path: 'multi_pay',
                    builder: (context, state) =>
                        MultiPayPage(state.extra as PaymentRequestT?),
                    routes: [
                      GoRoute(
                          path: 'new',
                          builder: (context, state) =>
                              SendPage(null, single: false)),
                    ]),
                // GoRoute(
                //   path: 'swap',
                //   builder: (context, state) => SwapPage(),
                //   routes: [
                //     GoRoute(
                //         path: 'history',
                //         builder: (context, state) => SwapHistoryPage(),
                //     ),
                //     // GoRoute(
                //     //     path: 'stealthex',
                //     //     builder: (context, state) => StealthExPage(),
                //     //     routes: [
                //     //       GoRoute(
                //     //           path: 'details',
                //     //           builder: (context, state) =>
                //     //               StealthExSummaryPage(state.extra as SwapT)),
                //     //     ]),
                //   ],
                // ),
                GoRoute(
                  path: 'txplan',
                  builder: (context, state) => TxPlanPage(
                    state.extra as TransactionSummaryT,
                    tab: state.uri.queryParameters['tab']!,
                    signOnly: state.uri.queryParameters['sign'] != null,
                  ),
                ),
                GoRoute(
                  path: 'broadcast_tx',
                  builder: (context, state) =>
                      SubmitTxPage(state.extra as TransactionBytesT),
                ),
                GoRoute(
                    path: 'export_raw_tx',
                    builder: (context, state) {
                      final s = GetIt.I.get<S>();
                      final tx = state.extra as TransactionSummaryT;
                      return AnimatedQRExportPage(tx.toBin(),
                          title: s.rawTransaction, filename: 'tx.raw');
                    }),
                GoRoute(
                  path: 'rescan',
                  builder: (context, state) => RescanPage(),
                ),
                GoRoute(
                  path: 'send',
                  builder: (context, state) {
                    final p = state.extra as PaymentRequestT?;
                    return SendPage(
                      p,
                      single: true,
                    );
                  },
                  routes: [
                    GoRoute(
                      path: 'contacts',
                      builder: (context, state) => ContactsPage(main: false),
                    ),
                    GoRoute(
                      path: 'accounts',
                      builder: (context, state) =>
                          AccountManagerPage(main: false),
                    ),
                  ],
                ),
                GoRoute(
                  path: 'payment_uri',
                  builder: (context, state) => PaymentURIPage(),
                ),
                GoRoute(
                  path: 'edit',
                  builder: (context, state) =>
                      EditAccountPage(state.extra as AccountNameT),
                ),
                GoRoute(
                  path: 'downgrade',
                  builder: (context, state) =>
                      DowngradeAccountPage(state.extra as AccountNameT),
                )
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
                path: '/contacts',
                builder: (context, state) => ContactsPage(main: true),
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
                  GoRoute(
                    path: 'broadcast_tx',
                    builder: (context, state) =>
                        SubmitTxPage(state.extra as TransactionBytesT),
                  ),
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
                      path: 'account_manager',
                      builder: (context, state) =>
                          AccountManagerPage(main: true),
                      routes: [
                        GoRoute(
                            path: 'new',
                            builder: (context, state) => NewImportAccountPage(
                                first: false,
                                seedInfo: state.extra as SeedInfo?)),
                      ]),
                  GoRoute(
                      path: 'transparent',
                      builder: (context, state) =>
                          PlaceHolderPage("transparent"),
                      routes: [
                        GoRoute(
                            path: 'addresses',
                            builder: (context, state) =>
                                TransparentAddressesPage(),
                            routes: [
                              GoRoute(
                                path: 'scan',
                                builder: (context, state) =>
                                    ScanTransparentAddressesPage(),
                              ),
                            ]),
                        GoRoute(
                          path: 'utxos',
                          builder: (context, state) => ListUTXOPage(),
                        ),
                      ]),
                  GoRoute(
                      path: 'cold',
                      builder: (context, state) => PlaceHolderPage('Cold'),
                      routes: [
                        GoRoute(
                          path: 'sign',
                          builder: (context, state) => ColdSignPage(),
                        ),
                        GoRoute(
                          path: 'broadcast',
                          builder: (context, state) => BroadcastTxPage(),
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
                    routes: [
                      GoRoute(
                        path: 'keygen',
                        builder: (context, state) => KeygenPage(),
                      ),
                    ],
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
                    path: 'signed',
                    builder: (context, state) {
                      final S s = GetIt.I.get<S>();
                      return AnimatedQRExportPage(state.extra as Uint8List,
                          title: s.signedTx, filename: 'tx.sgn');
                    },
                  ),
                  GoRoute(
                    path: 'vote',
                    builder: (context, state) => VotePage(),
                    routes: [
                      GoRoute(
                        path: 'notes',
                        builder: (context, state) =>
                            VoteNotesPage(state.extra as Vote),
                      ),
                      GoRoute(
                        path: 'candidate',
                        builder: (context, state) =>
                            VoteCandidatePage(state.extra as Vote),
                      ),
                    ],
                  ),
                  GoRoute(
                      path: 'about',
                      builder: (context, state) =>
                          AboutPage(state.extra as String)),
                  GoRoute(
                    path: 'broadcast_tx',
                    builder: (context, state) =>
                        SubmitTxPage(state.extra as TransactionBytesT),
                  ),
                ]),
          ],
        ),
      ],
    ),
    GoRoute(path: '/decrypt_db', builder: (context, state) => DbLoginPage()),
    GoRoute(path: '/disclaimer', builder: (context, state) => DisclaimerPage()),
    GoRoute(
      path: '/splash',
      builder: (context, state) => SplashPage(),
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
      path: '/quick_send_settings',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) =>
          QuickSendSettingsPage(state.extra as CustomSendSettings),
    ),
    GoRoute(
      path: '/encrypt_db',
      builder: (context, state) => EncryptDbPage(),
    ),
    GoRoute(
      path: '/scan',
      builder: (context, state) => ScanQRCodePage(state.extra as ScanQRContext),
    ),
    GoRoute(
      path: '/showqr',
      builder: (context, state) => ShowQRPage(
          title: state.uri.queryParameters['title'] ?? '',
          text: state.extra as String),
    ),
    GoRoute(
        path: '/calendar_height',
        builder: (context, state) =>
            CalendarHeightPage(state.extra as DateTime)),
    GoRoute(
        path: '/contacts_saved',
        builder: (context, state) {
          final coin = int.parse(state.uri.queryParameters['coin']!);
          final account = int.parse(state.uri.queryParameters['account']!);
          return ContactsSavedPage(coin, account);
        })
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
    final router = GoRouter.of(context);
    final RouteMatch lastMatch =
        router.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : router.routerDelegate.currentConfiguration;
    final String location = matchList.uri.toString();

    return PopScope(
        canPop: location == '/account',
        onPopInvoked: _onPop,
        child: Scaffold(
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
              BottomNavigationBarItem(
                  icon: Icon(Icons.message), label: s.messages),
              BottomNavigationBarItem(
                  icon: Icon(Icons.view_list), label: s.history),
              BottomNavigationBarItem(
                  icon: Icon(Icons.contacts), label: s.contacts),
              BottomNavigationBarItem(
                  icon: Icon(Icons.more_horiz), label: s.more),
            ],
            currentIndex: widget.shell.currentIndex,
            onTap: (index) {
              widget.shell.goBranch(index);
            },
          ),
          body: widget.shell,
        ));
  }

  help() {
    launchUrl(Uri.https('ywallet.app'));
  }

  settings() {
    GoRouter.of(context).push('/settings');
  }

  _onPop(bool didPop) {
    router.go('/account');
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
