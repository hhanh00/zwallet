import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:warp/main.dart';
import 'package:warp/store.dart';
import 'generated/l10n.dart';

import 'about.dart';

class AccountManagerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AccountManagerState();
}

class AccountManagerState extends State<AccountManagerPage> {
  var _accountNameController = TextEditingController();
  var _tbalances = Map<int, int>();

  @override
  initState() {
    super.initState();
    Future.microtask(() async {
      await accountManager.refresh();
      final tbalances = await accountManager.getAllTBalances();
      setState(() {
        _tbalances = tbalances;
      });
    });
    showAboutOnce(this.context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(S.of(context).selectAccount), actions: [
          PopupMenuButton<String>(
              itemBuilder: (context) => [
                    PopupMenuItem(
                        child: Text(S.of(context).settings), value: "Settings"),
                    PopupMenuItem(
                        child: Text(S.of(context).about), value: "About"),
                  ],
              onSelected: _onMenu)
        ]),
        body: Observer(
            builder: (context) =>
                  accountManager.accounts.isEmpty
                      ? Center(child: NoAccount())
                      : ListView.builder(
                          itemCount: accountManager.accounts.length,
                          itemBuilder: (BuildContext context, int index) {
                          final a = accountManager.accounts[index];
                          final zbal = a.balance / ZECUNIT;
                          final tbal = (_tbalances[a.id] ?? 0) / ZECUNIT;
                          final balance = zbal + tbal;
                          return Card(
                              child: Dismissible(
                            key: Key(a.name),
                            child: ListTile(
                              title: Text(a.name,
                                  style: Theme.of(context).textTheme.headline5),
                              subtitle: Text("${zbal.toStringAsFixed(3)} + ${_tbalances[a.id] != null ? tbal.toStringAsFixed(3) : '?'}"),
                              trailing: Text("${balance.toStringAsFixed(3)}"),
                              onTap: () {
                                _selectAccount(a);
                              },
                              onLongPress: () {
                                _editAccount(a);
                              },
                            ),
                            confirmDismiss: (d) => _onAccountDelete(a),
                            onDismissed: (d) =>
                                _onDismissed(index, a),
                          ));
                        }),
                ),
        floatingActionButton: FloatingActionButton(
            onPressed: _onRestore, child: Icon(Icons.add)));
  }

  Future<bool> _onAccountDelete(Account account) async {
    if (accountManager.accounts.length == 1) return false;
    final confirm1 = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
          title: Text(S.of(context).deleteAccount),
          content: Text(S.of(context).confirmDeleteAccount),
          actions: confirmButtons(context, () {
            Navigator.of(context).pop(true);
          }, okLabel: S.of(context).delete, cancelValue: false)),
    );
    final confirm2 = confirm1 ?? false;
    if (!confirm2) return false;

    final zbal = account.balance;
    final tbal = _tbalances[account.id] ?? 0;
    if (zbal + tbal > 0) {
      final confirm3 = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
            title: Text(S.of(context).deleteAccount),
            content: Text(S.of(context).accountHasSomeBalanceAreYouSureYouWantTo),
            actions: confirmButtons(context, () {
              Navigator.of(context).pop(true);
            }, okLabel: S.of(context).delete, cancelValue: false)),
      );
      return confirm3 ?? false;
    }
    return true;
  }

  void _onDismissed(int index, Account account) async {
    await accountManager.delete(account.id);
    accountManager.refresh();
  }

  _selectAccount(Account account) async {
    await accountManager.setActiveAccount(account);
    if (syncStatus.accountRestored) {
      syncStatus.setAccountRestored(false);
      await rescanDialog(context, () {
          syncStatus.sync(context);
          Navigator.of(context).pop();
        });
    }

    final navigator = Navigator.of(context);
    if (navigator.canPop())
      navigator.pop();
    else
      navigator.pushReplacementNamed('/account');
  }

  _editAccount(Account account) async {
    _accountNameController.text = account.name;
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text(S.of(context).changeAccountName),
            content: TextField(controller: _accountNameController),
            actions: confirmButtons(context, _changeAccountName)));
  }

  _changeAccountName() {
    accountManager.changeAccountName(_accountNameController.text);
    Navigator.of(context).pop();
  }

  _onRestore() {
    Navigator.of(context).pushNamed('/restore');
  }

  _onMenu(String choice) {
    switch (choice) {
      case "Settings":
        _settings();
        break;
      case "About":
        showAbout(this.context);
        break;
    }
  }

  _settings() {
    Navigator.of(this.context).pushNamed('/settings');
  }
}

class NoAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Widget wallet = SvgPicture.asset('assets/wallet.svg',
        color: Theme.of(context).primaryColor, semanticsLabel: 'Wallet');

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(child: wallet, height: 150, width: 150),
      Padding(padding: EdgeInsets.symmetric(vertical: 16)),
      Text(S.of(context).noAccount,
          style: Theme.of(context).textTheme.headline5),
      Padding(padding: EdgeInsets.symmetric(vertical: 8)),
      Text(S.of(context).createANewAccount,
          style: Theme.of(context).textTheme.bodyText1),
    ]);
  }
}
