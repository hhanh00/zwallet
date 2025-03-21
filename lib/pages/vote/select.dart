import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:file_selector/file_selector.dart';

import 'vote_data.dart';

class VoteSelect extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => VoteSelectState();
}

class VoteSelectState extends State<VoteSelect> {
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final election = context.watch<ElectionInfo>();

    return Observer(builder: (context) {
      final filepath = election.filepath;

      return Scaffold(
          appBar: AppBar(title: Text("Vote")),
          body: Padding(
              padding: EdgeInsets.all(16),
              child: Column(children: [
                if (filepath != null)
                  Text("Current election file: $filepath", style: t.bodyMedium),
                Gap(16),
                Card.outlined(
                    elevation: 10,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        """Open or Create a new election file. An election file is similar to a wallet but is only used for voting. It contains your SEED PHRASE, therefore keep it in a safe directory and delete it once you have voted.""",
                        style: t.bodyLarge))),
                Gap(16),
                ButtonBar(children: [
                  FilledButton(onPressed: onNew, child: Text("Create")),
                  OutlinedButton(onPressed: onOpen, child: Text("Open")),
                ])
              ])));
    });
  }

  void onNew() async {
    final location = await getSaveLocation(suggestedName: "vote.db");
    final path = location?.path;
    final e = context.read<ElectionInfo>();
    e.filepath = path;
    GoRouter.of(context).push('/vote/new');
  }

  void onOpen() {}
}
