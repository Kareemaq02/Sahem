import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Utils/DateFormatter.dart';
import 'package:account/Widgets/Popup/DateRangePopup.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
// ignore_for_file: file_names


class DateRangeField extends StatelessWidget {
  final double height;
  final double width;
  final Function(DateRangePickerSelectionChangedArgs) onSelectionChanged;
  final PickerDateRange initialRange;

  const DateRangeField({
    super.key,
    required this.height,
    required this.width,
    required this.onSelectionChanged,
    required this.initialRange,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Ink(
      height: height,
      width: width,
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.main, width: 1),
        borderRadius: BorderRadius.circular(50),
      ),
      child: InkWell(
        onTap: () => showDateRangeDialog(
          "أختر المواعيد",
          context,
          screenHeight * 0.5,
          onSelectionChanged,
          initialRange,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Icon(
                Icons.arrow_drop_down_rounded,
                color: AppColor.main,
                size: screenHeight * 0.045,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: screenWidth * 0.03),
                    child: Text(
                      "${formatDate(initialRange.startDate!)} - ${formatDate(initialRange.endDate!)}",
                      style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.bold,
                        color: AppColor.main,
                        fontFamily: 'DroidArabicKufi',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: screenWidth * 0.03),
                    child: Icon(
                      Icons.calendar_today_outlined,
                      color: AppColor.main,
                      size: width * 0.075 + height * 0.075,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
