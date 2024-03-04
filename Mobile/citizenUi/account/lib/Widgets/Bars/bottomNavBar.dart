import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Screens/Map/mapView.dart';
import 'package:account/Screens/Home/publicFeed.dart';
import 'package:account/Screens/MainMenu/MainMenu.dart';
import 'package:account/Screens/File%20complaint/fileComaplint.dart';
import 'package:account/Screens/View%20complaints/complaints_list.dart';

// ignore_for_file: must_be_immutable, unused_local_variable, file_names

class BottomNavBar1 extends StatefulWidget {
  int selectedIcon;
  BottomNavBar1(this.selectedIcon, {super.key});

  @override
  State<BottomNavBar1> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar1> {
  int _selectedIndex = 0;
  naviWithTransition(pgaeName) {
    Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => pgaeName,
          transitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: (_, a, __, c) =>
              FadeTransition(opacity: a, child: c),
        ));
  }

  _changeSelectedTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (_selectedIndex) {
      case 0:
        naviWithTransition(const MainMenu());
        break;
      case 1:
        naviWithTransition(const FullMap());
        break;
      case 2:
        naviWithTransition(const XDComplaintsList()); 
        break;
      case 3:
        naviWithTransition(const XDPublicFeed1());
        break;
      case 4:
        naviWithTransition(const FileCompalint());
        break;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _bottomNavBarItem(
      {required Icon icona,
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
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 8.5,
                  fontFamily: 'DroidArabicKufi',
                )),
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
        padding: const EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 0),
        notchMargin: -15,
        child: Padding(
          padding: const EdgeInsets.only(right: 6.0, left: 6, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _bottomNavBarItem(
                  onTap: () => _changeSelectedTab(3),
                  icona: widget.selectedIcon == 3
                      ? const Icon(
                          Icons.person,
                          color: AppColor.main,
                          size: 23,
                        )
                      : const Icon(
                          Icons.person,
                          color: Colors.grey,
                          size: 23,
                        ),
                  text: "المنتدى العام"),
              const SizedBox(
                width: 15,
              ),
              _bottomNavBarItem(
                  onTap: () => _changeSelectedTab(1),
                  icona: widget.selectedIcon == 1
                      ? const Icon(
                          Icons.map,
                          color: AppColor.main,
                          size: 23,
                        )
                      : const Icon(
                          Icons.map,
                          color: Colors.grey,
                          size: 23,
                        ),
                  text: "الخريطة"),
              const SizedBox(
                width: 15,
              ),
              _bottomNavBarItem(
                  onTap: () => _changeSelectedTab(4),
                  icona: widget.selectedIcon == 4
                      ? const Icon(
                          Icons.add_a_photo,
                          color: AppColor.main,
                          size: 23,
                        )
                      : const Icon(
                          Icons.add_a_photo,
                          color: Colors.grey,
                          size: 23,
                        ),
                  text: "ارسال بلاغ"),
              const SizedBox(
                width: 15,
              ),
              _bottomNavBarItem(
                  onTap: () => _changeSelectedTab(2),
                  icona: widget.selectedIcon == 2
                      ? const Icon(
                          Icons.integration_instructions_outlined,
                          color: AppColor.main,
                          size: 23,
                        )
                      : const Icon(
                          Icons.integration_instructions_outlined,
                          color: Colors.grey,
                          size: 23,
                        ),
                  text: "بلاغاتي"),
              const SizedBox(
                width: 15,
              ),
              _bottomNavBarItem(
                onTap: () => _changeSelectedTab(0),
                icona: widget.selectedIcon == 0
                    ? const Icon(
                        Icons.home,
                        color: AppColor.main,
                        size: 23,
                      )
                    : const Icon(
                        Icons.home,
                        color: Colors.grey,
                        size: 23,
                      ),
                text: " الصفحة الرئيسية",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class CustomActionButton extends StatelessWidget {
//   const CustomActionButton({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final deviceSize = MediaQuery.of(context).size;
//     return Stack(
//       alignment: Alignment.bottomCenter,
//       children: [
//         InkWell(
//           onTap: () {
//             Navigator.of(context).pushReplacement(
//                 MaterialPageRoute(builder: (context) => const FileCompalint()));
//           },
//           child: const Image(
//             image: AssetImage('assets/icons/FillComplaintIcon.png'),
//             fit: BoxFit.cover,
//             height: 52,
//           ),
//         ),
//       ],
//     );
//   }
// }
