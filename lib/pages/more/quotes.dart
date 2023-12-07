import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:graphic/graphic.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';

import '../../accounts.dart';
import '../../coin/coins.dart';
import '../../generated/intl/messages.dart';
import '../utils.dart';
import 'budget.dart';

class MarketQuotes extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MarketQuotesState();
}

class _MarketQuotesState extends State<MarketQuotes> with WithLoadingAnimation {
  final intervals = [
    '1m',
    '3m',
    '5m',
    '15m',
    '30m',
    '1h',
    '2h',
    '4h',
    '6h',
    '8h',
    '12h',
    '1d',
    '3d',
    '1w',
    '1M',
  ];
  List<OHLCV> quotes = [];
  String interval = '';

  @override
  void initState() {
    super.initState();
    Future(() => onInterval('1m'));
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final min = quotes.map((q) => q.low).min()?.floor();
    final max = quotes.map((q) => q.high).max()?.ceil();
    final items =
        intervals.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList();
    return Scaffold(
      appBar: AppBar(title: Text(s.marketPrice)),
      body: wrapWithLoading(Stack(
        children: [
          if (quotes.isNotEmpty) Chart<OHLCV>(
            data: quotes,
            variables: {
              'time': Variable<OHLCV, DateTime>(
                accessor: (OHLCV d) =>
                    DateTime.fromMillisecondsSinceEpoch(d.time),
                scale: TimeScale(formatter: (dt) => chartDateFormat.format(dt)),
              ),
              'open': Variable<OHLCV, num>(
                accessor: (OHLCV d) => d.open,
                scale: LinearScale(min: min, max: max),
              ),
              'high': Variable<OHLCV, num>(
                accessor: (OHLCV d) => d.high,
                scale: LinearScale(min: min, max: max),
              ),
              'low': Variable<OHLCV, num>(
                accessor: (OHLCV d) => d.low,
                scale: LinearScale(min: min, max: max),
              ),
              'close': Variable<OHLCV, num>(
                accessor: (OHLCV d) => d.close,
                scale: LinearScale(min: min, max: max),
              ),
            },
            axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
            marks: [
              CustomMark(
                shape: ShapeEncode(value: CandlestickShape(hollow: false)),
                size: SizeEncode(value: 2),
                position: Varset('time') *
                    (Varset('open') +
                        Varset('high') +
                        Varset('low') +
                        Varset('close')),
                color: ColorEncode(
                    encoder: (tuple) => tuple['close'] <= tuple['open']
                        ? Colors.red
                        : Colors.green),
              )
            ],
            selections: {
              'touchMove': PointSelection(
                on: {
                  GestureType.scaleUpdate,
                  GestureType.tapDown,
                  GestureType.longPressMoveUpdate
                },
                dim: Dim.x,
              )
            },
            tooltip: TooltipGuide(),
            crosshair: CrosshairGuide(),
            coord: RectCoord(
                horizontalRangeUpdater: Defaults.horizontalRangeEvent),
          ),
          FormBuilderDropdown(
            name: 'interval',
            decoration: InputDecoration(label: Text(s.interval)),
            initialValue: interval,
            items: items,
            onChanged: onInterval,
          ),
        ],
      )),
    );
  }

  onInterval(String? v) async {
    load(() async {
      await loadData(v!);
      interval = v;
      setState(() {});
    });
  }

  Future<void> loadData(String interval) async {
    final ticker = coins[aa.coin].marketTicker;
    if (ticker == null) return;
    final rep = await http.get(Uri.parse(
        'https://api.binance.com/api/v3/uiKlines?symbol=$ticker&interval=$interval'));
    final data = rep.body;
    final rows = jsonDecode(data) as List<dynamic>;

    quotes = rows
        .map((r) => OHLCV(
              time: r[0].toInt(),
              open: double.parse(r[1]),
              high: double.parse(r[2]),
              low: double.parse(r[3]),
              close: double.parse(r[4]),
              volume: double.parse(r[5]),
            ))
        .toList();
  }
}

class OHLCV {
  final int time;
  final double open, high, low, close, volume;
  OHLCV({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });
}
