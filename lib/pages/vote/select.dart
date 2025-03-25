import 'dart:io';

import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:YWallet/src/rust/api/simple.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import 'vote_data.dart';

class VoteSelect extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => VoteSelectState();
}

class VoteSelectState extends State<VoteSelect> {
  final addKey = GlobalKey();
  final listKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    Future(electionStore.reloadFileList);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showTutorial(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Select or Create"), actions: [
          Showcase(
              key: addKey,
              description:
                  "Create a NEW election file. It contains all the information required to vote including the wallet SEED PHRASE.",
              child: IconButton(onPressed: onNew, icon: Icon(Icons.add)))
        ]),
        body: Observer(builder: (context) {
          final files = electionStore.files;
          return Showcase(
              key: listKey,
              description:
                  "Tap a file name to OPEN it, swipe left/right to DELETE",
              child: ListView.builder(
                itemBuilder: (context, i) {
                  final f = files[i];
                  final fullpath = "${electionStore.votePath}/$f";
                  return Dismissible(
                    key: ValueKey(f),
                    child: ListTile(
                        title: Text(f), onTap: () => onSelect(fullpath)),
                    onDismissed: (_) {
                      files.remove(f);
                      final db = File(fullpath);
                      db.deleteSync();
                    },
                  );
                },
                itemCount: files.length,
              ));
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

  void showTutorial(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final showTutorial = prefs.getBool("tutorial:select") ?? true;
    if (showTutorial) {
      prefs.setBool("tutorial:select", false);
      Future.delayed(Durations.long1, () =>
      ShowCaseWidget.of(context).startShowCase([addKey, listKey]));
    }
  }
}
