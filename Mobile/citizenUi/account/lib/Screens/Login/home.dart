import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Screens/Login/login.dart';
import 'package:account/Screens/Registration/register.dart';
import 'package:account/Widgets/Buttons/bottonContainer.dart';
// ignore_for_file: constant_identifier_names, unused_element, library_private_types_in_public_api, no_leading_underscores_for_local_identifiers, use_build_context_synchronously, avoid_print

// import '../../Repository/language.dart';
// import '../../Repository/language_constants.dart';


class XDHome extends StatefulWidget {
 const XDHome({Key? key}) : super(key: key);
  @override
  _XDHomeState createState() => _XDHomeState();
}

class _XDHomeState extends State<XDHome> {
  
  var languagea='en';
  var arr='اَلْعَرَبِيَّةُ';

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: AppColor.background,
      body:   
        Center(
       
        child: Column(
         
         
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 40,height: 100,decoration: const BoxDecoration(color: Colors.grey,shape: BoxShape.circle),),
                const SizedBox(width: 10,),
                const Text('Logobrand',style: TextStyle(fontWeight: FontWeight.w100,fontSize: 20),),
              ],
            ),
            const SizedBox(height: 50,),
        BottonContainer( 'الدخول | مستخدم جديد',Colors.white ,AppColor.main,210,context,false,const XDRegister(),(){}),
       
           const SizedBox(height: 20,),
         BottonContainer( 'الدخول كزائر' ,AppColor.main,Colors.white,210,context,false,const XDLogin(),(){}),
         
      ]
      ), 
    ));
  }
 
}



