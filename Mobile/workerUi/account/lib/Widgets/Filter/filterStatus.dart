import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';



 List<int> selectedStatus = [];
class FilterPopup2 extends StatefulWidget {
  const FilterPopup2({Key? key}) : super(key: key);

  @override
  _FilterPopup2State createState() => _FilterPopup2State();
}

class _FilterPopup2State extends State<FilterPopup2> {
  // late Future<List<ComplaintType>> futureData;
  // ComplaintTypeRequest type = ComplaintTypeRequest();


 

  @override
  void initState() {
    super.initState();
    //futureData = type.getAllCategory();
   
  }




  @override
  Widget build(BuildContext context) {

     List<Map<String, dynamic>> checkboxData2 = [
 
    {
      "intId": 1,
      "strName": "مقيد",
      "isChecked": false,
    },
    {
      "intId": 2,
        "strName": "رفض",
      "isChecked": false,
    },
    {
      "intId": 3,
        "strName": "موافق عليه",
      "isChecked": false,
    },
     {
       "intId": 4,
       "strName": "مجدول",
      "isChecked": false,
    },
   
    
  ];
   return
    AlertDialog(
      title: const Text(
        'انواع البلاغات',
        textAlign: TextAlign.center,
        style: TextStyle( fontFamily:"DroidArabicKufi",),
      ),
      content: SizedBox(
        height: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: ListView.builder(
                  itemCount: checkboxData2.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    final data = checkboxData2[index];
                    final intTypeId = data["intId"] as int;
                    final strNameAr = data["strName"] as String;
                    bool isChecked = selectedStatus.contains(intTypeId);

                    return Column(
                      children: [
                        checkboxWidget2(
                          strNameAr,
                          context,
                          isChecked,
                          intTypeId,
                          (value) {
                            setState(() {
                              if (value!) {
                               
                                selectedStatus.add(intTypeId);
                                 print(selectedStatus);
                              } else {
                                
                                selectedStatus.remove(intTypeId);
                              }
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
          
            Container(
              height:40 ,
              width: 125,
              child: ElevatedButton(
               style: ButtonStyle(
               padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero), 
              backgroundColor: MaterialStateProperty.all<Color>(AppColor.main),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50), 
               side: const BorderSide(
                    color:AppColor.main,
                    width: 1.3,
                    //style: BorderStyle.solid,
                  ),
                ),
                ),
              ),
                        
                onPressed:() {
                 // selectedTypes.clear(); 
                 // selectedStatus.clear(); 
                Navigator.of(context).pop();
              // getFilteredComplaints(selectedTypes,selectedStatus);
              }, child: const Text("استمرار")),
            ),
          ],
        ),
      ),
    );
  }
}

Widget checkboxWidget2(
  String option, 
  BuildContext context, 
  bool? isChecked, 
  int typeId, 
  void Function(bool?) onChanged 
) {
  return GestureDetector(
    onTap: () {
      onChanged(!isChecked!); 
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          option,
          style: const TextStyle(color: AppColor.main, fontSize: 12, fontFamily: 'DroidArabicKufi'),
        ),
        SizedBox(width: MediaQuery.of(context).padding.right + 5),
        Checkbox(
          value: isChecked,
          onChanged: onChanged, 
          activeColor: AppColor.main,
        ),
      ],
    ),
  );
}
