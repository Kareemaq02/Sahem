
import 'dart:io';
import 'package:account/API/file_complaint_request.dart';
import 'package:account/API/get_complaints_types.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Screens/File%20complaint/dropdown.dart';
import 'package:account/Screens/File%20complaint/pageView.dart';
import 'package:account/Screens/Home/public_feed.dart';
import 'package:account/Widgets/appBar.dart';
import 'package:account/Widgets/bottomNavBar.dart';
import 'package:account/Widgets/bottonContainer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:account/Screens/File complaint/confirmPopup.dart';

List<MediaFile> selectedMediaFiles = [];
final List<String> imageList = [
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7zjk6aWDXjWiB_mMUpuxQdzMxtXbyd8M5ag&usqp=CAU',
    'img2.png',
    'img3.png',
  ];

class FileCompalint extends StatefulWidget {

   const FileCompalint({super.key}) ;

  @override
  State<FileCompalint> createState() => _ComaplintState();
}

class _ComaplintState extends State<FileCompalint> {

  late PageController controller;
  GlobalKey<PageContainerState> key = GlobalKey();



 
TextEditingController commentController = TextEditingController();

  final _picker = ImagePicker();

  //drop down List

  late DropDownValue dropdown=DropDownValue(1, " ");
  late int intType;
  List<DropDownValue> items = [];
  late Future<List<ComplaintType>>_futureData;
  ComplaintTypeRequest type=ComplaintTypeRequest();
 
   List<int> _lenght = [0, 1, 2,4];


@override
void initState() {
   WidgetsBinding.instance.addPostFrameCallback((_) {
    getImages(context);
  });
  super.initState();
    controller = PageController();
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
 addImage() {
   if(selectedMediaFiles.length<=2){
      getImages(context);
      }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تجاوزت الحد الأقصى لالتقاط الصور ')));
         }
}

 removeImage() {
   if(selectedMediaFiles.length<=2){
      getImages(context);
      }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تجاوزت الحد الأقصى لالتقاط الصور ')));
         }
}

//fetch classification



Future<void> getImages(BuildContext context) async {
  final pickedFile = await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);

  if (pickedFile != null) {
     selectedMediaFiles.add(
      MediaFile(
        File(pickedFile.path),
        31.958946, // Placeholder value for decLat
        31.958946, // Placeholder value for decLng
        false, // Placeholder value for blnIsVideo
      ),
    );
    setState(() {});
   
  } else {
    Navigator.pop(context,MaterialPageRoute(builder: (context) =>  const XDPublicFeed1()));
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text('Nothing is selected')),);
    
  }
}
//remove , add icons
Widget stackButton(ICONS,whatToDo,context){
 return
  Padding(
    padding: const EdgeInsets.all(8.0),
    child: ClipOval(
        child: Material(
          color: AppColor.background,
          child: InkWell(
            onTap: () {
            //  showDialog(
            //   context: context,
            //   builder: (BuildContext context) => _buildFilterDialog(context),
            // );
            },
            child: SizedBox(
              width: 25,
              height: 25,
              child: Icon(ICONS, color: Colors.grey, size: 20),
            ),
          ),
        ),
      ),
  );
}


  @override
  Widget build(BuildContext context) {
   
    return  Scaffold(
       backgroundColor: AppColor.background,
      resizeToAvoidBottomInset: false,
      floatingActionButton:const CustomActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar:BottomNavBar1(3),
       appBar:myAppBar(context,"ارسال بلاغ",false,170),
      body:
       SingleChildScrollView(
        scrollDirection: Axis.vertical,
         child: Column(
          children: [ 
          myPageView(),
          MyDropDown(),
          const SizedBox(height: 0,),
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Container(
             height: 150,
             decoration: BoxDecoration(
               border:Border.all(color: AppColor.main,width: 1),
               borderRadius: BorderRadius.circular(10),
             ),
             child: const Padding(
               padding: EdgeInsets.all(10.0),
               child: TextField(
                 maxLines: null, // Allow multiple lines for the comment
                 decoration: InputDecoration(
                   hintText: 'أضف تعليق ..',
                   border: InputBorder.none,
                   hintTextDirection: TextDirection.rtl,
                   hintStyle: TextStyle(color: AppColor.main),
                 ),
                 
               ),
             )),
           ),
           SizedBox(height: 10,),
  	       //BottonContainer("استمرار", Colors.white, AppColor.main, 250,context,true,,buildConfirmDialog(context)), 
            BottonContainer("استمرار", Colors.white, AppColor.main, 250,context,true,null,(){}), 
            SizedBox(height: 50,),
        
          
          ],
             ),
       ),
        ) ;                   
     }

}

// void showAlertDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return Container(
//           width: MediaQuery.of(context).size.width / 1.3,
//           height: MediaQuery.of(context).size.height / 2.5,
//           decoration: new BoxDecoration(
//             shape: BoxShape.rectangle,
//             color: const Color(0xFFFFFF),
//             borderRadius: new BorderRadius.all(const Radius.circular(32.0)),
//           ),
//           child:
//           Column(children: [
//             // text("تأكيد البلاغ؟", AppColor.textTitle),
//             // RowInfo( "نوع البلاغ", "مخلفات اعمال بناء"),
//             // RowInfo( "نوع البلاغ", "مخلفات اعمال بناء"),

//             Row(
//               children: [
//                // BottonContainer("", AppColor.main, Colors.white, 100),
//                // BottonContainer("", Colors.white, AppColor.main, 100),
//               ],
//             ),
//           ],) //Contents here
        
//       );
//     },
//   );
//}




class DropDownValue{
DropDownValue( this.intID, this.stringName);

late int intID=0;
late String stringName;
}
