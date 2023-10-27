import 'package:flutter/material.dart';
import 'package:flutter_palette/flutter_palette.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:go_router/go_router.dart';

import '../../chart.dart';
import '../../generated/intl/messages.dart';
import '../../main.dart';

class MorePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MoreState();
}

class _MoreState extends State<MorePage> {
  final buttons = <MoreButton>[];

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final t = Theme.of(context);
    final buttons = [
      MoreButton(
          url: '/account/account_manager',
          icon: FaIcon(FontAwesomeIcons.users),
          text: s.accounts),
      MoreButton(
          url: '/more/batch_backup',
          icon: FaIcon(FontAwesomeIcons.database),
          text: s.fullBackup),
      MoreButton(
          url: '/more/coins',
          icon: FaIcon(FontAwesomeIcons.moneyBill),
          text: s.notes),
      MoreButton(
          url: '/more/transfer',
          icon: FaIcon(FontAwesomeIcons.waterLadder),
          text: s.pools),
      MoreButton(
          url: '/more/contacts',
          icon: FaIcon(FontAwesomeIcons.addressBook),
          text: s.contacts),
      MoreButton(
          url: '/more/budget',
          icon: FaIcon(FontAwesomeIcons.scaleBalanced),
          text: s.budget),
      MoreButton(
          url: '/more/market',
          icon: FaIcon(FontAwesomeIcons.arrowTrendUp),
          text: s.marketPrice),
      MoreButton(
          url: '/more/backup',
          icon: FaIcon(FontAwesomeIcons.seedling),
          text: s.backup,
          secured: true),
      MoreButton(
          url: '/more/rescan',
          icon: FaIcon(FontAwesomeIcons.arrowRightLong),
          text: s.rescan),
      MoreButton(
          url: '/more/coins',
          icon: FaIcon(FontAwesomeIcons.arrowRotateLeft),
          text: s.rewind),
      MoreButton(
          url: '/more/coins',
          icon: FaIcon(FontAwesomeIcons.store),
          text: s.coldStorage),
      MoreButton(
          url: '/more/coins',
          icon: FaIcon(FontAwesomeIcons.signature),
          text: s.signOffline),
      MoreButton(
          url: '/more/coins',
          icon: FaIcon(FontAwesomeIcons.towerBroadcast),
          text: s.broadcast),
      MoreButton(
          url: '/more/coins',
          icon: FaIcon(FontAwesomeIcons.peopleArrows),
          text: s.multiPay),
      MoreButton(
          url: '/more/coins',
          icon: FaIcon(FontAwesomeIcons.key),
          text: s.keyTool),
      MoreButton(
          url: '/more/coins',
          icon: FaIcon(FontAwesomeIcons.broom),
          text: s.sweep),
    ];
    final palette = getPalette(Theme.of(context).primaryColor, buttons.length);

    return GridView.count(
      primary: true,
      padding: const EdgeInsets.all(8),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      crossAxisCount: 2,
      children: buttons
          .asMap()
          .entries
          .map(
            (kv) => GFButton(
              onPressed: () async {
                if (kv.value.secured) {
                  final auth = await authenticate(context, s.backup);
                  if (!auth) return;
                }
                GoRouter.of(context).push(kv.value.url);
              },
              icon: kv.value.icon,
              type: GFButtonType.solid,
              textStyle: t.textTheme.bodyLarge,
              child: Text(kv.value.text!, maxLines: 2, overflow: TextOverflow.fade),
              color: palette.colors[kv.key].toColor(),
              borderShape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.all(
                  Radius.circular(32),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  _coin() {
    GoRouter.of(context).go('/more/coins');
  }

  _rescan() {
    GoRouter.of(context).go('/more/rescan');
  }
}

class MoreButton {
  final String url;
  final String? text;
  final Widget? icon;
  final bool secured;

  MoreButton(
      {required this.url,
      required this.text,
      required this.icon,
      this.secured = false});
}
