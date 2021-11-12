import 'package:flutter/material.dart';
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
