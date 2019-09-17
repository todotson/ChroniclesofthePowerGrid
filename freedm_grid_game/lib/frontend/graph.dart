import 'package:flutter/material.dart';
import 'package:freedm_grid_game/interface.dart';
import 'package:charts_flutter/flutter.dart' as charts;


class LoadProfile extends StatelessWidget {
  List<charts.Series<PowerData, String>> seriesList;

  LoadProfile(PowerInterface supply,PowerInterface load) {
    seriesList = [
      charts.Series<PowerData, String>(
        id: 'Supply',
        colorFn: (_, __) => charts.MaterialPalette.teal.shadeDefault,
        domainFn: (PowerData data, _) => data.type,
        measureFn: (PowerData data, _) => data.magnitude,
        data: [
          PowerData('Base', supply.base),
          PowerData('Peak', supply.peak),
        ],
      ),
      charts.Series<PowerData, String>(
        id: 'Load',
        colorFn: (_, __) => charts.MaterialPalette.purple.shadeDefault,
        domainFn: (PowerData data, _) => data.type,
        measureFn: (PowerData data, _) => data.magnitude,
        data: [
          PowerData('Base', load.base),
          PowerData('Peak', load.peak),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: true,
      barGroupingType: charts.BarGroupingType.grouped,
    );
  }
}

class PowerData {
  String type;
  double magnitude;

  PowerData(this.type, this.magnitude);
}