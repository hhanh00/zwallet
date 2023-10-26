import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:warp_api/warp_api.dart';

import '../accounts.dart';
import '../appsettings.dart';
import '../avatar.dart';
import '../db.dart';
import '../generated/intl/messages.dart';
import '../main.dart';
import '../tablelist.dart';
import 'widgets.dart';

class MessagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SortSetting(
      child: Observer(
        builder: (context) {
          aaSequence.seqno;
          return TableListPage(
            view: appSettings.messageView,
            items: aa.messages.items,
            metadata: TableListMessageMetadata(),
          );
        },
      ),
    );
  }
}

class TableListMessageMetadata extends TableListItemMetadata<ZMessage> {
  @override
  List<Widget>? actions(BuildContext context) => null;

  @override
  Text? header(BuildContext context) => null;

  @override
  void inverseSelection() {}

  @override
  Widget toListTile(BuildContext context, int index, ZMessage message) {
    return MessageBubble(message, index: index);
  }

  @override
  List<ColumnDefinition> columns(BuildContext context) {
    final s = S.of(context);
    return [
      ColumnDefinition(label: s.datetime),
      ColumnDefinition(label: s.fromto),
      ColumnDefinition(label: s.subject),
      ColumnDefinition(label: s.body),
    ];
  }

  @override
  DataRow toRow(BuildContext context, int index, ZMessage message) {
    final t = Theme.of(context);
    var style = t.textTheme.bodyMedium!;
    if (!message.read) style = style.copyWith(fontWeight: FontWeight.bold);
    final addressStyle = message.incoming
        ? style.apply(color: Colors.green)
        : style.apply(color: Colors.red);
    return DataRow.byIndex(
        index: index,
        cells: [
          DataCell(
              Text("${msgDateFormat.format(message.timestamp)}", style: style)),
          DataCell(Text("${message.fromto()}", style: addressStyle)),
          DataCell(Text("${message.subject}", style: style)),
          DataCell(Text("${message.body}", style: style)),
        ],
        onSelectChanged: (_) {
          GoRouter.of(context).push('/messages/details?index=$index');
        });
  }

  @override
  SortConfig2? sortBy(String field) {
    aa.messages.setSortOrder(field);
    return aa.messages.order;
  }
}

class MessageBubble extends StatelessWidget {
  final ZMessage message;
  final int index;
  MessageBubble(this.message, {required this.index});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final date = humanizeDateTime(context, message.timestamp);
    final owner = (message.incoming ? message.sender : message.recipient) ?? '';
    return GestureDetector(
        onTap: () => select(context),
        child: Bubble(
          nip: message.incoming ? BubbleNip.leftTop : BubbleNip.rightTop,
          color: message.incoming
              ? t.colorScheme.inversePrimary
              : t.colorScheme.secondaryContainer,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Stack(children: [
              Text(owner, style: t.textTheme.labelMedium),
              Align(child: Text(message.subject, style: t.textTheme.bodyLarge)),
              Align(
                  alignment: Alignment.centerRight,
                  child: Text(date, style: t.textTheme.labelMedium)),
            ]),
            SizedBox(height: 8),
            Text(
              message.body,
            ),
          ]),
        ));
  }

  select(BuildContext context) {
    GoRouter.of(context).push('/messages/details?index=$index');
  }
}

class MessageTile extends StatelessWidget {
  final ZMessage message;
  final int index;
  final double? width;

  MessageTile(this.message, this.index, {this.width});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final s = message.incoming ? message.sender : message.recipient;
    final initial = (s == null || s.isEmpty) ? "?" : s[0];
    final dateString = humanizeDateTime(context, message.timestamp);

    final unreadStyle = (TextStyle? s) =>
        message.read ? s : s?.copyWith(fontWeight: FontWeight.bold);

    final av = avatar(initial);

    final body = Column(
      children: [
        Text(message.fromto(), style: unreadStyle(textTheme.bodySmall)),
        SizedBox(
          height: 4.0,
        ),
        if (message.subject.isNotEmpty)
          Text(message.subject,
              style: unreadStyle(textTheme.titleMedium),
              overflow: TextOverflow.ellipsis),
        SizedBox(
          height: 6.0,
        ),
        Text(
          message.body,
          softWrap: true,
          maxLines: 5,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );

    return GestureDetector(
        onTap: () {
          _onSelect(context);
        },
        onLongPress: () {
          active.markAllMessagesAsRead();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(children: [
            av,
            SizedBox(width: 15),
            Expanded(child: body),
            SizedBox(
                width: 80, child: Text(dateString, textAlign: TextAlign.right)),
          ]),
        ));
  }

  _onSelect(BuildContext context) {
    GoRouter.of(context).push('/messages/details?index=$index');
  }
}

class MessageItemPage extends StatefulWidget {
  final int index;
  MessageItemPage(this.index);

  @override
  State<StatefulWidget> createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItemPage> {
  late int idx;
  late final n;
  final replyController = TextEditingController();

  ZMessage get message => aa.messages.items[idx];

  void initState() {
    n = aa.messages.items.length;
    idx = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final ts = msgDateFormatFull.format(message.timestamp);
    return Scaffold(
      appBar: AppBar(title: Text(message.subject)),
      body: SingleChildScrollView(
        child: Column(children: [
          ButtonBar(alignment: MainAxisAlignment.center, children: [
            IconButton.outlined(
                onPressed: prevInThread,
                icon: Icon(Icons.arrow_left)), // because the sorting is desc
            IconButton.outlined(
                onPressed: idx > 0 ? prev : null,
                icon: Icon(Icons.chevron_left)),
            IconButton.outlined(
                onPressed: idx < n - 1 ? next : null,
                icon: Icon(Icons.chevron_right)),
            IconButton.outlined(
                onPressed: nextInThread, icon: Icon(Icons.arrow_right)),
            IconButton.outlined(
                onPressed: open, icon: Icon(Icons.open_in_browser)),
          ]),
          SizedBox(height: 16),
          Panel(s.datetime, text: ts),
          SizedBox(height: 8),
          Panel(s.sender, text: message.sender ?? ''),
          SizedBox(height: 8),
          Panel(s.recipient, text: message.recipient),
          SizedBox(height: 8),
          Panel(s.subject, text: message.subject),
          SizedBox(height: 8),
          Panel(s.body, child: Text(message.body, maxLines: 20)),
          SizedBox(height: 16),
          FormBuilder(
              child: Row(
            children: [
              Expanded(child: FormBuilderTextField(
                name: 'reply',
                decoration: InputDecoration(label: Text(s.reply)),
                controller: replyController,
                maxLines: 10,
              )),
              IconButton.outlined(onPressed: () {}, icon: Icon(Icons.send)),
            ],
          )),
        ]),
      ),
    );
  }

  prev() {
    if (idx > 0) idx -= 1;
    setState(() {});
  }

  next() {
    if (idx < n - 1) idx += 1;
    setState(() {});
  }

  prevInThread() {
    final pn = WarpApi.getPrevNextMessage(
        aa.coin, aa.id, message.subject, message.height);
    final id = pn.prev;
    if (id != 0) idx = aa.messages.items.indexWhere((m) => m.id == id);
    setState(() {});
  }

  nextInThread() {
    final pn = WarpApi.getPrevNextMessage(
        aa.coin, aa.id, message.subject, message.height);
    final id = pn.next;
    if (id != 0) idx = aa.messages.items.indexWhere((m) => m.id == id);
    setState(() {});
  }

  open() {
    final index = aa.txs.items.indexWhere((tx) => tx.id == message.txId);
    assert(index >= 0);
    GoRouter.of(context).push('/history/details?index=$index');
  }
}
