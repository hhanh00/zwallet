import 'package:YWallet/pages/utils.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:warp_api/data_fb_generated.dart';
import 'package:warp_api/warp_api.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../accounts.dart';
import '../../../generated/intl/messages.dart';
import '../../widgets.dart';

class SwapHistoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SwapHistoryState();
}

class SwapHistoryState extends State<SwapHistoryPage>
    with WithLoadingAnimation {
  late S s = S.of(context);
  List<SwapT> history = [];

  @override
  void initState() {
    super.initState();
    Future(() => load(() async {
          history = WarpApi.listSwaps(aa.coin);
        }));
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final p = t.colorScheme.primary;
    return wrapWithLoading(Scaffold(
        appBar: AppBar(
          title: Text(s.history),
          actions: [
            IconButton(onPressed: clear, icon: Icon(Icons.clear_all)),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: ListView.builder(
            itemBuilder: (context, index) {
              final swap = history[index];
              return Panel('',
                  child: Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(swap.provider!, style: TextStyle(color: p)),
                            Text(swap.providerId!,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(timeago.format(DateTime.fromMillisecondsSinceEpoch(
                                    swap.timestamp * 1000))),
                          ]),
                      Divider(),
                      Row(
                        children: [
                          Text(swap.fromAmount!),
                          Gap(8),
                          Text(swap.fromCurrency!),
                        ],
                      ),
                      Text(swap.fromAddress!, overflow: TextOverflow.ellipsis),
                      Divider(),
                      Row(
                        children: [
                          Text(swap.toAmount!),
                          Gap(8),
                          Text(swap.toCurrency!),
                        ],
                      ),
                      Text(swap.toAddress!, overflow: TextOverflow.ellipsis),
                      Divider(),
                      ElevatedButton(
                          onPressed: () => GoRouter.of(context).push(
                              '/account/swap/stealthex/details',
                              extra: swap),
                          child: Text(s.retry)),
                      // Text(
                      //     '${swap.fromAmount} ${swap.fromCurrency} ${swap.fromAddress} '),
                      // Text('${swap.toAmount} ${swap.toCurrency} ${swap.toAddress}'),
                    ],
                  ));
            },
            itemCount: history.length,
          ),
        )));
  }

  clear() async {
    final confirmed =
        await showConfirmDialog(context, s.confirm, s.confirmClearSwapHistory);
    if (confirmed) {
      WarpApi.clearSwapHistory(aa.coin);
      setState(() {
        history = [];
      });
    }
  }
}
