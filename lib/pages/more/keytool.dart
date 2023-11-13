import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:warp_api/data_fb_generated.dart';
import 'package:warp_api/warp_api.dart';

import '../../router.dart';
import '../../accounts.dart';
import '../../appsettings.dart';
import '../../coin/coins.dart';
import '../../generated/intl/messages.dart';
import '../../tablelist.dart';
import '../widgets.dart';

class KeyToolPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _KeyToolState();
}

class _KeyToolState extends State<KeyToolPage> {
  List<KeyPackT> keys = [];
  final formKey = GlobalKey<FormBuilderState>();
  bool shielded = false;
  int account = 0;
  bool external = true;
  int address = 0;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
        appBar: AppBar(title: Text(s.keyTool), actions: [
          IconButton(onPressed: refresh, icon: Icon(Icons.refresh))
        ]),
        body: TableListPage(
          key: UniqueKey(),
          view: 2,
          items: keys,
          metadata: TableListKeyMetadata(
              shielded: shielded,
              accountIndex: account,
              external: external,
              addressIndex: address,
              formKey: formKey),
        ));
  }

  void refresh() {
    final form = formKey.currentState!;
    if (form.validate()) {
      form.save();
      account = int.parse(form.fields['account']!.value);
      external = form.fields['external']?.value as bool;
      address = int.parse(form.fields['address']?.value);
      shielded = form.fields['shielded']?.value as bool;
      final ext = external ? 0 : 1; // only used by taddr

      print('$account $external $address');

      keys.clear();
      for (var a = 0; a < 100; a++) {
        final zkp =
            WarpApi.deriveZip32(aa.coin, aa.id, account + a, 0, null).unpack();
        final tkp =
            WarpApi.deriveZip32(aa.coin, aa.id, account, ext, address + a)
                .unpack();
        final kp = KeyPackT(
            tAddr: tkp.tAddr, tKey: tkp.tKey, zAddr: zkp.zAddr, zKey: zkp.zKey);
        keys.add(kp);
      }
    }
    setState(() {});
  }
}

class TableListKeyMetadata extends TableListItemMetadata<KeyPackT> {
  final s = S.of(rootNavigatorKey.currentContext!);
  final coinIndex = coins[aa.coin].coinIndex;
  final int accountIndex;
  final int addressIndex;
  final bool shielded;
  final bool external;
  int? selection;
  final GlobalKey<FormBuilderState> formKey;
  TableListKeyMetadata(
      {required this.shielded,
      required this.accountIndex,
      required this.external,
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
  Widget toListTile(BuildContext context, int index, KeyPackT item,
      {void Function(void Function())? setState}) {
    final address = shielded ? item.zAddr! : item.tAddr!;
    final key = shielded ? item.zKey! : item.tKey!;
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
                    Panel(s.key, text: key),
                  ],
                )
              : ListTile(leading: Text(idx.toString()), title: Text(address))),
    );
  }

  @override
  DataRow toRow(BuildContext context, int index, KeyPackT item) {
    final idx = shielded ? accountIndex + index : addressIndex + index;
    final address = shielded ? item.zAddr! : item.tAddr!;
    final key = shielded ? item.zKey! : item.tKey!;

    return DataRow.byIndex(index: index, cells: [
      DataCell(Text(idx.toString())),
      DataCell(Text(path(index))),
      DataCell(Text(address)),
      DataCell(Text(key)),
    ]);
  }

  String path(index) {
    final ext = external ? '0' : '1';
    return shielded
        ? "m/32'/$coinIndex'/${accountIndex + index}'"
        : "m/44'/$coinIndex'/$accountIndex'/$ext/${addressIndex + index}";
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
            FormBuilderSwitch(
              name: 'external',
              title: Text(s.external),
              initialValue: external,
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
