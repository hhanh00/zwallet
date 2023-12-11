import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
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
  bool selected = false;
  final listKey = GlobalKey<ContactListState>();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(s.contacts),
          actions: [
            if (selected) IconButton(onPressed: _edit, icon: Icon(Icons.edit)),
            if (selected)
              IconButton(onPressed: _delete, icon: Icon(Icons.delete)),
            // TODO: use coinsettings.contactsSaved flag
            IconButton(onPressed: _save, icon: Icon(Icons.save)),
            IconButton(onPressed: _add, icon: Icon(Icons.add)),
            if (widget.selectable && selected)
              IconButton(onPressed: _select, icon: Icon(Icons.check)),
          ],
        ),
        body: ContactList(
            key: listKey,
            onSelect: (v) => setState(() => selected = v != null)));
  }

  _select() {
    GoRouter.of(context).pop(listKey.currentState!.selectedContact);
  }

  _save() async {
    final s = S.of(context);
    final coinSettings = CoinSettingsExtension.load(aa.coin);
    final fee = coinSettings.feeT;
    final confirmed =
        await showConfirmDialog(context, s.save, s.confirmSaveContacts);
    if (!confirmed) return;
    final txPlan = WarpApi.commitUnsavedContacts(
        aa.coin, aa.id, appSettings.anchorOffset, fee, coinSettings.zFactor);
    GoRouter.of(context)
        .pushReplacement('/account/txplan?tab=more', extra: txPlan);
  }

  _add() {
    GoRouter.of(context).push('/more/contacts/add');
  }

  _edit() {
    final c = listKey.currentState!.selectedContact!;
    final id = c.id;
    GoRouter.of(context).push('/more/contacts/edit?id=$id');
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

class ContactList extends StatefulWidget {
  final int? initialSelect;
  final void Function(int?)? onSelect;
  ContactList({super.key, this.initialSelect, this.onSelect});

  @override
  State<StatefulWidget> createState() => ContactListState();
}

class ContactListState extends State<ContactList> {
  late int? selected = widget.initialSelect;
  @override
  Widget build(BuildContext context) {
    final c = contacts.contacts;
    return ListView.separated(
      itemBuilder: (context, index) => ContactItem(c[index].unpack(),
          selected: selected == index, onTap: () {
        final v = selected != index ? index : null;
        widget.onSelect?.call(v);
        selected = v;
        setState(() {});
      }),
      separatorBuilder: (context, index) => Divider(),
      itemCount: c.length,
    );
  }

  Contact? get selectedContact => selected?.let((s) => contacts.contacts[s]);
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
      selectedTileColor: t.colorScheme.inversePrimary,
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
        body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: FormBuilder(
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
                    ])))));
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
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: FormBuilder(
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
                      minLines: 5,
                      maxLines: 5,
                    )),
                    IconButton.outlined(
                        onPressed: _qr, icon: Icon(Icons.qr_code)),
                  ]),
                ],
              ),
            ),
          ),
        ));
  }

  _qr() async {
    addressController.text =
        await scanQRCode(context, validator: addressValidator);
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
