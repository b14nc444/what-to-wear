import 'package:flutter/material.dart';
import 'package:muipzi/theme/app_colors.dart';

class LocationSearchItem extends StatelessWidget {
  final String location;
  final bool selected;
  final VoidCallback onTap;

  const LocationSearchItem({
    super.key,
    required this.location,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: selected ? AppColors.gray100 : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          location,
          style: const TextStyle(
            color: AppColors.gray900,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
