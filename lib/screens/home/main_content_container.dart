import 'package:flutter/material.dart';
import 'package:muipzi/screens/home/what_to_wear_container.dart';
import 'package:muipzi/theme/app_colors.dart';

class MainContentContainer extends StatelessWidget {
  const MainContentContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(top: 28, left: 20, right: 20),
        decoration: MainContentContainerDecoration(),
        child: Column(
          spacing: 24,
          children: [
            Text(
              "기분 좋은 선선함, 가벼운 옷차림이 딱이에요!",
              style: TextStyle(color: AppColors.gray700, fontSize: 14),
            ),
            WhatToWearContainer(),
          ],
        ),
      ),
    );
  }

  ShapeDecoration MainContentContainerDecoration() {
    return const ShapeDecoration(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      shadows: [
        BoxShadow(
          color: Color(0x3F000000),
          blurRadius: 50,
          offset: Offset(0, 25),
          spreadRadius: -12,
        ),
      ],
    );
  }
}
