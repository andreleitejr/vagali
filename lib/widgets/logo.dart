import 'package:flutter/material.dart';
import 'package:vagali/theme/images.dart';

class Logo extends StatelessWidget {
  final double width;

  final bool hasDarkBackground;

  const Logo({super.key, this.width = 80, this.hasDarkBackground = false});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      hasDarkBackground ? Images.logoWhite : Images.logo,
      width: width,
    );
  }
}
