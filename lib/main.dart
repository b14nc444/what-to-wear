import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:muipzi/screens/location_permission_screen.dart';
import 'package:muipzi/services/location_service.dart';
import 'package:muipzi/theme/app_colors.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 임시 초기화 실행
  await LocationService().initializeLocationData();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '오늘머입지',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.backgroundColor,
        fontFamily: 'Pretendard',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Pretendard'),
          bodyMedium: TextStyle(fontFamily: 'Pretendard'),
          titleLarge: TextStyle(fontFamily: 'Pretendard'),
          titleMedium: TextStyle(fontFamily: 'Pretendard'),
          titleSmall: TextStyle(fontFamily: 'Pretendard'),
        ),
      ),
      home: const LocationPermissionScreen(),
    );
  }
}
