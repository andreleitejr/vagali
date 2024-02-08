import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vagali/apps/tenant/models/tenant.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
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
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ThemeColors.grey2),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Avatar(image: user.image),
            title: Text(
              '${user.firstName} ${user.lastName}',
              style: ThemeTypography.semiBold14,
            ),
            subtitle: Text(
              user is Tenant ? 'Locatário' : 'Locador',
              style: ThemeTypography.regular12,
            ),
            trailing: GestureDetector(
              onTap: () => _makePhoneCall(),
              child: Container(
                decoration: BoxDecoration(
                    color: ThemeColors.grey1,
                    borderRadius: BorderRadius.circular(50)),
                child: Coolicon(
                  padding: const EdgeInsets.all(8),
                  icon: Coolicons.phoneOutline,
                  width: 18,
                ),
              ),
            ),
          ),
          if (message != null && message!.isNotEmpty) ...[
            // const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
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
                    style: ThemeTypography.medium14,
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

  Future<void> _makePhoneCall() async {
    final url = Uri(scheme: 'tel', path: '${user.phone.replaceAll('+55', '')}');

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Não foi possível realizar a ligação para ${user.phone}';
    }
  }
}
