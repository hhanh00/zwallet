import 'dart:convert';

import 'package:YWallet/pages/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warp/warp.dart';

import '../../accounts.dart';
import '../../generated/intl/messages.dart';
import '../../store.dart';
import '../../tablelist.dart';

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

class VoteState extends State<VotePage> with WithLoadingAnimation {
  final urlController = TextEditingController();
  Vote? vote;

  @override
  void initState() {
    super.initState();
    Future(() async {
      final prefs = GetIt.I.get<SharedPreferences>();
      final electionURL = prefs.getString('election:url');
      if (electionURL != null) await _load(electionURL);
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    final height = syncStatus.latestHeight;
    if (height == null) return Scaffold();

    ElectionStatus? status;
    final e = vote?.election;
    if (e != null)
      status = ElectionStatus.values.byName(e.status);

    return Scaffold(
      appBar: AppBar(
        title: Text(s.vote),
        actions: [
          if (status == null || status == ElectionStatus.Registration || status == ElectionStatus.Opened)
            IconButton(onPressed: _next, icon: Icon(Icons.chevron_right))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: e != null
            ? SettingsList(sections: [
                SettingsSection(
                  title: Text(e.name),
                  tiles: [
                    SettingsTile(
                        title: Text('Registration Height'),
                        value: Text(e.start_height.toString())),
                    SettingsTile(
                        title: Text('Snapshot Height'),
                        value: Text(e.end_height.toString())),
                    if (status != null)
                      SettingsTile(title: Text('Status'), value: Text(status.name)),
                  ],
                )
              ])
            : FormBuilder(
                child: Column(
                  children: [
                    FormBuilderTextField(
                      name: 'url',
                      controller: urlController,
                      decoration: InputDecoration(label: Text('Vote URL')),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  _load(String electionURL) async {
    final prefs = GetIt.I.get<SharedPreferences>();
    prefs.setString('election:url', electionURL);
    final rep = await http.get(Uri.parse(electionURL));
    final electionString = rep.body;
    logger.d(electionString);
    final electionJson = jsonDecode(electionString);
    final election = Election.fromJson(electionJson);
    setState(() {
      vote = Vote(election: election, ids: []);
    });
  }

  _next() async {
    final e = vote?.election;
    if (e != null) {
      // WarpApi.populateVoteNotes(aa.coin, aa.id, e.start_height, e.end_height);
      // final ids = WarpApi.listVoteNotes(aa.coin, aa.id);
      // logger.d("$ids");
      // final vote = Vote(election: e, ids: ids);
      // GoRouter.of(context).push('/more/vote/notes', extra: vote);
    } else {
      final electionURL = urlController.text;
      await _load(electionURL);
    }
  }
}

class VoteNotesPage extends StatefulWidget {
  final Vote vote;
  VoteNotesPage(this.vote, {super.key});

  @override
  State<StatefulWidget> createState() => VoteNotesState();
}

class VoteNotesState extends State<VoteNotesPage> {
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    final ids = widget.vote.ids;
    notes = ids.map((id) {
      var n = aa.notes.items.firstWhere((n) => n.id == id).clone();
      n.selected = false;
      return n;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final status = ElectionStatus.values.byName(widget.vote.election.status);
    return Scaffold(
      appBar: AppBar(title: Text('Select Notes to Vote with'), actions: [
        if (status == ElectionStatus.Opened) IconButton(onPressed: _next, icon: Icon(Icons.chevron_right))
      ]),
      body: TableListPage(
        view: 1,
        items: notes,
        metadata: TableListVoteMetadata(),
      ),
    );
  }

  _next() {
    final ids = notes.where((n) => n.selected).map((n) => n.id).toList();
    final vote = Vote(election: widget.vote.election, ids: ids);
    GoRouter.of(context).push('/more/vote/candidate', extra: vote);
  }
}

class TableListVoteMetadata extends TableListItemMetadata<Note> {
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
  Widget toListTile(BuildContext context, int index, Note n,
      {void Function(void Function())? setState}) {
    return GestureDetector(
        onTap: () => setState?.call(() => n.selected = !n.selected),
        child: ListTile(title: Text(n.value.toString()), selected: n.selected));
  }

  @override
  DataRow toRow(BuildContext context, int index, Note item) =>
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
        appBar: AppBar(title: Text('Pick Candidate'), actions: [
          IconButton(onPressed: _next, icon: Icon(Icons.chevron_right))
        ]),
        body: wrapWithLoading(
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: FormBuilder(
                child: FormBuilderRadioGroup(
                  name: 'candidates',
                  initialValue: 0,
                  orientation: OptionsOrientation.vertical,
                  options: candidates,
                  onChanged: (v) => setState(() => candidate = v!),
                ),
              ),
            ),
          ),
        ));
  }

  _next() async {
    final election = widget.vote.election;
    final ids = widget.vote.ids;
    await load(() async {
      // final vote = await WarpApi.vote(
      //     aa.coin, aa.id, ids, candidate, jsonEncode(election));
      // final rep = await http.put(Uri.parse(election.submit_url), body: vote);
      // if (rep.statusCode != 200) {
      //   final error = rep.body;
      //   await showMessageBox2(context, 'Vote Failed', error);
      // }
      // else {
      //   final hash = rep.body;
      //   await showMessageBox2(context, 'Vote Submitted', hash);
      //   GoRouter.of(context).go('/more');
      // }
    });
  }
}
