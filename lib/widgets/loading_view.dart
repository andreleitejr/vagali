import 'package:flutter/material.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/gradient_text.dart';
import 'package:vagali/widgets/loader.dart';

class LoadingView extends StatefulWidget {
  final String message;

  const LoadingView({super.key, required this.message});

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Loader(),
            const SizedBox(height: 16),
            GradientText(
              widget.message,
              style: ThemeTypography.semiBold14,
            )
          ],
        ));
  }
}
