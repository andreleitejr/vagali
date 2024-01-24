import 'package:vagali/models/selectable_item.dart';
import 'package:vagali/theme/coolicons.dart';

class ParkingTag extends SelectableItem {
  final String name;
  late final String tag;
  late final String icon;

  ParkingTag({
    this.tag = all,
    required this.name,
    this.icon = Coolicons.house,
  });

  Map<String, dynamic> toMap() {
    return {'name': name};
  }

  static ParkingTag fromMap(Map<String, dynamic> map) {
    return ParkingTag(
      tag: map['tag'],
      name: map['name'],
    );
  }

  @override
  String get title => tag;

  static const all = 'all';
  static const closedGate = 'closedGate';
  static const securityCamera = 'securityCamera';
  static const safeStreet = 'safeStreet';
  static const twentyFourHours = 'twentyFourHours';
  static const easyAccess = 'easyAccess';
  static const coveredParking = 'coveredParking';
  static const illuminatedParking = 'illuminatedParking';
  static const publicTransportationNearby = 'publicTransportationNearby';
  static const elevator = 'elevator';
  static const valetService = 'valetService';
  static const handicappedParking = 'handicappedParking';
  static const loadingAndUnloading = 'loadingAndUnloading';
  static const motorcycleParking = 'motorcycleParking';
  static const valetParking = 'valetParking';
  static const bikeParking = 'bikeParking';
}

final parkingTags = <ParkingTag>[
  ParkingTag(
    tag: ParkingTag.all,
    name: 'Todos',
    icon: Coolicons.house,
  ),
  ParkingTag(
    tag: ParkingTag.closedGate,
    name: 'Portão fechado',
    icon: Coolicons.lock,
  ),
  ParkingTag(
    tag: ParkingTag.securityCamera,
    name: 'Câmeras Segurança',
    icon: Coolicons.camera,
  ),
  ParkingTag(
    tag: ParkingTag.safeStreet,
    name: 'Rua Segura',
    icon: Coolicons.octagonCheck,
  ),
  ParkingTag(
    tag: ParkingTag.twentyFourHours,
    name: '24 horas',
    icon: Coolicons.clock,
  ),
  ParkingTag(
    tag: ParkingTag.easyAccess,
    name: 'Fácil Acesso',
    icon: Coolicons.navigation,
  ),
  ParkingTag(
    tag: ParkingTag.coveredParking,
    name: 'Vaga Coberta',
    icon: Coolicons.house03,
  ),
  ParkingTag(
    tag: ParkingTag.illuminatedParking,
    name: 'Vaga Iluminada',
    icon: Coolicons.light,
  ),
  // ParkingTag(
  //   tag: ParkingTag.publicTransportationNearby,
  //   name: 'Próxima a transporte público',
  //   icon: Coolicons.checkAllBig,
  // ),
  // ParkingTag(
  //   tag: ParkingTag.elevator,
  //   name: 'Elevador',
  //   icon: Coolicons.building4,
  // ),
  // ParkingTag(
  //   tag: ParkingTag.valetService,
  //   name: 'Manobrista',
  //   icon: Coolicons.checkAllBig,
  // ),
  ParkingTag(
    tag: ParkingTag.handicappedParking,
    name: 'Vaga para Cadeirante',
    icon: Coolicons.happy,
  ),
  ParkingTag(
    tag: ParkingTag.loadingAndUnloading,
    name: 'Carga e descarga',
    icon: Coolicons.refresh,
  ),
  // ParkingTag(
  //   tag: ParkingTag.motorcycleParking,
  //   name: 'Estacionamento para motos',
  //   icon: Coolicons.checkAllBig,
  // ),
  // ParkingTag(
  //   tag: ParkingTag.valetParking,
  //   name: 'Estacionamento com valet',
  //   icon: Coolicons.checkAllBig,
  // ),
  ParkingTag(
    tag: ParkingTag.bikeParking,
    name: 'Vaga para bicicletas',
    icon: Coolicons.checkAllBig,
  ),
];
