import 'package:account/Repository/color.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
      RateData('ماركا', 0.8),
      RateData('الياسمين', 2.2),
      RateData('المقابلين', 3.4),
      RateData('شفا بدران', 4.7),
      RateData('جبل النزهة', 2.7),
      RateData('راس 21', 4.4),
      RateData('راس 41', 4.4),
      RateData('راس 55', 4.4),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: data.length * 0.20 * screenWidth,
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(
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
              name: 'Sales',
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
      ),
    );
  }
}