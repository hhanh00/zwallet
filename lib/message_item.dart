import 'package:ZYWallet/db.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class MessageItem extends StatelessWidget {
  final ZMessage message;
  final int index;

  MessageItem(this.message, this.index);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final s = message.incoming ? message.sender : message.recipient;
    final initial = (s == null || s.isEmpty) ? "?" : s[0];
    final width = MediaQuery.of(context).size.width;

    final unreadStyle = (TextStyle? s) => message.read ? s : s?.copyWith(fontWeight: FontWeight.bold);

    return GestureDetector(
        onTap: () {
          _onSelect(context);
        },
        onLongPress: () {
          active.markAllMessagesAsRead();
        },
        child: Container(
            margin: EdgeInsets.only(top: 3.0, bottom: 3.0, right: 0.0),
            padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
            child: Row(children: [
              CircleAvatar(
                backgroundColor: initialToColor(initial),
                child: Text(
                  initial,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                radius: 24.0,
              ),
              SizedBox(
                width: 15.0,
                height: 30.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(message.fromto(), style: unreadStyle(textTheme.caption)),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                      width: width * 0.6,
                      child: Text(
                          message.subject,
                          style: unreadStyle(textTheme.titleMedium), overflow: TextOverflow.ellipsis)),
                  SizedBox(
                    height: 4.0,
                  ),
                  Container(
                    width: width * 0.8,
                    child: Text(
                      message.body,
                      softWrap: true, maxLines: 5, overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )
            ])));
  }

  _onSelect(BuildContext context) {
    Navigator.of(context).pushNamed('/message', arguments: index);
  }
}

final colors = [
  const Color(0xFF1DE9B6),
  const Color(0xFFCDDC39),
  const Color(0xFFAA00FF),
  const Color(0xFF2196F3),
  const Color(0xFF689F38),
  const Color(0xFF388E3C),
  const Color(0xFFF57C00),
  const Color(0xFFFFA000),
  const Color(0xFFFBC02D),
  const Color(0xFFFFEA00),
  const Color(0xFFE64A19),
  const Color(0xFF5D4037),
  const Color(0xFF7E57C2),
  const Color(0xFF2196F3),
  const Color(0xFFAA00FF),
  const Color(0xFF2196F3),
  const Color(0xFF00B0FF),
  const Color(0xFF00E5FF),
  const Color(0xFFAA00FF),
  const Color(0xFF2196F3),
  const Color(0xFF64DD17),
  const Color(0xFFAEEA00),
  const Color(0xFFAA00FF),
  const Color(0xFFFFAB00),
  const Color(0xFFAA00FF),
  const Color(0xFF2196F3),
];

final defaultColor = const Color(0xFF717171);

Color initialToColor(String s) {
  final i = s.toUpperCase().codeUnitAt(0);
  if (i >= 65 && i < 91) {
    return colors[i-65];
  }
  return defaultColor;
}
