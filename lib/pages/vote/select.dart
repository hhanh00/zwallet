import 'dart:typed_data';

import 'package:YWallet/src/rust/api/simple.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';

import 'vote_data.dart';

class VoteSelect extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => VoteSelectState();
}

class VoteSelectState extends State<VoteSelect> {
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Observer(builder: (context) {
      final filepath = electionStore.filepath;

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
                  OutlinedButton(onPressed: onNew, child: Text("Create")),
                  FilledButton(onPressed: onOpen, child: Text("Open")),
                ])
              ])));
    });
  }

  void onNew() async {
    final appDocDir = await getApplicationSupportDirectory();
    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select where to save the election database',
      initialDirectory: appDocDir.path,
      fileName: 'vote.db',
      bytes: Uint8List(0)
    );
    if (path != null) {
      electionStore.filepath = path;
      GoRouter.of(context).push('/more/vote/new');
    }
  }

  void onOpen() async {
    final appDocDir = await getApplicationSupportDirectory();
    final res = await FilePicker.platform.pickFiles(
      initialDirectory: appDocDir.path,
    );
    if (res != null && res.files.isNotEmpty) {
      final file = res.files.first;
      electionStore.filepath = file.path;
      electionStore.election = await getElection(filepath: file.path!);
      electionStore.downloaded = electionStore.election!.downloaded;
      GoRouter.of(context).push('/more/vote/overview');
    }
  }
}
