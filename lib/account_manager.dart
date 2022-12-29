import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:warp_api/warp_api.dart';
import 'main.dart';
import 'rescan.dart';
import 'generated/l10n.dart';
import 'about.dart';
import 'accounts.dart';

class AccountManagerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AccountManagerState();
}

class AccountManagerState extends State<AccountManagerPage> {
  var _accountNameController = TextEditingController();
  var _countController = TextEditingController(text: '1');
  var _accounts = AccountList();

  @override
  initState() {
    super.initState();
    Future.microtask(() async {
      await _accounts.updateTBalance();
      if (mounted)
        setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nav = Navigator.of(context);

    if (active.id == 0) {
      Future.microtask(() async {
        nav.pushNamedAndRemoveUntil('/welcome', (route) => false);
        await syncStatus.update();
        for (var c in settings.coins) {
          syncStatus.markAsSynced(c.coin);
        }
      });
      return SizedBox();
    }

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
        body: Padding(padding: EdgeInsets.all(8), child: ListView.builder(
                      itemCount: _accounts.list.length,
                      itemBuilder: (BuildContext context, int index) {
                      final a = _accounts.list[index];
                      final weight = settings.coins[a.coin].active == a.id ? FontWeight.bold : FontWeight.normal;
                      final zbal = a.balance / ZECUNIT;
                      final tbal = a.tbalance / ZECUNIT;
                      final balance = zbal + tbal;
                      return Card(
                          child: Dismissible(
                        key: Key(a.name),
                        child: ListTile(
                          leading: CircleAvatar(backgroundImage: settings.coins[a.coin].def.image),
                          title: Text(a.name,
                              style: theme.textTheme.headline5
                                ?.merge(TextStyle(fontWeight: weight))
                                .apply(color: a.coin == 0 ? theme.colorScheme.primary : theme.colorScheme.secondary,
                              )),
                          subtitle: Text("${decimalFormat(zbal, 3)} + ${decimalFormat(tbal, 3)}"),
                          trailing: Text(decimalFormat(balance, 3)),
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
        floatingActionButton: SpeedDial(
          icon: Icons.add,
          onPress: _onAddAccount,
          children: [
            SpeedDialChild(
              child: Icon(Icons.download),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              label: 'Restore Batch',
              onTap: _onFullRestore,
            ),
            SpeedDialChild(
              child: Icon(Icons.upload),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              label: 'Save Batch',
              onTap: _onFullBackup,
            ),
            SpeedDialChild(
              child: Icon(Icons.subdirectory_arrow_right),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              label: 'New Sub-account',
              onTap: _onNewSubaccount,
            ),
            SpeedDialChild(
              child: Icon(Icons.scanner),
              backgroundColor: Colors.yellow,
              foregroundColor: Colors.white,
              label: 'Scan Accounts',
              onTap: _onScanSubAccounts,
            ),
          ]
        ));
  }

  Future<bool> _onAccountDelete(Account account) async {
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
    final tbal = account.tbalance;
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
    await _accounts.delete(account.coin, account.id);
    _accounts.refresh();
    await active.checkAndUpdate();
  }

  _selectAccount(Account account) async {
    await active.setActiveAccount(account.coin, account.id);
    await active.refreshAccount();
    if (syncStatus.accountRestored) {
      syncStatus.setAccountRestored(false);
      final height = await rescanDialog(context);
      if (height != null)
        syncStatus.rescan(height);
    }
    await syncStatus.update();

    final navigator = Navigator.of(context);
    navigator.pushNamedAndRemoveUntil('/account', (route) => false);
  }

  _editAccount(Account account) async {
    _accountNameController.text = account.name;
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text(S.of(context).changeAccountName),
            content: TextField(controller: _accountNameController),
            actions: confirmButtons(context, () { _changeAccountName(account); })));
  }

  _changeAccountName(Account account) {
    _accounts.changeAccountName(account.coin, account.id, _accountNameController.text);
    Navigator.of(context).pop();
    setState(() {});
  }

  _onAddAccount() {
    Navigator.of(context).pushNamed('/add_account');
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

  _onNewSubaccount() async {
    final s = S.of(context);
    if (active.id == 0) {
      showSnackBar(s.noActiveAccount);
      return;
    }
    final newName = s.subAccountOf(active.account.name);
    _accountNameController.text = newName;
    final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
            title: Text(s.newSubAccount),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(
                decoration: InputDecoration(label: Text(s.accountName)),
                controller: _accountNameController),
              TextField(
                decoration: InputDecoration(label: Text(s.count)),
                controller: _countController,
                keyboardType: TextInputType.number,
              ),
            ]),
            actions: confirmButtons(context, () {
              Navigator.of(context).pop(true);
            })));
    if (confirmed == true) {
      WarpApi.newSubAccount(_accountNameController.text, -1,
          int.parse(_countController.text));
    }
    await _refresh();
  }

  _refresh() async {
    _accounts.refresh();
    setState(() {});
  }
  
  _onFullBackup() {
    Navigator.of(context).pushNamed('/fullBackup');
  }

  _onFullRestore() {
    Navigator.of(this.context).pushNamed('/fullRestore');
  }

  _onScanSubAccounts() {
    Navigator.of(this.context).pushNamed('/scantaddr');
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
