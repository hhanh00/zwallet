import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:warp/warp.dart';

import '../store.dart';
import '../accounts.dart';
import '../appsettings.dart';
import '../generated/intl/messages.dart';
import '../tablelist.dart';
import 'avatar.dart';
import 'utils.dart';
import 'widgets.dart';

class MessagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SortSetting(
      child: Observer(
        builder: (context) {
          aaSequence.seqno;
          aaSequence.settingsSeqno;
          syncStatus.changed;
          return TableListPage(
            listKey: PageStorageKey('messages'),
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
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
  Text? headerText(BuildContext context) => null;

  @override
  void inverseSelection() {}

  @override
  Widget toListTile(BuildContext context, int index, ZMessage message,
      {void Function(void Function())? setState}) {
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
    logger.i(message);
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

  @override
  Widget? header(BuildContext context) => null;
}

class MessageBubble extends StatelessWidget {
  final ZMessage message;
  final int index;
  MessageBubble(this.message, {required this.index});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final date = humanizeDateTime(context, message.timestamp);
    final owner = centerTrim(
        (message.incoming ? message.sender : message.recipient) ?? '',
        length: 8);
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
            Gap(8),
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
        Gap(4),
        if (message.subject.isNotEmpty)
          Text(message.subject,
              style: unreadStyle(textTheme.titleMedium),
              overflow: TextOverflow.ellipsis),
        Gap(6),
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
          warp.markAllMessagesRead(aa.coin, aa.id, false);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(children: [
            av,
            Gap(15),
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
      appBar: AppBar(title: Text(message.subject), actions: [
        IconButton(
            onPressed: nextInThread,
            icon: Icon(Icons.arrow_left)), // because the sorting is desc
        IconButton(
            onPressed: idx > 0 ? prev : null, icon: Icon(Icons.chevron_left)),
        IconButton(
            onPressed: idx < n - 1 ? next : null,
            icon: Icon(Icons.chevron_right)),
        IconButton(onPressed: prevInThread, icon: Icon(Icons.arrow_right)),
        if (message.fromAddress.isNotEmptyAndNotNull) IconButton(onPressed: reply, icon: Icon(Icons.reply)),
        IconButton(onPressed: open, icon: Icon(Icons.open_in_browser)),
      ]),
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(children: [
          Gap(16),
          Panel(s.datetime, text: ts),
          Gap(8),
          Panel(s.sender, text: message.sender ?? ''),
          Gap(8),
          Panel(s.recipient, text: message.recipient),
          Gap(8),
          Panel(s.subject, text: message.subject),
          Gap(8),
          Panel(s.body, text: message.body, maxLines: 20),
        ]),
      ),
    ));
  }

  prev() {
    if (idx > 0) idx -= 1;
    setState(() {});
  }

  next() {
    if (idx < n - 1) idx += 1;
    setState(() {});
  }

  prevInThread() async {
    final m = await warp.prevMessageThread(
        aa.coin, aa.id, message.height, message.subject);
    final id = m.idMsg;
    if (id != 0) idx = aa.messages.items.indexWhere((m) => m.id == id);
    setState(() {});
  }

  nextInThread() async {
    final m = await warp.nextMessageThread(
        aa.coin, aa.id, message.height, message.subject);
    final id = m.idMsg;
    if (id != 0) idx = aa.messages.items.indexWhere((m) => m.id == id);
    setState(() {});
  }

  reply() async {
    // TODO
    // final memo = MemoData(true, message.subject, '');
    // final sc = SendContext(message.fromAddress!, 7, Amount(0, false), memo);
    // GoRouter.of(context).go('/account/quick_send', extra: sc);
  }

  open() {
    final index = aa.txs.items.indexWhere((tx) => tx.id == message.txId);
    assert(index >= 0);
    GoRouter.of(context).push('/history/details?index=$index');
  }
}
