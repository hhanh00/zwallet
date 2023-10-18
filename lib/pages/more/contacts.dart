import 'package:YWallet/init.dart';
import 'package:YWallet/settings.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:warp_api/data_fb_generated.dart';
import 'package:warp_api/warp_api.dart';

import '../../appsettings.dart';
import '../../generated/intl/messages.dart';
import '../../main.dart';
import '../../store2.dart';

class ContactsPage extends StatefulWidget {
  ContactsPage() {
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
            if (idSelected != null) IconButton(onPressed: _edit, icon: Icon(Icons.edit)),
            if (idSelected != null) IconButton(onPressed: _delete, icon: Icon(Icons.delete)),
            IconButton(onPressed: _save, icon: Icon(Icons.save)),
            IconButton(onPressed: _add, icon: Icon(Icons.add)),
            ],
        ),
        body: Observer(builder: (context) {
          final c = contacts.contacts;
          return ListView.separated(
            itemBuilder: (context, index) => ContactItem(c[index], 
              selected: idSelected == c[index].id,
              onTap: () => setState(() {
                if (idSelected == c[index].id) 
                  idSelected = null;
                else 
                  idSelected = c[index].id;
              }) ),
            separatorBuilder: (context, index) => Divider(),
            itemCount: c.length,
            
          );
        }));
  }

  _save() async {
    final s = S.of(context);
    final coinSettings = getCoinSettings(active.coin);
    final fee = coinSettings.feeT;
    final confirmed = await showConfirmDialog(context, s.save, s.confirmSaveContacts);
    if (!confirmed) return;
    final txPlan = WarpApi.commitUnsavedContacts(appSettings.anchorOffset, fee);
    GoRouter.of(context).pushReplacement('/account/txplan', extra: txPlan);
  }

  _add() {}

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
    final c = WarpApi.getContact(active.coin, widget.id);
    nameController.text = c.name!;
    addressController.text = c.address!;
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(s.editContact),
          actions: [
            IconButton(onPressed: _save, icon: Icon(Icons.save))
          ],
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
    WarpApi.storeContact(widget.id,
      nameController.text,
      addressController.text,
      true
    );
    contacts.fetchContacts();
  }

}
