import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:warp/data_fb_generated.dart';
import 'package:warp/warp.dart';

import '../../appsettings.dart';
import '../utils.dart';
import '../widgets.dart';
import '../../accounts.dart';
import '../../generated/intl/messages.dart';

class MultiPayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

// class MultiPayPage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _MultiPayState();
// }

// class _MultiPayState extends State<MultiPayPage> {
//   List<PaymentRequestT> outputs = [];
//   int? selected;
//   bool waiting = false;

//   @override
//   Widget build(BuildContext context) {
//     final s = S.of(context);
//     return Scaffold(
//       appBar: AppBar(title: Text(s.multiPay), actions: [
//         selected == null
//             ? IconButton(onPressed: add, icon: Icon(Icons.add))
//             : IconButton(onPressed: delete, icon: Icon(Icons.delete)),
//         if (outputs.isNotEmpty)
//           IconButton(onPressed: send, icon: Icon(Icons.send)),
//       ]),
//       body: LoadingWrapper(
//         waiting,
//         child: ListView.separated(
//           itemBuilder: (context, index) => GestureDetector(
//               onTap: () => select(index),
//               child: RecipientWidget(outputs[index],
//                   selected: selected == index)),
//           separatorBuilder: (context, index) => Divider(),
//           itemCount: outputs.length,
//         ),
//       ),
//     );
//   }

//   select(int index) {
//     if (selected == index)
//       selected = null;
//     else
//       selected = index;
//     setState(() {});
//   }

//   add() async {
//     final txOutput =
//         await GoRouter.of(context).push<Recipient>('/account/multi_pay/new');
//     if (txOutput != null) outputs.add(txOutput);
//   }

//   edit() {}
//   delete() async {
//     final s = S.of(context);
//     final confirmed =
//         await showConfirmDialog(context, s.delete, s.deletePayment);
//     if (confirmed) {
//       outputs.removeAt(selected!);
//       selected = null;
//       setState(() {});
//     }
//   }

//   send() async {
//     final s = S.of(context);
//     try {
//       _calculating(true);
//       final txPlan = await WarpApi.prepareTx(
//         aa.coin,
//         aa.id,
//         outputs,
//         7,
//         coinSettings.replyUa,
//         appSettings.anchorOffset,
//         coinSettings.feeT,
//       );
//       GoRouter.of(context).push('/account/txplan?tab=more', extra: txPlan);
//     } on String catch (e) {
//       await showMessageBox2(context, s.error, e);
//     } finally {
//       _calculating(false);
//     }
//   }

//   _calculating(bool v) {
//     if (mounted) setState(() => waiting = v);
//   }
// }
