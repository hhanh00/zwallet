import 'dart:io';

import 'package:YWallet/accounts.dart';
import 'package:YWallet/appsettings.dart';
import 'package:YWallet/coin/coins.dart';
import 'package:YWallet/pages/settings.dart';
import 'package:YWallet/pages/utils.dart';
import 'package:YWallet/pages/vote/vote_data.dart';
import 'package:YWallet/src/rust/api/simple.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

class VoteNew extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => VoteNewState();
}

class VoteNewState extends State<VoteNew> {
  final formKey = GlobalKey<FormBuilderState>();
  final nameKey = GlobalKey();
  final urlKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showTutorial(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("New Election")),
        body: FormBuilder(
            key: formKey,
            child: Column(children: [
              Showcase(
                key: nameKey,
                description: 'The name of the Election file. It can be anything you like and will appear in the list of elections',
                child: FormBuilderTextField(
                  name: "name",
                  decoration: InputDecoration(label: Text("Name")))),
              Showcase(
                key: urlKey,
                description: "URL or list of URLs as published by the Election authority",
                child: FormBuilderTextField(
                  name: "urls",
                  decoration: InputDecoration(label: Text("Election URL(s)")))),
              Gap(16),
              FilledButton(onPressed: onNext, child: Text("Next"))
            ])));
  }

  void onNext() async {
    final s = formKey.currentState!;
    if (s.validate()) {
      final name = s.fields["name"]?.value!;
      final urls = s.fields["urls"]?.value!;
      final seed = aa.seed ?? "";
      final lwd = resolveURL(coins[aa.coin], coinSettings);
      try {
        final dirPath = await getDataPath();
        final path = File("$dirPath/votes/$name.db");
        if (path.existsSync()) {
          s.fields["name"]!.invalidate("Election already exists");
          return;
        }
        final election = await createElection(filepath: path.path,
          lwdUrl: lwd, urls: urls, key: seed);
        electionStore.filepath = path.path;
        electionStore.election = election;
        electionStore.downloaded = false;
        electionStore.reloadFileList();
        GoRouter.of(context).pushReplacement("/more/vote/overview");
      }
      on AnyhowException catch (e) {
        await showMessageBox2(context, "Error", e.message);
      }
    }
  }

  void showTutorial(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final showTutorial = prefs.getBool("tutorial:new") ?? true;
    if (showTutorial) {
      prefs.setBool("tutorial:new", false);
      Future.delayed(Durations.long1, () =>
      ShowCaseWidget.of(context).startShowCase([nameKey, urlKey]));
    }
  }
}
