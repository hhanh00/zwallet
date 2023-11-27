import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:warp_api/data_fb_generated.dart';
import 'package:warp_api/warp_api.dart';

import '../../accounts.dart';
import '../../generated/intl/messages.dart';

class BackupPage extends StatelessWidget {
  late final Backup backup;
  late final String primary;

  BackupPage() {
    backup = WarpApi.getBackup(aa.coin, aa.id);
    if (backup.seed != null)
      primary = backup.seed!;
    else if (backup.sk != null)
      primary = backup.sk!;
    else if (backup.uvk != null)
      primary = backup.uvk!;
    else if (backup.fvk != null)
      primary = backup.fvk!;
    else
      throw 'Account has no key';
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final t = Theme.of(context);
    final name = backup.name!;
    final small = t.textTheme.bodySmall!;

    List<Widget> cards = [];
    TextStyle? style;
    if (backup.seed != null) {
      cards.add(BackupPanel(name, s.seed, backup.seed!, Icon(Icons.save)));
      style = small;
    }
    if (backup.sk != null) {
      cards.add(BackupPanel(name, s.secretKey, backup.sk!, Icon(Icons.vpn_key),
          style: style));
      style = small;
    }
    if (backup.uvk != null) {
      cards.add(BackupPanel(
          name, s.unifiedViewingKey, backup.uvk!, Icon(Icons.visibility),
          style: style));
      style = small;
    }
    if (backup.fvk != null) {
      cards.add(BackupPanel(
          name, s.viewingKey, backup.fvk!, Icon(Icons.visibility_outlined),
          style: style));
      style = small;
    }
    if (backup.tsk != null) {
      cards.add(BackupPanel(
          name, s.transparentKey, backup.tsk!, Icon(Icons.key),
          style: style));
      style = small;
    }

    return Scaffold(
      appBar: AppBar(title: Text(s.backup)),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Column(children: cards),
        ),
      ),
    );
  }
}

class BackupPanel extends StatelessWidget {
  final String name;
  final String label;
  final String value;
  final Icon icon;
  final TextStyle? style;

  BackupPanel(this.name, this.label, this.value, this.icon, {this.style});
  @override
  Widget build(BuildContext context) {
    final qrLabel = '$label of $name';
    return GestureDetector(
      onTap: () => showQR(context, value, qrLabel),
      child: Card(
        elevation: 2,
        child: InputDecorator(
          decoration: InputDecoration(
              label: Text(label), icon: icon, border: OutlineInputBorder()),
          child: Text(
            value,
            style: style,
            maxLines: 6,
          ),
        ),
      ),
    );
  }

  showQR(BuildContext context, String value, String title) {
    GoRouter.of(context).push('/showqr?title=$title', extra: value);
  }
}
