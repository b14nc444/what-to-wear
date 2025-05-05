import 'package:flutter/material.dart';
import 'package:muipzi/theme/app_colors.dart';

class TemperatureRow extends StatelessWidget {
  const TemperatureRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          spacing: 12,
          children: [
            const Text('☁️', style: TextStyle(fontSize: 56)),
            Row(
              spacing: 6,
              children: [
                const Text(
                  '18',
                  style: TextStyle(
                    color: AppColors.gray950,
                    fontSize: 56,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Text(
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: 8,
          children: [
            MaxMinTemperatureRow(label: '최고온도', temperature: 21),
            MaxMinTemperatureRow(label: '최저온도', temperature: 9),
          ],
        ),
      ],
    );
  }
}

class MaxMinTemperatureRow extends StatelessWidget {
  const MaxMinTemperatureRow({
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
        Text(
          label,
          style: TextStyle(
            color: AppColors.gray500,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          width: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
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
        ),
      ],
    );
  }
}
