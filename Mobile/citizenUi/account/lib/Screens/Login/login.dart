import 'package:account/Widgets/checkBox.dart';
import 'package:account/Widgets/fieldContainer.dart';
import 'package:account/Widgets/text.dart';
import 'package:arabic_font/arabic_font.dart' as a;
import 'package:account/API/login_request.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Screens/Registration/register.dart';
import 'package:account/Widgets/bottonContainer.dart';
import 'package:flutter/material.dart';


 
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
   UserLogin user=UserLogin();
           


 
class XDLogin extends StatefulWidget {
 const XDLogin({Key? key}) : super(key: key);
  @override
  _XDLoginState createState() => _XDLoginState();
}

class _XDLoginState extends State<XDLogin> {


  //  login(){
    
  //  UserLogin user=UserLogin();
  //  user.login(usernameController.text,passwordController.text,context);
  // }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
       
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
        FieldContainer('اسم المستخدم' ,false,Icons.account_circle,usernameController
        ),
           const SizedBox(height: 20,),
         FieldContainer( ' كلمة السر' ,true,Icons.lock_outline,passwordController
        ),
           const SizedBox(height: 15,),
       Row(
       mainAxisAlignment: MainAxisAlignment.start,
        children: [
        Padding(
          padding: const EdgeInsets.only(left: 58.0),
          child: 
           text("نسيت كلمة السر؟",AppColor.main,),
        ),
        SizedBox(width: MediaQuery.of(context).padding.left + 50,),
       
         text("تذكر تسجيل الدخول",AppColor.main,),
         const SizedBox(width: 2.5,),
         checkboxWidget("",context),
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
       ],),
        const SizedBox(height: 10,),
       
       BottonContainer("الدخول",Colors.white, AppColor.main,240,context,true,user.login(usernameController.text,passwordController.text,context)),
       const SizedBox(height: 15,),
       Row(
        mainAxisAlignment: MainAxisAlignment.center,
         children: [
           text(" تسجيل حساب جديد " ,AppColor.main),
             TextButton(onPressed: () =>navigatorCostum(context,XDRegister()),child:text("ليس لديك حساب؟",AppColor.secondary),
       )],
       ),
      ]
      ), 
    ));
  }
}


 navigatorCostum(BuildContext context,PageName){
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>  PageName),
  );
}






      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
//           Login Button
//           Pinned.fromPins(
//             Pin(start: 63.0, end: 62.0),
//             Pin(size: 71.0, middle: 0.8300),
//             child:
//                 Adobe XD layer: 'Login Button' (group)
//                 InkWell(
//                   onTap: () {
                   
//                      UserLogin user=UserLogin();
//                      user.login(usernameController.text,passwordController.text,context);
//                   } ,
//             
//      
   

 


