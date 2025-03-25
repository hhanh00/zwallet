import 'dart:async';

import 'package:YWallet/pages/utils.dart';
import 'package:YWallet/pages/vote/vote_data.dart';
import 'package:YWallet/src/rust/api/simple.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

class VoteOverview extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => VoteOverviewState();
}

class VoteOverviewState extends State<VoteOverview> {
  StreamSubscription<int>? subscription;
  int? height;

  final nameKey = GlobalKey();
  final idKey = GlobalKey();
  final fileKey = GlobalKey();
  final questionKey = GlobalKey();
  final startKey = GlobalKey();
  final endKey = GlobalKey();
  final downloadKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showTutorial(context);
    });
  }

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
              Showcase(
                  key: nameKey,
                  description:
                      "Name of the Election as set by its creator",
                  child: ListTile(
                      title: Text("Name"), subtitle: Text(election.name))),
              Showcase(
                  key: idKey,
                  description:
                      "The Hash ID of the Election. You SHOULD check that it is the same as the Election Authority published. If it differs, the Election could have been tampered with",
                  child: ListTile(
                      title: Text("ID"),
                      subtitle: SelectableText(election.id,
                          style: t.textTheme.bodySmall
                              ?.copyWith(color: t.colorScheme.primary)))),
              Showcase(
                  key: fileKey,
                  description:
                      "The full path to the Election file. On mobile devices, this location is sandboxed and is not user accessible",
                  child: ListTile(
                      title: Text("Current Election file"),
                      subtitle: Text(filepath))),
              Showcase(
                  key: questionKey,
                  description: "The Question/Motion being polled",
                  child: ListTile(
                      title: Text("Question"),
                      subtitle: Text(election.question))),
              Showcase(
                  key: startKey,
                  description:
                      "The Start of the Registration Period. Notes created before this height are not eligible",
                  child: ListTile(
                      title: Text("Start Height"),
                      subtitle: Text(election.startHeight.toString()))),
              Showcase(
                  key: endKey,
                  description:
                      "The End of the Registration Period. Notes created after this height are not eligible",
                  child: ListTile(
                      title: Text("End Height"),
                      subtitle: Text(election.endHeight.toString()))),
              if (height != null)
                ListTile(
                    title: Text("Downloaded Height"),
                    subtitle: Text(height.toString())),
              if (progress != null) LinearProgressIndicator(value: progress),
              if (height == null)
                !downloaded
                    ? Showcase(
                        key: downloadKey,
                        description:
                            "Press to start downloading data from the zcash blockchain",
                        child: FilledButton(
                            onPressed: onDownload, child: Text("Download")))
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

  void showTutorial(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final showTutorial = prefs.getBool("tutorial:overview") ?? true;
    if (showTutorial) {
      prefs.setBool("tutorial:overview", false);
      Future.delayed(Durations.long1, () =>
      ShowCaseWidget.of(context).startShowCase([nameKey, idKey,
      fileKey, questionKey, startKey, endKey, downloadKey
      ]));
    }
  }
}
