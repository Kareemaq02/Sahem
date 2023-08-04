import 'package:account/Screens/Login/login.dart';
import 'package:flutter/material.dart';

Widget BottonContainer(String text,textColor,Color boxColor,double width,BuildContext context,bool apiFlag,PageName,[Future<dynamic>? onPressed])
{
  return   Container(
              height:49 ,
              width: width,
              decoration:
               BoxDecoration(
                borderRadius:BorderRadius.all(Radius.circular(50)),
              border:Border.all(
              color: textColor,
              width: 1.3,
              style: BorderStyle.solid
              ),
       ),    
              child: 
              ElevatedButton(
                style: 
                ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(boxColor),
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
                    fontSize: 18,
                    fontWeight: FontWeight.w500                 
                  ),
                ),
                 ),
            );
}
