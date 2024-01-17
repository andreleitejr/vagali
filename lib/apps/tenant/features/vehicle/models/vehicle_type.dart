import 'package:vagali/models/selectable_item.dart';
import 'package:vagali/theme/images.dart';

enum VehicleTypeEnum { motorcycle, hatch, sedan, suv, pickup, van, truck }

class VehicleType extends SelectableItem {
  final String name;
  final VehicleTypeEnum type;
  final double height;
  final double width;
  final double depth;
  final String image;

  VehicleType({
    required this.name,
    required this.type,
    required this.height,
    required this.width,
    required this.depth,
    required this.image,
  });


  @override
  String get title => name;
}

final vehicleTypes = <VehicleType>[
  VehicleType(
    name: 'Motocicleta',
    type: VehicleTypeEnum.motorcycle,
    height: 1,
    width: 1,
    depth: 1.5,
    image: Images.motorcycle,
  ),
  VehicleType(
    name: 'Hatch',
    type: VehicleTypeEnum.hatch,
    height: 1,
    width: 1,
    depth: 1.5,
    image: Images.hatch,
  ),
  VehicleType(
    name: 'Sedan',
    type: VehicleTypeEnum.sedan,
    height: 1,
    width: 1,
    depth: 1.5,
    image: Images.sedan,
  ),
  VehicleType(
    name: 'SUV',
    type: VehicleTypeEnum.suv,
    height: 1,
    width: 1,
    depth: 1.5,
    image: Images.suv,
  ),
  VehicleType(
    name: 'Caminhonete',
    type: VehicleTypeEnum.pickup,
    height: 1,
    width: 1,
    depth: 1.5,
    image: Images.pickup,
  ),
  VehicleType(
    name: 'Van',
    type: VehicleTypeEnum.van,
    height: 1,
    width: 1,
    depth: 1.5,
    image: Images.van,
  ),
  VehicleType(
    name: 'Caminhão',
    type: VehicleTypeEnum.truck,
    height: 1,
    width: 1,
    depth: 1.5,
    image: Images.truck,
  ),
];
