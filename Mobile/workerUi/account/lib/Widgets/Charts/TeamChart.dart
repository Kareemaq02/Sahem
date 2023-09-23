import 'package:account/Utils/Team.dart';
import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TeamChart extends StatelessWidget {
  final List<TeamData> data;

  const TeamChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      zoomPanBehavior: ZoomPanBehavior(
        enablePinching: true,
        enablePanning: true,
        zoomMode: ZoomMode.xy,
      ),
      primaryXAxis: CategoryAxis(
        isInversed: true,
        labelStyle: const TextStyle(
          fontSize: 12,
          color: AppColor.secondary,
          fontFamily: 'DroidArabicKufi',
        ),
      ),
      primaryYAxis: NumericAxis(
        labelStyle: const TextStyle(
          fontSize: 10,
          color: AppColor.secondary,
          fontWeight: FontWeight.bold,
          fontFamily: 'DroidArabicKufi',
        ),
        title: AxisTitle(
          text: 'العدد',
          textStyle: const TextStyle(
            fontSize: 12,
            color: AppColor.textTitle,
            fontFamily: 'DroidArabicKufi',
          ),
        ),
      ),
      series: <ChartSeries>[
        ColumnSeries<TeamData, String>(
          dataSource: data,
          xValueMapper: (TeamData tasks, _) => tasks.title,
          yValueMapper: (TeamData tasks, _) => tasks.count,
          name: 'Tasks',
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
          ),
          color: AppColor.main,
          width: 0.35,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
      ],
    );
  }
}
