import '../../Repository/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:account/Screens/SubmitTask/submitTask.dart';

ratingSheet(context) {
  return Container(
    height: 150,
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: Text(
            teamMembersListFake.first.strName,
            style: const TextStyle(
                color: AppColor.textBlue,
                fontFamily: 'DroidArabicKufi',
                fontSize: 15),
          ),
        ),
        const SizedBox(height: 10,),
        RatingBar.builder(
          initialRating: 3,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) =>
              const Icon(Icons.star, color: AppColor.main),
          onRatingUpdate: (rating) {
            print(rating);
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
