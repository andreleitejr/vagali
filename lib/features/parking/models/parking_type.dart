import 'package:vagali/models/selectable_item.dart';
import 'package:vagali/theme/coolicons.dart';

class ParkingType extends SelectableItem {
  final String name;
  final String type;
  final String icon;

  ParkingType({
    required this.name,
    required this.type,
    required this.icon,
  });

  // Map<String, dynamic> toMap() {
  //   return {'name': name};
  // }
  //
  // static ParkingType fromMap(Map<String, dynamic> map) {
  //   return ParkingType(name: map['name']);
  // }

  static const all = 'all';
  static const building = 'building';
  static const commercial = 'commercial';
  static const house = 'house';
  static const other = 'other';
  static const public = 'public';
  static const shopping = 'shopping';

  @override
  String get title => name;
}

final List<ParkingType> parkingTypes = [
  ParkingType(
    name: 'Todos',
    type: ParkingType.all,
    icon: Coolicons.mapPin,
  ),
  ParkingType(
    name: 'Casas',
    type: ParkingType.house,
    icon: Coolicons.house,
  ),
  ParkingType(
    name: 'Prédios',
    type: ParkingType.building,
    icon: Coolicons.building,
  ),
  ParkingType(
    name: 'Comerciais',
    type: ParkingType.commercial,
    icon: Coolicons.building4,
  ),
  ParkingType(
    name: 'Shoppings',
    type: ParkingType.shopping,
    icon: Coolicons.shoppingCart,
  ),
  ParkingType(
    name: 'Públicos',
    type: ParkingType.public,
    icon: Coolicons.usersGroup,
  ),
  ParkingType(
    name: 'Outros',
    type: ParkingType.other,
    icon: Coolicons.compass,
  ),
];
