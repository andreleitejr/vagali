import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vagali/features/user/controllers/user_edit_controller.dart';
import 'package:vagali/features/user/models/gender.dart';
import 'package:vagali/utils/extensions.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/widgets/bottom_sheet.dart';
import 'package:vagali/widgets/date_input.dart';
import 'package:vagali/widgets/dropdown.dart';
import 'package:vagali/widgets/image_button.dart';
import 'package:vagali/widgets/image_picker_bottom_sheet.dart';
import 'package:vagali/widgets/input.dart';
import 'package:vagali/widgets/input_button.dart';

class PersonalInfoEditWidget extends StatelessWidget {
  final UserEditController controller;

  PersonalInfoEditWidget({super.key, required this.controller});

  final FocusNode firstNameFocus = FocusNode();
  final FocusNode lastNameFocus = FocusNode();
  final FocusNode documentFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode genderFocus = FocusNode();
  final FocusNode birthdayFocus = FocusNode();

  // final firstNameController = TextEditingController();
  // final lastNameController = TextEditingController();
  // final documentController = TextEditingController();
  // final emailController = TextEditingController();
  // final genderController = TextEditingController();
  // final birthdayController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final focus = FocusScope.of(context);
    return ListView(
      children: [
        const SizedBox(height: 32),
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageButton(
                imageUrl: controller.currentUser.value?.image.image ??
                    controller.imageFile.value?.path,
                imageSize: 100,
                imageDataSource: controller.hasCurrentUser.isTrue
                    ? ImageDataSource.network
                    : ImageDataSource.asset,
                onPressed: () async {
                  final source = await showImagePickerBottomSheet(context);

                  if (source != null) {
                    await controller.pickImage(source);

                    await Future.delayed(const Duration(milliseconds: 500));
                    focus.requestFocus(firstNameFocus);
                  }
                },
              ),
            ],
          ),
        ),
        Obx(() {
          if (controller.imageBlurhash.value != null) {
            return Container();
          }
          return Column(
            children: [
              const SizedBox(height: 8),
              Text(
                'Tire uma foto',
                style: ThemeTypography.regular14.apply(
                  color: controller.isImageValid.isTrue ||
                          controller.showErrors.isFalse
                      ? ThemeColors.primary
                      : ThemeColors.red,
                ),
              ),
            ],
          );
        }),
        const SizedBox(height: 32),
        Obx(
          () => Input(
            enabled:  controller.hasCurrentUser.isFalse,
            onChanged: controller.firstNameController,
            hintText: 'Nome',
            keyboardType: TextInputType.name,
            error: controller.getError(controller.firstNameError),
            currentFocusNode: firstNameFocus,
            nextFocusNode: lastNameFocus,
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => Input(
            enabled:  controller.hasCurrentUser.isFalse,
            onChanged: controller.lastNameController,
            hintText: 'Sobrenome',
            keyboardType: TextInputType.name,
            error: controller.getError(controller.lastNameError),
            currentFocusNode: lastNameFocus,
            nextFocusNode: documentFocus,
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => Input(
            enabled:  controller.hasCurrentUser.isFalse,
            onChanged: controller.documentController,
            hintText: 'Document',
            keyboardType: TextInputType.number,
            error: controller.getError(controller.documentError),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CpfInputFormatter(),
            ],
            currentFocusNode: documentFocus,
            nextFocusNode: emailFocus,
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => Input(
            onChanged: controller.emailController,
            hintText: 'Email',
            keyboardType: TextInputType.emailAddress,
            error: controller.getError(controller.emailError),
            currentFocusNode: emailFocus,
            onSubmit: () {
              emailFocus.unfocus();
              showGenderBottomSheet(context, controller);
            },
          ),
        ),
        const SizedBox(height: 16),
        InputButton(
          onChanged: controller.genderController,
          hintText: 'Qual seu gênero?',
          onTap: () => showGenderBottomSheet(context, controller),
        ),
        const SizedBox(height: 16),
        Obx(
          () => DateInput(
            date: controller.birthday.value,
            dateInputType: DateInputType.birthday,
            hintText: 'Data de aniversário',
            error: controller.getError(controller.birthdayError),
            onDateSelected: controller.birthday,
          ),
        ),
      ],
    );
  }
}

void showGenderBottomSheet(
    BuildContext context, UserEditController controller) {
  final focus = FocusScope.of(context);

  Get.bottomSheet(
    CustomBottomSheet(
      items: genders.map((gender) => gender.toReadableGender).toList(),
      title: 'Qual seu gênero?',
      onItemSelected: (selectedItem) async {
        controller.genderController.value = selectedItem;
        focus.unfocus();

        await Future.delayed(const Duration(milliseconds: 100));

        final birthday = await selectDateTime(
          context,
          DateInputType.birthday,
          showTime: false,
        );
        if (birthday != null) {
          controller.birthday.value = birthday;
        }
      },
    ),
    enableDrag: true,
  );
}
