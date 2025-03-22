import 'package:YWallet/pages/vote/vote_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class VoteOverview extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => VoteOverviewState();
}

class VoteOverviewState extends State<VoteOverview> {
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
              ButtonBar(children: [
                FilledButton(onPressed: onVote, child: Text("Vote")),
                OutlinedButton(onPressed: onDelegate, child: Text("Delegate")),
                TextButton(onPressed: onHistory, child: Text("History")),
              ])
            ],
          ));
    });
  }

  void onVote() {}
  void onDelegate() {}
  void onHistory() {}
}
