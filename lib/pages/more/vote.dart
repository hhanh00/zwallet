import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warp_api/data_fb_generated.dart';

import '../../pages/utils.dart';
import '../../accounts.dart';
import '../../generated/intl/messages.dart';
import '../../store2.dart';
import '../../tablelist.dart';

class VotePage2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => VoteState();
}

class VoteState extends State<VotePage2> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(color: Colors.red, height: 200),
      Container(color: Colors.blue, height: 100),
      Expanded(child: Container(color: Colors.green)),
    ]);
  }
}

const electionURLKey = 'election:url';

enum ElectionStatus {
  Waiting,
  Registration,
  Opened,
  Closed,
}

class VotePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => VoteState();
}

class _VoteState extends State<VotePage> with WithLoadingAnimation {
  final urlController = TextEditingController();
  Vote? vote;

  @override
  void initState() {
    super.initState();
    load(() async {
      final prefs = await SharedPreferences.getInstance();
      final electionURL = prefs.getString(electionURLKey);
      if (electionURL != null) await _load(electionURL);
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    final height = syncStatus2.latestHeight;
    if (height == null) return Scaffold();

    ElectionStatus? status;
    final e = vote?.election;
    if (e != null) status = ElectionStatus.values.byName(e.status);

    return Scaffold(
        appBar: AppBar(
          title: Text(s.vote),
          actions: [
            if (e != null)
              IconButton(onPressed: _reset, icon: Icon(Icons.clear)),
            if (status == null ||
                status == ElectionStatus.Registration ||
                status == ElectionStatus.Opened)
              IconButton(onPressed: _next, icon: Icon(Icons.chevron_right))
          ],
        ),
        body: wrapWithLoading(
          e != null
              ? SettingsList(sections: [
                  SettingsSection(
                    title: Text(e.name),
                    tiles: [
                      SettingsTile(
                          title: Text(s.registrationHeight),
                          value: Text(e.start_height.toString())),
                      SettingsTile(
                          title: Text(s.snapshotHeight),
                          value: Text(e.end_height.toString())),
                      if (status != null)
                        SettingsTile(
                            title: Text(s.status), value: Text(status.name)),
                    ],
                  )
                ])
              : Padding(
                  padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: FormBuilder(
                    child: Column(
                      children: [
                        FormBuilderTextField(
                          name: 'url',
                          controller: urlController,
                          decoration: InputDecoration(label: Text(s.voteURL)),
                        )
                      ],
                    ),
                  ),
                ),
        ));
  }

  _load(String electionURL) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(electionURLKey, electionURL);
    final rep = await http.get(Uri.parse(electionURL));
    final electionString = rep.body;
    logger.d(electionString);
    final electionJson = jsonDecode(electionString);
    final election = Election.fromJson(electionJson);
    setState(() {
      vote = Vote(election: election, notes: []);
    });
  }

  _next() async {
    final e = vote?.election;
    if (e != null) {
      // WarpApi.populateVoteNotes(aa.coin, aa.id, e.start_height, e.end_height);
      // final notes = WarpApi.listVoteNotes(aa.coin, aa.id, e.end_height);
      // final vote = Vote(election: e, notes: notes);
      GoRouter.of(context).push('/more/vote/notes', extra: vote);
    } else {
      final electionURL = urlController.text;
      await _load(electionURL);
    }
  }

  _reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(electionURLKey);
    // WarpApi.resetVote(aa.coin);
    setState(() {
      vote = null;
    });
  }
}

class VoteNotesPage extends StatefulWidget {
  final Vote vote;
  VoteNotesPage(this.vote, {super.key});

  @override
  State<StatefulWidget> createState() => VoteNotesState();
}

class VoteNotesState extends State<VoteNotesPage> {
  late final s = S.of(context);
  late List<VoteNoteT> notes = widget.vote.notes
      .map((n) => VoteNoteT(
          id: n.id, height: n.height, value: n.value, selected: false))
      .toList();

  @override
  Widget build(BuildContext context) {
    final status = ElectionStatus.values.byName(widget.vote.election.status);
    return Scaffold(
      appBar: AppBar(title: Text(s.selectNoteVote), actions: [
        if (status == ElectionStatus.Opened)
          IconButton(onPressed: _next, icon: Icon(Icons.chevron_right))
      ]),
      body: TableListPage(
        view: 1,
        items: notes,
        metadata: TableListVoteMetadata(),
      ),
    );
  }

  _next() {
    final selectedNotes = notes.where((n) => n.selected).toList();
    final vote = Vote(election: widget.vote.election, notes: selectedNotes);
    GoRouter.of(context).push('/more/vote/candidate', extra: vote);
  }
}

class TableListVoteMetadata extends TableListItemMetadata<VoteNoteT> {
  @override
  List<Widget>? actions(BuildContext context) => [];

  @override
  List<ColumnDefinition> columns(BuildContext context) => [];

  @override
  Widget? header(BuildContext context) => null;

  @override
  Text? headerText(BuildContext context) => null;

  @override
  void inverseSelection() {}

  @override
  SortConfig2? sortBy(String field) => null;

  @override
  Widget toListTile(BuildContext context, int index, VoteNoteT n,
      {void Function(void Function())? setState}) {
    final v = amountToString2(n.value);
    return GestureDetector(
        onTap: () => setState?.call(() => n.selected = !n.selected),
        child: ListTile(title: Text(v), selected: n.selected));
  }

  @override
  DataRow toRow(BuildContext context, int index, VoteNoteT item) =>
      DataRow(cells: []);
}

class VoteCandidatePage extends StatefulWidget {
  final Vote vote;
  VoteCandidatePage(this.vote, {super.key});

  @override
  State<StatefulWidget> createState() => VoteCandidateState();
}

class VoteCandidateState extends State<VoteCandidatePage>
    with WithLoadingAnimation {
  late final s = S.of(context);
  late final vote = widget.vote;
  var candidate = 0;

  @override
  Widget build(BuildContext context) {
    final e = widget.vote.election;
    final candidates = e.candidates
        .asMap()
        .entries
        .map((e) => FormBuilderFieldOption(
              value: e.key,
              child: Text(e.value),
            ))
        .toList();
    return Scaffold(
        appBar: AppBar(
            title: Text(e.question),
            actions: [IconButton(onPressed: _ok, icon: Icon(Icons.check))]),
        body: wrapWithLoading(
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: FormBuilder(
                child: FormBuilderRadioGroup(
                  name: 'candidates',
                  initialValue: candidate,
                  orientation: OptionsOrientation.vertical,
                  options: candidates,
                  onChanged: (v) => setState(() => candidate = v!),
                ),
              ),
            ),
          ),
        ));
  }

  _ok() async {
    final election = widget.vote.election;
    final ids = widget.vote.notes.map((n) => n.id).toList();
    await load(() async {
      // final vote = await WarpApi.vote(
      //     aa.coin, aa.id, ids, candidate, jsonEncode(election));
      // final prefs = await SharedPreferences.getInstance();
      // final electionURL = prefs.getString(electionURLKey)!;
      // final url = Uri.parse(electionURL);
      // final submitURL = url.replace(path: election.submit_url);
      // final rep = await http.put(submitURL, body: vote);
      // if (rep.statusCode != 200) {
      //   final error = rep.body;
      //   await showMessageBox2(context, s.voteFailed, error);
      // } else {
      //   final hash = rep.body;
      //   await showMessageBox2(context, s.voteSubmitted, hash);
      //   GoRouter.of(context).go('/more');
      // }
    });
  }
}
