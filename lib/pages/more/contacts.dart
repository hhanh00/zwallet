import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:warp_api/data_fb_generated.dart';
import 'package:warp_api/warp_api.dart';

import '../../accounts.dart';
import '../../appsettings.dart';
import '../../generated/intl/messages.dart';
import '../../store2.dart';
import '../scan.dart';
import '../utils.dart';

class ContactsPage extends StatefulWidget {
  final bool selectable;
  ContactsPage({this.selectable = false}) {
    contacts.fetchContacts();
  }

  @override
  State<StatefulWidget> createState() => _ContactsState();
}

class _ContactsState extends State<ContactsPage> {
  int? idSelected;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(s.contacts),
          actions: [
            if (idSelected != null)
              IconButton(onPressed: _edit, icon: Icon(Icons.edit)),
            if (idSelected != null)
              IconButton(onPressed: _delete, icon: Icon(Icons.delete)),
            IconButton(onPressed: _save, icon: Icon(Icons.save)), // TODO: use coinsettings.contactsSaved flag
            IconButton(onPressed: _add, icon: Icon(Icons.add)),
            if (widget.selectable && idSelected != null)
              IconButton(onPressed: _select, icon: Icon(Icons.check)),
          ],
        ),
        body: Observer(builder: (context) {
          final c = contacts.contacts;
          return ListView.separated(
            itemBuilder: (context, index) => ContactItem(c[index].unpack(),
                selected: idSelected == c[index].id,
                onTap: () => setState(() => idSelected =
                    idSelected != c[index].id ? c[index].id : null)),
            separatorBuilder: (context, index) => Divider(),
            itemCount: c.length,
          );
        }));
  }

  _select() {
    final c = contacts.contacts.firstWhere((c) => c.id == idSelected!);
    GoRouter.of(context).pop(c);
  }

  _save() async {
    final s = S.of(context);
    final coinSettings = CoinSettingsExtension.load(aa.coin);
    final fee = coinSettings.feeT;
    final confirmed =
        await showConfirmDialog(context, s.save, s.confirmSaveContacts);
    if (!confirmed) return;
    final txPlan =
        WarpApi.commitUnsavedContacts(aa.coin, appSettings.anchorOffset, fee);
    GoRouter.of(context)
        .pushReplacement('/account/txplan?tab=more', extra: txPlan);
  }

  _add() {
    GoRouter.of(context).push('/more/contacts/add');
  }

  _edit() {
    GoRouter.of(context).push('/more/contacts/edit?id=${idSelected!}');
  }

  _delete() async {
    final s = S.of(context);
    final confirmed =
        await showConfirmDialog(context, s.delete, s.confirmDeleteContact);
    if (!confirmed) return;
    GoRouter.of(context).pop();
    contacts.fetchContacts();
  }
}

class ContactItem extends StatelessWidget {
  final ContactT contact;
  final bool? selected;
  final void Function()? onTap;
  ContactItem(this.contact, {this.selected, this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return ListTile(
      title: Text(contact.name!, style: t.textTheme.headlineSmall),
      subtitle: Text(contact.address!),
      onTap: onTap,
      selected: selected ?? false,
    );
  }
}

class ContactEditPage extends StatefulWidget {
  final int id;
  ContactEditPage(this.id);

  @override
  State<StatefulWidget> createState() => _ContactEditState();
}

class _ContactEditState extends State<ContactEditPage> {
  final formKey = GlobalKey<FormBuilderState>();
  final nameController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final c = WarpApi.getContact(aa.coin, widget.id);
    nameController.text = c.name!;
    addressController.text = c.address!;
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(s.editContact),
          actions: [IconButton(onPressed: _save, icon: Icon(Icons.save))],
        ),
        body: FormBuilder(
            key: formKey,
            child: Column(children: [
              FormBuilderTextField(
                  name: 'name',
                  decoration: InputDecoration(label: Text(s.name)),
                  controller: nameController),
              FormBuilderTextField(
                name: 'address',
                decoration: InputDecoration(label: Text(s.address)),
                controller: addressController,
                maxLines: 10,
              ),
            ])));
  }

  _save() {
    WarpApi.storeContact(
        widget.id, nameController.text, addressController.text, true);
    contacts.fetchContacts();
  }
}

class ContactAddPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ContactAddState();
}

class _ContactAddState extends State<ContactAddPage> {
  final formKey = GlobalKey<FormBuilderState>();
  final nameController = TextEditingController();
  final addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(s.addContact),
        actions: [
          IconButton(onPressed: add, icon: Icon(Icons.add)),
        ],
      ),
      body: FormBuilder(
        key: formKey,
        child: Column(
          children: [
            FormBuilderTextField(
              name: 'name',
              decoration: InputDecoration(label: Text(s.name)),
              controller: nameController,
              validator: FormBuilderValidators.required(),
            ),
            Row(children: [
              Expanded(
                  child: FormBuilderTextField(
                name: 'address',
                decoration: InputDecoration(label: Text(s.address)),
                controller: addressController,
                validator: addressValidator,
              )),
              IconButton.outlined(onPressed: _qr, icon: Icon(Icons.qr_code)),
            ]),
          ],
        ),
      ),
    );
  }

  _qr() async {
    addressController.text = await scanQRCode(context, validator: addressValidator);
  }

  add() async {
    final form = formKey.currentState!;
    if (form.validate()) {
      WarpApi.storeContact(
          0, nameController.text, addressController.text, true);
      contacts.fetchContacts();
      GoRouter.of(context).pop();
    }
  }
}
