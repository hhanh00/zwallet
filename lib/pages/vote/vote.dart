import 'package:YWallet/pages/utils.dart';
import 'package:YWallet/pages/vote/history.dart';
import 'package:YWallet/pages/vote/vote_data.dart';
import 'package:YWallet/src/rust/api/simple.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class VoteVote extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => VoteVoteState();
}

const VOTE_UNIT = 100000;

class VoteVoteState extends State<VoteVote> with WithLoadingAnimation {
  final formKey = GlobalKey<FormBuilderState>();
  final amountController = TextEditingController(text: "0");
  int balance = 0;

  @override
  void initState() {
    super.initState();
    Future(() async {
      final filepath = electionStore.filepath!;
      await synchronize(filepath: filepath);
      final zats = await getBalance(filepath: filepath);
      setState(() => balance = (zats / BigInt.from(VOTE_UNIT)).toInt());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      final election = electionStore.election!;

      final choices = election.candidates.map((c) => 
        FormBuilderFieldOption(value: c.address, child: Text(c.choice))
        ).toList();

      return Scaffold(
        appBar: AppBar(title: Text("Vote")),
        body: wrapWithLoading(FormBuilder(key: formKey, child: Column(children: [
          ListTile(title: Text(election.question)),
          FormBuilderRadioGroup<String>(name: "choices", 
            orientation: OptionsOrientation.vertical,
            validator: FormBuilderValidators.required(),
            options: choices),
          Gap(8),
          ListTile(title: Text("Votes Available"), subtitle: Text(balance.toString())),
          FormBuilderTextField(name: "amount", 
            decoration: InputDecoration(label: Text("Votes")),
            controller: amountController,
            keyboardType: TextInputType.number,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.integer(),
              FormBuilderValidators.min(1),
            ])
            ),
          Gap(16),
          FilledButton(onPressed: onVote, child: Text("Vote")),
          Gap(16),
          Divider(),
          Text("Past Votes"),
          Expanded(child: VoteHistory()),
        ]))
      ));
    });
  }

  void onVote() async {
    final form = formKey.currentState!;
    if (form.saveAndValidate()) {
      final c = form.fields["choices"]!.value;
      final a = int.parse(amountController.text);
      logger.i("choice: $c, amount: $a");

      await load(() async {
        final id = await vote(filepath: electionStore.filepath!,
          address: c,
          amount: BigInt.from(a * VOTE_UNIT));
        await showMessageBox2(context, "Vote Submitted", id);
        GoRouter.of(context).pop();
      });
    }
  }
}
