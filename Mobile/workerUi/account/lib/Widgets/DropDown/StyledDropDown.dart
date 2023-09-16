import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Utils/DropDownValue.dart';
// ignore_for_file: file_names


class TasksDropDown extends StatefulWidget {
  final double width;
  final List<DropDownValue> valuesList;
  final ValueChanged<DropDownValue> onSelect;

  const TasksDropDown(
      {super.key,
      required this.width,
      required this.valuesList,
      required this.onSelect});

  @override
  State<TasksDropDown> createState() => _TasksDropDownState();
}

class _TasksDropDownState extends State<TasksDropDown> {
  late double width = widget.width;
  late List<DropDownValue> valuesList = widget.valuesList;
  late DropDownValue selectedValue = widget.valuesList[0];
  late ValueChanged<DropDownValue> onSelect = widget.onSelect;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: width,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.main, width: 1),
          borderRadius: BorderRadius.circular(50),
        ),
        child: DropdownButton<DropDownValue>(
          style: const TextStyle(
            fontSize: 14,
            color: AppColor.main,
            fontFamily: 'DroidArabicKufi',
          ),
          iconSize: screenHeight * 0.045,
          icon: Padding(
            padding: EdgeInsets.only(right: screenWidth * 0.03),
            child: Icon(
              Icons.info_outlined,
              color: AppColor.main,
              size: screenHeight * 0.045,
            ),
          ),
          isExpanded: true,
          itemHeight: screenHeight * 0.06,
          underline: const SizedBox(),
          value: selectedValue,
          borderRadius: BorderRadius.circular(50),
          onChanged: (DropDownValue? newValue) {
            setState(() {
              selectedValue = newValue!;
              widget.onSelect(selectedValue);
            });
          },
          items: valuesList.map((DropDownValue parameter) {
            return DropdownMenuItem<DropDownValue>(
              value: parameter,
              child: Stack(
                children: [
                  selectedValue.intID == parameter.intID
                      ? Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.arrow_drop_down_rounded,
                            color: AppColor.main,
                            size: screenHeight * 0.045,
                          ),
                        )
                      : const SizedBox(),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: screenWidth * 0.03),
                        child: Text(parameter.strName),
                      )),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
