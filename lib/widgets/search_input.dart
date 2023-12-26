import 'package:flutter/material.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/theme/theme_colors.dart';
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
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: textEditingController,
              onChanged: widget.onSearch,
              // controller: controller,
              // keyboardType: keyboardType,
              // inputFormatters: inputFormatters,

              style: ThemeTypography.medium16.apply(
                color: ThemeColors.intermediary,
              ),
              cursorColor: ThemeColors.primary,
              cursorWidth: 3,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top: 16),
                hintText: widget.hintText,
                hintStyle: ThemeTypography.regular16.apply(
                  color: ThemeColors.grey3,
                ),
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Coolicon(
                    icon: Coolicons.search,
                    color: ThemeColors.grey3,
                    scale: 1.2,
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
                fillColor: ThemeColors.grey1,
                filled: true,
              ),
            ),
          ),
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(
          //     Icons.filter_list,
          //     color: ThemeColors.grey4,
          //   ),
          // ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}
