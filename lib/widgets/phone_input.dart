import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vagali/theme/images.dart';
import 'package:vagali/theme/theme_colors.dart';

class PhoneInput extends StatelessWidget {
  final String value;
  final String? error;
  final bool required;
  final VoidCallback? onSubmit;
  final Function(String) onChanged;

  PhoneInput({
    required this.value,
    this.error,
    this.required = false,
    this.onSubmit,
    required this.onChanged,
  });

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controller.text = value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.phone,
          onEditingComplete: onSubmit,
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF01A9A3),
            fontWeight: FontWeight.w600,
          ),
          inputFormatters: [
            // obrigatório
            FilteringTextInputFormatter.digitsOnly,
            TelefoneInputFormatter(),
          ],
          decoration: InputDecoration(
            hintText: '(11) 99000-0000',
            hintStyle: TextStyle(
              fontSize: 16,
              color: Color(0xFFBDBDBD), // Cor do hint
            ),
            prefixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 16,
                ),
                Image.asset(
                  Images.brazil,
                  width: 24,
                ),
                const SizedBox(
                  width: 8,
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black26,
                ),
              ],
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: ThemeColors.grey2,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: ThemeColors.grey2,
                width: 1,
              ),
            ),
            fillColor: ThemeColors.grey1,
            filled: true,
          ),
          onChanged: onChanged,
        ),
        if (error != null && error!.isNotEmpty) ...[
          Text(
            error!,
            style: TextStyle(color: Colors.red),
          ),
        ],
      ],
    );
  }
}
