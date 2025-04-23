import 'package:flutter/material.dart';
import 'package:muipzi/theme/app_colors.dart';

class WhatToWearContainer extends StatelessWidget {
  const WhatToWearContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 32,
      children: [
        //상하의
        Column(
          spacing: 12,
          children: [
            ClothingDisplayBox(height: 150),
            Row(
              spacing: 28,
              children: [
                Expanded(
                  child: ClothingDescription(
                    label: '👕 상의',
                    clothes: '가디건, 긴팔 티셔츠',
                  ),
                ),
                Expanded(
                  child: ClothingDescription(label: '👖 하의', clothes: '청바지'),
                ),
              ],
            ),
          ],
        ),
        //신발, 악세사리
        Row(
          spacing: 32,
          children: [
            //신발
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  ClothingDisplayBox(height: 120),
                  ClothingDescription(label: '👟 신발', clothes: '샌들'),
                ],
              ),
            ),
            //악세사리
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  ClothingDisplayBox(height: 120),
                  ClothingDescription(label: '🧢 악세서리', clothes: '모자'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ClothingDisplayBox extends StatelessWidget {
  const ClothingDisplayBox({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: AppColors.gray100),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

class ClothingDescription extends StatelessWidget {
  const ClothingDescription({
    super.key,
    required this.label,
    required this.clothes,
  });

  final String label;
  final String clothes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.gray950,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            clothes,
            style: TextStyle(
              color: AppColors.gray950,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
