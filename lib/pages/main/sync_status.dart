import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../generated/intl/messages.dart';
import '../../store2.dart';
import '../../main.dart';

class SyncStatusWidget extends StatefulWidget {
  SyncStatusState createState() => SyncStatusState();
}

class SyncStatusState extends State<SyncStatusWidget> {
  var display = 0;

  @override
  void initState() {
    super.initState();
    Future(() async { 
      await syncStatus2.update();
      // startAutoSync();
    });
  }

  String getSyncText(int syncedHeight) {
    final s = S.of(context);
    if (!syncStatus2.syncing) 
      return syncedHeight.toString();
    if (syncStatus2.paused) 
      return s.syncPaused;

    final latestHeight = syncStatus2.latestHeight;

    if (latestHeight == null)
      return s.disconnected;

    final timestamp = syncStatus2.timestamp?.let(timeago.format) ?? s.na;
    final downloadedSize = syncStatus2.downloadedSize;
    final trialDecryptionCount = syncStatus2.trialDecryptionCount;

    final remaining = syncStatus2.eta.remaining;
    final percent = syncStatus2.eta.progress;
    final downloadedSize2 =
        NumberFormat.compact().format(downloadedSize);
    final trialDecryptionCount2 =
        NumberFormat.compact().format(trialDecryptionCount);

    switch (display) {
      case 0:
        return '$syncedHeight / $latestHeight';
      case 1:
        final m = syncStatus2.isRescan ? s.rescan : s.catchup;
        return '$m $percent %';
      case 2:
        return remaining != null ? '$remaining...' : '';
      case 3:
        return timestamp;
      case 4:
        return '${syncStatus2.eta.timeRemaining}';
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

    final syncedHeight = syncStatus2.syncedHeight;
    final text = getSyncText(syncedHeight);
    final syncing = syncStatus2.syncing;
    final syncStyle = syncing ? t.textTheme.bodySmall!
    : t.textTheme.bodyMedium!.apply(color: t.primaryColor);
    final Widget inner = GestureDetector(onTap: _onSync, child: Text(text, style: syncStyle));
    final value = syncStatus2.eta.progress?.let((x) => x.toDouble() / 100.0);
    return SizedBox(
      height: 50,
      child: Stack(
        children: <Widget>[
          if (value != null) SizedBox.expand(
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
    if (syncStatus2.syncing) {
      setState(() {
        display = (display + 1) % 7;
      });
    }
    else if (syncStatus2.paused)
      syncStatus2.setPause(false);
    else 
      Future(() => syncStatus2.sync(false));
  }
}

