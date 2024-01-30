import 'package:get/get.dart';
import 'package:vagali/features/faq/models/faq_subtopic.dart';
import 'package:vagali/features/faq/models/faq_topic.dart';

class FaqController extends GetxController {
  var topics = <FaqTopic>[
    FaqTopic(
      title: 'Pagamentos',
      subtopics: [
        FaqSubtopic(
          title: 'Pergunta I',
          description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        ),
        FaqSubtopic(
          title: 'Como usar este aplicativo?',
          description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        ),
      ],
    ),
    FaqTopic(
      title: 'Cancelamentos',
      subtopics: [
        FaqSubtopic(
          title: 'Pergunta II',
          description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        ),
        FaqSubtopic(
          title: 'Como usar este aplicativo?',
          description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        ),
      ],
    ),
    // Adicionar mais tópicos e sub-tópicos conforme necessário
  ].obs;

  final selectedSubtopic = ''.obs;

  void showSubtopicDescription(FaqSubtopic subtopic) {
    selectedSubtopic.value = subtopic.description;
  }
}
