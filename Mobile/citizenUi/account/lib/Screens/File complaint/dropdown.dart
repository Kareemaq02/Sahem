



import 'package:account/API/get_complaints_types.dart';
import 'package:account/Repository/color.dart';
import 'package:flutter/material.dart';





class MyDropDown extends StatefulWidget {

   const MyDropDown({super.key}) ;

  @override
  State<MyDropDown> createState() => _MyDropDownState();
}

class _MyDropDownState extends State<MyDropDown> {




  //drop down List

  late DropDownValue dropdown=DropDownValue(1, " ");
  late int intType;
  List<DropDownValue> items = [];
  late Future<List<ComplaintType>>_futureData;
  ComplaintTypeRequest type=ComplaintTypeRequest();
 
   List<int> _lenght = [0, 1, 2,4];


@override
void initState() {
 
  super.initState();
   
    _futureData=type.getAllCategory();
   _initializeData();
 
}

  void _initializeData() async {
  final data = await type.getAllCategory();
  setState(() {
    items = data.map((item) => DropDownValue(item.intTypeId, item.strNameAr)).toList();
    dropdown = items[0];
    print(items[0]);
  });
}



  @override
  Widget build(BuildContext context) {
   
    return

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 40,
                width: double.infinity,
              decoration: BoxDecoration (
                 
                border: Border.all(color: AppColor.main,width: 1.0),
                borderRadius: BorderRadius.circular(10)
              ),
              
              child:
                FutureBuilder<List<ComplaintType>>(
          //move getAllCategory on page load
           future: _futureData,
          builder: (context, snapshot) {
          if (snapshot.hasData) {
         var data = snapshot.data!;
         var items =  data.map((item) {
          return DropdownMenuItem(
            value:  DropDownValue(item.intTypeId, item.strNameAr) ,
            child: Padding(
              padding: const EdgeInsets.only(left:60.0),
              child: Row(
                children: [
                   Text(item.strNameAr),
                  Icon(Icons.report_gmailerrorred, color:AppColor.main,size: 20,),
                 
                ],
              ),
            ),
          );
        }).toList();

      
      // dropdown=items[0].value!;
       dropdown=items[dropdown.intID-1].value!;

         return DropdownButton(
          underline: Container(),
          //enableFeedback: false,
          alignment: Alignment.topRight,
           borderRadius: BorderRadius.circular(10),
          // icon:const Padding(
          //       padding: EdgeInsets.all(8.0),
          //       child: Row(
          //         //mainAxisAlignment: MainAxisAlignment.spaceAround,
          //         children: [
          //           SizedBox(width:1,),
          //         //Icon(Icons.arrow_drop_down_sharp,color:AppColor.main,),
          //       // SizedBox(width:10,),
          //          Icon(Icons.report_gmailerrorred, color:AppColor.main,size: 20,),
             
          //       ],),),   
        value:dropdown ,
        icon: const Icon(Icons.keyboard_arrow_down,color:AppColor.main),
        items:items,
        onChanged: (newValue) {
          setState(() {
            dropdown= newValue as DropDownValue;
            print(dropdown.intID );
            print(dropdown.stringName );
           
          });
        },

      );
    } else {
      return const CircularProgressIndicator();
    }
  },
),
              ),
            );
}
}

class DropDownValue{
DropDownValue( this.intID, this.stringName);

late int intID=0;
late String stringName;
}
