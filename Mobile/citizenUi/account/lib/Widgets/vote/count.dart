
// ignore_for_file: unused_local_variable, file_names, prefer_const_constructors

import 'package:account/Repository/color.dart';
import 'package:account/Widgets/countProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CountWidget extends StatefulWidget {

  final int initialCount;

  
    CountWidget({
    required this.initialCount,
 
    
  });

 
  @override
  _CountWidgetState createState() => _CountWidgetState();
}
class _CountWidgetState extends State<CountWidget> {
   

  @override
  void initState() {
    super.initState();



  }

 @override
  Widget build(BuildContext context) {
var countProvider = Provider.of<CountProvider>(context,);
//countProvider.updateCount(widget.initialCount);

    
  return Expanded(
    child: Stack(
      children: [
        Center(
          child: Column(
            children: [
              Text(countProvider.count.toString(),style: TextStyle(color: AppColor.secondary),),
              Divider(thickness: 1, color: Color(0xFFC9BD40),height: 5,),
            ],
          ),
        ),
      ],
    ),
  );
}
  }


