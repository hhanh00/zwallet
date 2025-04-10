import 'package:YWallet/pages/utils.dart';
import 'package:YWallet/pages/vote/history.dart';
import 'package:YWallet/pages/vote/vote_data.dart';
import 'package:YWallet/src/rust/api/simple.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

class VoteVote extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => VoteVoteState();
}

const VOTE_UNIT = 100000;

class VoteVoteState extends State<VoteVote> with WithLoadingAnimation {
  final formKey = GlobalKey<FormBuilderState>();
  final amountController = TextEditingController(text: "0");
  int balance = 0;

  final availableKey = GlobalKey();
  final historyKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    Future(() async {
      try {
        final filepath = electionStore.filepath!;
        await synchronize(filepath: filepath);
        final zats = await getBalance(filepath: filepath);
        setState(() => balance = (zats / BigInt.from(VOTE_UNIT)).toInt());
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showTutorial(context);
        });
      } on AnyhowException catch (e) {
        showMessageBox2(context, "Error", e.message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      final election = electionStore.election!;

      final choices = election.candidates
          .map((c) =>
              FormBuilderFieldOption(value: c.address, child: Text(c.choice)))
          .toList();

      return Scaffold(
          appBar: AppBar(title: Text("Vote")),
          body: wrapWithLoading(SingleChildScrollView(child: FormBuilder(
              key: formKey,
              child: Column(children: [
                ListTile(title: Text(election.question)),
                FormBuilderRadioGroup<String>(
                    name: "choices",
                    orientation: OptionsOrientation.vertical,
                    validator: FormBuilderValidators.required(),
                    options: choices),
                Gap(8),
                Showcase(
                    key: availableKey,
                    description:
                        "Amount of votes remaining. Votes that have not been confirmed may still be included here. Blocks are finalized every second. Leave and come back to this page to refresh it.",
                    child: ListTile(
                        title: Text("Votes Available"),
                        subtitle: Text(balance.toString()))),
                FormBuilderTextField(
                    name: "amount",
                    decoration: InputDecoration(label: Text("Votes")),
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.integer(),
                      FormBuilderValidators.min(1),
                    ])),
                Gap(16),
                FilledButton(onPressed: onVote, child: Text("Vote")),
                Gap(16),
                Divider(),
                Text("Past Votes"),
                Showcase(
                  key: historyKey,
                  description:
                      "Past votes and delegations submitted from this file. If votes were submitted prior to the creation of this file, they will not appear here but are counted anyway. Rows in red are votes that have not been finalized yet.",
                  child: VoteHistory()),
              ])))));
    });
  }

  void onVote() async {
    final form = formKey.currentState!;
    if (form.saveAndValidate()) {
      final c = form.fields["choices"]!.value;
      final a = int.parse(amountController.text);
      logger.i("choice: $c, amount: $a");

      await load(() async {
        try {
          final id = await vote(
              filepath: electionStore.filepath!,
              address: c,
              amount: BigInt.from(a * VOTE_UNIT));
          await showMessageBox2(context, "Vote Submitted", id);
          GoRouter.of(context).pop();
        } on AnyhowException catch (e) {
          await showMessageBox2(context, "Error", e.message);
        }
      });
    }
  }

  void showTutorial(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final showTutorial = prefs.getBool("tutorial:vote") ?? true;
    if (showTutorial) {
      prefs.setBool("tutorial:vote", false);
      Future.delayed(
          Durations.long1,
          () => ShowCaseWidget.of(context).startShowCase([
                availableKey,
                historyKey,
              ]));
    }
  }
}
