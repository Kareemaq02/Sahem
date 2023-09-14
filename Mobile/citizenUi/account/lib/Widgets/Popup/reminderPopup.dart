// ignore_for_file: file_names
// import 'package:flutter/material.dart';
// import 'package:account/Repository/color.dart';
// import 'package:account/API/complaint_requests.dart';
// import 'package:account/Screens/Home/publicFeed.dart';
// import 'package:account/API/get_complaints_types.dart';
// import 'package:account/API/send_reminder_Request.dart';
// import 'package:account/Widgets/Filter/filterType.dart';
// import 'package:account/Widgets/CheckBoxes/CheckBox.dart';
// import 'package:account/API/get_complaints_with_filter.dart';
// import 'package:account/Widgets/ComaplaintCard/timeLineVertical.dart';

// List<int> selectedStatus = [];

// class ReminderPopup extends StatefulWidget {
//   final int id;
//   const ReminderPopup({Key? key, required this.id}) : super(key: key);

//   @override
//   _ReminderState createState() => _ReminderState();
// }

// class _ReminderState extends State<ReminderPopup> {
//   ComapalintReminder a = ComapalintReminder();

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20.0),
//       ),
//       titlePadding: EdgeInsets.all(8),
//       contentPadding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 17),
//       content: SizedBox(
//         height: 100,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             FutureBuilder(
//               future: a.comaplintReminder(widget.id),
//               builder: (context, AsyncSnapshot<void> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return CircularProgressIndicator();
//                 } else if (snapshot.hasError) {
//                   return Text('Error: ${snapshot.error}');
//                 } else if (!snapshot.hasData) {
//                   return Text('No status types available');
//                 } else {
//                   final categories = snapshot.data;
//                   return Padding(
//                     padding: const EdgeInsets.only(bottom: 10.0),
//                     child: Text(""),
//                   );
//                 }
//               },
//             ),
//             const SizedBox(height: 10),
//           ],
//         ),
//       ),
//     );
//   }
// }
