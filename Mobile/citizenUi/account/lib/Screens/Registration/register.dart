
// ignore_for_file: constant_identifier_names, unused_element, non_constant_identifier_names, camel_case_types, library_private_types_in_public_api

import 'package:account/Repository/color.dart';
import 'package:account/Screens/Login/login.dart';
import 'package:account/Screens/Registration/register1.dart';
import 'package:account/Screens/Registration/register2.dart';
import 'package:account/Validation/validations.dart';
import 'package:account/Widgets/bottonContainer.dart';
import 'package:account/Widgets/checkBox.dart';
import 'package:account/Widgets/fieldContainer.dart';
import 'package:account/Widgets/text.dart';
import 'package:flutter/material.dart';





 enum nationalitySelection{Jordanian,forign}
 var selectedNationality=nationalitySelection.forign;
 Validation _validation=Validation();

  TextEditingController FnameController = TextEditingController();
  TextEditingController LnameController = TextEditingController();
  TextEditingController PhoneController = TextEditingController();
  TextEditingController EmailController= TextEditingController();
  

  // GlobalKey<FormState> _key1 = GlobalKey();
  // GlobalKey<FormState> _key2 = GlobalKey();
  // GlobalKey<FormState> _key3 = GlobalKey();
  // bool _validate = false;
  // bool jordanian = false;
  // bool forign = false;


class XDRegister extends StatefulWidget {
  const XDRegister({
    Key? key,}) : super(key: key);
      @override
  _XDRegisterState createState() => _XDRegisterState();
}

class _XDRegisterState extends State<XDRegister> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffffffff),
      body: 
      SafeArea(
        child: Center(
         
          child: Column(
           
           
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 55,height: 100,decoration: const BoxDecoration(color: Colors.grey,shape: BoxShape.circle),),
                  const SizedBox(width: 10,),
                  const Text('Logobrand',style: TextStyle(fontWeight: FontWeight.w100,fontSize: 20),),
                ],
              ),
              const SizedBox(height: 30,),
          FieldContainer(context,'اسم الأول' ,false,Icons.account_circle,FnameController
          ),
             const SizedBox(height: 10,),
           FieldContainer( context,' الاسم الأخير' ,false,Icons.account_circle,LnameController
          ),
              const SizedBox(height: 10,),
          FieldContainer(context,' البريد الالكتروني' ,false,Icons.email,EmailController
          ),
             const SizedBox(height: 10,),
           FieldContainer( context,' رقم الهاتف' ,false,Icons.phone,PhoneController
          ),
             const SizedBox(height: 15,),
          Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
           SizedBox(width: MediaQuery.of(context).padding.left + 50,),
          checkboxWidget("لا",context),
          SizedBox(width: MediaQuery.of(context).padding.left + 7,),
          checkboxWidget('نعم',context),
          SizedBox(width: MediaQuery.of(context).padding.left + 80,),
          
           const Text("هل أنت أردني؟",style:TextStyle(color: AppColor.main, fontFamily:'DroidArabicKufi', fontSize: 11),)
          
        ],
      ),
         
          
         
          
          // SizedBox(width: 2.5,),
          
        //        Checkbox(
        //         focusColor: AppColor.main,
        //         side: BorderSide(width: 1,color: AppColor.main,),   
        //         onChanged: (value) {
        //         setState(() {
        //         isChecked = value!;
        //         });
        //   },
        //   value: isChecked, 
        // ),
       
          const SizedBox(height: 10,),
         
         BottonContainer("استمرار",Colors.white, AppColor.main,240,context,false,
      
          (FnameController != null && LnameController != null && PhoneController != null && EmailController !=null)
        ? (selectedNationality == nationalitySelection.Jordanian
            ? 
                XDRegister1()
                
              
            : 
               XDRegister1()
              
         
        ):XDRegister1(),null
        ),
         
         const SizedBox(height: 0,),
         Row(
          mainAxisAlignment: MainAxisAlignment.center,
           children: [
             text(" تسجيل الدخول " ,AppColor.main),
             TextButton(child: text(" لديك حساب؟",AppColor.secondary),onPressed:() =>  Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const XDLogin ()),
            ),),
           ],
         ),
        ]
        ), 
          ),
      )





  















    );
  }
}

//     Stack(
//         children: <Widget>[
          
//                 //radio button
//                 Pinned.fromPins(
//                   Pin(size: 30.0, start: -5.0),
//                   Pin(size: 40.0, end: 1.0),
                 
//                     child:RadioListTile<nationalitySelection>(
//                           value: nationalitySelection.Jordanian,
//                           groupValue: selectedNationality,
//                           onChanged: (value) {
//                           setState(() {
//                           selectedNationality = nationalitySelection.Jordanian;
//                         });
//                      },
//                     ),
//                   ),
                
//                 //radio button
//                 Pinned.fromPins(
//                   Pin(size: 20.0, middle: 0.70),
//                   Pin(size: 40.0, end: 1.0),
                 
//                     child: RadioListTile<nationalitySelection>(
//                           value: nationalitySelection.forign,
//                           groupValue: selectedNationality,
//                           onChanged: (value) {
//                           setState(() {
//                           selectedNationality = nationalitySelection.forign;
//                         });
//                      },
//                     ),
                
//                 ),
               
         


//           Pinned.fromPins(
//             Pin(start: 14.0, end: 32.0),
//             Pin(size: 90.0, middle: 0.3600),
//             child:
//              Form(
//               key: _key1,
            
//               autovalidateMode: AutovalidateMode.onUserInteraction,
//               child: 
//  // Adobe XD layer: 'First Name' (group)
//                 Stack(
//               children: <Widget>[
//                 Padding(
//                 padding: const EdgeInsets.fromLTRB(0.0, 24.0, 0.0, 0.0),child:
//                 TextFormField(
//                 keyboardType: TextInputType.name,
//                 validator: _validation.validateName,
//                  onSaved:(newValue) => fName = newValue!,
//                   controller: FnameController,
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
//                   Pin(size: 86.0, start: 3.0),
//                   Pin(size: 21.0, start: 0.0),
//                   child:  Text(
//                     translation(context).firstName,
//                     style: TextStyle(
//                       fontFamily: 'Poppins',
//                       fontSize: 15,
//                       color: Color(0xff6f407d),
//                     ),
//                   ),
//                 ),
//                 ]),
//             ),
//           ),
//           Pinned.fromPins(
//             Pin(start: 14.0, end: 32.0),
//             Pin(size: 90.0, middle: 0.5250),
//             child:
//              Form(
//              key: _key3,
            
//               autovalidateMode: AutovalidateMode.onUserInteraction,
//               child: 
//                 // Adobe XD layer: 'Last Name' (group)
//                 Stack(
//               children: <Widget>[
//                 Padding(
//                 padding: const EdgeInsets.fromLTRB(0.0, 24.0, 0.0, 0.0),child:
//                 TextFormField(
//                   keyboardType: TextInputType.name,
//                   controller: LnameController,
//                   validator:_validation.validateName,
//                  onSaved:(newValue) =>  lName= newValue!,
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
//                   Pin(size: 80.0, start: 3.0),
//                   Pin(size: 21.0, start: 0.0),
//                   child:  Text(
//                     translation(context).lastName,
//                     style: TextStyle(
//                       fontFamily: 'Poppins',
//                       fontSize: 15,
//                       color: Color(0xff6f407d),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),),
//           Pinned.fromPins(
//             Pin(start: 14.0, end: 32.0),
//             Pin(size: 90.0, middle: 0.6850),
//             child:
//              Form(
//               key: _key2,
//               autovalidateMode: AutovalidateMode.onUserInteraction,
//               child:
//                 // Adobe XD layer: 'Phone Number' (group)
//                 Stack(
//               children: <Widget>[
//                 Padding(
//                 padding: const EdgeInsets.fromLTRB(0.0, 24.0, 0.0, 0.0),child:
//                  TextFormField(
//                   keyboardType: TextInputType.phone,
//                   controller:PhoneController,
//                   validator: _validation.validateMobile,
//                   maxLength: 10,
//                  onSaved:(newValue) => Phone =newValue!,
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
             



//           //send data to neext page 
//           Pinned.fromPins(
//             Pin(start: 63.0, end: 62.0),
//             Pin(size: 50.0, end: 20.2),
//             child:
//                 // Adobe XD layer: 'Login Button' (group)
//                 InkWell(
//               onTap:(){
              
            
//               _sendToServer(_key1);
//               _sendToServer(_key2);
//               _sendToServer(_key3);

//               if(fName!=null && lName!=null && Phone !=null ){
//                 if(selectedNationality==nationalitySelection.Jordanian){
//                Navigator.push(context,MaterialPageRoute(builder: (context) => XDRegister1()),);
//               }
//                else{
//                  Navigator.push(context,MaterialPageRoute(builder: (context) => XDRegister2()),);
//               }
//               }
             
              
//               } ,
              
              
            





//           //have account
//           Pinned.fromPins(
//             Pin(size: 202.0, end: 0.0),
//             Pin(size: 21.0, middle: 0.8700),
//             child: PageLink(
//               links: [
//                 PageLinkInfo(
//                   duration: 0,
//                   pageBuilder: () =>  XDLogin(),
//                 ),
//               ],
//               child:  Text(
//                 translation(context).haveAccount,
//                 style: TextStyle(
//                   fontFamily: 'Poppins',
//                   fontSize: 15,
//                   color: Color(0xff6f407d),
//                 ),
//               ),
//             ),
//           ),
         
          
               
                
//               ],
//             ),
//           ),
          
          
//         ],
//       ),
//     );
//   }

//    _sendToServer(var pKey) {
//     if (pKey.currentState!.validate()) {
//       // No any error in validation
//       pKey.currentState!.save();
//     } else {
//       // validation error
//       setState(() {
//         _validate = true;
//       });
//     }
//   }
// }

