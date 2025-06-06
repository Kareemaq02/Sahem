import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:account/Widgets/Filter/filterType.dart';
import 'package:account/Screens/Notifications/NotificationsHistory.dart';
// ignore_for_file: file_names




 myAppBar(BuildContext context,title,visible, space){
  return
  PreferredSize(
    preferredSize: const Size.fromHeight(55.0),
     child: AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leadingWidth: double.infinity,
      leading: SizedBox(
        width: double.infinity,
        //height:10,

        child: Row(
          //mainAxisAlignment: MainAxisAlignment.start,

          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationsHistory()),
                );
              },
              icon: const Icon(
                Icons.notifications_none_outlined,
                color: Colors.white,
                size: 30,
              ),
            ),
            SizedBox(width: MediaQuery.of(context).padding.right + space),
            Visibility(
              visible: visible,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0, left: 15),
                child: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => const FilterPopup(),
                    );
                  },
                  icon: const Icon(
                    Icons.filter_alt_sharp,
                    color: AppColor.main,
                    size: 20,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(title,
                  //textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    color: AppColor.textTitle,
                    fontSize: 19,
                    fontFamily: 'DroidArabicKufi',
                  )),
            ),
          ],
        ),
      ),
    ),
  );
}
