import 'package:vagali/models/dimension.dart';

enum SpaceFill { excess, free, full }

class SpaceCalculatorService {
  double occupiedVolume = 0;
  double freeVolume = 0;
  double excessVolume = 0;

  SpaceFill fitObjectsInSpace(
    Dimension space,
    List<Dimension> objects,
  ) {
    final totalVolume = space.volume;

    for (final object in objects) {
      occupiedVolume += object.volume;

      if (occupiedVolume > totalVolume) {
        excessVolume = occupiedVolume - totalVolume;
        return SpaceFill.excess;
      }
    }

    if (occupiedVolume >= totalVolume) {
      return SpaceFill.full;
    } else {
      freeVolume = totalVolume - occupiedVolume;
      return SpaceFill.free;
    }
  }
}

class Material extends Dimension {
  final double weight;
  final String type;
  final String material;

  Material(super.width, super.height, super.depth, this.weight, this.type,
      this.material);
}
