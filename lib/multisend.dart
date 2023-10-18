import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:warp_api/data_fb_generated.dart';
import 'store.dart';

import 'main.dart';
import 'generated/intl/messages.dart';
import 'send.dart';

class MultiPayPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MultiPayState();
}

class MultiPayState extends State<MultiPayPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).multiPay)),
      body: Observer(builder: (context) {
        if (multipayData.recipients.isEmpty) return NoRecipient();
        final rows = multipayData.recipients.asMap().entries.map((e) {
          final index = e.key;
          final recipient = e.value;
          final amount = recipient.amount / ZECUNIT;
          return Dismissible(
            key: UniqueKey(),
            child: ListTile(
                title: Text(recipient.address!), subtitle: Text("$amount")),
            onDismissed: (_) {
              _remove(index);
            },
          );
        }).toList();
        return ListView(children: rows);
      }),
      bottomNavigationBar: BottomAppBar(
          child: Row(children: [
        IconButton(onPressed: _add, icon: Icon(Icons.add)),
        Spacer(),
        IconButton(onPressed: _send, icon: Icon(Icons.send)),
      ])),
    );
  }

  _add() async {
    final recipient = await Navigator.of(context).pushNamed('/send', arguments: SendPageArgs(isMulti: true, recipients: multipayData.recipients)) as Recipient?;
    if (recipient != null) {
      multipayData.addRecipient(recipient);
    }
  }

  _remove(int index) {
    multipayData.removeRecipient(index);
  }

  _send() async {
    await send(context, multipayData.recipients);

    multipayData.clear();
    active.update();
  }
}

class NoRecipient extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Widget contact = SvgPicture.asset('assets/multipay.svg',
        color: Theme.of(context).primaryColor, semanticsLabel: 'Contacts');

    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(child: contact, height: 150, width: 150),
      Padding(padding: EdgeInsets.symmetric(vertical: 16)),
      Text(S.of(context).noRecipient,
          style: Theme.of(context).textTheme.headlineSmall),
      Padding(padding: EdgeInsets.symmetric(vertical: 8)),
      Text(S.of(context).addARecipientAndItWillShowHere,
          style: Theme.of(context).textTheme.bodyLarge),
    ]));
  }
}
