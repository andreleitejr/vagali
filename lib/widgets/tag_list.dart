import 'package:flutter/material.dart';
import 'package:vagali/features/parking/models/parking_tag.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/theme/theme_colors.dart';
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
              final icon =
                  parkingTags.firstWhere((t) => t.name == tag.name).icon;
              return Row(
                children: [
                  if (tag == tags.first) const SizedBox(width: 16),
                  Chip(
                    backgroundColor: ThemeColors.grey1,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    label: Row(
                      children: [
                        Coolicon(
                          icon: icon,
                          scale: 1.3,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          tag.name,
                          style: ThemeTypography.semiBold14.apply(
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
