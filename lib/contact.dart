import 'package:barcode_scan/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:warp_api/warp_api.dart';

import 'main.dart';
import 'generated/l10n.dart';
import 'store.dart';

class ContactsTab extends StatefulWidget {
  ContactsTab({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ContactsState();
}

class ContactsState extends State<ContactsTab> {
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return contacts.contacts.isEmpty
          ? NoContact()
          : Column(children: [
            if (contacts.dirty) OutlinedButton(onPressed: _onCommit, child: Text(S.of(context).saveToBlockchain), style: OutlinedButton.styleFrom(
          side: BorderSide(
              width: 1, color: Theme.of(context).primaryColor))),
              Expanded(child: ListView.builder(
                  itemCount: contacts.contacts.length,
                  itemBuilder: (BuildContext context, int index) {
                    final c = contacts.contacts[index];
                    return Card(
                        child: Dismissible(
                            key: Key("${c.id}"),
                            child: ListTile(
                              title: Text(c.name,
                                  style: Theme.of(context).textTheme.headline5),
                              subtitle: Text(c.address),
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
              )]);
    });
  }

  _onContact(Contact c) {
    Navigator.of(context).pushNamed('/send', arguments: c);
  }

  _editContact(Contact c) async {
    print(c.id);
    final contact = await showContactForm(context, c);
    if (contact != null) contacts.add(contact);
  }

  Future<bool> _onConfirmDelContact(Contact c) async {
    final confirm = await showMessageBox(context, S.of(context).deleteContact,
        S.of(context).areYouSureYouWantToDeleteThisContact,
        S.of(context).delete);
    return confirm;
  }

  _delContact(Contact c) async {
    await contacts.remove(c);
  }

  Future<Contact> showContactForm(BuildContext context, Contact c) async {
    final key = GlobalKey<ContactState>();

    final contact = await showDialog<Contact>(
        context: context,
        builder: (context) => AlertDialog(
              contentPadding: EdgeInsets.all(16),
              title: Text('Add Contact'),
              content: ContactForm(c, key: key),
              actions: confirmButtons(context, () {
                key.currentState.onOK();
              }),
            ));
    return contact;
  }

  _onCommit() async {
    final approve = await showMessageBox(context, S.of(context).saveToBlockchain, 
        S.of(context).areYouSureYouWantToSaveYourContactsIt(coin.ticker),
        S.of(context).ok);
    if (approve) {
      contacts.markContactsDirty(false);
      final tx = await WarpApi.commitUnsavedContacts(
          accountManager.active.id, settings.anchorOffset);
      final snackBar = SnackBar(content: Text("${S.of(context).txId}: $tx"));
      rootScaffoldMessengerKey.currentState.showSnackBar(snackBar);
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
      Text('No Contacts', style: Theme.of(context).textTheme.headline5),
      Padding(padding: EdgeInsets.symmetric(vertical: 8)),
      Text('Create a new contact and it will show up here',
          style: Theme.of(context).textTheme.bodyText1),
    ]);
  }
}

class ContactForm extends StatefulWidget {
  final Contact contact;

  ContactForm(this.contact, {Key key}) : super(key: key);

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
    nameController.text = widget.contact.name;
    address = widget.contact.address;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: SingleChildScrollView(
            child: Column(children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Contact Name'),
            controller: nameController,
            validator: _checkName,
          ),
          AddressInput(
              labelText: 'Address',
              initialValue: address,
              onSaved: (addr) {
                address = addr;
              })
        ])));
  }

  onOK() {
    final state = formKey.currentState;
    if (state.validate()) {
      state.save();
      final contact = Contact(widget.contact.id, nameController.text, address);
      Navigator.of(context).pop(contact);
    }
  }

  String _checkName(String v) {
    if (v.isEmpty) return S.of(context).nameIsEmpty;
    return null;
  }
}

class AddressInput extends StatefulWidget {
  final void Function(String) onSaved;
  final String labelText;
  final String initialValue;

  AddressInput({this.labelText, this.initialValue, this.onSaved});

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

  String _checkAddress(String v) {
    if (v.isEmpty) return S.of(context).addressIsEmpty;
    final zaddr = WarpApi.getSaplingFromUA(v);
    if (zaddr.isNotEmpty) return null;
    if (!WarpApi.validAddress(v)) return S.of(context).invalidAddress;
    return null;
  }

  void _onScan() async {
    var code = await BarcodeScanner.scan();
    setState(() {
      final address = code.rawContent;
      _addressController.text = address;
    });
  }
}
