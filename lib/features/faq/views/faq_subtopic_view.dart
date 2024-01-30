import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/faq/controllers/faq_controller.dart';
import 'package:vagali/features/faq/models/faq_topic.dart';
import 'package:vagali/features/support/views/support_edit_view.dart';
import 'package:vagali/theme/coolicons.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/coolicon.dart';
import 'package:vagali/widgets/flat_button.dart';
import 'package:vagali/widgets/top_bavigation_bar.dart';

class FaqSubtopicView extends StatelessWidget {
  final FaqTopic topic;

  FaqSubtopicView(this.topic);

  final FaqController faqController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigationBar(title: topic.title),
      body: ListView.builder(
        itemCount: topic.subtopics.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(
              topic.subtopics[index].title,
              style: ThemeTypography.medium14,
            ),
            trailing: Coolicon(
              icon: Coolicons.chevronDown,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  topic.subtopics[index].description,
                  maxLines: null,
                ),
              ),
            ],
            onExpansionChanged: (isExpanded) {
              if (isExpanded) {
                faqController.showSubtopicDescription(
                  topic.subtopics[index],
                );
              }
            },
          );
        },
      ),
    );
  }
}
