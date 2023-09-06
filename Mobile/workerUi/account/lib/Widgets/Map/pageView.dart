import 'package:flutter/material.dart';
import 'package:account/Repository/color.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:account/Screens/SubmitTask/submitTask.dart';

Widget mapPageView(context){
   double screenHeight = MediaQuery.of(context).size.height;
  double screenWidth = MediaQuery.of(context).size.width;
  return
SizedBox(
              height: screenHeight * 0.1,
              child: PageIndicatorContainer(
                align: IndicatorAlign.bottom,
                length: imageList.length,
                indicatorSpace: 10.0,
                padding: const EdgeInsets.all(15),
                indicatorColor: Colors.grey,
                indicatorSelectorColor: Colors.blue,
                shape: IndicatorShape.circle(size: 7),
                child: PageView.builder(
                  itemCount: imageList.length,
                  itemBuilder: (context, position) {
                    return Container(
                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 10),
                      child: Container(
                        //height: ,
                        color: AppColor.background,
                        child: Image.network(
                          imageList[
                              position], // Use the correct image path here
                          scale: 0.1,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
);
}