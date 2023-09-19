import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
// ignore_for_file: file_names


class RateData {
  RateData(this.region, this.rate);
  final String region;
  final double rate;
}

class RatingChart extends StatelessWidget {
  const RatingChart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;

    final data = <RateData>[
      RateData("راس العين", 3.6),
      RateData("جبل النزهة", 2.2),
      RateData("شفا بدران", 3.4),
      RateData("المقابلين", 4.7),
      RateData("الياسمين", 2.7),
      RateData("ماركا", 1.4),
      RateData("جبل الحسين", 2.5),
      RateData("ابو نصير", 3.4),
    ];

    return SizedBox(
      width: data.length * 0.20 * screenWidth,
      child: SfCartesianChart(
        zoomPanBehavior: ZoomPanBehavior(
          enablePinching: true,
          enablePanning: true,
          zoomMode: ZoomMode.xy,
        ),
        primaryXAxis: CategoryAxis(
          isInversed: true,
          visibleMinimum: 3.5,
          labelStyle: const TextStyle(
            fontSize: 10,
            color: AppColor.secondary,
            fontFamily: 'DroidArabicKufi',
          ),
          title: AxisTitle(
            text: '',
            textStyle: const TextStyle(
              fontSize: 12,
              color: AppColor.textTitle,
              fontFamily: 'DroidArabicKufi',
            ),
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
            text: 'التقييم',
            textStyle: const TextStyle(
              fontSize: 12,
              color: AppColor.textTitle,
              fontFamily: 'DroidArabicKufi',
            ),
          ),
          maximum: 5,
          minimum: 0,
        ),
        series: <ChartSeries>[
          ColumnSeries<RateData, String>(
            dataSource: data,
            xValueMapper: (RateData rates, _) => rates.region,
            yValueMapper: (RateData rates, _) => rates.rate,
            name: 'Rates',
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
            ),
            color: AppColor.main,
            width: 0.35,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}
