import 'package:flutter/material.dart';
import 'package:vagali/features/item/models/item.dart';
import 'package:vagali/features/item/models/vehicle.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';

class ItemListItem extends StatelessWidget {
  final Item item;

  const ItemListItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: ThemeColors.grey2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(96),
                  image: DecorationImage(
                    image: NetworkImage(item.image.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.type,
                      style: ThemeTypography.semiBold16,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (item.description != null)
                          Text(
                            item.description!,
                            style: ThemeTypography.regular14,
                          ),
                        const SizedBox(width: 8),
                        Container(
                          height: 4,
                          width: 4,
                          decoration: BoxDecoration(
                              color: ThemeColors.grey4,
                              borderRadius: BorderRadius.circular(4)),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Cor: ${item.createdAt}',
                          style: ThemeTypography.regular14,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
