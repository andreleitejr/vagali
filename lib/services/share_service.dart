import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:vagali/features/parking/models/parking.dart';

class ShareService {
  Future<void> shareParking(Parking parking) async {
    const subject = 'Confira esta vaga';
    final shareText =
        'Olha o que encontrei pra você: ${parking.name} localizada em ${parking.address.street}, ${parking.address.city}';

    try {
      await Share.share(subject: subject, shareText);
    } catch (e) {
      print('Erro ao compartilhar: $e');
    }
  }

// Future<void> handleDeepLink() async {
//   try {
//     final initialLink = await getInitialLink();
//     if (initialLink != null) {
//       // Analise o deep link e direcione o usuário para a entidade correspondente
//       // com base nas informações do link.
//       // Exemplo de análise de link: final entityId = ...;
//     }
//   } on PlatformException {
//     // Lidar com erros ao processar o link
//   }
// }
}
