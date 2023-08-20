


import 'package:account/Repository/color.dart';
import 'package:account/Screens/File%20complaint/complaints1.dart';
import 'package:flutter/material.dart';
import 'package:page_indicator/page_indicator.dart';

Widget myPageView(){

  return        Padding(
    padding: const EdgeInsets.only(top:8.0),
    child: Container(
                height: 210,
               // color: Colors.black,
                child: PageIndicatorContainer(
                  align: IndicatorAlign.bottom,
                  length: imageList.length,
                  indicatorSpace: 10.0,
                  padding: const EdgeInsets.all(10),
                  indicatorColor: Colors.grey,
                  indicatorSelectorColor: Colors.blue,
                  shape: IndicatorShape.circle(size: 7),
                  child: PageView.builder(
                    itemCount: imageList.length,
                    itemBuilder: (context, position) {
                      return Container(
                       //padding: const EdgeInsets.only(bottom:0),
                        child: Stack(
                          children: [
                             Image.network(
                              imageList[position], // Use the correct image path here
                              scale: 0.1,
                              fit:BoxFit.fill,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                               
                              // stackButton(Icons.add,addImage(),context),
                              // stackButton(Icons.delete,removeImage(),context),
                               
                            ],),
                           
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
  );
}