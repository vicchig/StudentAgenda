import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

//Data point for a pie chart
class PieDatum {
  final String label;
  final double percentVal;
  final Color color;

  PieDatum(this.label, this.percentVal, this.color);
}

//Data point for a line chart
class LineSeriesValue{
  final int idx;
  int val;

  LineSeriesValue(this.idx, this.val);
}

//creates pie chart data from a value map
List<charts.Series<PieDatum, String>> createPieData(Map<String, dynamic> chartData) {
  List<PieDatum> data = new List<PieDatum>();
  data.add(new PieDatum("Done on Time", chartData["onTime%"], Colors.green[200]));
  data.add(new PieDatum("Done Late", chartData["late%"], Colors.orangeAccent[100]));
  data.add(new PieDatum("Incomplete", chartData["incomplete%"], Colors.redAccent[100]));

  return [
    new charts.Series<PieDatum, String>(
        id: 'Data',
        domainFn: (PieDatum point, _) => point.label,
        measureFn: (PieDatum point, _) => point.percentVal,
        data: data,
        labelAccessorFn: (PieDatum row, _) => '${row.percentVal.toString() + "%"}',
        colorFn: (PieDatum point, _) => charts.ColorUtil.fromDartColor(point.color)
    )
  ];
}

//build a pie chart from given series
charts.PieChart buildPieChart(List<charts.Series<PieDatum, dynamic>> chartDataSeries){
  return charts.PieChart(
    chartDataSeries,
    animate: true,
    animationDuration: Duration(milliseconds: 750),
    behaviors: [
      new charts.DatumLegend(
        outsideJustification: charts.OutsideJustification.endDrawArea,
        horizontalFirst: false,
        desiredMaxRows: 1,
        cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),

      )
    ],
    defaultRenderer: new charts.ArcRendererConfig(
        arcRendererDecorators: [
          new charts.ArcLabelDecorator(
            labelPosition: charts.ArcLabelPosition.inside,
          )
        ]
    ),
  );
}


//create line series data points from given value map
List<charts.Series<LineSeriesValue, int>> createTimeLineData(Map<String, dynamic> chartData, int months) {
  List<LineSeriesValue> data = new List<LineSeriesValue>();
  for(int i = 0; i < months; i++){
    data.add(LineSeriesValue(i + 1, 0));
  }
  if(chartData["goalCompletions"].length > 0){
    int periodStartYear = chartData["goalCompletions"][0].year;
    int periodStartMonth = chartData["goalCompletions"][0].month;
    int periodEndMonth = chartData["goalCompletions"][1].month;
    for(int i = 2; i < chartData["goalCompletions"].length; i++){
      int goalCompletionYear = chartData["goalCompletions"][i].year;
      int goalCompletionMonth = chartData["goalCompletions"][i].month;

      if(goalCompletionYear <= periodStartYear){
        int monthIdx = goalCompletionMonth - periodStartMonth;
        monthIdx = monthIdx == months ? monthIdx - 1: monthIdx;
        data[monthIdx].val++;
      }
      else if(goalCompletionYear > periodStartYear){
        data[12 - ((periodEndMonth - months) + 12)].val++;
      }
    }
  }



  return [
    new charts.Series<LineSeriesValue, int>(
      id: 'Data',
      domainFn: (LineSeriesValue point, _) => point.idx,
      measureFn: (LineSeriesValue point, _) => point.val,
      data: data,
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
    )
  ];
}