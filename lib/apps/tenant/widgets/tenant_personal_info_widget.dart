import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vagali/apps/landlord/controllers/landlord_edit_controller.dart';
import 'package:vagali/apps/tenant/controllers/tenant_edit_controller.dart';
import 'package:vagali/features/user/controllers/user_edit_controller.dart';
import 'package:vagali/features/user/models/gender.dart';
import 'package:vagali/theme/theme_colors.dart';
import 'package:vagali/theme/theme_typography.dart';
import 'package:vagali/widgets/bottom_sheet.dart';
import 'package:vagali/widgets/date_input.dart';
import 'package:vagali/widgets/image_button.dart';
import 'package:vagali/widgets/image_picker_bottom_sheet.dart';
import 'package:vagali/widgets/input.dart';
import 'package:vagali/widgets/input_button.dart';

class TenantPersonalInfoWidget extends StatelessWidget {
  final TenantEditController controller;

  TenantPersonalInfoWidget({super.key, required this.controller});

  final FocusNode firstNameFocus = FocusNode();
  final FocusNode lastNameFocus = FocusNode();
  final FocusNode documentFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode genderFocus = FocusNode();
  final FocusNode birthdayFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final focus = FocusScope.of(context);
    return Obx(() {
      if(controller.loading.isTrue){
        return Container();
      }
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
                  () {
                return Input(
                  initialValue: controller.firstNameController.value,
                  enabled: controller.hasCurrentUser.isFalse,
                  onChanged: controller.firstNameController,
                  hintText: 'Nome',
                  keyboardType: TextInputType.name,
                  error: controller.getError(controller.firstNameError),
                  currentFocusNode: firstNameFocus,
                  nextFocusNode: lastNameFocus,
                );
              }
          ),
          const SizedBox(height: 16),
          Obx(
                () => Input(
              initialValue: controller.lastNameController.value,
              enabled: controller.hasCurrentUser.isFalse,
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
              initialValue: controller.documentController.value,
              enabled: controller.hasCurrentUser.isFalse,
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
              initialValue: controller.emailController.value,
              onChanged: controller.emailController,
              hintText: 'Email',
              keyboardType: TextInputType.emailAddress,
              error: controller.getError(controller.emailError),
              currentFocusNode: emailFocus,
              onSubmit: () {
                emailFocus.unfocus();
                if(controller.currentUser.value == null){
                  showGenderBottomSheet(context);
                }
              },
            ),
          ),
          const SizedBox(height: 16),
          InputButton(
            controller: controller.genderController,
            hintText: 'Qual seu gênero?',
            onTap: () => showGenderBottomSheet(context),
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
    });
  }

  void showGenderBottomSheet(BuildContext context) {
    final focus = FocusScope.of(context);

    Get.bottomSheet(
      CustomBottomSheet<Gender>(
        items: genders,
        title: 'Qual seu gênero?',
        onItemSelected: (selectedItem) async {
          controller.genderController.text = selectedItem.title;
          focus.unfocus();

          await Future.delayed(const Duration(milliseconds: 100));

          if (controller.currentUser.value == null) {
            final birthday = await selectDateTime(
              context,
              DateInputType.birthday,
              showTime: false,
            );
            if (birthday != null) {
              controller.birthday.value = birthday;
            }
          }
        },
      ),
      enableDrag: true,
    );
  }
}

class GenderSelectionInpu extends StatelessWidget {
  const GenderSelectionInpu({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
