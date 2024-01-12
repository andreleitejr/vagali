import 'package:flutter/material.dart';
import 'package:vagali/theme/images.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';

class EmptyList extends StatelessWidget {
  const EmptyList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Opacity(
          opacity: 0.75,
          child: Image.asset(
            Images.empty,
            width: MediaQuery.of(context).size.width * 0.6,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          'Sua garagem está vazia',
          style: ThemeTypography.semiBold14.apply(
            color: ThemeColors.grey4,
          ),
        ),
      ],
    );
  }
}
