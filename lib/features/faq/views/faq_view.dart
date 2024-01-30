import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/config/widgets/config_list_tile.dart';
import 'package:vagali/features/faq/controllers/faq_controller.dart';
import 'package:vagali/features/faq/views/faq_subtopic_view.dart';
import 'package:vagali/features/support/views/support_edit_view.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/flat_button.dart';
import 'package:vagali/widgets/top_bavigation_bar.dart';

class FaqView extends StatelessWidget {
  final FaqController faqController = Get.put(FaqController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigationBar(
        title: 'Perguntas frequentes',
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: faqController.topics.length,
              itemBuilder: (context, index) {
                final topic = faqController.topics[index];

                return ConfigListTile(
                  title: topic.title,
                  onTap: () => Get.to(() => FaqSubtopicView(topic)),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  "Não encontrou o que estava buscando?",
                  style: ThemeTypography.regular12,
                ),
                SizedBox(height: 12),
                FlatButton(
                  onPressed: () => Get.to(() => SupportEditView()),
                  actionText: 'Solicitar suporte',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
