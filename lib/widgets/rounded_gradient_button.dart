import 'package:flutter/material.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/loader.dart';

class RoundedGradientButton extends StatelessWidget {
  final String actionText;
  final VoidCallback onPressed;
  final bool loading;
  final bool isValid;

  const RoundedGradientButton({
    super.key,
    required this.actionText,
    required this.onPressed,
    this.loading = false,
    this.isValid = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Pegue toda a largura disponível
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100), // Borda arredondada
        gradient: isValid
            ? const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFF02C39A),
                  Color(0xFF0077B6)
                ], // Cores do degradê
              )
            : const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  ThemeColors.grey2,
                  ThemeColors.grey2,
                ], // Cores do degradê
              ),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: loading
            ? const SizedBox(
                height: 24,
                child: Loader(dotColor: Colors.white),
              )
            : Text(
                actionText,
                style: ThemeTypography.semiBold16.apply(color: Colors.white),
              ),
      ),
    );
  }
}
