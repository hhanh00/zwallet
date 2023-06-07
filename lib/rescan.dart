import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:warp_api/warp_api.dart';
import 'generated/l10n.dart';
import 'main.dart';

final rescanKey = GlobalKey<RescanFormState>();

Future<int?> rescanDialog(BuildContext context) async {
  try {
    if (active.coin >= 2) return 0;
    DateTime minDate = WarpApi.getActivationDate();
    final bool approved = await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
                title: Text(S.of(context).rescanFrom),
                content: RescanForm(minDate, key: rescanKey),
                actions: confirmButtons(
                    context, () => Navigator.of(context).pop(true),
                    cancelValue: false))) ??
        false;
    if (approved) {
      final date = rescanKey.currentState!.startDate;
      final heightText = rescanKey.currentState!.heightController.text;
      final approved = await confirmWifi(context);
      if (approved) {
        showSnackBar(S.of(context).rescanning, autoClose: true);
        final height = int.tryParse(heightText);
        if (height != null) return height;
        final height2 = await WarpApi.getBlockHeightByTime(date);
        return height2;
      }
    }
  } on String {}
  return null;
}

class RescanForm extends StatefulWidget {
  final minDate;
  RescanForm(this.minDate, {Key? key}) : super(key: key);

  @override
  RescanFormState createState() => RescanFormState();
}

class RescanFormState extends State<RescanForm> {
  DateTime maxDate = DateTime.now();
  late DateTime startDate;
  var heightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    startDate = widget.minDate;
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    return SingleChildScrollView(
        child: Column(children: [
      OutlinedButton(
          onPressed: _showDatePicker,
          child: Text(dateFormat.format(startDate))),
      Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('OR')),
      TextFormField(
        decoration: InputDecoration(labelText: S.of(context).height),
        keyboardType: TextInputType.number,
        controller: heightController,
      ),
    ]));
  }

  _showDatePicker() async {
    final date = await showDatePicker(
        context: context,
        firstDate: widget.minDate,
        initialDate: startDate,
        lastDate: maxDate);
    if (date != null) {
      setState(() {
        startDate = date;
      });
    }
  }
}

Future<bool> confirmWifi(BuildContext context) async {
  if (!isMobile()) return true;
  final connectivity = await Connectivity().checkConnectivity();
  if (connectivity == ConnectivityResult.mobile) {
    return await showDialog<bool?>(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
                title: Text(S.of(context).rescan),
                content: Text(S.of(context).mobileCharges),
                actions: confirmButtons(
                    context, () => Navigator.of(context).pop(true),
                    cancelValue: false))) ??
        false;
  }
  return true;
}
