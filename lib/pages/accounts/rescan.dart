import 'package:YWallet/pages/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:warp/data_fb_generated.dart';
import 'package:warp/warp.dart';

import '../../accounts.dart';
import '../../coin/coins.dart';
import '../../generated/intl/messages.dart';
import '../../store.dart';
import '../utils.dart';

class RescanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RescanState();
}

class RescanState extends State<RescanPage> {
  late S s = S.of(context);
  final formKey = GlobalKey<FormBuilderState>();
  late int height;

  @override
  void initState() {
    super.initState();
    final activationHeight = warp.getActivationHeight(aa.coin);
    final accounts = warp.listAccounts(aa.coin);
    final minHeight = accounts.map((a) => a.birth).min() ?? activationHeight;
    height = minHeight;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text(s.rescan),
          actions: [
            IconButton(onPressed: rescan, icon: Icon(Icons.check)),
          ],
        ),
        body: Padding(
            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: FormBuilder(
                key: formKey,
                child: Column(children: [
                  HeightPicker(
                    height,
                    label: Text(s.rescanFrom),
                    onChanged: (h) => height = h!,
                  )
                ]))));
  }

  rescan() async {
    final form = formKey.currentState!;
    if (form.validate()) {
      form.save();
      final h = height;
      if (h != null) {
        aa.reset(h);
        Future(() => syncStatus.rescan(h));
        GoRouter.of(context).pop();
      }
    }
  }
}

class RewindPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RewindState();
}

class _RewindState extends State<RewindPage> {
  late final s = S.of(context);
  int? selected;
  bool calendar = true;
  DateTime? dateSelected;
  List<CheckpointT> checkpoints = [];
  List<DateTime> checkpointDates = [];

  @override
  void initState() {
    super.initState();
    Future(() async {
      final cps = await warp.listCheckpoints(aa.coin);
      setState(() {
        checkpoints = cps;
        checkpointDates = checkpoints
            .map((cp) => _toDate(cp.timestamp, dateOnly: true))
            .toSet()
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final activationDate = DateTime.fromMillisecondsSinceEpoch(
        warp.getActivationDate(aa.coin) * 1000);
    final today = DateTime.now();
    return Scaffold(
      appBar: AppBar(title: Text(s.rewind), actions: [
        calendar
            ? IconButton(
                onPressed: () => setState(() => calendar = false),
                icon: Icon(Icons.list))
            : IconButton(
                onPressed: () => setState(() => calendar = true),
                icon: Icon(Icons.event)),
        if (selected != null)
          IconButton(onPressed: rewind, icon: Icon(Icons.check)),
      ]),
      body: calendar
          ? CalendarDatePicker(
              initialDate: today,
              firstDate: activationDate,
              lastDate: today,
              onDateChanged: _selectDate,
              selectableDayPredicate: (dt) => checkpointDates.contains(dt),
            )
          : ListView.separated(
              itemBuilder: (context, index) {
                final cp = checkpoints[index];
                final time = noteDateFormat.format(_toDate(cp.timestamp));
                return ListTile(
                  selected: index == selected,
                  title: Text(time),
                  trailing: Text(cp.height.toString()),
                  onTap: () => setState(
                      () => selected = index != selected ? index : null),
                );
              },
              separatorBuilder: (context, index) => Divider(),
              itemCount: checkpoints.length),
    );
  }

  _selectDate(DateTime dt) {
    selected = checkpointDates.indexWhere((d) => d == dt);
    dateSelected = dt;
    setState(() {});
  }

  rewind() async {
    final height = checkpoints[selected!].height;
    final confirmed =
        await showConfirmDialog(context, s.rewind, s.confirmRewind(height));
    if (!confirmed) return;
    Future(() async {
      await warp.rewindTo(aa.coin, height);
      syncStatus.sync(true);
    });
    GoRouter.of(context).pop();
  }

  DateTime _toDate(int ts, {bool dateOnly = false}) {
    var dt = DateTime.fromMillisecondsSinceEpoch(ts * 1000);
    if (dateOnly) dt = DateTime(dt.year, dt.month, dt.day);
    return dt;
  }
}
