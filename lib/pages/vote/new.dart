import 'package:YWallet/accounts.dart';
import 'package:YWallet/appsettings.dart';
import 'package:YWallet/coin/coins.dart';
import 'package:YWallet/pages/settings.dart';
import 'package:YWallet/pages/vote/vote_data.dart';
import 'package:YWallet/src/rust/api/simple.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class VoteNew extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => VoteNewState();
}

class VoteNewState extends State<VoteNew> {
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("New Election")),
        body: FormBuilder(
            key: formKey,
            child: Column(children: [
              FormBuilderTextField(
                  name: "urls",
                  decoration: InputDecoration(label: Text("Election URL(s)"))),
              Gap(16),
              FilledButton(onPressed: onNext, child: Text("Next"))
            ])));
  }

  void onNext() async {
    final s = formKey.currentState!;
    if (s.validate()) {
      final urls = s.fields["urls"]?.value!;
      print(urls);
      final seed = aa.seed ?? "";
      print(seed);
      final path = electionStore.filepath!;
      final lwd = resolveURL(coins[aa.coin], coinSettings);
      final election = await createElection(filepath: path,
        lwdUrl: lwd, urls: urls, key: seed);
      electionStore.election = election;
      electionStore.downloaded = false;
      print(election);
      GoRouter.of(context).push("/more/vote/overview");
    }
  }
}
