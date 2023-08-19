
// ignore_for_file: must_be_immutable, unused_local_variable, file_names

import 'package:account/Repository/color.dart';
import 'package:account/Screens/File%20complaint/complaints1.dart';
import 'package:account/Screens/Home/public_feed.dart';
import 'package:account/Screens/Map/map_view.dart';
import 'package:account/Screens/Profile/profile.dart';
import 'package:account/Screens/View%20complaints/complaints_list.dart';
import 'package:flutter/material.dart';




class BottomNavBar1 extends StatefulWidget {
 int selectedIcon;
   BottomNavBar1( this.selectedIcon, {super.key}) ;

  @override
  State<BottomNavBar1> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar1> {
  int _selectedIndex = 0;

  // getClip(Size size) {
  //   var path = Path();
  //   path.lineTo(0, size.height);
    
  //   path.lineTo(size.width, size.height);
  //   path.lineTo(size.width,0.0);
  //   path.lineTo(2*size.width/3, 0.0);
  //   var firstEnd = Offset(size.width / 2, size.height/2);
  //   path.arcToPoint(Offset(size.width/3, 0),radius:const Radius.circular(1));
      
  // path.close();
  //   return path;
  // }


  _changeSelectedTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (_selectedIndex) {
      case 0:
       
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const XDPublicFeed1()));
        break;
      case 1:
       
       Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const FullMap()));    
         break;
      case 2:
         
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const XDComplaintsList())); 
        break;
      case 3:
       
       Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Profile()));
        break;
    }
   
  }
@override
  void initState() {
setState(() {
  // _selectedIndex =widget.selectedIcon ;

});    super.initState();
  }
  Widget _bottomNavBarItem(
      {required  Icon icona,
      required String text,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          icona,
          const SizedBox(height: 4),
          Expanded(
            child: Text(text,
                style:
                    const TextStyle(color: Colors.grey, fontSize: 8.5,fontFamily:'DroidArabicKufi', )),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return IntrinsicHeight(
      child: BottomAppBar(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        padding: const EdgeInsets.only(
            top: 10, left: 5, right: 5, bottom: 0),
            notchMargin:-15,
            //shape:CircularNotchedRectangle() ,
        // decoration: BoxDecoration(
        //   color:Colors.white,
        //   borderRadius: const BorderRadius.only(
        //       topRight: Radius.circular(15), topLeft: Radius.circular(30)),
        //   boxShadow: [
        //     BoxShadow(color: Colors.black38.withOpacity(0.25), blurRadius: 1),
        //   ],
        // ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [

            _bottomNavBarItem(
                onTap: () => _changeSelectedTab(3),
                icona: widget.selectedIcon==3? const Icon(Icons.person,color:AppColor.main,size: 23,): const Icon(Icons.person,color:Colors.grey,size: 23,),
                text: "المنتدى العام"),
             const SizedBox(width: 15,),
            _bottomNavBarItem(
                onTap: () => _changeSelectedTab(1),
                 icona: widget.selectedIcon==1? const Icon(Icons.map_outlined,color:AppColor.main,size: 23,): const Icon(Icons.map,color:Colors.grey,size: 23,),
                text: "الخريطة"),
            const Spacer(), 
            _bottomNavBarItem(
                onTap: () => _changeSelectedTab(2),
                 icona: widget.selectedIcon==2? const Icon(Icons.integration_instructions_outlined,color:AppColor.main,size: 23,): const Icon(Icons.integration_instructions_outlined,color:Colors.grey,size: 23,),
                text: "بلاغاتي"),
            const SizedBox(width: 15,),
                _bottomNavBarItem(
                onTap: () => _changeSelectedTab(0),
                 icona: widget.selectedIcon==0? const Icon(Icons.home,color:AppColor.main,size: 23,): const Icon(Icons.home,color:Colors.grey,size:23,),
                text: " الصفحة الرئيسية",),
            
          ],
        ),
      ),
    );
  }
}

class CustomActionButton extends StatelessWidget {
  const CustomActionButton( {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [

        InkWell(
        
        onTap: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const FileCompalint()));
        },
         child: const Image(
          image: AssetImage('assets/icons/FillComplaintIcon.png'),
          fit: BoxFit.cover,
          height: 52,
          
    ),
),
      ],
    );
  }
}
