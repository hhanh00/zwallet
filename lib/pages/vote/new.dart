import 'package:YWallet/accounts.dart';
import 'package:YWallet/pages/vote/vote_data.dart';
import 'package:YWallet/src/rust/api/simple.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
      final e = context.read<ElectionInfo>();
      final path = e.filepath!;
      final election = await createElection(filepath: path, urls: urls, key: seed);
      e.election = election;
      print(election);
      GoRouter.of(context).push("/vote/overview");
    }
  }
}

// http://localhost:8000/election/03045bcc8b345e6847b9fb7d0096b57bde97ef40613c55ad8240789c0a90f409