
import 'package:flutter/material.dart';

class DesignWidget{
  BoxDecoration myBoxDecoration(
      {double circular=0 ,
        double borderWidth= 0,
        Color color=Colors.transparent,
        Color colorBorder=Colors.black}) {
    return BoxDecoration(
      color: color,
      border: Border.all(
        color: colorBorder,
          width: borderWidth
      ),
      borderRadius: BorderRadius.all(
          Radius.circular(circular) //      
      ),
    );
  }
  BoxDecoration myBoxDecorationWithOutBorder(
      {double circular=0 ,
        Color color=Colors.transparent,
     }) {
    return BoxDecoration(
      boxShadow:const [
        BoxShadow(
          color: Colors.grey,
          blurRadius: 5.0,
          spreadRadius: 0.0,
          offset: Offset(0.0, 5.0), // shadow direction: bottom right
        )
      ],
      color: color,
      borderRadius: BorderRadius.all(
          Radius.circular(circular) //                 <--- border radius here
      ),
    );
  }
}