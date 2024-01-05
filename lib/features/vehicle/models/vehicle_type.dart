import 'package:vagali/theme/images.dart';

enum VehicleTypeEnum { hatch, sedan, suv, truck, motorcycle, none }

class VehicleType {
  final String title;
  final VehicleTypeEnum type;
  final double height;
  final double width;
  final double depth;
  final String image;

  VehicleType({
    required this.title,
    required this.type,
    required this.height,
    required this.width,
    required this.depth,
    required this.image,
  });
}

final vehicleTypes = <VehicleType>[
  VehicleType(
    title: 'Motocicleta',
    type: VehicleTypeEnum.motorcycle,
    height: 1,
    width: 1,
    depth: 1.5,
    image: Images.motorcycle,
  ),
  VehicleType(
    title: 'Hatch',
    type: VehicleTypeEnum.hatch,
    height: 1,
    width: 1,
    depth: 1.5,
    image: Images.hatch,
  ),
  VehicleType(
    title: 'Sedan',
    type: VehicleTypeEnum.sedan,
    height: 1,
    width: 1,
    depth: 1.5,
    image: Images.sedan,
  ),
  VehicleType(
    title: 'SUV',
    type: VehicleTypeEnum.suv,
    height: 1,
    width: 1,
    depth: 1.5,
    image: Images.suv,
  ),
  VehicleType(
    title: 'Caminhonete',
    type: VehicleTypeEnum.truck,
    height: 1,
    width: 1,
    depth: 1.5,
    image: Images.truck,
  ),
];
