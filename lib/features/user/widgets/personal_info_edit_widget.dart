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

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final documentController = TextEditingController();
  final emailController = TextEditingController();
  final genderController = TextEditingController();
  final birthdayController = TextEditingController();

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
                imageUrl: controller.imageFile.value?.path,
                imageSize: 100.0,
                imageDataSource: ImageDataSource.asset,
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
          () => Input2(
            controller: firstNameController,
            value: controller.firstName.value,
            hintText: 'Nome',
            keyboardType: TextInputType.name,
            error: controller.getError(controller.firstNameError),
            currentFocusNode: firstNameFocus,
            nextFocusNode: lastNameFocus,
            onChanged: controller.firstName,
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => Input2(
            controller: lastNameController,
            value: controller.lastName.value,
            hintText: 'Sobrenome',
            keyboardType: TextInputType.name,
            error: controller.getError(controller.lastNameError),
            currentFocusNode: lastNameFocus,
            nextFocusNode: documentFocus,
            onChanged: controller.lastName,
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => Input2(
            controller: documentController,
            value: controller.document.value,
            hintText: 'Document',
            keyboardType: TextInputType.number,
            error: controller.getError(controller.documentError),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CpfInputFormatter(),
            ],
            currentFocusNode: documentFocus,
            nextFocusNode: emailFocus,
            onChanged: controller.document,
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => Input2(
            controller: emailController,
            value: controller.email.value,
            hintText: 'Email',
            keyboardType: TextInputType.emailAddress,
            error: controller.getError(controller.emailError),
            currentFocusNode: emailFocus,
            onSubmit: () {
              emailFocus.unfocus();
              _showGenderBottomSheet(context);
            },
            onChanged: controller.email,
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => InputButton2(
            controller: genderController,
            value: controller.gender.value,
            hintText: 'Qual seu gênero?',
            onTap: () => _showGenderBottomSheet(context),
            onSelected: controller.gender,
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => DateInput(
            value: controller.birthday.value,
            controller: birthdayController,
            // enabled: false,
            dateInputType: DateInputType.birthday,
            // value: controller.birthday.value,
            // keyboardType: TextInputType.datetime,
            hintText: 'Data de aniversário',
            // onTap: () async {
            //   final birthday = await selectDateTime(
            //     context,
            //     DateInputType.birthday,
            //   );
            //   controller.birthday.value = birthday.toString();
            //
            //   FocusScope.of(context).requestFocus(FocusNode());
            // },
            error: controller.getError(controller.birthdayError),
            // onChanged: controller.birthday,
            onDateSelected: (date){
              controller.birthday(date.toString());
            }
          ),
        ),
      ],
    );
  }

  void _showGenderBottomSheet(BuildContext context) {
    final focus = FocusScope.of(context);

    Get.bottomSheet(
      CustomBottomSheet(
        items: genders.map((gender) => gender.toReadableGender).toList(),
        title: 'Qual seu gênero?',
        onItemSelected: (selectedItem) async {
          controller.gender.value = selectedItem;
          focus.unfocus();

          await Future.delayed(const Duration(milliseconds: 100));

          final birthday = await selectDateTime(
            context,
            DateInputType.birthday,
            showTime: false,
          );
          if (birthday != null) {
            controller.birthday.value =
                birthday.toMonthlyAndYearFormattedString();
            controller.birthdayDate(birthday);
          }
        },
      ),
      enableDrag: true,
    );
  }
}
