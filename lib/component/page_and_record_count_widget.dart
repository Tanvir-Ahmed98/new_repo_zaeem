import 'dart:developer';
import 'package:flutter/material.dart';
import '../utils/color_const.dart';
import 'custome_text.dart';

class PageAndRecordCountWidget/*<T>*/ extends StatelessWidget {
  const PageAndRecordCountWidget({
    super.key,
    // required this.controller,
    required this.count,
  });

  // final T controller;
  final int count;

  @override
  Widget build(BuildContext context) {
    log("$count");
    return Container(
      height: 20,
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        color: AppColors.blueColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomeText(
            fontSize: 10,
            text:
                "Page Count: ${((count) / 10) >= 0.5 ? ((count) / 10).floor() : ((count) / 10).ceil()}",
            color: AppColors.whiteColor,
          ),
          Transform.flip(
            flipY: true,
            child: Container(
              height: 10,
              width: 2,
              color: AppColors.whiteColor,
              margin: const EdgeInsets.all(4),
            ),
          ),
          CustomeText(
            fontSize: 10,
            text: "Total Record: $count",
            color: AppColors.whiteColor,
          )
        ],
      ),
    );
  }
}
