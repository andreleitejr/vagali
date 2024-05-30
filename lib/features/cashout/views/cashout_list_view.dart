import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/cashout/controllers/cashout_edit_controller.dart';
import 'package:vagali/features/cashout/controllers/cashout_list_controller.dart';
import 'package:vagali/features/cashout/models/cashout.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/utils/extensions.dart';
import 'package:vagali/widgets/top_bavigation_bar.dart';

class CashOutListView extends StatelessWidget {
  CashOutListView({super.key});

  final CashOutController _controller = Get.put(CashOutController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigationBar(
        title: 'Meus saques',
      ),
      body: Obx(
        () {
          if (_controller.cashOuts.isEmpty) {
            return Center(
              child: Text('Sem saques disponíveis.'),
            );
          } else {
            return ListView.builder(
              itemCount: _controller.cashOuts.length,
              itemBuilder: (context, index) {
                final cashOut = _controller.cashOuts[index];
                return _buildCashOutItem(cashOut);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildCashOutItem(CashOut cashOut) {
    return ListTile(
      title: RichText(
        text: TextSpan(
          text: 'Valor: ',
          style: ThemeTypography.semiBold14.apply(color: Colors.black),
          children: [
            TextSpan(
              text: '${UtilBrasilFields.obterReal(cashOut.amount)}',
              style: ThemeTypography.regular16,
            ),
          ],
        ),
      ),
      subtitle: Text('Status: ${cashOut.status.message}'),
    );
  }
}
