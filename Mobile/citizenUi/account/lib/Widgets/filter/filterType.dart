import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/API/get_complaints_types.dart';
import 'package:account/Widgets/CheckBoxes/CheckBox.dart';
import 'package:account/Widgets/Filter/filterStatus.dart';
import 'package:account/Widgets/HelperWidegts/popupBotton.dart';

List<int> selectedTypes1 = [];

class FilterPopup extends StatefulWidget {
  const FilterPopup({Key? key}) : super(key: key);

  @override
  _FilterPopupState createState() => _FilterPopupState();
}

class _FilterPopupState extends State<FilterPopup> {
  late Future<List<ComplaintType>> futureData;
  ComplaintTypeRequest type = ComplaintTypeRequest();

  @override
  void initState() {
    super.initState();
    //selectedTypes.clear();
    // futureData = type.getAllCategory();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: const Text(
        'انواع البلاغات',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: "DroidArabicKufi",
        ),
      ),
      titlePadding: EdgeInsets.all(8),
      contentPadding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 17),
      content: SizedBox(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: FutureBuilder(
                  future: type.getAllCategory(),
                  builder:
                      (context, AsyncSnapshot<List<ComplaintType>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text('No complaint types available');
                    } else {
                      final categories = snapshot.data!;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Column(
                          children: categories.map((category) {
                            final int intTypeId = category.intTypeId;
                            final String strNameAr = category.strNameAr;
                            bool isChecked = selectedTypes1.contains(intTypeId);

                            return Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 8.0, top: 8.0),
                              child: CheckBoxNew(
                                key: widget.key,
                                text: strNameAr,
                                isChecked: selectedTypes1.contains(intTypeId),
                                onChanged: () {
                                  setState(() {
                                    if (!selectedTypes1.contains(intTypeId)) {
                                      selectedTypes1.add(intTypeId);
                                    } else {
                                      selectedTypes1.remove(intTypeId);
                                    }
                                    print(selectedTypes1);
                                  });
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            BottonContainerPopup(
              "استمرار",
              Colors.white,
              AppColor.main,
              context,
              true,
              "",
              () {
                selectedStatus.clear();
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (BuildContext context) => const FilterPopup2(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
