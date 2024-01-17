import 'package:flutter/material.dart';
import 'package:vagali/apps/tenant/features/vehicle/models/vehicle.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/title_with_icon.dart';

class VehicleInfoWidget extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleInfoWidget({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: ThemeColors.grey2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWithIcon(
            title: 'Detalhes do veículo',
            icon: Coolicons.car,
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(96),
                  image: DecorationImage(
                    image: NetworkImage(vehicle.image.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      vehicle.model,
                      style: ThemeTypography.semiBold14,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'Placa: ${vehicle.licensePlate}',
                          style: ThemeTypography.regular12,
                        ),
                        const SizedBox(width: 6),
                        Container(
                          height: 4,
                          width: 4,
                          decoration: BoxDecoration(
                            color: ThemeColors.grey4,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Cor: ${vehicle.color}',
                          style: ThemeTypography.regular12,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
