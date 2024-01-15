import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/user/controllers/user_edit_controller.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/features/user/widgets/personal_info_edit_widget.dart';
import 'package:vagali/repositories/firestore_repository.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/top_bavigation_bar.dart';

class PersonalInfoEditView extends StatefulWidget {
  final User user;

  PersonalInfoEditView({super.key, required this.user});

  @override
  State<PersonalInfoEditView> createState() => _PersonalInfoEditViewState();
}

class _PersonalInfoEditViewState extends State<PersonalInfoEditView> {
  late UserEditController controller;

  @override
  void initState() {
    controller = Get.put(
      UserEditController(
        widget.user.type,
        user: widget.user,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigationBar(
        title: 'Informaçoes pessoais',
        actions: [
          TextButton(
            onPressed: () async {
              if (controller.isPersonalInfoValid.isTrue) {
                if (controller.imageFile.value != null) {
                  await controller.uploadImage();
                }

                final result = await controller.save();

                if (result == SaveResult.success) {
                  Get.back();
                }
              } else {
                controller.showErrors(true);
                debugPrint('Is Invalid.');
              }
            },
            child: Text(
              'Salvar',
              style: ThemeTypography.medium14.apply(
                color: controller.isValid.isTrue
                    ? ThemeColors.primary
                    : ThemeColors.grey3,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: PersonalInfoEditWidget(
          controller: controller,
        ),
      ),
    );
  }
}
