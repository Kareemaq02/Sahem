import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:account/Widgets/HelperWidegts/text.dart';

final List<String> imageList12 = [
  'https://www.khaberni.com/uploads/news_model/2019/08/main_image5d59279aef218.jpg',
  'https://pbs.twimg.com/media/ECvxvFgX4AAY___.jpg'
];

Widget mapPageView(context) {
  double screenHeight = MediaQuery.of(context).size.height;
  double screenWidth = MediaQuery.of(context).size.width;
  return SizedBox(
    height: screenHeight * 0.1,
    child: PageIndicatorContainer(
      align: IndicatorAlign.bottom,
      length: imageList12.length,
      indicatorSpace: 10.0,
      padding: const EdgeInsets.all(15),
      indicatorColor: Colors.grey,
      indicatorSelectorColor: Colors.blue,
      shape: IndicatorShape.circle(size: 7),
      child: PageView.builder(
        itemCount: imageList12.length,
        itemBuilder: (context, position) {
          return Container(
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 10),
            child: Stack(
              children: [
                Container(
                  height: screenHeight * 01,
                  color: AppColor.background,
                  child: Image.network(
                    imageList12[position],
                    //scale: 0.1,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 5,
                  left: 65,
                  child: Container(
                    height: screenHeight * 0.03,
                    width: screenWidth * 0.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color:position == 0? Colors.red : Colors.green,
                    ),
                    child: Center(
                      child: position == 0
                          ? text(" قبل", Colors.white)
                          : text(" بعد", Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}
