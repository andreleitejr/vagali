import 'dart:math';

import 'package:vagali/features/vehicle/models/vehicle_type.dart';

class GarageService {
  List<VehicleTypeEnum> getCompatibleCarTypes(
      double height, double width, double depth) {
    final carTypes = <VehicleTypeEnum>[];

    if (height >= 1.5 && width >= 1.7 && depth >= 4.5) {
      carTypes.add(VehicleTypeEnum.truck);
      carTypes.add(VehicleTypeEnum.suv);
      carTypes.add(VehicleTypeEnum.sedan);
      carTypes.add(VehicleTypeEnum.hatch);
    } else if (height >= 1.4 && width >= 1.5 && depth >= 4.0) {
      carTypes.add(VehicleTypeEnum.suv);
      carTypes.add(VehicleTypeEnum.sedan);
      carTypes.add(VehicleTypeEnum.hatch);
    } else if (height >= 1.3 && width >= 1.4 && depth >= 3.5) {
      carTypes.add(VehicleTypeEnum.sedan);
      carTypes.add(VehicleTypeEnum.hatch);
    } else if (height >= 1.2 && width >= 1.3 && depth >= 3.0) {
      carTypes.add(VehicleTypeEnum.hatch);
    } else {
      carTypes.add(VehicleTypeEnum.none);
    }

    return carTypes;
  }
}
