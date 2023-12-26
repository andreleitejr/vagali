class OperatingHours {
  final Map<String, Map<String, String>> daysAndHours;

  OperatingHours({required this.daysAndHours});

  Map<String, dynamic> toMap() {
    return {'daysAndHours': daysAndHours};
  }

  static OperatingHours fromMap(Map<String, dynamic> map) {
    Map<String, Map<String, String>> daysAndHours = {};
    if (map.containsKey('daysAndHours')) {
      final daysAndHoursMap = map['daysAndHours'] as Map<String, dynamic>;
      daysAndHoursMap.forEach((day, hours) {
        if (hours is Map<String, dynamic>) {
          daysAndHours[day] = hours.map((key, value) => MapEntry(key, value.toString()));
        }
      });
    }

    return OperatingHours(
      daysAndHours: daysAndHours,
    );
  }

}
