import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_palette/flutter_palette.dart';
import 'package:warp_api/warp_api.dart';

import 'store.dart';
import 'main.dart';

class LineChartTimeSeries extends StatefulWidget {
  final List<TimeSeriesPoint<double>> timeseries;

  LineChartTimeSeries(this.timeseries);

  @override
  LineChartTimeSeriesState createState() => LineChartTimeSeriesState();
}

class LineChartTimeSeriesState extends State<LineChartTimeSeries> {
  final numberFormat = NumberFormat.compact();

  bool showAvg = false;
  var _minX = 0.0;
  var _maxX = 0.0;
  var _minY = 0.0;
  var _maxY = 0.0;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 1.7,
        child: LineChart(
          mainData(),
        ));
  }

  LineChartData mainData() {
    final theme = Theme.of(context);
    double minY = double.maxFinite;
    double maxY = 0.0;

    final spots = widget.timeseries.map((ab) {
      if (minY > ab.value) minY = ab.value;
      if (maxY < ab.value) maxY = ab.value;
      return FlSpot(ab.day.toDouble(), ab.value);
    }).toList();

    _minX = spots.first.x;
    _maxX = spots.last.x;
    _minY = minY;
    _maxY = maxY;
    var yInterval = 1.1 * (_maxY - _minY) / 6;
    if (yInterval == 0) {
      yInterval = 1;
    }

    List<Color> gradientColors = [
      theme.colorScheme.secondary,
      theme.colorScheme.primary,
    ];

    final textStyle = theme.textTheme.bodyText1!;
    final bgColor = theme.backgroundColor;

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: theme.colorScheme.secondary.withOpacity(0.2),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: theme.colorScheme.secondary.withOpacity(0.2),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (context, value) => TextStyle(
              color: theme.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 12),
          // checkToShowTitle: (min, max, _, interval, v) => v != max,
          getTitles: (v) {
            final dt = DateTime.fromMillisecondsSinceEpoch(v.toInt() * DAY_MS);
            return DateFormat.Md().format(dt);
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => TextStyle(
            color: theme.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (v) {
            return numberFormat.format(v);
          },
          reservedSize: 40,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true, border: Border.all(color: theme.colorScheme.secondary, width: 1)),
      minX: _minX,
      maxX: _maxX,
      minY: _minY,
      maxY: _maxY,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: false,
          colors: gradientColors,
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: bgColor,
          getTooltipItems: (touchedSpots) =>
              touchedSpots.map((LineBarSpot spot) {
                final x = spot.x;
                final dt = DateTime.fromMillisecondsSinceEpoch(x.toInt() * DAY_MS);
                final xdt = DateFormat.Md().format(dt);
                final y = decimalFormat(spot.y, 3);
                return LineTooltipItem("$xdt - $y",
                    textStyle);
              }).toList()
        )
      )
    );
  }
}

