import 'package:flutter/material.dart';

class AppAssets {
  static const String logo = 'lib/assets/images/logo_x2.png';
  static Image get logoImage =>
      Image.asset(logo, width: 152, height: 29, fit: BoxFit.contain);
}
