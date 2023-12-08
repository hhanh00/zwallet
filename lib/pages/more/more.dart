import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../generated/intl/messages.dart';
import '../widgets.dart';

class MorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final buttons = [
      MosaicButton(
          url: '/account/account_manager',
          icon: FaIcon(FontAwesomeIcons.users),
          text: s.accounts),
      MosaicButton(
          url: '/more/batch_backup',
          icon: FaIcon(FontAwesomeIcons.database),
          text: s.fullBackup,
          secured: true),
      MosaicButton(
          url: '/more/coins',
          icon: FaIcon(FontAwesomeIcons.moneyBill),
          text: s.notes),
      MosaicButton(
          url: '/more/transfer',
          icon: Icon(Icons.pool),
          text: s.pools),
      MosaicButton(
          url: '/more/contacts',
          icon: FaIcon(FontAwesomeIcons.addressBook),
          text: s.contacts),
      MosaicButton(
          url: '/more/budget',
          icon: FaIcon(FontAwesomeIcons.scaleBalanced),
          text: s.budget),
      MosaicButton(
          url: '/more/market',
          icon: FaIcon(FontAwesomeIcons.arrowTrendUp),
          text: s.marketPrice),
      MosaicButton(
          url: '/more/backup',
          icon: FaIcon(FontAwesomeIcons.seedling),
          text: s.backup,
          secured: true),
      MosaicButton(
          url: '/more/rescan',
          icon: FaIcon(FontAwesomeIcons.arrowRightLong),
          text: s.rescan),
      MosaicButton(
          url: '/more/rewind',
          icon: FaIcon(FontAwesomeIcons.arrowRotateLeft),
          text: s.rewind),
      MosaicButton(
          url: '/more/cold',
          icon: FaIcon(FontAwesomeIcons.snowflake),
          text: s.coldStorage),
      MosaicButton(
          url: '/account/multi_pay',
          icon: FaIcon(FontAwesomeIcons.peopleArrows),
          text: s.multiPay),
      MosaicButton(
          url: '/more/keytool',
          icon: FaIcon(FontAwesomeIcons.key),
          text: s.keyTool,
          secured: true),
      MosaicButton(
          url: '/more/sweep',
          icon: FaIcon(FontAwesomeIcons.broom),
          text: s.sweep),
      MosaicButton(
          url: '/more/about',
          icon: FaIcon(FontAwesomeIcons.circleInfo),
          text: s.about,
          onPressed: () async {
            final contentTemplate =
                await rootBundle.loadString('assets/about.md');
            GoRouter.of(context).push('/more/about', extra: contentTemplate);
          }),
    ];
    return MosaicWidget(buttons);
  }
}
