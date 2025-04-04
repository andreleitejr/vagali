// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:vagali/features/user/controllers/user_edit_controller.dart';
// import 'package:vagali/features/user/widgets/personal_info_edit_widget.dart';
// import 'package:vagali/repositories/firestore_repository.dart';
// import 'package:vagali/theme/theme_colors.dart';
// import 'package:vagali/theme/theme_typography.dart';
// import 'package:vagali/widgets/snackbar.dart';
// import 'package:vagali/widgets/top_bavigation_bar.dart';
//
// class PersonalInfoEditView extends StatefulWidget {
//   PersonalInfoEditView({super.key});
//
//   @override
//   State<PersonalInfoEditView> createState() => _PersonalInfoEditViewState();
// }
//
// class _PersonalInfoEditViewState extends State<PersonalInfoEditView> {
//   late UserEditController controller;
//
//   @override
//   void initState() {
//     controller = Get.put(UserEditController());
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: TopNavigationBar(
//         title: 'Informaçoes pessoais',
//         actions: [
//           TextButton(
//             onPressed: () async {
//               if (controller.isPersonalInfoValid.isTrue) {
//                 if (controller.imageFile.value != null) {
//                   controller.uploadImage();
//                 }
//
//                 Get.back();
//
//                 final result = await controller.save();
//
//                 if (result != SaveResult.success) {
//                   snackBar(
//                     'Erro ao atualizar',
//                     'Houve um erro ao atualizar',
//                   );
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
//                   color: controller.isPersonalInfoValid.isTrue
//                       ? ThemeColors.primary
//                       : ThemeColors.grey3,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: PersonalInfoEditWidget(
//           controller: controller,
//         ),
//       ),
//     );
//   }
// }
