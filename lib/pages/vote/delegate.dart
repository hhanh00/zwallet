import 'package:YWallet/pages/utils.dart';
import 'package:YWallet/pages/vote/vote_data.dart';
import 'package:YWallet/src/rust/api/simple.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import 'vote.dart';

class VoteDelegate extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => VoteDelegateState();
}

class VoteDelegateState extends State<VoteDelegate> with WithLoadingAnimation {
  final formKey = GlobalKey<FormBuilderState>();
  final addressController = TextEditingController();
  final amountController = TextEditingController();

  int balance = 0;

  final addressKey = GlobalKey();

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
    final election = electionStore.election!;
    final address = election.address;

    return Scaffold(
        appBar: AppBar(title: Text("Delegate")),
        body: wrapWithLoading(SingleChildScrollView(child: FormBuilder(
            key: formKey,
            child: Column(children: [
              Showcase(key: addressKey, description: "This is your own voting address. Vote Delegations sent to it will be added to your available votes", child:
              ListTile(
                  title: Text("My Address"), subtitle: SelectableText(address))),
              Gap(16),
              FormBuilderTextField(
                  name: "address",
                  controller: addressController,
                  decoration: InputDecoration(label: Text("Delegate To")),
                  validator: FormBuilderValidators.required()),
              ListTile(
                  title: Text("Votes Available"),
                  subtitle: Text(balance.toString())),
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
              FilledButton(onPressed: onDelegate, child: Text("Delegate"))
            ])))));
  }

  void onDelegate() async {
    final form = formKey.currentState!;
    if (form.saveAndValidate()) {
      final d = addressController.text;
      final a = int.parse(amountController.text);
      logger.i("address: $d, amount: $a");

      await load(() async {
        try {
          final id = await vote(
              filepath: electionStore.filepath!,
              address: d,
              amount: BigInt.from(a * VOTE_UNIT));
          await showMessageBox2(context, "Delegation Submitted", id);
          GoRouter.of(context).pop();
        } on AnyhowException catch (e) {
          await showMessageBox2(context, "Error", e.message);
        }
      });
    }
  }

  void showTutorial(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final showTutorial = prefs.getBool("tutorial:delegate") ?? true;
    if (showTutorial) {
      prefs.setBool("tutorial:delegate", false);
      Future.delayed(Durations.long1, () =>
      ShowCaseWidget.of(context).startShowCase([addressKey]));
    }
  }
}
