import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:warp_api/warp_api.dart';
import 'generated/l10n.dart';
import 'main.dart';

final rescanKey = GlobalKey<RescanFormState>();

Future<int?> rescanDialog(BuildContext context) async {
  final approved = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
              title: Text(S.of(context).rescanFrom),
              content: RescanForm(key: rescanKey),
              actions: confirmButtons(
                  context, () => Navigator.of(context).pop(true),
                  cancelValue: false))) ??
      false;
  if (approved) {
    final date = rescanKey.currentState!.startDate;
    final approved = await confirmWifi(context);
    if (approved) {
      showSnackBar(S.of(context).rescanning, autoClose: true);
      final height = await WarpApi.getBlockHeightByTime(date);
      return height;
    }
  }
  return null;
}

class RescanForm extends StatefulWidget {
  RescanForm({Key? key}) : super(key: key);

  @override
  RescanFormState createState() => RescanFormState();
}

class RescanFormState extends State<RescanForm> {
  DateTime minDate = WarpApi.getActivationDate();
  DateTime maxDate = DateTime.now();
  late DateTime startDate;

  @override
  void initState() {
    super.initState();
    startDate = minDate;
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    return SingleChildScrollView(
        child: OutlinedButton(onPressed: _showDatePicker, child: Text(dateFormat.format(startDate)))
            );
  }

  _showDatePicker() async {
    final date = await showDatePicker(context: context, firstDate: minDate, initialDate: startDate, lastDate: maxDate);
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
                content: Text(
                    S.of(context).mobileCharges),
                actions: confirmButtons(
                    context, () => Navigator.of(context).pop(true),
                    cancelValue: false))) ??
        false;
  }
  return true;
}
