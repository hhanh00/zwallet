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
    final e = context.watch<ElectionInfo>();

    return Observer(builder: (context) {
      final election = e.election!;

      return Scaffold(
          appBar: AppBar(title: Text(election.name)),
          body: Column(
            children: [],
          ));
    });
  }
}
