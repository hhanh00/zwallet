import 'dart:async';

import 'package:YWallet/pages/utils.dart';
import 'package:YWallet/pages/vote/vote_data.dart';
import 'package:YWallet/src/rust/api/simple.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

class VoteOverview extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => VoteOverviewState();
}

class VoteOverviewState extends State<VoteOverview> {
  StreamSubscription<int>? subscription;
  int? height;

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      final t = Theme.of(context);
      final filepath = electionStore.filepath!;
      final election = electionStore.election!;
      final downloaded = electionStore.downloaded;
      final range = (election.endHeight - election.startHeight).toDouble();
      final progress =
          height != null ? (height! - election.startHeight) / range : null;

      return Scaffold(
          appBar: AppBar(title: Text(election.name)),
          body: Column(
            children: [
              ListTile(title: Text("Name"), subtitle: Text(election.name)),
              ListTile(
                  title: Text("ID"),
                  subtitle: SelectableText(election.id,
                      style: t.textTheme.bodySmall
                          ?.copyWith(color: t.colorScheme.primary))),
              ListTile(title: Text("Current election file"), subtitle: Text(filepath)),
              ListTile(
                  title: Text("Question"), subtitle: Text(election.question)),
              ListTile(
                  title: Text("Start Height"),
                  subtitle: Text(election.startHeight.toString())),
              ListTile(
                  title: Text("End Height"),
                  subtitle: Text(election.endHeight.toString())),
              if (height != null)
                ListTile(
                    title: Text("Downloaded Height"),
                    subtitle: Text(height.toString())),
              if (progress != null) LinearProgressIndicator(value: progress),
              if (height == null)
                !downloaded
                    ? FilledButton(
                        onPressed: onDownload, child: Text("Download"))
                    : ButtonBar(children: [
                        FilledButton(onPressed: onVote, child: Text("Vote")),
                        OutlinedButton(
                            onPressed: onDelegate, child: Text("Delegate")),
                      ])
            ],
          ));
    });
  }

  void onDownload() async {
    subscription = download(filepath: electionStore.filepath!).listen((h) {
      setState(() {
        height = h;
        if (h == electionStore.election!.endHeight) {
          electionStore.downloaded = true;
          height = null;
        }
      });
    }, onError: (e) async {
      await showMessageBox2(context, "Download Error", e.toString());
      setState(() {
        height = null;
        electionStore.downloaded = false;
      });
    });
  }

  void onVote() => GoRouter.of(context).push("/more/vote/vote");
  void onDelegate() => GoRouter.of(context).push("/more/vote/delegate");
}
