import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:velocity_x/velocity_x.dart';
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
  late final s = S.of(context);
  final formKey = GlobalKey<FormBuilderState>();
  final minDate = activationDate;
  DateTime maxDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(s.rescan),
        actions: [
          IconButton(onPressed: _rescan, icon: Icon(Icons.check)),
        ],
      ),
      body: wrapWithLoading(
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: FormBuilder(
              key: formKey,
              child: Column(
                children: [
                  FormBuilderField<DateTime>(
                      name: 'date',
                      builder: (field) => CalendarDatePicker(
                          initialDate: minDate,
                          firstDate: minDate,
                          lastDate: maxDate,
                          onDateChanged: (v) => field.didChange(v))),
                  Gap(8),
                  FormBuilderTextField(
                    name: 'height',
                    decoration: InputDecoration(labelText: s.height),
                    keyboardType: TextInputType.number,
                    validator: (v) => (v.isEmptyOrNull
                        ? null
                        : FormBuilderValidators.integer()(v)),
                  ),
                  Gap(16),
                  DecoratedBox(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.red, width: 2)),
                      child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(s.rescanWarning,
                              style: t.textTheme.titleLarge)))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _rescan() async {
    final form = formKey.currentState!;
    if (form.validate()) {
      form.save();
      String? h = form.fields['height']!.value;
      DateTime d = form.fields['date']!.value ?? minDate;
      load(() async {
        final height = h.isNotEmptyAndNotNull ? int.parse(h!) :
            await WarpApi.getBlockHeightByTime(aa.coin, d);
        final confirmed = await showConfirmDialog(context, s.rescan, s.confirmRescanFrom(height));
        if (!confirmed) return;
        aa.reset(height);
        Future(() => syncStatus2.rescan(height));
        GoRouter.of(context).pop();
      });
    }
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
