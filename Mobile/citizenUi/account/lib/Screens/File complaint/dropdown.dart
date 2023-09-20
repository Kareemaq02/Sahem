import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/API/get_complaints_types.dart';

DropDownValue dropdown = DropDownValue(1, " ");

class MyDropDown extends StatefulWidget {
  const MyDropDown({super.key});

  @override
  State<MyDropDown> createState() => _MyDropDownState();
}

class _MyDropDownState extends State<MyDropDown> {
  //drop down List

  late int intType;
  List<DropDownValue> items = [];
  late Future<List<ComplaintType>> _futureData;
  ComplaintTypeRequest type = ComplaintTypeRequest();

  @override
  void initState() {
    super.initState();

    _futureData = type.getAllCategory();
    _initializeData();
  }

  void _initializeData() async {
    final data = await type.getAllCategory();
    setState(() {
      items = data
          .map((item) => DropDownValue(item.intTypeId, item.strNameAr))
          .toList();
      dropdown = items[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: screenSize.height * 0.05,
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(color: AppColor.main, width: 1.0),
            borderRadius: BorderRadius.circular(10)),
        child: FutureBuilder<List<ComplaintType>>(
          //move getAllCategory on page load
          future: _futureData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data!;
              var items = data.map((item) {
                return DropdownMenuItem(
                  value: DropDownValue(item.intTypeId, item.strNameAr),
                  child: Padding(
                    padding: EdgeInsets.only(left: screenSize.width * 0.32),
                    child: SizedBox(
                      height: screenSize.height * 0.5,
                      child: Row(
                        children: [
                          Text(item.strNameAr),
                          const Icon(
                            Icons.report_gmailerrorred,
                            color: AppColor.main,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList();

              // dropdown=items[0].value!;
              dropdown = items[dropdown.intID - 1].value!;

              return DropdownButton(
                underline: Container(),
                alignment: Alignment.topRight,
                borderRadius: BorderRadius.circular(10),
                value: dropdown,
                icon:
                    const Icon(Icons.keyboard_arrow_down, color: AppColor.main),
                items: items,
                onChanged: (newValue) {
                  setState(() {
                    dropdown = newValue as DropDownValue;
                  });
                },
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

class DropDownValue {
  DropDownValue(this.intID, this.stringName);

  late int intID = 0;
  late String stringName;
}
