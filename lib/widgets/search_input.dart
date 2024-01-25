import 'package:flutter/material.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/coolicon.dart';

class SearchInput extends StatefulWidget {
  final String searchText;
  final Function(String) onSearch;
  final String hintText;

  const SearchInput({
    super.key,
    required this.searchText,
    required this.hintText,
    required this.onSearch,
  });

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  final textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textEditingController.text = widget.searchText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      onChanged: widget.onSearch,
      style: ThemeTypography.regular14.apply(color: ThemeColors.primary),
      cursorColor: ThemeColors.primary,
      cursorWidth: 2,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.zero,
        hintText: widget.hintText,
        hintStyle: ThemeTypography.regular14.apply(color: ThemeColors.grey4),
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 8),
          child: Coolicon(
            icon: Coolicons.search,
            color: ThemeColors.grey4,
            height: 20,
          ),
        ),
        suffix: widget.searchText.isNotEmpty
            ? TextButton(
                onPressed: () {
                  widget.onSearch('');
                  textEditingController.text = '';
                },
                child: Text(
                  'Limpar',
                  style: ThemeTypography.regular12.apply(
                    color: ThemeColors.primary,
                  ),
                ),
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: const BorderSide(
            color: ThemeColors.grey2,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: const BorderSide(
            color: ThemeColors.grey2,
            width: 1,
          ),
        ),
        // fillColor: ThemeColors.grey1,
        // filled: true,
      ),
    );
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}
