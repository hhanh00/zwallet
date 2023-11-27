import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:warp_api/data_fb_generated.dart';
import 'package:warp_api/warp_api.dart';

import '../../accounts.dart';
import '../../coin/coins.dart';
import '../../generated/intl/messages.dart';
import '../../store2.dart';
import '../utils.dart';

class RescanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RescanState();
}

class _RescanState extends State<RescanPage> with WithLoadingAnimation {
  final minDate = activationDate;
  DateTime maxDate = DateTime.now();
  late DateTime selectedDate;
  var heightController = TextEditingController();

  _RescanState() {
    selectedDate = minDate;
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final t = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(s.rescan),
        actions: [
          IconButton(onPressed: _rescan, icon: Icon(Icons.check)),
        ],
      ),
      body: wrapWithLoading(SingleChildScrollView(
        child: Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Column(
          children: [
            CalendarDatePicker(
                initialDate: minDate,
                firstDate: minDate,
                lastDate: maxDate,
                onDateChanged: _onDate),
            Gap(8),
            TextFormField(
              decoration: InputDecoration(labelText: s.height),
              keyboardType: TextInputType.number,
              controller: heightController,
            ),
            Gap(16),
            DecoratedBox(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.red, width: 2)),
                child: Padding(padding: EdgeInsets.all(8), child: Text(s.rescanWarning, style: t.textTheme.titleLarge)))
          ],
        ),
      )),
    ));
  }

  _onDate(date) {
    setState(() {
      selectedDate = date;
    });
  }

  _rescan() async {
    load(() async {
      final height = int.tryParse(heightController.text) ??
          await WarpApi.getBlockHeightByTime(aa.coin, selectedDate);
      aa.reset(height);
      Future(() => syncStatus2.rescan(height));
      GoRouter.of(context).pop();
    });
  }
}

class RewindPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RewindState();
}

class _RewindState extends State<RewindPage> {
  int? selected;
  final List<Checkpoint> checkpoints = WarpApi.getCheckpoints(aa.coin);

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.rewind), actions: [
        if (selected != null)
          IconButton(onPressed: rewind, icon: Icon(Icons.check)),
      ]),
      body: ListView.separated(
          itemBuilder: (context, index) {
            final cp = checkpoints[index];
            final time = noteDateFormat.format(
                DateTime.fromMillisecondsSinceEpoch(cp.timestamp * 1000));
            return ListTile(
              selected: index == selected,
              title: Text(time),
              trailing: Text(cp.height.toString()),
              onTap: () =>
                  setState(() => selected = index != selected ? index : null),
            );
          },
          separatorBuilder: (context, index) => Divider(),
          itemCount: checkpoints.length),
    );
  }

  rewind() {
    WarpApi.rewindTo(aa.coin, checkpoints[selected!].height);
    Future(() async {
      syncStatus2.sync(true);
    });
    GoRouter.of(context).pop();
  }
}
