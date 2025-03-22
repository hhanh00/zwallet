import 'package:YWallet/pages/vote/vote_data.dart';
import 'package:YWallet/src/rust/api/simple.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';

class VoteVote extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => VoteVoteState();
}

class VoteVoteState extends State<VoteVote> {
  final formKey = GlobalKey<FormBuilderState>();
  final amountController = TextEditingController(text: "0");
  int balance = 0;

  @override
  void initState() {
    super.initState();
    Future(() async {
      final zats = await getBalance(filepath: electionStore.filepath!);
      setState(() => balance = (zats / BigInt.from(100000)).toInt());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      final election = electionStore.election!;

      final choices = election.candidates.asMap().entries.map((c) => 
        FormBuilderFieldOption(value: c.key, child: Text(c.value))
        ).toList();

      return Scaffold(
        appBar: AppBar(title: Text("Vote")),
        body: FormBuilder(key: formKey, child: Column(children: [
          ListTile(title: Text(election.question)),
          FormBuilderRadioGroup<int>(name: "choices", 
            orientation: OptionsOrientation.vertical,
            initialValue: 0,
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
        ]))
      );
    });
  }

  void onVote() {
    final form = formKey.currentState!;
    if (form.saveAndValidate()) {
      final c = form.fields["choices"]!.value;
      final a = int.parse(amountController.text);
      print("choice: $c, amount: $a");
    }
  }
}
