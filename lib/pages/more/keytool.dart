import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:warp/data_fb_generated.dart';
import 'package:warp/warp.dart';

import '../../router.dart';
import '../../accounts.dart';
import '../../coin/coins.dart';
import '../../generated/intl/messages.dart';
import '../../store.dart';
import '../../tablelist.dart';
import '../../pages/utils.dart';
import '../widgets.dart';

class KeyToolPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _KeyToolState();
}

class _KeyToolState extends State<KeyToolPage> with WithLoadingAnimation {
  late final seed = aa.seed!;
  List<Zip32KeysT> keys = [];
  final formKey = GlobalKey<FormBuilderState>();
  bool shielded = false;
  int account = 0;
  int addrIndex = 0;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
        appBar: AppBar(title: Text(s.keyTool), actions: [
          IconButton(onPressed: refresh, icon: Icon(Icons.refresh))
        ]),
        body: wrapWithLoading(Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TableListPage(
              key: UniqueKey(),
              view: 2,
              items: keys,
              metadata: TableListKeyMetadata(
                  seed: seed,
                  shielded: shielded,
                  accountIndex: account,
                  addressIndex: addrIndex,
                  formKey: formKey),
            ))));
  }

  void refresh() {
    final form = formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      account = int.parse(form.fields['account']!.value);
      addrIndex = int.parse(form.fields['address']?.value);
      shielded = form.fields['shielded']?.value as bool;

      final coin = aa.coin;
      final id = aa.id;
      keys.clear();
      load(() => _computeKeys(coin, id, account, addrIndex));
    }
    setState(() {});
  }

  Future<void> _computeKeys(int coin, int account, int aindex, int addrIndex) async {
    for (int a = 0; a < 100; a++) {
      final kp = await warp.deriveZip32Keys(coin, account, aindex, addrIndex + a);
      keys.add(kp);
    }
  }
}

class TableListKeyMetadata extends TableListItemMetadata<Zip32KeysT> {
  final s = S.of(rootNavigatorKey.currentContext!);
  final String seed;
  final coinIndex = coins[aa.coin].coinIndex;
  final int accountIndex;
  final int addressIndex;
  final bool shielded;
  int? selection;
  final GlobalKey<FormBuilderState> formKey;
  TableListKeyMetadata(
      {required this.seed,
      required this.shielded,
      required this.accountIndex,
      required this.addressIndex,
      required this.formKey});

  @override
  List<ColumnDefinition> columns(BuildContext context) {
    return [
      ColumnDefinition(label: s.index),
      ColumnDefinition(label: s.derpath),
      ColumnDefinition(label: s.address, field: 'address'),
      ColumnDefinition(label: s.secretKey, field: 'sk'),
    ];
  }

  @override
  Widget toListTile(BuildContext context, int index, Zip32KeysT item,
      {void Function(void Function())? setState}) {
    final address = shielded ? item.zaddress! : item.taddress!;
    final key = shielded ? item.zsk! : item.tsk!;
    final derPath = path(index);
    final selected = selection == index;
    final idx = shielded ? accountIndex + index : addressIndex + index;

    return GestureDetector(
      onTap: () => setState?.call(() => selection = !selected ? index : null),
      child: Card(
          margin: EdgeInsets.all(8),
          child: selected
              ? Column(
                  children: [
                    Panel(s.index, text: idx.toString()),
                    Gap(8),
                    Panel(s.derpath, text: derPath),
                    Gap(8),
                    Panel(s.address, text: address),
                    Gap(8),
                    Panel(s.secretKey, text: key),
                    Gap(8),
                    IconButton(
                      onPressed: () => addSubAccount(
                        context,
                        seed,
                        idx,
                      ),
                      icon: Icon(Icons.add),
                    ),
                  ],
                )
              : ListTile(leading: Text(idx.toString()), title: Text(address))),
    );
  }

  @override
  DataRow toRow(BuildContext context, int index, Zip32KeysT item) {
    final idx = shielded ? accountIndex + index : addressIndex + index;
    final address = shielded ? item.zaddress! : item.taddress!;
    final key = shielded ? item.zsk! : item.tsk!;

    return DataRow.byIndex(index: index, cells: [
      DataCell(Text(idx.toString())),
      DataCell(Text(path(index))),
      DataCell(Text(address)),
      DataCell(Text(key)),
    ]);
  }

  String path(index) {
    return shielded
        ? "m/32'/$coinIndex'/${accountIndex + index}'"
        : "m/44'/$coinIndex'/$accountIndex'/0/${addressIndex + index}";
  }

  @override
  Widget? header(BuildContext context) {
    return FormBuilder(
        key: formKey,
        child: Column(
          children: [
            FormBuilderTextField(
              name: 'account',
              decoration: InputDecoration(label: Text(s.accountIndex)),
              initialValue: accountIndex.toString(),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.integer(),
              ]),
            ),
            FormBuilderTextField(
              name: 'address',
              decoration: InputDecoration(label: Text(s.addressIndex)),
              initialValue: addressIndex.toString(),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.integer(),
              ]),
            ),
            FormBuilderSwitch(
              name: 'shielded',
              title: Text(s.shielded),
              initialValue: shielded,
            ),
          ],
        ));
  }

  @override
  List<Widget>? actions(BuildContext context) => null;

  @override
  Text? headerText(BuildContext context) => null;

  @override
  void inverseSelection() {}

  @override
  SortConfig2? sortBy(String field) => null;
}

void addSubAccount(BuildContext context, String seed, int index) {
  GoRouter.of(context).push('/more/account_manager/new',
      extra: SeedInfo(seed: seed, index: index));
}
