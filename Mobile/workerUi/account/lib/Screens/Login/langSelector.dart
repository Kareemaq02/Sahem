// ignore_for_file: file_names

// import 'package:account/Repository/language.dart';
// import 'package:account/Repository/language_constants.dart';
// import 'package:account/main.dart';
// import 'package:adobe_xd/pinned.dart';
// import 'package:flutter/material.dart';

// Widget langugaeSelector(BuildContext context){

//   var languagea='en';
//   var arr='اَلْعَرَبِيَّةُ';

// return
//             Pinned.fromPins(
//           Pin(size: 500.0, middle:languagea =='ar'? 0.1500 :   0.9800),
//            Pin(size: 90.0, start: 200.7),      
    
//       child: Padding(
//        padding: const EdgeInsets.only(right:40.0),
//         child: Stack(
//         children: [
//         Align(
//           alignment: languagea=='en' ?Alignment.topLeft : Alignment.topRight,
//           child: DropdownButton<Language>(
//             underline: const SizedBox(),
//             onChanged: (Language? language) async {
//               if (language != null) {
//                 Locale _locale = await setLocale(language.languageCode);
//                 MyApp.setLocale(context, _locale);
//                 print(languagea);
//                  languagea=language.languageCode ;
//                  arr=language.name;
//               }
//             },
//             items: Language.languageList()
//                 .map<DropdownMenuItem<Language>>(
//                   (e) => DropdownMenuItem<Language>(
//                     value: e,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: <Widget>[
//                         Text(
//                           e.flag,
//                           style: const TextStyle(fontSize: 20),
//                         ),
//                         Text(e.name),
//                       ],
//                     ),
//                   ),
//                 )
//                 .toList(),
//           ),
//         ),
//         Align(
//           alignment: languagea=='en' ?Alignment.topLeft : Alignment.topRight,
//           child: Padding(
//             padding: const EdgeInsets.only(left: 8.0),
//             child: Row(
//               children: [
//                 Icon(
//                   Icons.language,
//                   color: Colors.white,
//                 ),
//                 Text(
//                   languagea=='en'? languagea :arr,
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     ),
//   ),
// );
// }