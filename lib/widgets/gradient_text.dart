import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;

  const GradientText(
    this.text, {
    super.key,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF02C39A), Color(0xFF0077B6)],
        ).createShader(bounds);
      },
      child: Text(
        text,
        style: style.apply(
          color: Colors.white,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}
