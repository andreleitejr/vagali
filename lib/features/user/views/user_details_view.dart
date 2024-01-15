// import 'package:brasil_fields/brasil_fields.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:vagali/features/user/controllers/user_edit_controller.dart';
// import 'package:vagali/features/user/models/user.dart';
// import 'package:vagali/features/user/widgets/personal_info_edit_widget.dart';
// import 'package:vagali/repositories/firestore_repository.dart';
// import 'package:vagali/theme/theme_colors.dart';
// import 'package:vagali/theme/theme_typography.dart';
// import 'package:vagali/widgets/date_input.dart';
// import 'package:vagali/widgets/image_button.dart';
// import 'package:vagali/widgets/image_picker_bottom_sheet.dart';
// import 'package:vagali/widgets/input.dart';
// import 'package:vagali/widgets/input_button.dart';
// import 'package:vagali/widgets/top_bavigation_bar.dart';
//
// class UserDetailsView extends StatefulWidget {
//   final User user;
//
//   const UserDetailsView({super.key, required this.user});
//
//   @override
//   State<UserDetailsView> createState() => _UserDetailsViewState();
// }
//
// class _UserDetailsViewState extends State<UserDetailsView> {
//   late UserEditController controller;
//
//   @override
//   void initState() {
//     controller = Get.put(
//       UserEditController(
//         widget.user.type,
//         user: widget.user,
//       ),
//     );
//     super.initState();
//   }
//
//   final FocusNode firstNameFocus = FocusNode();
//   final FocusNode lastNameFocus = FocusNode();
//   final FocusNode documentFocus = FocusNode();
//   final FocusNode emailFocus = FocusNode();
//   final FocusNode genderFocus = FocusNode();
//   final FocusNode birthdayFocus = FocusNode();
//
//   @override
//   Widget build(BuildContext context) {
//     final focus = FocusScope.of(context);
//
//     return Scaffold(
//       appBar: TopNavigationBar(
//         title: 'Editar Usuário',
//         actions: [
//           TextButton(
//             onPressed: () async {
//               if (controller.isValid.isTrue) {
//                 if (controller.imageFile.value != null) {
//                   await controller.uploadImage();
//                 }
//                 final result = await controller.save();
//                 if (result == SaveResult.success) {
//                   Get.back();
//                 }
//               } else {
//                 controller.showErrors(true);
//                 debugPrint('Is Invalid.');
//               }
//             },
//             child: Obx(
//               () => Text(
//                 'Salvar',
//                 style: ThemeTypography.medium14.apply(
//                   color: controller.isValid.isTrue
//                       ? ThemeColors.primary
//                       : ThemeColors.grey4,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: ListView(
//         children: [
//           const SizedBox(height: 32),
//           Obx(
//             () => Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ImageButton(
//                   imageUrl: controller.imageFile.value?.path,
//                   imageSize: 100,
//                   imageDataSource: controller.imageFile.value != null
//                       ? ImageDataSource.asset
//                       : ImageDataSource.network,
//                   onPressed: () async {
//                     final source = await showImagePickerBottomSheet(context);
//
//                     if (source != null) {
//                       await controller.pickImage(source);
//
//                       await Future.delayed(const Duration(milliseconds: 500));
//                       focus.requestFocus(firstNameFocus);
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//           Obx(() {
//             if (controller.imageBlurhash.value != null) {
//               return Container();
//             }
//             return Column(
//               children: [
//                 const SizedBox(height: 8),
//                 Text(
//                   'Tire uma foto',
//                   style: ThemeTypography.regular14.apply(
//                     color: controller.isImageValid.isTrue ||
//                             controller.showErrors.isFalse
//                         ? ThemeColors.primary
//                         : ThemeColors.red,
//                   ),
//                 ),
//               ],
//             );
//           }),
//           const SizedBox(height: 32),
//           Obx(
//             () => Input(
//               enabled: false,
//               controller: controller.firstNameController,
//               hintText: 'Nome',
//               keyboardType: TextInputType.name,
//               error: controller.getError(controller.firstNameError),
//               currentFocusNode: firstNameFocus,
//               nextFocusNode: lastNameFocus,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Obx(
//             () => Input(
//               enabled: false,
//               controller: lastNameController,
//               hintText: 'Sobrenome',
//               keyboardType: TextInputType.name,
//               error: controller.getError(controller.lastNameError),
//               currentFocusNode: lastNameFocus,
//               nextFocusNode: documentFocus,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Obx(
//             () => Input2(
//               enabled: false,
//               controller: documentController,
//               value: controller.document.value,
//               hintText: 'Document',
//               keyboardType: TextInputType.number,
//               error: controller.getError(controller.documentError),
//               inputFormatters: [
//                 FilteringTextInputFormatter.digitsOnly,
//                 CpfInputFormatter(),
//               ],
//               currentFocusNode: documentFocus,
//               nextFocusNode: emailFocus,
//               onChanged: controller.document,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Obx(
//             () => Input2(
//               controller: emailController,
//               value: controller.email.value,
//               hintText: 'Email',
//               keyboardType: TextInputType.emailAddress,
//               error: controller.getError(controller.emailError),
//               currentFocusNode: emailFocus,
//               onSubmit: () {
//                 emailFocus.unfocus();
//                 showGenderBottomSheet(context, controller);
//               },
//               onChanged: controller.email,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Obx(
//             () => InputButton2(
//               controller: genderController,
//               value: controller.gender.value,
//               hintText: 'Qual seu gênero?',
//               onTap: () => showGenderBottomSheet(context, controller),
//               onSelected: controller.gender,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Obx(
//             () => DateInput(
//               value: controller.birthday.value!,
//               controller: birthdayController,
//               // enabled: false,
//               dateInputType: DateInputType.birthday,
//               hintText: 'Data de aniversário',
//               // onTap: () async {
//               //   final birthday = await selectDateTime(
//               //     context,
//               //     DateInputType.birthday,
//               //   );
//               //   controller.birthday.value = birthday.toString();
//               //
//               //   FocusScope.of(context).requestFocus(FocusNode());
//               // },
//               error: controller.getError(controller.birthdayError),
//               onDateSelected: controller.birthday,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
