import 'dart:io';

import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:YWallet/src/rust/api/simple.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'vote_data.dart';

class VoteSelect extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => VoteSelectState();
}

class VoteSelectState extends State<VoteSelect> {
  @override
  void initState() {
    super.initState();
    Future(electionStore.reloadFileList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Select or Create"),
            actions: [IconButton(onPressed: onNew, icon: Icon(Icons.add))]),
        body: Observer(builder: (context) {
          final files = electionStore.files;
          return ListView.builder(
            itemBuilder: (context, i) {
              final f = files[i];
              final fullpath = "${electionStore.votePath}/$f";
              return Dismissible(
                key: ValueKey(f),
                child:
                    ListTile(title: Text(f), onTap: () => onSelect(fullpath)),
                onDismissed: (_) {
                  files.remove(f);
                  final db = File(fullpath);
                  db.deleteSync();
                },
              );
            },
            itemCount: files.length,
          );
        }));
  }

  void onNew() => GoRouter.of(context).push("/more/vote/new");

  void onSelect(String path) {
    Future(() async {
      electionStore.filepath = path;
      electionStore.election = await getElection(filepath: path);
      electionStore.downloaded = electionStore.election!.downloaded;
      GoRouter.of(context).push("/more/vote/overview");
    });
  }
}
