import 'dart:convert';

import 'package:YWallet/pages/utils.dart';
import 'package:YWallet/router.dart';
import 'package:YWallet/store.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';
import 'package:warp/data_fb_generated.dart';
import 'package:warp/warp.dart';
import 'package:flat_buffers/flat_buffers.dart' as fb;

import '../../../accounts.dart';
import '../../../appsettings.dart';
import '../../../generated/intl/messages.dart';
import '../../widgets.dart';

const SXapiId = '81e963b6-d9f8-41a5-bfbe-88752d2a6a49';
const SXbaseURL = 'https://api.stealthex.io/api';
// pairs/

class StealthExPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

// TODO
// class StealthExPage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => StealthExState();
// }

// class StealthExState extends State<StealthExPage> with WithLoadingAnimation {
//   final formKey = GlobalKey<FormBuilderState>();
//   final fromKey = GlobalKey<SwapAmountState>();
//   final toKey = GlobalKey<SwapAmountState>();
//   late S s = S.of(context);
//   List<String> currencies = [];
//   final addressController = TextEditingController();

//   SwapQuote? quote;
//   bool reversed = false;

//   var from = SwapAmount(
//     amount: '0',
//     currency: 'ZEC',
//   );
//   var to = SwapAmount(
//     amount: '0',
//     currency: 'BTC',
//   );

//   @override
//   void initState() {
//     super.initState();
//     load(() async {
//       try {
//         currencies = await getCurrencies();
//       } catch (e) {
//         logger.e(e);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final sendToZEC = reversed ? from.currency == 'ZEC' : to.currency == 'ZEC';
//     return wrapWithLoading(
//       Scaffold(
//         appBar: AppBar(title: Text(s.stealthEx)),
//         body: Padding(
//           padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
//           child: SingleChildScrollView(
//             child: Center(
//               child: FormBuilder(
//                 key: formKey,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SwapAmountWidget(
//                       key: fromKey,
//                       name: 'from',
//                       initialValue: from,
//                       onChanged: (v) => setState(() {
//                         logger.d('from onChanged');
//                         toKey.currentState!.resetAmount();
//                         quote = null;
//                         from = v;
//                       }),
//                       currencies: currencies,
//                     ),
//                     Gap(16),
//                     IconButton(
//                         onPressed: swapCurrencies,
//                         icon: Icon(reversed
//                             ? FontAwesomeIcons.arrowUp
//                             : FontAwesomeIcons.arrowDown)),
//                     Gap(16),
//                     SwapAmountWidget(
//                       key: toKey,
//                       name: 'to',
//                       initialValue: to,
//                       onChanged: (v) => setState(() {
//                         logger.d('to onChanged $v');
//                         if (to.currency != v.currency && v.amount != '0') {
//                           toKey.currentState!.resetAmount();
//                           quote = null;
//                         }
//                         to = v;
//                       }),
//                       readOnly: true,
//                       currencies: currencies,
//                     ),
//                     Gap(32),
//                     if (!sendToZEC)
//                       FormBuilderTextField(
//                         name: 'address',
//                         decoration: InputDecoration(
//                           label: Text(s.address),
//                           helperText: s.checkSwapAddress,
//                         ),
//                         controller: addressController,
//                       ),
//                     Gap(32),
//                     ButtonBar(children: [
//                       ElevatedButton(
//                         onPressed: () {
//                           final from = fromKey.currentState!;
//                           final to = toKey.currentState!;
//                           if (fromKey.currentState!.validate()) {
//                             final a = Decimal.parse(from.value.amount);
//                             logger.d("$a ${from.value}");
//                             getQuote(a, from.value.currency, to.value.currency);
//                           }
//                         },
//                         child: Text(s.getQuote),
//                       ),
//                       if (quote?.rate_id != null)
//                         ElevatedButton.icon(
//                             onPressed: swap,
//                             label: Text(s.next),
//                             icon: Icon(Icons.chevron_right)),
//                     ]),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   swapCurrencies() {
//     setState(() {
//       reversed = !reversed;
//     });
//   }

//   void getQuote(Decimal amount, String f, String t) async {
//     if (f != 'ZEC' && t != 'ZEC') {
//       fromKey.currentState!.invalidate(s.invalidSwapCurrencies);
//       return;
//     }
//     final uri = Uri.parse(reversed
//         ? '${SXbaseURL}/v2/estimate/${t}/${f}'
//         : '${SXbaseURL}/v2/estimate/${f}/${t}');
//     final amountField = reversed ? 'amount_to' : 'amount';
//     final url = Uri(
//         scheme: uri.scheme,
//         host: uri.host,
//         path: uri.path,
//         queryParameters: {
//           'fixed': 'true',
//           amountField: amount.toString(),
//         });
//     final rep = await http.get(url, headers: {
//       'X-SX-API-KEY': SXapiId,
//     });
//     final res = jsonDecode(rep.body);
//     setState(() {
//       if (rep.statusCode == 200) {
//         final q = SwapQuote.fromJson(res);
//         logger.d(q);
//         quote = q;
//         toKey.currentState!.update(to.copyWith(amount: q.estimated_amount));
//       } else {
//         quote = null;
//         logger.e(res);
//         final error = res['err']['details'] as String;
//         fromKey.currentState!.invalidate(error);
//       }
//     });
//   }

//   swap() {
//     final q = quote;
//     if (q == null) return;
//     final taddr = WarpApi.getTAddr(aa.coin, aa.id);
//     final fromCurrency = reversed ? to.currency : from.currency;
//     final toCurrency = reversed ? from.currency : to.currency;
//     final amount = Decimal.parse(reversed ? q.estimated_amount : from.amount);
//     final sendToZEC = reversed ? from.currency == 'ZEC' : to.currency == 'ZEC';
//     final address = sendToZEC ? taddr : addressController.text;
//     if (address.isEmpty) {
//       formKey.currentState!.fields['address']!.invalidate(s.addressIsEmpty);
//       return;
//     }
//     load(() async {
//       try {
//         final swap = await createExchange(
//             q.rate_id, fromCurrency, toCurrency, amount, address);
//         GoRouter.of(context)
//             .push('/account/swap/stealthex/details', extra: swap);
//       } on String catch (err) {
//         formKey.currentState!.fields['address']!.invalidate(err);
//       }
//     });
//   }
// }

// class StealthExSummaryPage extends StatefulWidget {
//   final SwapT swap;
//   StealthExSummaryPage(this.swap);

//   @override
//   State<StatefulWidget> createState() => StealthExSummaryState();
// }

// class StealthExSummaryState extends State<StealthExSummaryPage>
//     with WithLoadingAnimation {
//   @override
//   Widget build(BuildContext context) {
//     final s = S.of(context);
//     final swap = widget.swap;
//     logger.d(swap);
//     final reversed = swap.fromCurrency != 'zec';
//     return wrapWithLoading(
//       Scaffold(
//         appBar: AppBar(title: Text(s.stealthEx)),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
//             child: Column(
//               children: [
//                 Text(swap.providerId!),
//                 Gap(8),
//                 Panel(s.swapSend,
//                     child: SwapLegWidget(
//                       swap.fromAmount!,
//                       swap.fromAddress!,
//                       swap.fromCurrency!,
//                       swap.fromImage!,
//                       isFrom: true,
//                       onSend: _send,
//                     )),
//                 Gap(16),
//                 Panel(s.swapReceive,
//                     child: SwapLegWidget(
//                       swap.toAmount!,
//                       swap.toAddress!,
//                       swap.toCurrency!,
//                       swap.toImage!,
//                       isFrom: false,
//                     )),
//                 Gap(16),
//                 Text(reversed ? s.swapFromTip : s.swapToTip),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   _send(String address, String amount) async {
//     load(() async {
//       final context = rootNavigatorKey.currentContext!;
//       final s = S.of(context);
//       try {
//         final recipient = Recipient(RecipientObjectBuilder(
//           address: address,
//           amount: stringToAmount(amount),
//         ).toBytes());
//         final txPlan = await WarpApi.prepareTx(aa.coin, aa.id, [recipient], 1,
//             coinSettings.replyUa, appSettings.anchorOffset, coinSettings.feeT);
//         GoRouter.of(context).push('/account/txplan?tab=more', extra: txPlan);
//       } on String catch (e) {
//         showMessageBox2(context, s.error, e);
//       }
//     });
//   }
// }

// class SwapLegWidget extends StatelessWidget {
//   final String amount;
//   final String address;
//   final String currency;
//   final String image;
//   final bool isFrom;
//   final Function(String, String)? onSend;
//   SwapLegWidget(this.amount, this.address, this.currency, this.image,
//       {super.key, required this.isFrom, this.onSend});

//   @override
//   Widget build(BuildContext context) {
//     final qr =
//         (currency == 'btc') ? 'bitcoin:${address}?amount=${amount}' : null;
//     final canSend = currency == 'zec';
//     return Column(
//       children: [
//         Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//           SvgPicture.network(image),
//           SelectableText(amount),
//           Text(currency),
//         ]),
//         SelectableText(address),
//         Row(mainAxisAlignment: MainAxisAlignment.end, children: [
//           if (isFrom && qr != null)
//             IconButton(
//                 onPressed: () => _qr(context, qr), icon: Icon(Icons.qr_code)),
//           if (isFrom && canSend && onSend != null)
//             IconButton(
//                 onPressed: () => onSend?.call(address, amount),
//                 icon: Icon(Icons.send))
//         ]),
//       ],
//     );
//   }

//   _qr(BuildContext context, String code) {
//     GoRouter.of(context).push('/showqr?title=$code', extra: code);
//   }
// }

// List<String> _currencies = [];

// Future<List<String>> getCurrencies() async {
//   if (_currencies.isNotEmpty) return _currencies;
//   final rep = await http.get(Uri.parse('${SXbaseURL}/v2/pairs/ZEC?fixed=true'),
//       headers: {"X-SX-API-KEY": SXapiId, "Content-Type": "application/json"});
//   if (rep.statusCode != 200) throw Exception(rep.body);
//   _currencies = (jsonDecode(rep.body) as List<dynamic>)
//       .map((c) => (c as String).toUpperCase())
//       .toSet()
//       .toList();
//   _currencies = _currencies.sortedBy((a, b) {
//     if (a == 'ZEC') a = ' ZEC'; // Will appear first
//     if (b == 'ZEC') b = ' ZEC';
//     return a.compareTo(b);
//   });
//   return _currencies;
// }

// Future<SwapT> createExchange(String rateId, String from, String to,
//     Decimal amount, String address) async {
//   final requestURL = Uri.parse('${SXbaseURL}/v3/exchange');
//   final requestData = SwapRequest(
//       fixed: true,
//       rate_id: rateId,
//       currency_from: from,
//       currency_to: to,
//       amount_from: amount.toDouble(),
//       address_to: address);
//   final rep = await http.post(
//     requestURL,
//     headers: {"X-SX-API-KEY": SXapiId, "Content-Type": "application/json"},
//     body: jsonEncode(requestData),
//   );
//   logger.d(requestData);
//   if (rep.statusCode != 201) {
//     final err = jsonDecode(rep.body)['err']['details'] as String;
//     throw err;
//   }

//   final repBody = jsonDecode(rep.body)['data'];
//   logger.d(repBody);
//   final resp = SwapResponse.fromJson(repBody);
//   final currencies = repBody['currencies'];
//   final fromJson = currencies[resp.currency_from] as Map<String, dynamic>;
//   final toJson = currencies[resp.currency_to] as Map<String, dynamic>;
//   final fromDetails = SwapLeg.fromJson(fromJson);
//   final toDetails = SwapLeg.fromJson(toJson);

//   logger.d(resp);
//   logger.d(fromDetails);
//   logger.d(toDetails);

//   logger.d(rep.body);

//   final swap = SwapT(
//     provider: 'SX',
//     providerId: resp.id,
//     timestamp: DateTime.parse(resp.timestamp).millisecondsSinceEpoch ~/ 1000,
//     fromCurrency: fromDetails.symbol,
//     fromAmount: resp.amount_from,
//     fromAddress: resp.address_from,
//     fromImage: fromDetails.image,
//     toCurrency: toDetails.symbol,
//     toAmount: resp.amount_to,
//     toAddress: resp.address_to,
//     toImage: toDetails.image,
//   );
//   WarpApi.storeSwap(aa.coin, aa.id, swap);

//   return swap;
// }
