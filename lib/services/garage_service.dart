import 'package:vagali/features/vehicle/models/vehicle_type.dart';

class GarageService {
  List<VehicleType> getCompatibleCarTypes(
    double heightInCentimeters,
    double widthInCentimeters,
    double depthInCentimeters,
  ) {
    final carTypes = <VehicleType>[];

    final motorcycle = vehicleTypes
        .firstWhere((vehicle) => vehicle.type == VehicleTypeEnum.motorcycle);

    final hatch = vehicleTypes
        .firstWhere((vehicle) => vehicle.type == VehicleTypeEnum.hatch);

    final sedan = vehicleTypes
        .firstWhere((vehicle) => vehicle.type == VehicleTypeEnum.sedan);

    final suv = vehicleTypes
        .firstWhere((vehicle) => vehicle.type == VehicleTypeEnum.suv);

    final pickup = vehicleTypes
        .firstWhere((vehicle) => vehicle.type == VehicleTypeEnum.pickup);

    final van = vehicleTypes
        .firstWhere((vehicle) => vehicle.type == VehicleTypeEnum.van);

    if (heightInCentimeters >= 600 &&
        widthInCentimeters >= 400 &&
        depthInCentimeters >= 1200) {
      carTypes.addAll(vehicleTypes);
    } else if (heightInCentimeters >= 400 &&
        widthInCentimeters >= 400 &&
        depthInCentimeters >= 600) {
      carTypes.add(van);
      carTypes.add(pickup);
      carTypes.add(suv);
      carTypes.add(sedan);
      carTypes.add(hatch);
      carTypes.add(motorcycle);
    } else if (heightInCentimeters >= 300 &&
        widthInCentimeters >= 300 &&
        depthInCentimeters >= 500) {
      carTypes.add(pickup);
      carTypes.add(suv);
      carTypes.add(sedan);
      carTypes.add(hatch);
      carTypes.add(motorcycle);
    } else if (heightInCentimeters >= 200 &&
        widthInCentimeters >= 200 &&
        depthInCentimeters >= 400) {
      carTypes.add(sedan);
      carTypes.add(hatch);
      carTypes.add(motorcycle);
    } else if (heightInCentimeters >= 200 &&
        widthInCentimeters >= 200 &&
        depthInCentimeters >= 300) {
      carTypes.add(hatch);
      carTypes.add(motorcycle);
    } else if (heightInCentimeters >= 200 &&
        widthInCentimeters >= 100 &&
        depthInCentimeters >= 200) {
      carTypes.add(motorcycle);
    }

    return carTypes;
  }
}

//
// import 'dart:math';
//
// import 'package:vagali/features/vehicle/models/vehicle_type.dart';
//
// class GarageService {
//   List<VehicleType> getCompatibleCarTypes(
//       double height, double width, double depth) {
//     final carTypes = <VehicleType>[];
//
//     print('############################### $height $width $depth');
//     if (height >= 2 && width >= 1 && depth >= 2) {
//       final motorcycle = vehicleTypes
//           .firstWhere((vehicle) => vehicle.type == VehicleTypeEnum.motorcycle);
//
//       carTypes.add(motorcycle);
//     } else if (height >= 2 && width >= 2 && depth >= 3) {
//       final hatch = vehicleTypes
//           .firstWhere((vehicle) => vehicle.type == VehicleTypeEnum.hatch);
//
//       carTypes.add(hatch);
//     } else if (height >= 2 && width >= 2 && depth >= 4) {
//       final sedan = vehicleTypes
//           .firstWhere((vehicle) => vehicle.type == VehicleTypeEnum.sedan);
//
//       carTypes.add(sedan);
//     } else if (height >= 3 && width >= 3 && depth >= 4) {
//       final suv = vehicleTypes
//           .firstWhere((vehicle) => vehicle.type == VehicleTypeEnum.suv);
//       carTypes.add(suv);
//     } else if (height >= 3 && width >= 4 && depth >= 5) {
//       final truck = vehicleTypes
//           .firstWhere((vehicle) => vehicle.type == VehicleTypeEnum.truck);
//       carTypes.add(truck);
//     }
//     // print('############################### ${height} $width');
//     // if (height >= 3 && width >= 4 && depth >= 5) {
//     //   carTypes.addAll(vehicleTypes);
//     // } else if (height >= 3 && width >= 3 && depth >= 4) {
//     //   final filteredVehicles = vehicleTypes.where((vehicle) =>
//     //       vehicle.type == VehicleTypeEnum.suv ||
//     //       vehicle.type == VehicleTypeEnum.sedan ||
//     //       vehicle.type == VehicleTypeEnum.hatch ||
//     //       vehicle.type == VehicleTypeEnum.motorcycle);
//     //
//     //   print('############################### ${filteredVehicles.length}');
//     //   carTypes.addAll(filteredVehicles);
//     // } else if (height >= 2 && width >= 2 && depth >= 3.5) {
//     //   final filteredVehicles = vehicleTypes.where((vehicle) =>
//     //       vehicle.type == VehicleTypeEnum.sedan ||
//     //       vehicle.type == VehicleTypeEnum.hatch);
//     //
//     //   print('############################### 2 ${filteredVehicles.length}');
//     //   carTypes.addAll(filteredVehicles);
//     // } else if (height >= 1.2 && width >= 1.3 && depth >= 3.0) {
//     //   final filteredVehicles = vehicleTypes.where((vehicle) =>
//     //       vehicle.type == VehicleTypeEnum.suv ||
//     //       vehicle.type == VehicleTypeEnum.sedan ||
//     //       vehicle.type == VehicleTypeEnum.hatch);
//     //   carTypes.addAll(filteredVehicles);
//     // } else {
//     //   final filteredVehicles =
//     //       vehicleTypes.where((vehicle) => vehicle.type == VehicleTypeEnum.none);
//     //   carTypes.addAll(filteredVehicles);
//     // }
//
//     return carTypes;
//   }
// }
