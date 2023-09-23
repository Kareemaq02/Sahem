import 'package:flutter/material.dart';

Widget text(text,color){
  return Center(
    child: Text(
              text,
              textDirection: TextDirection.rtl,
              style: TextStyle(
        fontSize: 10,
              color:color,
              fontFamily:'DroidArabicKufi', 
              ),
  
              ),
  );
}