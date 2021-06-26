import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:warp/main.dart';
import 'package:warp/store.dart';

class AccountManagerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AccountManagerState();
}

class AccountManagerState extends State<AccountManagerPage> {
  @override
  initState() {
    Future.microtask(accountManager.refresh);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Accounts')),
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
    final confirm = showDialog<bool>(
      context: this.context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
          title: Text('Seed'),
          content: Text('Are you SURE you want to DELETE this account?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(this.context).pop(false);
              },
            ),
            TextButton(
              child: Text('OK'),
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

  _selectAccount(Account account) {
    accountManager.setActiveAccount(account);
    final navigator = Navigator.of(context);
    if (navigator.canPop())
      navigator.pop();
    else
      navigator.pushReplacementNamed('/account');
  }

  _onRestore() {
    Navigator.of(context).pushNamed('/restore');
  }
}
