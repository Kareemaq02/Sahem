import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/API/complaint_requests.dart';
import 'package:account/Screens/Home/publicFeed.dart';
import 'package:account/API/get_complaints_types.dart';
import 'package:account/Widgets/Filter/filterType.dart';
import 'package:account/Widgets/CheckBoxes/CheckBox.dart';
import 'package:account/API/get_complaints_with_filter.dart';
import 'package:account/Widgets/ComaplaintCard/timeLineVertical.dart';
// ignore_for_file: file_names, library_private_types_in_public_api, avoid_print, use_build_context_synchronously


List<int> selectedStatus = [];

class FilterPopup2 extends StatefulWidget {
  const FilterPopup2({Key? key}) : super(key: key);

  @override
  _FilterPopup2State createState() => _FilterPopup2State();
}

class _FilterPopup2State extends State<FilterPopup2> {
  late Future<List<ComplaintType>> futureData;
  getUserComplaint status = getUserComplaint();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: const Text(
        'حالة البلاغات',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: "DroidArabicKufi",
        ),
      ),
      titlePadding: const EdgeInsets.all(8),
      contentPadding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 17),
      content: SizedBox(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: FutureBuilder(
                  future: status.fetchStatus(),
                  builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No status types available');
                    } else {
                      final categories = snapshot.data!;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Column(
                          children: categories.map((category) {
                            final int intTypeId = category["intId"];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CheckBoxNew(
                                key: widget.key,
                                text: status22[intTypeId].name,
                                isChecked: selectedStatus.contains(intTypeId),
                                onChanged: () {
                                  setState(() {
                                    if (!selectedStatus.contains(intTypeId)) {
                                      selectedStatus.add(intTypeId);
                                    } else {
                                      selectedStatus.remove(intTypeId);
                                    }
                                    print(selectedStatus);
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
            SizedBox(
              height: 40,
              width: 125,
              child: ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.zero),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(AppColor.main),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: const BorderSide(
                          color: AppColor.main,
                          width: 1.3,
                          //style: BorderStyle.solid,
                        ),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    await getFilteredComplaints(selectedStatus, selectedTypes1,
                        currentPosition!.latitude, currentPosition!.longitude);

                    setState(() {});
                    Navigator.of(context).pop();
                  },
                  child: const Text("استمرار")),
            ),
          ],
        ),
      ),
    );
  }
}
