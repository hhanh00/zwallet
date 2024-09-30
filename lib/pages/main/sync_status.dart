import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../generated/intl/messages.dart';
import '../../store.dart';
import '../utils.dart';

class SyncStatusWidget extends StatefulWidget {
  SyncStatusState createState() => SyncStatusState();
}

class SyncStatusState extends State<SyncStatusWidget> {
  var display = 0;

  @override
  void initState() {
    super.initState();
    Future(() async {
      await syncStatus.updateBCHeight();
      await startAutoSync();
    });
  }

  String getSyncText(int syncedHeight) {
    final s = S.of(context);
    if (!syncStatus.connected) return s.connectionError;
    final latestHeight = syncStatus.latestHeight;
    if (latestHeight == null) return '';

    if (syncStatus.paused) return s.syncPaused;
    if (!syncStatus.syncing) return syncedHeight.toString();

    final timestamp = syncStatus.timestamp?.let(timeago.format) ?? s.na;
    final downloadedSize = syncStatus.downloadedSize;
    final trialDecryptionCount = syncStatus.trialDecryptionCount;

    final remaining = syncStatus.eta.remaining;
    final percent = syncStatus.eta.progress;
    final downloadedSize2 = NumberFormat.compact().format(downloadedSize);
    final trialDecryptionCount2 =
        NumberFormat.compact().format(trialDecryptionCount);

    switch (display) {
      case 0:
        return '$syncedHeight / $latestHeight';
      case 1:
        final m = syncStatus.isRescan ? s.rescan : s.catchup;
        return '$m $percent %';
      case 2:
        return remaining != null ? '$remaining...' : '';
      case 3:
        return timestamp;
      case 4:
        return '${syncStatus.eta.timeRemaining}';
      case 5:
        return '\u{2193} $downloadedSize2';
      case 6:
        return '\u{2192} $trialDecryptionCount2';
    }
    throw Exception('Unreachable');
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);

    final syncedHeight = syncStatus.syncedHeight;
    final text = getSyncText(syncedHeight);
    final syncing = syncStatus.syncing;
    final syncStyle = syncing
        ? t.textTheme.bodySmall!
        : t.textTheme.bodyMedium!.apply(color: t.primaryColor);
    final Widget inner = GestureDetector(
        onTap: _onSync,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
                color: t.colorScheme.background,
                padding: EdgeInsets.all(8),
                child: Text(text, style: syncStyle))));
    final value = syncStatus.eta.progress?.let((x) => x.toDouble() / 100.0);
    return SizedBox(
      height: 50,
      child: Stack(
        children: <Widget>[
          if (value != null)
            SizedBox.expand(
              child: LinearProgressIndicator(
                value: value,
              ),
            ),
          Center(child: inner),
        ],
      ),
    );
  }

  _onSync() {
    if (syncStatus.syncing) {
      setState(() {
        display = (display + 1) % 7;
      });
    } else {
      if (syncStatus.paused)
        syncStatus.setPause(false);
      Future(() => syncStatus.sync(false));
    }
  }
}
