import 'package:YWallet/pages/vote/vote_data.dart';
import 'package:YWallet/src/rust/api/simple.dart';
import 'package:flutter/material.dart';

import 'vote.dart';

class VoteHistory extends StatefulWidget {
  const VoteHistory({super.key});

  @override
  State<StatefulWidget> createState() => VoteHistoryState();
}

class VoteHistoryState extends State<VoteHistory> {
  List<Vote> votes = [];

  @override
  void initState() {
    super.initState();
    Future(() async {
      final v = await listVotes(filepath: electionStore.filepath!);
      setState(() => votes = v);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(shrinkWrap: true, itemBuilder: (context, index) {
      final vote = votes[index];
      final candidates = electionStore.election!.candidates;
      final index_choice = candidates.indexWhere((c) => c.address == vote.address);
      final choice = index_choice >= 0 ? candidates[index_choice].choice : vote.address;

      return ListTile(title: Text(vote.hash), subtitle: Text(choice),
      trailing: Text((vote.amount / BigInt.from(VOTE_UNIT)).toString()),
      textColor: vote.height == null ? Colors.red.shade500 : null);
    },
    itemCount: votes.length);
  }
}
