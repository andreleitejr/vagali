import 'package:vagali/models/dimension.dart';
import 'package:vagali/models/selectable_item.dart';
import 'package:vagali/theme/images.dart';

enum VehicleTypeEnum { motorcycle, hatch, sedan, suv, pickup, van, truck }

class VehicleType extends SelectableItem {
  final String name;
  final VehicleTypeEnum type;
  final Dimension dimension;
  final String image;

  VehicleType({
    required this.name,
    required this.type,
    required this.dimension,
    required this.image,
  });

  @override
  String get title => name;
}

final vehicleTypes = <VehicleType>[
  VehicleType(
    name: 'Motocicleta',
    type: VehicleTypeEnum.motorcycle,
    dimension: Dimension(1, 1, 1.5),
    image: Images.motorcycle,
  ),
  VehicleType(
    name: 'Hatch',
    type: VehicleTypeEnum.hatch,
    dimension: Dimension(1, 1, 1.5),
    image: Images.hatch,
  ),
  VehicleType(
    name: 'Sedan',
    type: VehicleTypeEnum.sedan,
    dimension: Dimension(1, 1, 1.5),
    image: Images.sedan,
  ),
  VehicleType(
    name: 'SUV',
    type: VehicleTypeEnum.suv,
    dimension: Dimension(1, 1, 1.5),
    image: Images.suv,
  ),
  VehicleType(
    name: 'Caminhonete',
    type: VehicleTypeEnum.pickup,
    dimension: Dimension(1, 1, 1.5),
    image: Images.pickup,
  ),
  VehicleType(
    name: 'Van',
    type: VehicleTypeEnum.van,
    dimension: Dimension(1, 1, 1.5),
    image: Images.van,
  ),
  VehicleType(
    name: 'Caminhão',
    type: VehicleTypeEnum.truck,
    dimension: Dimension(1, 1, 1.5),
    image: Images.truck,
  ),
];
