import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:warp/main.dart';
import 'package:warp/store.dart';

import 'about.dart';

class AccountManagerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AccountManagerState();
}

class AccountManagerState extends State<AccountManagerPage> {
  var _accountNameController = TextEditingController();

  @override
  initState() {
    super.initState();
    Future.microtask(accountManager.refresh);
    showAboutOnce(this.context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Accounts'), actions: [
          PopupMenuButton<String>(
              itemBuilder: (context) => [
                    PopupMenuItem(child: Text('Settings'), value: "Settings"),
                    PopupMenuItem(child: Text("About"), value: "About"),
                  ],
              onSelected: _onMenu)
        ]),
        body: Observer(
            builder: (context) => Stack(children: [
                  accountManager.accounts.isEmpty
                      ? Center(
                          child: Text("No account",
                              style: Theme.of(context).textTheme.headline5))
                      : ListView(
                          children: accountManager.accounts
                              .asMap()
                              .entries
                              .map((a) => Card(
                                      child: Dismissible(
                                    key: Key(a.value.name),
                                    child: ListTile(
                                      title: Text(a.value.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5),
                                      trailing:
                                          Text("${a.value.balance / ZECUNIT}"),
                                      onTap: () {
                                        _selectAccount(a.value);
                                      },
                                      onLongPress: () {
                                        _editAccount(a.value);
                                      },
                                    ),
                                    confirmDismiss: _onAccountDelete,
                                    onDismissed: (direction) =>
                                        _onDismissed(a.key, a.value.id),
                                  )))
                              .toList()),
                ])),
        floatingActionButton: FloatingActionButton(
            onPressed: _onRestore, child: Icon(Icons.add)));
  }

  Future<bool> _onAccountDelete(DismissDirection _direction) async {
    if (accountManager.accounts.length == 1) return false;
    final confirm = showDialog<bool>(
      context: this.context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
          title: Text('Seed'),
          content: Text(
              'Are you SURE you want to DELETE this account? You MUST have a BACKUP to recover it. This operation is NOT reversible.'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(this.context).pop(false);
              },
            ),
            TextButton(
              child: Text('DELETE'),
              onPressed: () {
                Navigator.of(this.context).pop(true);
              },
            ),
          ]),
    );
    return confirm;
  }

  void _onDismissed(int index, int account) async {
    await accountManager.delete(account);
    accountManager.refresh();
  }

  _selectAccount(Account account) async {
    await accountManager.setActiveAccount(account);
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
                title: Text('Change Account Name'),
                content: TextField(controller: _accountNameController),
                actions: [
                  ElevatedButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  ElevatedButton(
                    child: Text('OK'),
                    onPressed: () {
                      _changeAccountName();
                    },
                  ),
                ]));
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
