import 'package:YWallet/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:k_chart/k_chart_widget.dart';
import 'package:k_chart/flutter_k_chart.dart';

class SyncChartPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SyncChartState();
}

class SyncChartState extends State<SyncChartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Sync Stats')),
        body: Column(children: [
          Expanded(child: Observer(builder: (context) {
            final syncData = syncStats.syncData;
            List<KLineEntity> datas = syncData.map((datum) {
              final h = datum.height.toDouble();
              return KLineEntity.fromCustom(
                  time: datum.timestamp.millisecondsSinceEpoch,
                  open: h,
                  close: h,
                  high: h,
                  low: h,
                  amount: 0,
                  vol: 0);
            }).toList();
            return KChartWidget(
              datas,
              ChartStyle(),
              ChartColors(context: context),
              isLine: true,
              volHidden: true,
              showInfoDialog: true,
              mainState: MainState.MA,
              secondaryState: SecondaryState.NONE,
            );
          })),
          ButtonBar(children: [
            ElevatedButton.icon(
                onPressed: _refresh,
                label: Text('Reset'),
                icon: Icon(Icons.restart_alt)),
            ElevatedButton.icon(
                onPressed: _export,
                label: Text('Export'),
                icon: Icon(Icons.save))
          ])
        ]));
  }

  _refresh() {
    syncStats.reset();
  }

  _export() async {
    final csvData = syncStats.syncData.map((data) => [
      data.timestamp,
      data.height]).toList();
    await shareCsv(csvData, 'sync_status.csv', 'Sync Status Data');
  }
}
