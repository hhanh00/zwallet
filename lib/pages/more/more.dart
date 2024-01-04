import 'package:YWallet/appsettings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../generated/intl/messages.dart';
import '../utils.dart';
import '../widgets.dart';

class MorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final moreSections = [
      MoreSection(title: Text(s.account), tiles: [
        MoreTile(
            url: '/account/account_manager',
            icon: FaIcon(FontAwesomeIcons.users),
            text: s.accounts),
        MoreTile(
            url: '/more/coins',
            icon: FaIcon(FontAwesomeIcons.moneyBill),
            text: s.notes),
        MoreTile(
            url: '/more/transfer',
            icon: FaIcon(FontAwesomeIcons.personSwimming),
            text: s.pools),
        MoreTile(
            url: '/account/multi_pay',
            icon: FaIcon(FontAwesomeIcons.peopleArrows),
            text: s.multiPay,
            secured: appSettings.protectSend),
        MoreTile(
            url: '/more/contacts',
            icon: FaIcon(FontAwesomeIcons.addressBook),
            text: s.contacts),
      ]),
      MoreSection(title: Text(s.backup), tiles: [
        MoreTile(
            url: '/more/backup',
            icon: FaIcon(FontAwesomeIcons.seedling),
            text: s.backup,
            secured: true),
        MoreTile(
            url: '/more/batch_backup',
            icon: FaIcon(FontAwesomeIcons.database),
            text: s.fullBackup,
            secured: true),
      ]),
      MoreSection(title: Text(s.market), tiles: [
        MoreTile(
            url: '/more/budget',
            icon: FaIcon(FontAwesomeIcons.scaleBalanced),
            text: s.budget),
        MoreTile(
            url: '/more/market',
            icon: FaIcon(FontAwesomeIcons.arrowTrendUp),
            text: s.marketPrice),
      ]),
      MoreSection(title: Text(s.sync), tiles: [
        MoreTile(
            url: '/more/rescan',
            icon: FaIcon(FontAwesomeIcons.arrowRightLong),
            text: s.rescan),
        MoreTile(
            url: '/more/rewind',
            icon: FaIcon(FontAwesomeIcons.arrowRotateLeft),
            text: s.rewind),
      ]),
      MoreSection(title: Text(s.coldStorage), tiles: [
        MoreTile(
            url: '/more/cold/sign',
            icon: FaIcon(FontAwesomeIcons.signature),
            text: s.signOffline),
        MoreTile(
            url: '/more/cold/broadcast',
            icon: FaIcon(FontAwesomeIcons.towerBroadcast),
            text: s.broadcast),
      ]),
      MoreSection(
        title: Text(s.tools),
        tiles: [
          MoreTile(
              url: '/more/keytool',
              icon: FaIcon(FontAwesomeIcons.key),
              text: s.keyTool,
              secured: true),
          MoreTile(
              url: '/more/sweep',
              icon: FaIcon(FontAwesomeIcons.broom),
              text: s.sweep),
          MoreTile(
              url: '/more/about',
              icon: FaIcon(FontAwesomeIcons.circleInfo),
              text: s.about,
              onPressed: () async {
                final contentTemplate =
                    await rootBundle.loadString('assets/about.md');
                GoRouter.of(context)
                    .push('/more/about', extra: contentTemplate);
              }),
        ],
      )
    ];

    final sections = moreSections.map((s) => 
      SettingsSection(
        title: s.title,
        tiles: s.tiles.map((t) => 
          SettingsTile.navigation(
            leading: SizedBox(width: 32, child: t.icon),
            onPressed: (context) => onNav(context, t),
            title: Text(t.text))
        ).toList())
    ).toList();

    return SettingsList(sections: sections);
  }

  onNav(BuildContext context, MoreTile tile) async {
    final onPressed = tile.onPressed;
    if (onPressed != null) {
      await onPressed();
    } else {
      if (tile.secured) {
        final s = S.of(context);
        final auth = await authenticate(context, s.secured);
        if (!auth) return;
      }
      GoRouter.of(context).push(tile.url);
    }
  }
}
