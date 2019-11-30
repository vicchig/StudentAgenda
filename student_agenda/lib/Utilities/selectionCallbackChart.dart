import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class SelectionCallbackChart extends StatefulWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SelectionCallbackChart(this.seriesList, {this.animate});

  @override
  State<StatefulWidget> createState() => new _SelectionCallbackChartState();
}

class _SelectionCallbackChartState extends State<SelectionCallbackChart> {
  int _dataIndex;
  Map<String, num> _measures;

  // Listens to the underlying selection changes, and updates the information
  // relevant to building the primitive legend like information under the
  // chart.
  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    int dataIndex;
    final measures = <String, num>{};

    // We get the model that updated with a list of [SeriesDatum] which is
    // simply a pair of series & datum.
    //
    // Walk the selection updating the measures map, storing off the sales and
    // series name for each selection point.
    if (selectedDatum.isNotEmpty) {
      dataIndex = selectedDatum.first.datum.idx;
      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        measures[datumPair.series.displayName] = datumPair.datum.val;
      });
    }

    // Request a build.
    setState(() {
      _dataIndex = dataIndex;
      _measures = measures;
    });
  }

  @override
  Widget build(BuildContext context) {
    // The children consist of a Chart and Text widgets below to hold the info.
    final children = <Widget>[
      new SizedBox(
          height: 250.0,
          child: new charts.LineChart(
            widget.seriesList,
            animate: true,
            behaviors: [
              new charts.SlidingViewport(),
              new charts.PanAndZoomBehavior(),

              new charts.ChartTitle('Month of Time Period',
                  behaviorPosition: charts.BehaviorPosition.bottom,
                  titleOutsideJustification:
                  charts.OutsideJustification.middleDrawArea),
              new charts.ChartTitle('Goals Compelted',
                  behaviorPosition: charts.BehaviorPosition.start,
                  titleOutsideJustification:
                  charts.OutsideJustification.middleDrawArea),
            ],
            selectionModels: [
              new charts.SelectionModelConfig(
                type: charts.SelectionModelType.info,
                changedListener: _onSelectionChanged,
              )
            ],
          )),
    ];

    if (_dataIndex != null) {
      children.add(new Padding(
          padding: new EdgeInsets.only(top: 5.0)));

    }
    _measures?.forEach((String series, num value) {
      children.add(new Text("(Month from Start of Time Period: $_dataIndex, Goals Completed: $value)"));
    });

    return new Column(children: children);
  }
}
