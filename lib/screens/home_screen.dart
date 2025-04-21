import 'package:flutter/material.dart';
import 'package:muipzi/assets/assets.dart';
import 'package:muipzi/theme/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            Column(
              spacing: 24,
              children: [
                Container(
                  height: 48,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppAssets.logoImage,
                      Icon(Icons.settings, color: AppColors.gray700, size: 24),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      shadows: [
                        BoxShadow(
                          color: Color(0x0F000000),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                          spreadRadius: -1,
                        ),
                        BoxShadow(
                          color: Color(0x0F000000),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                          spreadRadius: -1,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          child: Column(
                            spacing: 12,
                            children: [
                              //날씨, 시간, 장소
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //날씨, 시간
                                  Row(
                                    spacing: 12,
                                    children: [
                                      Text(
                                        '날씨',
                                        style: TextStyle(
                                          color: const Color(0xFF252527),
                                          fontSize: 16,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        '오후 12시',
                                        style: TextStyle(
                                          color: const Color(0xFF4D4C52),
                                          fontSize: 12,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  //장소
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: ShapeDecoration(
                                      color: AppColors.gray50,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Row(
                                      spacing: 6,
                                      children: [
                                        Icon(
                                          Icons.place_outlined,
                                          color: AppColors.gray700,
                                        ),
                                        Text(
                                          '서울시 00구',
                                          style: TextStyle(
                                            color: AppColors.gray900,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              //온도
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //현재온도
                                  Row(
                                    spacing: 12,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '☁️',
                                        style: TextStyle(fontSize: 56),
                                      ),
                                      Row(
                                        spacing: 6,
                                        children: [
                                          Text(
                                            '18',
                                            style: TextStyle(
                                              color: AppColors.gray950,
                                              fontSize: 56,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            '°C',
                                            style: TextStyle(
                                              color: AppColors.gray700,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  //최고, 최저온도
                                  Column(
                                    spacing: 8,
                                    children: [
                                      MaxMinTemperature(
                                        label: '최고온도',
                                        temperature: 21,
                                      ),
                                      MaxMinTemperature(
                                        label: '최저온도',
                                        temperature: 14,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 28, left: 20, right: 20),
                  decoration: ShapeDecoration(
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
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MaxMinTemperature extends StatelessWidget {
  const MaxMinTemperature({
    super.key,
    required this.label,
    required this.temperature,
  });

  final String label;
  final int temperature;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 6,
      children: [
        Text(label, style: TextStyle(color: AppColors.gray500, fontSize: 12)),
        Row(
          children: [
            Text(
              temperature.toString(),
              style: TextStyle(
                color: AppColors.gray950,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '°C',
              style: TextStyle(
                color: AppColors.gray700,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
