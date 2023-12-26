import 'package:flutter/material.dart';

class SwitchButton extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  SwitchButton({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      child: Container(
        width: 50,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), // Borda circular
          gradient: LinearGradient(
            // Gradiente de cores
            colors: [
              value ? Color(0xFF02C39A) : Color(0xFFBDBDBD),
              // Cores condicionais
              value ? Color(0xFF0077B6) : Color(0xFFBDBDBD),
              // Cores condicionais
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: value
              ? MainAxisAlignment.end
              : MainAxisAlignment.start, // Alinhamento do círculo
          children: [
            Container(
              width: 25, // Tamanho do círculo
              height: 25, // Tamanho do círculo
              margin: EdgeInsets.all(2), // Margem para espaçamento interno
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Forma circular
                color: Colors.white, // Cor do círculo
              ),
            ),
          ],
        ),
      ),
    );
  }
}
