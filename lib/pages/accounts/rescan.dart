import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(s.rescan),
        actions: [
          IconButton(onPressed: _rescan, icon: Icon(Icons.check)),
        ],
      ),
      body: wrapWithLoading(SingleChildScrollView(
        child: Column(
          children: [
            CalendarDatePicker(
                initialDate: minDate,
                firstDate: minDate,
                lastDate: maxDate,
                onDateChanged: _onDate),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 8), child: Text(s.or)),
            TextFormField(
              decoration: InputDecoration(labelText: s.height),
              keyboardType: TextInputType.number,
              controller: heightController,
            ),
          ],
        ),
      )),
    );
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
