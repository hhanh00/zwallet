import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:warp_api/types.dart';
import 'package:warp_api/warp_api.dart';

import 'db.dart';
import 'generated/l10n.dart';
import 'main.dart';
import 'message_item.dart';
import 'store.dart';

class MessagesTab extends StatefulWidget {
  MessagesTab({Key? key}): super(key: key);
  @override
  MessagesState createState() => MessagesState();
}

class MessagesState extends State<MessagesTab> with AutomaticKeepAliveClientMixin {
  MessagesDataSource? source;
  @override
  bool get wantKeepAlive => true; //Set to true

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final s = S.of(context);

    if (!settings.messageTable)
      return MessageList();

    final _source = MessagesDataSource(context);
    source = _source;
    return SingleChildScrollView(
      padding: EdgeInsets.all(8),
      scrollDirection: Axis.vertical,
      child: Observer(builder: (context) {
        final _ = active.messages;
        return PaginatedDataTable(
          header: Text(s.markAllAsRead,
              style: Theme.of(context).textTheme.bodyText2),
          actions: [
            IconButton(onPressed: _onMarkRead, icon: Icon(Icons.check))
          ],
          columns: [
            DataColumn(
              label: Text(s.datetime),
            ),
            DataColumn(
              label: Text(s.fromto),
            ),
            DataColumn(
              label: Text(s.subject),
            ),
            DataColumn(
              label: Text(s.body),
            ),
          ],
          columnSpacing: 16,
          showCheckboxColumn: false,
          availableRowsPerPage: [5, 10, 25, 100],
          onRowsPerPageChanged: (int? value) {
            settings.setRowsPerPage(value ?? 25);
          },
          showFirstLastButtons: true,
          rowsPerPage: settings.rowsPerPage,
          source: _source);
    }));
  }

  onChanged() {
    source?.onChanged();
  }

  _onMarkRead() {
    active.markAllMessagesAsRead();
    onChanged();
  }
}

class MessagesDataSource extends DataTableSource {
  final BuildContext context;

  MessagesDataSource(this.context);

  @override
  DataRow? getRow(int index) {
    final message = active.messages[index];
    var style = Theme.of(context).textTheme.bodyText2!;
    if (!message.read)
      style = style.copyWith(fontWeight: FontWeight.bold);
    final addressStyle = message.incoming ?
      style.copyWith(color: Colors.green) :
      style.copyWith(color: Colors.red);
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text("${msgDateFormat.format(message.timestamp)}", style: style)),
        DataCell(Text("${message.fromto()}", style: addressStyle)),
        DataCell(Text("${message.subject}", style: style)),
        DataCell(Text("${message.body}", style: style)),
      ],
      onSelectChanged: (_) {
        Navigator.of(context).pushNamed('/message', arguments: index);
      }
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => active.messages.length;

  @override
  int get selectedRowCount => 0;

  onChanged() {
    Future(() {
      notifyListeners();
    });
  }
}

class MessageList extends StatefulWidget {
  @override
  MessageListState createState() => MessageListState();
}

class MessageListState extends State<MessageList> {
  @override
  Widget build(BuildContext context) {
    if (active.messages.isEmpty) return Container();
    return Container(child: ListView.builder(
      itemCount: active.messages.length,
      itemBuilder: (context, index) {
        return MessageItem(active.messages[index], index);
    }));
  }
}

class MessagePage extends StatefulWidget {
  final index;
  MessagePage(this.index);

  @override
  MessagePageState createState() => MessagePageState(index);
}

class MessagePageState extends State<MessagePage> {
  int index;
  final n = active.messages.length;
  MessagePageState(this.index);

  @override
    Widget build(BuildContext context) {
    final s = S.of(context);
    final message = active.messages[index];
    final i = index;
    Future.microtask(() {
      active.markMessageAsRead(i);
    });
    messageKey.currentState?.onChanged();

    return Scaffold(
        appBar: AppBar(title: Text(s.message)),
        body: ListView(padding: EdgeInsets.all(16), children: [
        ButtonBar(alignment: MainAxisAlignment.center, children: [
          IconButton(onPressed: _nextInThread, icon: Icon(Icons.arrow_left)), // because the sorting is desc
          IconButton(onPressed: index > 0 ? _prev : null, icon: Icon(Icons.chevron_left)),
          IconButton(onPressed: index < n-1 ? _next : null, icon: Icon(Icons.chevron_right)),
          IconButton(onPressed: _prevInThread, icon: Icon(Icons.arrow_right)),
        ]),
        ListTile(
          title: Text(s.datetime), subtitle: SelectableText('${msgDateFormatFull.format(message.timestamp)}')),
        ListTile(
          title: Text(s.sender), subtitle: SelectableText('${message.sender ?? s.na}')),
        ListTile(
          title: Text(s.recipient), subtitle: SelectableText('${message.recipient}')),
        ListTile(
          title: Text(s.subject), subtitle: SelectableText('${message.subject}')),
        ListTile(
          title: Text(s.body), subtitle: SelectableText('${message.body}')),
          ButtonBar(alignment: MainAxisAlignment.center, children: [
            ElevatedButton.icon(onPressed: _hasReplyTo() ? _reply : null, icon: Icon(Icons.reply), label: Text(s.reply)),
          ]),
        ],
    ));
  }

  _prev() {
    setState(() {
      index -= 1;
    });
  }

  _next() {
    setState(() {
      if (index < n-1) index += 1;
    });
  }

  _prevInThread() async {
    final id = await active.prevInThread(index);
    setState(() {
      if (id != null) index = active.messages.indexWhere((m) => m.id == id);
    });
  }

  _nextInThread() async {
    final id = await active.nextInThread(index);
    setState(() {
      if (id != null) index = active.messages.indexWhere((m) => m.id == id);
    });
  }

  _hasReplyTo() {
    final message = active.messages[index];
    return message.sender != null;
  }

  _reply() {
    final message = active.messages[index];
    Navigator.of(context).pushNamed('/send', arguments: SendPageArgs(address: message.sender, subject: message.subject));
  }
}
