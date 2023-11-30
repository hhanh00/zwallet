import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warp_api/data_fb_generated.dart';
import 'package:warp_api/warp_api.dart';

import '../../accounts.dart';
import '../../coin/coins.dart';
import '../../generated/intl/messages.dart';
import '../utils.dart';

class AccountManagerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AccountManagerState();
}

class _AccountManagerState extends State<AccountManagerPage> {
  late final s = S.of(context);
  int? selected;
  bool editing = false;
  final accountsKey = GlobalKey<AccountListState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(s.accountManager), actions: [
          if (selected != null)
            IconButton(onPressed: edit, icon: Icon(Icons.edit)),
          if (selected != null)
            IconButton(onPressed: delete, icon: Icon(Icons.delete)),
          if (selected != null)
            IconButton(onPressed: cold, icon: Icon(MdiIcons.snowflake)),
          if (selected == null)
            IconButton(onPressed: add, icon: Icon(Icons.add)),
          if (selected != null)
            IconButton(onPressed: select, icon: Icon(Icons.check)),
        ]),
        body: AccountList(
          key: accountsKey,
          editing: editing,
          onSelect: (v) => setState(() => selected = v),
          onEdit: onEdit,
        ));
  }

  add() async {
    await GoRouter.of(context).push('/account/account_manager/new');
    setState(() {});
  }

  edit() {
    editing = true;
    setState(() {});
  }

  onEdit(String name) {
    final a = accounts[selected!];
    WarpApi.updateAccountName(a.coin, a.id, name);
    editing = false;
    setState(() {});
  }

  select() {
    final a = accounts[selected!];
    setActiveAccount(a.coin, a.id);
    Future(() async {
      final prefs = await SharedPreferences.getInstance();
      await aa.save(prefs);
    });
    aa.update(null);
    GoRouter.of(context).pop<Account>(a);
  }

  delete() async {
    final a = accounts[selected!];
    final confirmed =
        await showConfirmDialog(context, s.delete, s.confirmDeleteAccount);
    if (confirmed) {
      WarpApi.deleteAccount(a.coin, a.id);
      final ac = accounts.firstOrNull;
      if (ac != null)
        setActiveAccount(ac.coin, ac.id);
      else
        setActiveAccount(0, 0);
      selected = null;
      setState(() {});
    }
  }

  cold() async {
    final confirmed = await showConfirmDialog(
        context, s.convertToWatchonly, s.confirmWatchOnly);
    if (!confirmed) return;
    WarpApi.convertToWatchOnly(aa.coin, aa.id);
    setState(() {});
  }

  List<Account> get accounts => accountsKey.currentState!.widget.accounts;
}

class AccountList extends StatefulWidget {
  final int? initialSelect;
  final bool editing;
  final void Function(int?)? onSelect;
  final void Function(String)? onEdit;
  late final List<Account> accounts = _getAllAccounts().toList();
  AccountList({super.key, this.initialSelect, this.onSelect, this.editing = false, this.onEdit});

  @override
  State<StatefulWidget> createState() => AccountListState();

  _getAllAccounts() => coins.expand((c) => WarpApi.getAccountList(c.coin));
}

class AccountListState extends State<AccountList> {
  late int? selected = widget.initialSelect;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) {
          final a = widget.accounts[index];
          return AccountTile(
            a,
            selected: index == selected,
            editing: widget.editing,
            onTap: () {
              final v = selected != index ? index : null;
              widget.onSelect?.call(v);
              setState(() => selected = v);
            },
            onEdit: widget.onEdit,
          );
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: widget.accounts.length);
  }

  Account? get selectedAccount => selected?.let((s) => widget.accounts[s]);
}

class AccountTile extends StatelessWidget {
  final Account a;
  final void Function()? onTap;
  final bool selected;
  final bool editing;
  final void Function(String)? onEdit;
  late final nameController = TextEditingController(text: a.name);
  AccountTile(this.a,
      {this.onTap, required this.selected, required this.editing, this.onEdit});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final c = coins[a.coin];
    WidgetSpan? icon;
    switch (a.keyType) {
      case 0x80:
        icon = WidgetSpan(
            child: Icon(MdiIcons.snowflake, color: t.colorScheme.secondary),
            style: t.textTheme.bodyMedium);
        break;
      case 1: // secret key
        icon = WidgetSpan(
            child: Icon(MdiIcons.sprout, color: t.colorScheme.secondary),
            style: t.textTheme.bodyMedium);
        break;
      case 2: // ledger
        icon = WidgetSpan(
            child: SvgPicture.asset("assets/ledger.svg",
                height: 20, color: t.colorScheme.secondary));
        break;
    }
    return ListTile(
      selected: selected,
      leading: CircleAvatar(backgroundImage: c.image),
      title: editing && selected
          ? TextField(
              controller: nameController,
              autofocus: true,
              onEditingComplete: () => onEdit?.call(nameController.text))
          : RichText(
              text: TextSpan(children: [
              TextSpan(text: a.name, style: t.textTheme.headlineSmall),
              if (icon != null)
                WidgetSpan(
                    child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                )),
              if (icon != null) icon,
            ])),
      trailing: Text(amountToString2(a.balance)),
      onTap: onTap,
      selectedTileColor: t.colorScheme.inversePrimary,
    );
  }
}
