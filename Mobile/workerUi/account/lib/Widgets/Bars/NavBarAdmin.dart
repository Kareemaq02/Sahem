import 'package:account/Screens/CreateTask/CreateTask.dart';
import 'package:account/Screens/TaskEvaluation/TaskEvaluation.dart';
import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Screens/Map/mapView.dart';
import 'package:account/Screens/Home/MainMenuAdmin.dart';

class NavBarAdmin extends StatefulWidget {
  final int selectedIcon;
  NavBarAdmin(this.selectedIcon, {super.key});

  @override
  State<NavBarAdmin> createState() => _NavBarAdminState();
}

class _NavBarAdminState extends State<NavBarAdmin> {
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
        naviWithTransition(const MainMenuAdmin());
        break;
      case 1:
        naviWithTransition(const FullMap1());
        break;
      case 2:
        // Change
        naviWithTransition(const TaskEvaluation(
          taskId: 1,
        ));
        break;
      case 3:
        naviWithTransition(const CreateTask());
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
        padding: const EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 0),
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _bottomNavBarItem(
                onTap: () => _changeSelectedTab(3),
                icona: widget.selectedIcon == 3
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
                text: "إنشاء المهام"),
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
                        Icons.star_rounded,
                        color: AppColor.main,
                        size: 23,
                      )
                    : const Icon(
                        Icons.star_rounded,
                        color: Colors.grey,
                        size: 23,
                      ),
                text: "تقييم المهام"),
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
