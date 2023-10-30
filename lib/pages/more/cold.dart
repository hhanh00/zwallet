import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../generated/intl/messages.dart';
import '../widgets.dart';

class ColdStoragePage extends StatelessWidget {
  Widget build(BuildContext context) {
    final s = S.of(context);
    final buttons = [
      MosaicButton(
          url: '/more/cold/watch_only',
          icon: FaIcon(FontAwesomeIcons.snowflake),
          text: s.convertToWatchonly),
      MosaicButton(
          url: '/more/cold/sign',
          icon: FaIcon(FontAwesomeIcons.signature),
          text: s.signOffline),
      MosaicButton(
          url: '/more/cold/broadcast',
          icon: FaIcon(FontAwesomeIcons.towerBroadcast),
          text: s.broadcast),
    ];
    return Scaffold(
        appBar: AppBar(title: Text(s.coldStorage)),
        body: MosaicWidget(buttons));
  }
}
