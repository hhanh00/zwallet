import 'dart:async';

import 'package:YWallet/pages/vote/vote_data.dart';
import 'package:YWallet/src/rust/api/simple.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

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
      final election = electionStore.election!;

      return Scaffold(
          appBar: AppBar(title: Text(election.name)),
          body: Column(
            children: [
              ListTile(title: Text("Name"), subtitle: Text(election.name)),
              ListTile(title: Text("Question"), subtitle: Text(election.question)),
              ListTile(title: Text("Start Height"), subtitle: Text(election.startHeight.toString())),
              ListTile(title: Text("End Height"), subtitle: Text(election.endHeight.toString())),
              if (height != null) ListTile(title: Text("Downloaded Height"), subtitle: Text(height.toString())),
              !electionStore.downloaded ?
              FilledButton(onPressed: onDownload, child: Text("Download"))
              : ButtonBar(children: [
                FilledButton(onPressed: onVote, child: Text("Vote")),
                OutlinedButton(onPressed: onDelegate, child: Text("Delegate")),
                TextButton(onPressed: onHistory, child: Text("History")),
              ])
            ],
          ));
    });
  }

  void onDownload() {
    subscription = download(filepath: electionStore.filepath!).listen((h) {
      setState(() => height = h);
    });
  }

  void onVote() {}
  void onDelegate() {}
  void onHistory() {}
}
