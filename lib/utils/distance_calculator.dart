import 'dart:math';

double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
    ) {
  const double earthRadius = 6371.0; // Radius of the Earth in kilometers
  final double dLat = radians(lat2 - lat1);
  final double dLon = radians(lon2 - lon1);
  final double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(radians(lat1)) *
          cos(radians(lat2)) *
          sin(dLon / 2) *
          sin(dLon / 2);
  final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  final double distance = earthRadius * c;
  return distance;
}

double radians(double degrees) {
  return degrees * pi / 180.0;
}
