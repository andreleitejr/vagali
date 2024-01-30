import 'package:flutter/material.dart';
import 'package:vagali/apps/landlord/features/parking/models/parking_tag.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/coolicon.dart';

class TagList extends StatelessWidget {
  final List<ParkingTag> tags;

  const TagList({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: Stack(
        children: [
          ListView(
            scrollDirection: Axis.horizontal,
            children: tags.map((tag) {
              final filteredTag =
                  parkingTags.firstWhere((t) => t.tag == tag.tag);
              return Row(
                children: [
                  if (tag == tags.first) const SizedBox(width: 16),
                  Chip(
                    backgroundColor: ThemeColors.grey1,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    label: Row(
                      children: [
                        Coolicon(
                          icon: filteredTag.icon,
                          width: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          filteredTag.name,
                          style: ThemeTypography.regular12.apply(
                            color: ThemeColors.grey4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (tag == tags.last) const SizedBox(width: 8),
                ],
              );
            }).toList(),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            top: 0,
            child: Container(
              width: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.05),
                    Colors.white,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
