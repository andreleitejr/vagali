import 'package:vagali/models/selectable_item.dart';
import 'package:vagali/theme/coolicons.dart';

class ParkingTag extends SelectableItem {
  final String name;
  final String icon;

  ParkingTag({required this.name, this.icon = Coolicons.house});

  Map<String, dynamic> toMap() {
    return {'name': name};
  }

  static ParkingTag fromMap(Map<String, dynamic> map) {
    return ParkingTag(name: map['name']);
  }

  @override
  String get title => name;
}

final List<ParkingTag> parkingTags = [
  ParkingTag(name: 'Portão fechado', icon: Coolicons.lock),
  ParkingTag(name: 'Câmeras de segurança', icon: Coolicons.camera),
  ParkingTag(name: 'Rua segura', icon: Coolicons.octagonCheck),
  ParkingTag(name: 'Acesso 24 horas', icon: Coolicons.clock),
  ParkingTag(name: 'Fácil acesso', icon: Coolicons.navigation),
  ParkingTag(name: 'Coberta', icon: Coolicons.house03),
  ParkingTag(name: 'Iluminada', icon: Coolicons.light),
  ParkingTag(name: 'Próxima a transporte público', icon: Coolicons.checkAllBig),
  // ParkingTag(name: 'Elevador', icon: Coolicons.building4),
  // ParkingTag(name: 'Manobrista', icon: Coolicons.checkAllBig),
  ParkingTag(name: 'Vaga para cadeirante', icon: Coolicons.happy),
  ParkingTag(name: 'Carga e descarga', icon: Coolicons.refresh),
  // ParkingTag(name: 'Estacionamento para motos', icon: Coolicons.checkAllBig),
  // ParkingTag(name: 'Estacionamento com valet', icon: Coolicons.checkAllBig),
  // ParkingTag(name: 'Vaga para bicicletas', icon: Coolicons.checkAllBig),
];
