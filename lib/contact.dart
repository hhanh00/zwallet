import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:warp_api/data_fb_generated.dart';
import 'package:warp_api/warp_api.dart';

import 'home.dart';
import 'main.dart';
import 'generated/l10n.dart';
import 'store.dart';

class ContactsTab extends StatefulWidget {
  ContactsTab({key = Key}): super(key: key);
  @override
  State<StatefulWidget> createState() => ContactsState();
}

class ContactsState extends State<ContactsTab> {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    return Observer(builder: (context) =>
      Padding(padding: EdgeInsets.all(8), child: contacts.contacts.isEmpty
          ? NoContact()
          : Column(children: [
            if (!settings.coins[active.coin].contactsSaved) OutlinedButton(onPressed: _onCommit, child: Text(s.saveToBlockchain), style: OutlinedButton.styleFrom(
              side: BorderSide(
                width: 1, color: theme.primaryColor))),
            Expanded(child: ListView.builder(
                itemCount: contacts.contacts.length,
                itemBuilder: (BuildContext context, int index) {
                  final c = contacts.contacts[index];
                  return Card(
                      child: Dismissible(
                          key: Key("${c.id}"),
                          child: ListTile(
                            title: Text(c.name!,
                                style: theme.textTheme.headlineSmall),
                            subtitle: Text(c.address!),
                            trailing: Icon(Icons.chevron_right),
                            onTap: () { _onContact(c); },
                            onLongPress: () { _editContact(c); },
                          ),
                          confirmDismiss: (_) async {
                            return await _onConfirmDelContact(c);
                          },
                          onDismissed: (_) {
                            _delContact(c);
                          }));
                })
            )]))
    );
  }

  _onContact(ContactT c) {
    Navigator.of(context).pushNamed('/send', arguments: SendPageArgs(contact: c));
  }

  _editContact(ContactT c) async {
    await addContact(context, c);
  }

  Future<bool> _onConfirmDelContact(ContactT c) async {
    final confirm = await showMessageBox(context, S.of(context).deleteContact,
        S.of(context).areYouSureYouWantToDeleteThisContact,
        S.of(context).delete);
    return confirm;
  }

  _delContact(ContactT c) {
    contacts.remove(c);
  }

  _onCommit() async {
    try {
      final txPlan = WarpApi.commitUnsavedContacts(settings.anchorOffset);
      Navigator.of(context).pushNamed('/txplan', arguments: txPlan);
    }
    on String catch (msg) {
      showSnackBar(msg);
    }
  }
}

class NoContact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Widget contact = SvgPicture.asset('assets/contacts.svg',
        color: Theme.of(context).primaryColor, semanticsLabel: 'Contacts');

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(child: contact, height: 150, width: 150),
      Padding(padding: EdgeInsets.symmetric(vertical: 16)),
      Text(S.of(context).noContacts, style: Theme.of(context).textTheme.headlineSmall),
      Padding(padding: EdgeInsets.symmetric(vertical: 8)),
      Text(S.of(context).createANewContactAndItWillShowUpHere,
          style: Theme.of(context).textTheme.bodyLarge),
    ]);
  }
}

class ContactForm extends StatefulWidget {
  final ContactT contact;

  ContactForm(this.contact, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ContactState();
}

class ContactState extends State<ContactForm> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  var address = "";

  @override
  void initState() {
    super.initState();
    nameController.text = widget.contact.name ?? "";
    address = widget.contact.address ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: SingleChildScrollView(
            child: Column(children: [
          TextFormField(
            decoration: InputDecoration(labelText: S.of(context).contactName),
            controller: nameController,
            validator: _checkName,
          ),
          AddressInput(widget.contact.id, S.of(context).address, address, (addr) {
                address = addr ?? "";
              })
        ])));
  }

  onOK() {
    final state = formKey.currentState!;
    if (state.validate()) {
      state.save();
      final contact = ContactT(id: widget.contact.id, name: nameController.text, address: address);
      Navigator.of(context).pop(contact);
      active.update();
    }
  }

  String? _checkName(String? v) {
    if (v == null || v.isEmpty) return S.of(context).nameIsEmpty;
    return null;
  }
}

class AddressInput extends StatefulWidget {
  final int id;
  final void Function(String?) onSaved;
  final String labelText;
  final String initialValue;

  AddressInput(this.id, this.labelText, this.initialValue, this.onSaved);

  @override
  State<StatefulWidget> createState() => AddressState();
}

class AddressState extends State<AddressInput> {
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _addressController.text = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
        child: TextFormField(
          decoration: InputDecoration(labelText: widget.labelText),
          minLines: 4,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          controller: _addressController,
          validator: _checkAddress,
          onSaved: widget.onSaved,
        ),
      ),
      IconButton(icon: new Icon(MdiIcons.qrcodeScan), onPressed: _onScan)
    ]);
  }

  String? _checkAddress(String? v) {
    if (v == null || v.isEmpty) return S.of(context).addressIsEmpty;
    if (!WarpApi.validAddress(active.coin, v)) return S.of(context).invalidAddress;
    if (contacts.contacts.where((c) => c.address == v && c.id != widget.id).isNotEmpty) return S.of(context).duplicateContact;
    return null;
  }

  void _onScan() async {
    var address = await scanCode(context);
    if (address != null)
      setState(() {
        final paymentURI = decodeAddress(context, address);
        _addressController.text = paymentURI.address;
      });
  }
}

Future<void> addContact(BuildContext context, ContactT? c) async {
  final s = S.of(context);
  final key = GlobalKey<ContactState>();
  final contact = await showDialog<ContactT>(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.all(16),
        title: Text(c?.name != null ? s.editContact : s.addContact),
        content: ContactForm(c ?? ContactT(), key: key),
        actions: confirmButtons(context, () {
          key.currentState!.onOK();
        }),
      ));
  if (contact != null) {
    contacts.add(contact);
  }
}
