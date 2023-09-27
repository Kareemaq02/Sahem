import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Widgets/Buttons/StyledButton.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
// ignore_for_file: file_names

void showDateRangeDialog(
    String title,
    BuildContext context,
    double height,
    Function(DateRangePickerSelectionChangedArgs) onSelectionChanged,
    PickerDateRange initialRange,
    {List<DateTime>? blackedOutdates}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
          height: height,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: height * 0.15,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: height * 0.02, bottom: height * 0.04),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColor.textTitle,
                      fontFamily: 'DroidArabicKufi',
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.7,
                child: SfDateRangePicker(
                  enablePastDates: false,
                  todayHighlightColor: AppColor.main,
                  startRangeSelectionColor: AppColor.main,
                  endRangeSelectionColor: AppColor.main,
                  rangeSelectionColor: const Color.fromARGB(50, 201, 44, 107),
                  initialSelectedRange: initialRange,
                  onSelectionChanged: onSelectionChanged,
                  selectionMode: DateRangePickerSelectionMode.range,
                  selectableDayPredicate: blackedOutdates != null
                      ? (DateTime dateTime) {
                          return blackedOutdates.contains(dateTime);
                        }
                      : null,
                ),
              ),
              SizedBox(
                height: height * 0.1,
                child: StyledButton(
                  text: "موافق",
                  fontSize: 14,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
