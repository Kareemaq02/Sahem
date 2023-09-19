import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/API/login_request.dart';
import 'package:account/Screens/Map/mapView.dart';
import 'package:account/Screens/Home/MainMenuAdmin.dart';
import 'package:account/Screens/Home/MainMenuWorker.dart';
import 'package:account/Screens/View%20tasks/task_list.dart';
import 'package:account/Screens/CurrentTask/currentTask.dart';
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
    Widget menu =
        userIsAdmin() ? const MainMenuAdmin() : const MainMenuWorker();
    setState(() {
      _selectedIndex = index;
    });
    switch (_selectedIndex) {
      case 0:
        naviWithTransition(menu);
        break;
      case 1:
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const FullMap1()));
        break;
      case 2:
        naviWithTransition(const XDTasksList());
        break;
      case 3:
        naviWithTransition(const CurrentTask());
        break;
    }
  }

  @override
  void initState() {
    setState(() {
      // _selectedIndex =widget.selectedIcon ;
    });
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
        //clipBehavior: Clip.antiAliasWithSaveLayer,
        padding: const EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 0),
        shape: const CircularNotchedRectangle(), //shape of notch
        notchMargin:
            5, //notche margin between floating button and bottom appbar

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _bottomNavBarItem(
                onTap: () => _changeSelectedTab(3),
                icona: widget.selectedIcon == 3
                    ? const Icon(
                        Icons.work_history_rounded,
                        color: AppColor.main,
                        size: 23,
                      )
                    : const Icon(
                        Icons.work_history_rounded,
                        color: Colors.grey,
                        size: 23,
                      ),
                text: "العمل الحالي"),
            const SizedBox(
              width: 15,
            ),
            _bottomNavBarItem(
                onTap: () => _changeSelectedTab(1),
                icona: widget.selectedIcon == 1
                    ? const Icon(
                        Icons.map_rounded,
                        color: AppColor.main,
                        size: 23,
                      )
                    : const Icon(
                        Icons.map_rounded,
                        color: Colors.grey,
                        size: 23,
                      ),
                text: "الخريطة"),
            const SizedBox(
              width: 20,
            ),
            _bottomNavBarItem(
                onTap: () => _changeSelectedTab(2),
                icona: widget.selectedIcon == 2
                    ? const Icon(
                        Icons.task_alt_rounded,
                        color: AppColor.main,
                        size: 23,
                      )
                    : const Icon(
                        Icons.task_alt_rounded,
                        color: Colors.grey,
                        size: 23,
                      ),
                text: "الأعمال"),
            const SizedBox(
              width: 20,
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
    );
  }
}
