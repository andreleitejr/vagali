import 'package:flutter/material.dart';
import 'package:vagali/features/tenant/models/tenant.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/widgets/coolicon.dart';

import 'avatar.dart';

class UserCard extends StatelessWidget {
  final User user;
  final String? message;

  const UserCard({
    super.key,
    required this.user,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ThemeColors.grey2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.35),
            spreadRadius: -8,
            blurRadius: 20,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            leading: Avatar(image: user.image),
            title: Text(
              '${user.firstName} ${user.lastName}',
              style: ThemeTypography.semiBold16,
            ),
            subtitle: Text(
              user is Tenant ? 'Locatário' : 'Locador',
              style: ThemeTypography.regular12,
            ),
            trailing: Coolicon(
              onTap: () {},
              padding: const EdgeInsets.all(8),
              icon: Coolicons.userSquare,
            ),
          ),
          if (message != null) ...[
            // const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: ThemeColors.grey2,
                  ),
                ),
              ),
              child: Row(
                children: [
                  const Text(
                    'Mensagem do usuário: ',
                    style: ThemeTypography.semiBold14,
                  ),
                  Text(
                    message!,
                    style: ThemeTypography.regular14,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
