enum VehicleTypeEnum { hatch, sedan, suv, truck, none }

class VehicleType {
  final String title;
  final VehicleTypeEnum type;

  VehicleType(this.title, this.type);
}

final vehicleTypes = <VehicleType>[
  VehicleType(
    'Hatch',
    VehicleTypeEnum.hatch,
  ),
  VehicleType(
    'Sedan',
    VehicleTypeEnum.hatch,
  ),
  VehicleType(
    'SUV',
    VehicleTypeEnum.hatch,
  ),
  VehicleType(
    'Utilitário/Caminhonete',
    VehicleTypeEnum.hatch,
  ),
];
