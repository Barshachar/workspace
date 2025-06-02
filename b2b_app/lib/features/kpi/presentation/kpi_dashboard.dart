import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class KpiDashboard extends StatelessWidget {
  const KpiDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final data = [charts.Series<int, String>(
      id: 'GMV',
      data: [100, 120, 140],
      domainFn: (v, i) => 'D$i',
      measureFn: (v, i) => v,
    )];
    return SizedBox(
      height: 200,
      child: charts.BarChart(data),
    );
  }
}
