import 'package:flutter/material.dart';
import 'package:muipzi/assets/assets.dart';
import 'package:muipzi/theme/app_colors.dart';

class LocationPermissionScreen extends StatelessWidget {
  const LocationPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [AppAssets.logoImage],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const Text(
                    '내 위치 기반 날씨 정보로 옷차림을 추천해드릴게요.',
                    style: TextStyle(fontSize: 16, color: AppColors.gray900),
                  ),
                  const SizedBox(height: 40),
                  Column(
                    children: [
                      const OptionBox('위치 권한 허용하기'),
                      const SizedBox(height: 8),
                      const OptionBox('수동으로 위치 설정하기'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OptionBox extends StatelessWidget {
  final String label;

  const OptionBox(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.gray700, fontSize: 14),
          ),
          const SizedBox(
            width: 16,
            height: 16,
            child: DecoratedBox(
              decoration: BoxDecoration(color: AppColors.gray300),
            ),
          ),
        ],
      ),
    );
  }
}
