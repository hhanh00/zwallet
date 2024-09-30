import 'package:YWallet/pages/widgets.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:warp/data_fb_generated.dart';
import 'package:warp/warp.dart';

import '../../accounts.dart';
import '../../appsettings.dart';
import '../../generated/intl/messages.dart';
import '../../store.dart';
import '../scan.dart';
import '../utils.dart';

class ContactsPage extends StatefulWidget {
  final bool main;
  ContactsPage({this.main = false}) {
    contacts.fetchContacts();
  }

  @override
  State<StatefulWidget> createState() => _ContactsState();
}

class _ContactsState extends State<ContactsPage> {
  bool selected = false;
  final listKey = GlobalKey<ContactListState>();
  late final s = S.of(context);

  @override
  Widget build(BuildContext context) {
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
        ],
      ),
      body: ContactList(
        key: listKey,
        onSelect: widget.main ? _copyToClipboard : (v) => _select(v!),
        onLongSelect: (v) => setState(() => selected = v != null),
      ),
    );
  }

  _select(int v) {
    final c = contacts.contacts[v];
    if (!widget.main) GoRouter.of(context).pop(c);
  }

  _copyToClipboard(int? v) {
    final c = contacts.contacts[v!];
    Clipboard.setData(ClipboardData(text: c.address!));
    showSnackBar(s.addressCopiedToClipboard);
  }

  _save() async {
    final s = S.of(context);
    final confirmed =
        await showConfirmDialog(context, s.save, s.confirmSaveContacts);
    if (!confirmed) return;
    try {
      final txPlan = await warp.saveContacts(
          aa.coin,
          aa.id,
          syncStatus.confirmHeight,
          '/contacts_saved?coin=${aa.coin}&account=${aa.id}');
      GoRouter.of(context).push('/account/txplan?tab=contacts', extra: txPlan);
    } on String catch (m) {
      await showMessageBox(context, s.error, m, type: DialogType.error);
    }
  }

  _add() {
    GoRouter.of(context).push('/contacts/add');
  }

  _edit() {
    final c = listKey.currentState!.selectedContact!;
    final id = c.id;
    GoRouter.of(context).push('/contacts/edit?id=$id');
  }

  _delete() async {
    final s = S.of(context);
    final confirmed =
        await showConfirmDialog(context, s.delete, s.confirmDeleteContact);
    if (!confirmed) return;
    final c = listKey.currentState!.selectedContact!;
    warp.deleteContact(aa.coin, c.id);
    contacts.fetchContacts();
  }
}

class ContactList extends StatefulWidget {
  final int? initialSelect;
  final void Function(int?)? onSelect;
  final void Function(int?)? onLongSelect;
  ContactList(
      {super.key, this.initialSelect, this.onSelect, this.onLongSelect});

  @override
  State<StatefulWidget> createState() => ContactListState();
}

class ContactListState extends State<ContactList> {
  late int? selected = widget.initialSelect;
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      final c = contacts.contacts;
      return ListView.separated(
        itemBuilder: (context, index) => ContactItem(
          c[index],
          selected: selected == index,
          onLongPress: () {
            final v = selected != index ? index : null;
            widget.onLongSelect?.call(v);
            selected = v;
            setState(() {});
          },
          onPress: () => widget.onSelect?.call(index),
        ),
        separatorBuilder: (context, index) => Divider(),
        itemCount: c.length,
      );
    });
  }

  ContactCardT? get selectedContact =>
      selected?.let((s) => contacts.contacts[s]);
}

class ContactItem extends StatelessWidget {
  final ContactCardT contact;
  final bool? selected;
  final void Function()? onPress;
  final void Function()? onLongPress;
  ContactItem(this.contact, {this.selected, this.onPress, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return ListTile(
      title: Text(contact.name!, style: t.textTheme.headlineSmall),
      subtitle: Text(contact.address!),
      onTap: onPress,
      onLongPress: onLongPress,
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
    final c = warp.getContact(aa.coin, widget.id);
    nameController.text = c.name!;
    addressController.text = c.address!;
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(s.editContact),
          actions: [IconButton(onPressed: _save, icon: Icon(Icons.check))],
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
    warp.addContact(
        aa.coin,
        ContactCardT(
            id: widget.id,
            name: nameController.text,
            address: addressController.text,
            saved: false));
    contacts.fetchContacts();
    GoRouter.of(context).pop();
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
      warp.addContact(
          aa.coin,
          ContactCardT(
            account: aa.id,
            name: nameController.text,
            address: addressController.text,
            saved: false,
          ));
      contacts.fetchContacts();
      GoRouter.of(context).pop();
    }
  }
}

class ContactsSavedPage extends StatefulWidget {
  final int coin;
  final int account;
  ContactsSavedPage(this.coin, this.account, {super.key});

  @override
  State<StatefulWidget> createState() => ContactsSavedState();
}

class ContactsSavedState extends State<ContactsSavedPage> {
  late final S s = S.of(context);

  @override
  void initState() {
    super.initState();
    warp.onContactsSaved(widget.coin, widget.account);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(s.contacts), actions: [
          IconButton(
              onPressed: () => GoRouter.of(context).pop(),
              icon: Icon(Icons.check)),
        ]),
        body: Jumbotron(s.contactsSaved));
  }
}
