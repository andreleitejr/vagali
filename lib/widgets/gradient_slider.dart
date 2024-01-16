import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:get/get.dart';
import 'package:vagali/theme/theme_typography.dart';

class GradientSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final String label;

  const GradientSlider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: ThemeTypography.semiBold16,
              ),
            ),
            Text(
            '${value.toStringAsFixed(0)} metros',
            style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        FlutterSlider(
          values: [value],
          min: min,
          max: max,
          onDragging: (handlerIndex, lowerValue, upperValue) {
            onChanged(lowerValue);
          },
          tooltip: FlutterSliderTooltip(
            custom: (value) {
              return Text(
                '${value.toStringAsFixed(0)}m',
                style: const TextStyle(fontSize: 14),
              );
            },
          ),
          trackBar: FlutterSliderTrackBar(
            activeTrackBarHeight: 12,
            activeTrackBar: BoxDecoration(
              borderRadius: BorderRadius.circular(48),
              gradient: const LinearGradient(
                colors: [Color(0xFF02C39A), Color(0xFF0077B6)],
                stops: [0.0, 1.0],
              ),
            ),
            inactiveTrackBar: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFBDBDBD), Color(0xFFBDBDBD)],
                stops: [0.0, 1.0],
              ),
            ),
          ),
          handler: FlutterSliderHandler(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
