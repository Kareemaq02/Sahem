import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/API/get_complaints_types.dart';
import 'package:account/Widgets/Filter/filterStatus.dart';





 List<int> selectedTypes = [];
class FilterPopup extends StatefulWidget {
  const FilterPopup({Key? key}) : super(key: key);

  @override
  _FilterPopupState createState() => _FilterPopupState();
}

class _FilterPopupState extends State<FilterPopup> {
  late Future<List<ComplaintType>> futureData;
  ComplaintTypeRequest type = ComplaintTypeRequest();


 

  @override
  void initState() {
    super.initState();
     //selectedTypes.clear(); 
    futureData = type.getAllCategory();
   
  }




  @override
  Widget build(BuildContext context) {
//   final filterModel = Provider.of<FilterModel>(context);
// List<int> selectedTypes = filterModel.selectedType;

     List<Map<String, dynamic>> checkboxData = [

  {
    "intTypeId": 1,
    "strNameAr": "تراكم النفايات",
    "isChecked": false,
  },
  {
    "intTypeId": 12,
    "strNameAr": "تصدعات في  الشارع ",
    "isChecked": false,
  },
  {
    "intTypeId": 2,
    "strNameAr": "مبعثرات حول الحاوية",
    "isChecked": false,
  },
   {
    "intTypeId": 11,
    "strNameAr": "مناهل مفقودة ",
    "isChecked": false,
  },
  {
    "intTypeId": 14,
    "strNameAr": "شواخص  غير قانونية",
    "isChecked": false,
  },
  {
    "intTypeId": 15,
    "strNameAr": "شواخص  مكسوره",
    "isChecked": false,
  },
  {
    "intTypeId": 16,
    "strNameAr": "شواخص  محجوبة",
    "isChecked": false,
  },
  {
    "intTypeId": 17,
    "strNameAr": "انارة الشوارع معطلة",
    "isChecked": false,
  },
  {
    "intTypeId": 18,
    "strNameAr": "تصدع جدار استنادي",
    "isChecked": false,
  },
  {
    "intTypeId": 19,
    "strNameAr": "تكسر اطراف/ارصفة",
    "isChecked": false,
  },
  {
    "intTypeId": 21,
    "strNameAr": "مخلفات اعمال بناء",
    "isChecked": false,
  },
  {
    "intTypeId": 22,
    "strNameAr": "مخلفات اعمال صيانة",
    "isChecked": false,
  },
   {
    "intTypeId": 3,
    "strNameAr": "مخلفات تقليم الاشجار",
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
                  itemCount: checkboxData.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    final data = checkboxData[index];
                    final intTypeId = data["intTypeId"] as int;
                    final strNameAr = data["strNameAr"] as String;
                    bool isChecked = selectedTypes.contains(intTypeId);

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
                               
                                selectedTypes.add(intTypeId);
                                 print(selectedTypes);
                              } else {
                                
                                selectedTypes.remove(intTypeId);
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
               padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero), // Remove default padding
              backgroundColor: MaterialStateProperty.all<Color>(AppColor.main),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50), // Same as the container border radius
               side: const BorderSide(
                    color:AppColor.main,
                    width: 1.3,
                    //style: BorderStyle.solid,
                  ),
                ),
                ),
              ),
                        
                onPressed:() {
                
                  selectedStatus.clear(); 
                Navigator.of(context).pop();
                showDialog(
                context: context,
                builder: (BuildContext context) => const FilterPopup2(),
                     );
              }, child: const Text("استمرار")),
            ),
          ],
        ),
      ),
    );
  }
}

Widget checkboxWidget(
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
