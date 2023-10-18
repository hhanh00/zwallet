import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

import '../accounts.dart';
import '../appsettings.dart';
import '../db.dart';
import '../generated/intl/messages.dart';
import '../main.dart';
import '../message_item.dart';
import '../tablelist.dart';

class MessagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SortSetting(
      child: Observer(
        builder: (context) {
          active.messages;
          return TableListPage(
            view: appSettings.messageView,
            items: active.messages,
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
    return MessageItem(message, index);
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
    active.setMessageSortOrder(field);
    return active.messageOrder;
  }
}
