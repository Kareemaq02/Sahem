// ignore_for_file: constant_identifier_names, unused_element, unused_import, depend_on_referenced_packages, avoid_print, library_private_types_in_public_api

import 'dart:convert';

import 'package:account/Repository/color.dart';
import 'package:account/Screens/Login/login.dart';
import 'package:account/Screens/Registration/register1.dart';
import 'package:account/Screens/Registration/register4.dart';
import 'package:account/Widgets/bottonContainer.dart';
import 'package:account/Widgets/fieldContainer.dart';
import 'package:account/Widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:flutter/services.dart';
import 'package:adobe_xd/page_link.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../Repository/language_constants.dart';

late String dropdownValue;
late List<String> dropdownItems;
Map<String, String> _nationalities = {};


Future<void> loadNationalities() async {
  final jsonString = await rootBundle.loadString('assets/data.json');
  final Map<String, dynamic> jsonMap = json.decode(jsonString);
  print(jsonMap.length);
  jsonMap.forEach((key, value) {
    _nationalities[key] = value.toString();

  });
}


class XDRegister2 extends StatefulWidget {
  const XDRegister2({
    Key? key,
  }) : super(key: key);
       @override
  _XDRegister2State createState() => _XDRegister2State();
}

class _XDRegister2State extends State<XDRegister2> {

  TextEditingController passportNumController=TextEditingController();
  TextEditingController usernameController3=TextEditingController();
  TextEditingController passwordController3=TextEditingController();
  TextEditingController nationalityController=TextEditingController();
  


@override
  void initState() {
  super.initState();
 loadNationalities();
  dropdownValue=_nationalities.keys.first;
  print(dropdownValue);
}



Widget dropDownWidget(context,String fieldName,bool isVisible,fieldIcon,inputController)
{
  final double screenWidth = MediaQuery.of(context).size.width;
  final double containerWidth = screenWidth * 0.75; 
  final double containerHeight = 45;

  return   Container(
              height:containerHeight ,
              width: containerWidth,
              decoration:
               BoxDecoration(
                borderRadius:const BorderRadius.all(Radius.circular(50)),
              border:Border.all(
              color:AppColor.main,
              width: 1,
              style: BorderStyle.solid
              ),
       ),    
              child: 
          TypeAheadFormField<String>(
        initialValue: null,
       
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textFieldConfiguration: TextFieldConfiguration(
          controller: nationalityController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                width: 1,
                color: Colors.grey.shade300,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                width: 1,
                color: Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(
                width: 1,
                color: Color(0xff6f407d),
              ),
            ),
          ),
          style: const TextStyle(color: Color(0xff6f407d)),
        ),
        suggestionsCallback: (pattern) {
        
          return _nationalities.values.where((nationality) =>
            nationality.toLowerCase().contains(pattern.toLowerCase())
            
          );
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(suggestion),
          );
        },
        onSuggestionSelected: (suggestion) {
          setState(() {
            dropdownValue = suggestion;
            nationalityController.text=suggestion;

      
          });
        },
        
         getImmediateSuggestions: true, 
         // added this line
      ));
      
  
      
  
  
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffffffff),
      body:  Center(
       
        child: Column(
         
         
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 55,height: 100,decoration: BoxDecoration(color: Colors.grey,shape: BoxShape.circle),),
                SizedBox(width: 10,),
                const Text('Logobrand',style: TextStyle(fontWeight: FontWeight.w100,fontSize: 20),),
              ],
            ),
            const SizedBox(height: 30,),
        FieldContainer(context,'رقم جواز السفر' ,false,Icons.account_circle,passportNumController
        ),
           const SizedBox(height: 10,),
        FieldContainer( context,'جنسية' ,false,Icons.account_circle,nationalityController
        ),
            const SizedBox(height: 10,),
        FieldContainer(context,' اسم المستخدم ' ,false,Icons.email,usernameController3
        ),
           const SizedBox(height: 10,),
         FieldContainer(context, ' كلمةالمرور' ,false,Icons.phone,passwordController3
    
        ),
           const SizedBox(height: 15,),
       
        SizedBox(height: 10,),
       
       BottonContainer("استمرار",Colors.white, AppColor.main,240,context, false,XDLogin()),
       SizedBox(height: 15,),
       Row(
        mainAxisAlignment: MainAxisAlignment.center,
         children: [
           text(" تسجيل الدخول " ,AppColor.main),
           text(" لديك حساب؟",AppColor.secondary),
         ],
       ),
      ]
      ), 
    ));
  }
}




        
         
      // const SizedBox(height: 10,),
      // TypeAheadFormField<String>(
      //   initialValue: null,
       
      //   autovalidateMode: AutovalidateMode.onUserInteraction,
      //   textFieldConfiguration: TextFieldConfiguration(
      //     controller: nationalityController,
      //     decoration: InputDecoration(
      //       filled: true,
      //       fillColor: Colors.white,
      //       contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      //       border: OutlineInputBorder(
      //         borderRadius: BorderRadius.circular(5),
      //         borderSide: BorderSide(
      //           width: 1,
      //           color: Colors.grey.shade300,
      //         ),
      //       ),
      //       enabledBorder: OutlineInputBorder(
      //         borderRadius: BorderRadius.circular(5),
      //         borderSide: BorderSide(
      //           width: 1,
      //           color: Colors.grey.shade300,
      //         ),
      //       ),
      //       focusedBorder: OutlineInputBorder(
      //         borderRadius: BorderRadius.circular(5),
      //         borderSide: const BorderSide(
      //           width: 1,
      //           color: Color(0xff6f407d),
      //         ),
      //       ),
      //     ),
      //     style: const TextStyle(color: Color(0xff6f407d)),
      //   ),
      //   suggestionsCallback: (pattern) {
        
      //     return _nationalities.values.where((nationality) =>
      //       nationality.toLowerCase().contains(pattern.toLowerCase())
            
      //     );
      //   },
      //   itemBuilder: (context, suggestion) {
      //     return ListTile(
      //       title: Text(suggestion),
      //     );
      //   },
      //   onSuggestionSelected: (suggestion) {
      //     setState(() {
      //       dropdownValue = suggestion;
      //       nationalityController.text=suggestion;

      
      //     });
      //   },
        
      //    getImmediateSuggestions: true, 
      //    // added this line
      // ),
      
  
      
//     ],
//   ),
// )
//                 )])),
    
          
//           Pinned.fromPins(
//             Pin(start: 23.0, end: 23.0),
//             Pin(size: 90.0, middle: 0.6300),
//             child:
//                 Adobe XD layer: 'Last Name' (group)
//                 Stack(
//               children: <Widget>[
//                Padding(
//                 padding: const EdgeInsets.fromLTRB(0.0, 24.0, 0.0, 0.0),child:
//                 TextField(
//                 decoration: InputDecoration(
//                 filled: true,
//                fillColor: Colors.white,
//                contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//                border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(5),
//              borderSide: BorderSide(
//              width: 1,
//              color: Colors.grey.shade300,
//              ),
//             ),
//            enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(5),
//           borderSide: BorderSide(
//         width: 1,
//         color: Colors.grey.shade300,
//          ),
//         ),
//        focusedBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(5),
//       borderSide: const BorderSide(
//         width: 1,
//         color: Color(0xff6f407d),
//       ),
//     ),
//   )
// ),
//                 ),
//                 Pinned.fromPins(
//                   Pin(size: 132.0, start: 3.0),
//                   Pin(size: 21.0, start: 0.0),
//                   child: const Text(
//                     'Passport Number',
//                     style: TextStyle(
//                       fontFamily: 'Poppins',
//                       fontSize: 15,
//                       color: Color(0xff6f407d),
//                     ),
//                   ),
//                 ),
              
//               ],
//             ),
//           ),
//           Pinned.fromPins(
//             Pin(start: -61.4, end: -99.1),
//             Pin(size: 368.2, start: -160.2),
//             child:
//                 Adobe XD layer: 'Action Bar' (group)
//                 Stack(
//               children: <Widget>[
//                 Pinned.fromPins(
//                   Pin(size: 477.0, end: 0.0),
//                   Pin(start: 27.4, end: 0.0),
//                   child: SvgPicture.string(
//                     _svg_tllar,
//                     allowDrawingOutsideViewBox: true,
//                     fit: BoxFit.fill,
//                   ),
//                 ),
//                 Pinned.fromPins(
//                   Pin(size: 477.0, start: 0.0),
//                   Pin(start: 27.4, end: 0.0),
//                   child: SvgPicture.string(
//                     _svg_mz,
//                     allowDrawingOutsideViewBox: true,
//                     fit: BoxFit.fill,
//                   ),
//                 ),
//                 Pinned.fromPins(
//                   Pin(size: 432.0, start: 60.8),
//                   Pin(start: 0.0, end: 35.1),
//                   child: SvgPicture.string(
//                     _svg_gg6p5,
//                     allowDrawingOutsideViewBox: true,
//                     fit: BoxFit.fill,
//                   ),
//                 ),
//               ],
//             ),
//           ),
          
//           Pinned.fromPins(
//             Pin(size: 167.0, middle: 0.5019),
//             Pin(size: 56.0, start: 96.0),
//             child: const Text(
//               'Register',
//               style: TextStyle(
//                 fontFamily: 'Poppins',
//                 fontSize: 40,
//                 color: Color(0xffffffff),
//               ),
//             ),
//           ),
//           Pinned.fromPins(
//             Pin(size: 21.9, start: 29.9),
//             Pin(size: 36.6, start: 55.8),
//             child:
//                 Adobe XD layer: 'BackIcon' (shape)
//                 InkWell(
             
                 
                 
      
//               child: SvgPicture.string(
//                 _svg_h30c0y,
//                 allowDrawingOutsideViewBox: true,
//                 fit: BoxFit.fill,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
