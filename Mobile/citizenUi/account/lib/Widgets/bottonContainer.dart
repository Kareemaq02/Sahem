import 'package:account/Repository/color.dart';
import 'package:account/Screens/Login/login.dart';
import 'package:flutter/material.dart';

Widget BottonContainer(String text,textColor,Color boxColor,double width,BuildContext context,bool apiFlag,PageName,[Future<dynamic>? onPressed])
{
  return   Container(
              height:49 ,
              width: width,
      //         decoration:
      //          BoxDecoration(
      //           borderRadius:BorderRadius.all(Radius.circular(50)),
      //         border:Border.all(
      //         color: textColor,
      //         width: 1.3,
      //         style: BorderStyle.solid
      //         ),
      //  ),    
              child: 
              ElevatedButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero), // Remove default padding
        backgroundColor: MaterialStateProperty.all<Color>(boxColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50), // Same as the container border radius
            side: BorderSide(
              color:AppColor.main,
              width: 1.3,
              //style: BorderStyle.solid,
            ),
          ),
        ),
      ),
                onPressed:(){
                  !apiFlag ?
               Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => PageName),
               ) : onPressed!;

                },
                child: 
                 Text(
                  text,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color:textColor,
                    fontSize: 15,
                    fontFamily:'DroidArabicKufi',            
                  ),
                ),
                 ),
            );
}
