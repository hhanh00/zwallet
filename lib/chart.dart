import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_palette/flutter_palette.dart';
import 'package:intl/intl.dart';
import 'package:warp_api/warp_api.dart';
import 'package:k_chart/k_chart_widget.dart';
import 'package:k_chart/flutter_k_chart.dart';

import 'store.dart';

class LineChartTimeSeries extends StatelessWidget {
  List<KLineEntity> datas;

  LineChartTimeSeries(this.datas);
  factory LineChartTimeSeries.fromTimeSeries(List<TimeSeriesPoint<double>> quotes) =>
      LineChartTimeSeries(quotes.map((q) => KLineEntity.fromCustom(time: q.day * DAY_MS, open: q.value, close: q.value,
          high: q.value, low: q.value, amount: 0, vol: 0)).toList());

  @override
  Widget build(BuildContext context) {
    return Container(
      child: KChartWidget(datas,
      ChartStyle(), ChartColors(context: context),
      isLine: true,
      volHidden: true,
      showInfoDialog: true,
      mainState: MainState.MA,
      secondaryState: SecondaryState.NONE,
      )
    );
  }
}

class HorizontalBarChart extends StatelessWidget {
  final List<double> values;
  final double height;

  HorizontalBarChart(this.values, { this.height: 32 });

  @override
  Widget build(BuildContext context) {
    final palette = getPalette(Theme.of(context).primaryColor, values.length);

    final sum = values.fold<double>(0, ((acc, v) => acc + v));
    final stacks = values.asMap().entries.map((e) {
      final i = e.key;
      final color = palette[i];
      final v = NumberFormat.compact().format(values[i]);
      final flex = max((values[i] / sum * 100).round(), 1);
      return Flexible(child: Container(child:
        Center(child: Text(v, textAlign: TextAlign.center, style: TextStyle(color: Colors.white))),
        color: color, height: height), flex: flex);
    }).toList();

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch, children: stacks));
  }
}

ColorPalette getPalette(Color color, int n) => ColorPalette.polyad(
  color,
  numberOfColors: max(n, 1),
  hueVariability: 15,
  saturationVariability: 10,
  brightnessVariability: 10,
);
