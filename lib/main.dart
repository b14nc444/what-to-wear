import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:muipzi/assets/assets.dart';
import 'package:muipzi/screens/splash_screen.dart';
import 'package:muipzi/theme/app_colors.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '오늘머입지',
      theme: ThemeData(scaffoldBackgroundColor: AppColors.backgroundColor),
      home: const SplashScreen(),
    );
  }
}
