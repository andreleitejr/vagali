class Dimension {
  final double width;
  final double height;
  final double depth;

  double get volume => width * height * depth;

  const Dimension(this.width, this.height, this.depth);

  Dimension.fromMap(Map<String, dynamic> map)
      : width = map['width'],
        height = map['height'],
        depth = map['depth'];

  Map<String, dynamic> toMap() {
    return {
      'width': width,
      'height': height,
      'depth': depth,
    };
  }
}

// Vehicle
// Stock
// SmallVehicle
// Furniture
// Boxes
// HouseholdHardware
// HomeAppliance
// GymEquipment
// MusicalInstrument
// Shopping

// // Exemplo 1: Espaço totalmente ocupado
// var space1 = Dimension(3, 3, 3);
// var objects1 = [
//   Dimension(1, 1, 1),
//   Dimension(1, 1, 1),
//   Dimension(1, 1, 1),
//   Dimension(1, 1, 1),
//   Dimension(1, 1, 1),
//   Dimension(1, 1, 1),
//   Dimension(1, 1, 1),
//   Dimension(1, 1, 1),
//   Dimension(1, 1, 1),
//   Dimension(1, 1, 1),
//   Dimension(1, 1, 1),
//   Dimension(1, 1, 1),
//   Dimension(1, 1, 1),
//   Dimension(1, 1, 1),
//   Dimension(1, 1, 1),
//   Dimension(1, 1, 1),
//   Dimension(1, 1, 1),
//   Dimension(1, 1, 1),
//   Dimension(1, 1, 1),
//   Dimension(1, 1, 1),
//   Dimension(1, 1, 1),
//   Dimension(1, 1, 1),
//   Dimension(1, 1, 1),
//   Dimension(1, 1, 1),
//   Dimension(1, 1, 1),
//   Dimension(1, 1, 1),
//   Dimension(1, 1, 1),
// ];
//
// var spaceCalculator1 = SpaceCalculatorService();
// final fit1 = spaceCalculator1.fitObjectsInSpace(space1, objects1);
// print("Espaço totalmente ocupado: $fit1");
//
// // Exemplo 2: Espaço com sobra
// var space2 = Dimension(5, 5, 5);
// var objects2 = [
// Dimension(2, 2, 2),
// Dimension(2, 2, 2),
// ];
//
// var spaceCalculator2 = SpaceCalculatorService();
// final fit2 = spaceCalculator2.fitObjectsInSpace(space2, objects2);
// print("Espaço com sobra: $fit2");
//
// // Exemplo 3: Objetos ultrapassam o espaço
// final space3 = Dimension(3, 3, 3);
// final objects3 = [
// Dimension(3, 3, 3),
// Dimension(1, 1, 1),
// ];
//
// var spaceCalculator3 = SpaceCalculatorService();
// final fit3 = spaceCalculator3.fitObjectsInSpace(space3, objects3);
// print("Objetos ultrapassam o espaço: $fit3");
