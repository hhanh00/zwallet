import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:warp_api/warp_api.dart';

import '../../generated/intl/messages.dart';
import '../../main.dart';
import '../../store2.dart';

class RescanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RescanState();
}

class _RescanState extends State<RescanPage> {
  final minDate = WarpApi.getActivationDate();
  DateTime maxDate = DateTime.now();
  DateTime? selectedDate;
  var heightController = TextEditingController();

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
      body: SingleChildScrollView(
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
      ),
    );
  }

  _onDate(date) {
    setState(() {
      selectedDate = date;
    });
  }

  _rescan() async {
    active.clear();
    final height = int.tryParse(heightController.text) ??
        await WarpApi.getBlockHeightByTime(active.coin, selectedDate!);
    Future(() => syncStatus2.rescan(height));
    GoRouter.of(context).pop();
  }
}
