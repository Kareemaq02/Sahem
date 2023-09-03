
// // ignore_for_file: library_private_types_in_public_api, avoid_print, use_build_context_synchronously, duplicate_ignore

// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import '../API/login_request.dart';
// import '../API/sign_in_up_request.dart';


// import 'file_complaint_submission.dart';


// // determine public or private complaint and for complaint type 
// // edit image picker to from camera 
// // user name in login remove debug , ,,  remove complaint type int debug

// enum complaint_level{private,public,none}



// class HomePage1 extends StatefulWidget {
//   const HomePage1( {Key? key}) : super(key: key);

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage1> {
//   //File? image1;
//   complaint_level selectLevel=complaint_level.none;
//   List<File> selectedImages = [];
//   final _picker = ImagePicker();
//   TextEditingController textArea = TextEditingController();
//   //int? dropdownvalue;
//   late int intType;
//   late DropDownValue dropdown=DropDownValue(1, "");
//   List<DropDownValue> items = [];
//   late Future<List<Map<String, dynamic>>>_futureData;
//   String language="strNameAr";
 

//   @override
//   void initState() {
//     super.initState();
//     _futureData=getAllCategory();
// _initializeData();

    
//   }
  
//   void _initializeData() async {
//   final data = await getAllCategory();
//   setState(() {
//     items = data.map((item) => DropDownValue(item["intId"], item[language])).toList();
//     dropdown = items[0];
//   });
// }

//   // Implementing the image picker
//   // Future getImages() async {

//   //   final pickedFile = await _picker.pickMultiImage(
//   //       imageQuality: 50, 
//   //     ); 

//   //   List<XFile> xfilePick = pickedFile;
//   //       if (xfilePick.isNotEmpty) {
//   //         for (var i = 0; i < xfilePick.length; i++) {
            
//   //           selectedImages.add(File(xfilePick[i].path));
//   //         }
//   //          setState(
//   //     () {  },
//   //   );
//   //   _getCurrentPosition();
//   //   print(selectedImages.length);
//   //       } else {
//   //         ScaffoldMessenger.of(context).showSnackBar(
//   //             const SnackBar(content: Text('Nothing is selected')));
//   //       }
//   // }

// Future<void> getImages() async {
//   final pickedFile = await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);

//   if (pickedFile != null) {
//     selectedImages.add(File(pickedFile.path));
//     setState(() {});
//     _getCurrentPosition();
//     print(selectedImages.length);
//   } else {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Nothing is selected')),
//     );
//   }
// }

// //fetch classification
//  Future<List<Map<String, dynamic>>> getAllCategory() async {
   
   
//   var baseUrl = "https://10.0.2.2:5000/api/complaints/types";
//   http.Response response = await http.get(Uri.parse(baseUrl),
//    headers: {
//           'Authorization': 'Bearer $token2',
//         }
//   );


//   if (response.statusCode == 200) {
//     var jsonData = json.decode(response.body) as List;
//     return jsonData.map((element) => {
//       "intId": element["intId"],
//       "strNameAr": element["strNameAr"],
//       "strNameEn": element["strNameEn"]
//     }).toList();
//   } else {
//     throw response.statusCode;
//   }
// }



// //Location implemntation
//   String? currentAddress;
//   Position? _currentPosition;

//   Future<bool> _handleLocationPermission() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text(
//               'Location services are disabled. Please enable the services')));
//       return false;
//     }
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         // ignore: use_build_context_synchronously
//         ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Location permissions are denied')));
//         return false;
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       // ignore: use_build_context_synchronously
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text(
//               'Location permissions are permanently denied, we cannot request permissions.')));
//       return false;
//     }
//     return true;
//   }

//   Future<void> _getCurrentPosition() async {

   
//     final hasPermission = await _handleLocationPermission();

//     if (!hasPermission) return;
//     await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
//         .then((Position position) {
//       setState(() => _currentPosition = position);
//       _getAddressFromLatLng(_currentPosition!);
//     }).catchError((e) {
//       debugPrint(e);
//     });
    
//   }

//   Future<void> _getAddressFromLatLng(Position position) async {
//     await placemarkFromCoordinates(
//             _currentPosition!.latitude, _currentPosition!.longitude)
//         .then((List<Placemark> placemarks) {
//       Placemark place = placemarks[0];
//       setState(() {
//         currentAddress =
//             '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
//       });
//     }).catchError((e) {
//       debugPrint(e);
//     });
//   }


//   @override
//   Widget build(BuildContext context) {
  
//         return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 207, 207, 207),
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 216, 90, 81),
//         shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(5)),
//         title: const Text(
//           'Complaint details',
//           textAlign: TextAlign.center,
//           style: TextStyle(fontWeight: FontWeight.normal),
//           textDirection: TextDirection.rtl,
//         ),
//       ),



      
//        body:  SingleChildScrollView(
//         child:SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(children: [
            
//             GestureDetector(child:Row(children: [ const Icon(Icons.translate),const Text("Eng"),]),
//             onTap: () {
//                 setState(() {
//                 language = "strNameEn";
//                 _initializeData();
//               });
//             },),// icon

//             GestureDetector(child:Row(children: [ const Icon(Icons.translate),const Text("Ar"),]),
//             onTap: () 
//              {
//                 setState(() {
//                 language = "strNameAr";
//                 _initializeData();
//               });
//             },),//  // icon
        
//              const SizedBox(height:20),
//             Row(children: const [
//             Icon(Icons.flag_circle,color: Colors.red,),
//             Text("Complaint type",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)
//             ],),
//             const SizedBox(height:5),
//             const Text("   Choose type of complaint that you want to report",style: TextStyle(fontSize: 12,color: Color.fromARGB(255, 167, 167, 167)),),
//            Row(
//           children: [
//             Expanded(child: 
      
//       RadioListTile<complaint_level>(
//         title: const Text('Public'),
//         value: complaint_level.public,
//         groupValue: selectLevel,
//         onChanged: (value) {
//           setState(() {
//             selectLevel = complaint_level.public;
//           });
//         },
//       ),),
//      Expanded(child: 
//       RadioListTile<complaint_level>(
//         title: const Text('Private'),
//         value: complaint_level.private,
//         groupValue: selectLevel,
//         onChanged: (value) {
//           setState(() {
//             selectLevel = complaint_level.private;
//           });
//         },
//       ),
//            )],
//   ),


          
//           FutureBuilder<List<Map<String, dynamic>>>(
//           //move getAllCategory on page load
//            future: _futureData,
//           builder: (context, snapshot) {
//           if (snapshot.hasData) {
//          var data = snapshot.data!;
//          var items =  data.map((item) {
//           return DropdownMenuItem(
//             value:  DropDownValue(item["intId"], item[language]) ,
//             child: Text(item[language]),
//           );
//         }).toList();

      
//       // dropdown=items[0].value!;
//        dropdown=items[dropdown.intID-1].value!;

//          return DropdownButton(
       
//         value:dropdown ,
//         icon: const Icon(Icons.keyboard_arrow_down),
//         items:items,
//         onChanged: (newValue) {
//           setState(() {
//             dropdown= newValue!;
//             print(dropdown.intID );
//             print(dropdown.stringName );
           
//           });
//         },

//       );
//     } else {
//       return const CircularProgressIndicator();
//     }
//   },
// ),
            
          
//              const SizedBox(height:30,),
//              Row(children: const [
//             Icon(Icons.info_outline,color: Colors.red,),
//             Text("Complaint Information",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)
//             ],),
//             const Text("Enable your location and import an image",style: TextStyle(fontWeight:FontWeight.w300,fontSize: 12),),
//             const SizedBox(height:20),


//             const Icon(
//               Icons.camera_alt_outlined,
//               size: 5,
//               color: Color.fromARGB(255, 146, 145, 145),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             const Text(
//               'Please make sure the photo \n  clearly shows the issue.',
//               style: TextStyle(color: Colors.grey,fontSize: 15),
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             Center(
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: const Color.fromARGB(255, 202, 112, 105),
//                   backgroundColor: Colors.white,
//                 ),
//                 onPressed: () {

              
//                 if(selectedImages.length<=2){
//                 getImages();
//                 }
//                 else{
//                    ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('you can only 3 images capture')));

//                 }
                 
//                 },
//                 child:
//                   const Text('     +   Import image'),
               
//               ),
//             ),
          
//              const SizedBox(
//               height: 10,
//             ),

//              TextField(
//               controller: textArea,
//                decoration: const InputDecoration( 
//                          hintText: "add addtional information",
//                          focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(width: 1, color: Colors.redAccent)
//                          )
//                       ),
//             keyboardType: TextInputType.multiline,
//             maxLines: 1 
//             ),
           
//                ElevatedButton(
//                style: ElevatedButton.styleFrom(
//                   foregroundColor: const Color.fromARGB(255, 202, 112, 105),
//                   backgroundColor: Colors.white,
                  
//                 ),
              
//                 onPressed:() {
              

//                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SubmissionPage(currentAddress: currentAddress,currentPosition:_currentPosition!
//                ,dropdownvalue: dropdown,comment:textArea.text,selectedImages:selectedImages)));
                  
//                 },
                  
                  
                 
               
//                 child: Row(children: const [ Text("Next",style: TextStyle(fontWeight: FontWeight.bold),textAlign:TextAlign.center ,),
//                 Icon(Icons.arrow_forward),],)
                
                
//               ),
            
//           ]),
//         ),
//       ),
     
//     ));
//   }
  
// }
 
// class MyHttpOverrides extends HttpOverrides{
//   @override
//   HttpClient createHttpClient(SecurityContext? context){
//     return super.createHttpClient(context)
//       ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
//   }
// }

// class DropDownValue{
// DropDownValue( this.intID, this.stringName);

// late int intID=0;
// late String stringName;
// }



