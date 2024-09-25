import 'package:YWallet/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:warp/data_fb_generated.dart';
import 'package:warp/warp.dart';

import '../../accounts.dart';
import '../../coin/coins.dart';
import '../../generated/intl/messages.dart';
import '../utils.dart';
import '../widgets.dart';

class AccountManagerPage extends StatefulWidget {
  final bool main;
  AccountManagerPage({required this.main});
  @override
  State<StatefulWidget> createState() => _AccountManagerState();
}

class _AccountManagerState extends State<AccountManagerPage> {
  late List<AccountNameT> accounts = getAllAccounts();
  late final s = S.of(context);
  int? selected;

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
        ]),
        body: AccountList(
          accounts,
          key: ValueKey(accounts),
          selected: selected,
          onSelect: (v) => select(v!),
          onLongSelect: (v) => setState(() => selected = v),
        ));
  }

  add() async {
    await GoRouter.of(context).push('/more/account_manager/new');
    _refresh();
    setState(() {});
  }

  select(int index) {
    final a = accounts[index];
    if (widget.main) {
      Future(() async {
        await setActiveAccount(a.coin, a.id);
        await aa.save();
      });
      aa.update(syncStatus.syncedHeight);
    }
    GoRouter.of(context).pop<AccountNameT>(a);
  }

  delete() async {
    final a = accounts[selected!];
    final count = accounts.length;
    if (count > 1 && a.coin == aa.coin && a.id == aa.id) {
      await showMessageBox2(context, s.error, s.cannotDeleteActive);
      return;
    }

    final confirmed = await showConfirmDialog(
        context, s.deleteAccount(a.name!), s.confirmDeleteAccount);
    if (confirmed) {
      await warp.deleteAccount(a.coin, a.id);
      _refresh();
      if (accounts.isEmpty) {
        await setActiveAccount(0, 0);
        GoRouter.of(context).go('/account');
      } else {
        selected = null;
        setState(() {});
      }
    }
  }

  edit() async {
    final a = accounts[selected!];
    await GoRouter.of(context).push('/account/edit', extra: a);
    _refresh();
    setState(() {});
  }

  cold() async {
    final a = accounts[selected!];
    await GoRouter.of(context).push('/account/downgrade', extra: a);
    _refresh();
    setState(() {});
  }

  _refresh() {
    setState(() {
      accounts = getAllAccounts();
    });
  }
}

class AccountList extends StatelessWidget {
  final List<AccountNameT> accounts;
  final int? selected;
  final void Function(int?)? onSelect;
  final void Function(int?)? onLongSelect;

  AccountList(
    this.accounts, {
    super.key,
    this.selected,
    this.onSelect,
    this.onLongSelect,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) {
          final a = accounts[index];
          return AccountTile(
            a,
            selected: index == selected,
            onPress: () => onSelect?.call(index),
            onLongPress: () {
              final v = selected != index ? index : null;
              onLongSelect?.call(v);
            },
          );
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: accounts.length);
  }
}

class AccountTile extends StatelessWidget {
  final AccountNameT a;
  final void Function()? onPress;
  final void Function()? onLongPress;
  final bool selected;
  late final nameController = TextEditingController(text: a.name);
  AccountTile(
    this.a, {
    this.onPress,
    this.onLongPress,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final c = coins[a.coin];
    List<InlineSpan> accountFeatures = [
      TextSpan(text: a.name, style: t.textTheme.headlineSmall),
      WidgetSpan(child: Gap(0, crossAxisExtent: 8)),
    ];
    if (a.keyType & 2 != 0) // T_SK
      accountFeatures
          .add(TextSpan(text: 'T', style: TextStyle(color: t.primaryColor)));
    else if (a.keyType & 1 != 0) // T_VK
      accountFeatures.add(TextSpan(text: 't'));
    if (a.keyType & 8 != 0) // T_SK
      accountFeatures
          .add(TextSpan(text: 'S', style: TextStyle(color: t.primaryColor)));
    else if (a.keyType & 4 != 0) // S_VK
      accountFeatures.add(TextSpan(text: 's'));
    if (a.keyType & 32 != 0) // O_SK
      accountFeatures
          .add(TextSpan(text: 'O', style: TextStyle(color: t.primaryColor)));
    else if (a.keyType & 16 != 0) // O_VK
      accountFeatures.add(TextSpan(text: 'o'));
    final accountRT = Text.rich(TextSpan(children: accountFeatures));

    return ListTile(
      selected: selected,
      leading: CircleAvatar(backgroundImage: c.image),
      title: accountRT,
      trailing: Text(amountToString(a.balance)),
      onTap: onPress,
      onLongPress: onLongPress,
      selectedTileColor: t.colorScheme.inversePrimary,
    );
  }
}

class EditAccountPage extends StatefulWidget {
  final AccountNameT account;
  EditAccountPage(this.account, {super.key});
  @override
  State<StatefulWidget> createState() => EditAccountState();
}

class EditAccountState extends State<EditAccountPage> {
  late final S s = S.of(context);
  final formKey = GlobalKey<FormBuilderState>();
  late final nameController = TextEditingController(text: widget.account.name);
  late int birth = widget.account.birth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(s.editAccount),
          actions: [IconButton(onPressed: ok, icon: Icon(Icons.check))]),
      body: Padding(
        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: FormBuilder(
          key: formKey,
          child: Column(children: [
            FormBuilderTextField(name: 'name', decoration: InputDecoration(label: Text(s.name)), controller: nameController),
            HeightPicker(birth, label: Text(s.birthHeight), onChanged: (v) => setState(() => birth = v!),),
          ]),
        ),
      ),
    );
  }

  ok() async {
    await warp.editAccountName(widget.account.coin, widget.account.id, 
      nameController.text);
    await warp.editAccountBirthHeight(widget.account.coin, widget.account.id, 
      birth);
    GoRouter.of(context).pop();
  }
}

class DowngradeAccountPage extends StatefulWidget {
  final AccountNameT account;
  DowngradeAccountPage(this.account, {super.key});
  @override
  State<StatefulWidget> createState() => DowngradeAccountState();
}

class DowngradeAccountState extends State<DowngradeAccountPage> {
  late final S s = S.of(context);
  late final AccountSigningCapabilitiesT accountCaps =
      warp.getAccountCapabilities(widget.account.coin, widget.account.id);
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    print(accountCaps);
    final keyOptions = [
      FormBuilderFieldOption(value: 3, child: Text(s.secretKey)),
      FormBuilderFieldOption(value: 1, child: Text(s.viewingKey)),
      FormBuilderFieldOption(value: 0, child: Text(s.noKey)),
    ];

    return Scaffold(
      appBar: AppBar(
          title: Text(s.downgradeAccount),
          actions: [IconButton(onPressed: downgrade, icon: Icon(Icons.check))]),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: FormBuilder(
            key: formKey,
            child: Column(children: [
              FormBuilderCheckbox(
                  name: 'seed',
                  title: Text(s.seed),
                  enabled: accountCaps.transparent == 3 &&
                      accountCaps.sapling == 3 &&
                      accountCaps.orchard == 3,
                  initialValue: accountCaps.seed,
                  onChanged: (v) {
                    setState(() => accountCaps.seed = v!);
                  }),
              FormBuilderRadioGroup(
                name: 'transparent',
                decoration: InputDecoration(label: Text(s.transparent)),
                options: keyOptions,
                initialValue: accountCaps.transparent,
                onChanged: (v) {
                  setState(() {
                    uncheckSeed();
                    accountCaps.transparent = v!;
                  });
                },
              ),
              FormBuilderRadioGroup(
                name: 'sapling',
                decoration: InputDecoration(label: Text(s.sapling)),
                options: keyOptions,
                initialValue: accountCaps.sapling,
                onChanged: (v) {
                  setState(() {
                    uncheckSeed();
                    accountCaps.sapling = v!;
                  });
                },
              ),
              FormBuilderRadioGroup(
                name: 'orchard',
                decoration: InputDecoration(label: Text(s.orchard)),
                options: keyOptions,
                initialValue: accountCaps.orchard,
                onChanged: (v) {
                  setState(() {
                    uncheckSeed();
                    accountCaps.orchard = v!;
                  });
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }

  uncheckSeed() {
    formKey.currentState!.fields['seed']!.setValue(false);
    accountCaps.seed = false;
  }

  downgrade() async {
    logger.d(accountCaps);
    final confirmed =
        await showConfirmDialog(context, s.coldStorage, s.confirmWatchOnly);
    if (confirmed) {
      try {
        await warp.downgradeAccount(
            widget.account.coin, widget.account.id, accountCaps);
        GoRouter.of(context).pop();
      } on String catch (e) {
        await showMessageBox2(context, s.error, e);
      }
    }
  }
}
