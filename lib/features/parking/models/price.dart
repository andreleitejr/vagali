class Price {
  final double? hour;
  final double? sixHours;
  final double? twelveHours;
  final double? day;
  final double month;

  Price({
    this.hour,
    this.sixHours,
    this.twelveHours,
    this.day,
    required this.month,
  });

  static Price fromMap(Map<String, dynamic> map) {
    return Price(
      hour: map['hour'],
      sixHours: map['sixHours'],
      twelveHours: map['twelveHours'],
      day: map['day'],
      month: map['month'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hour': hour,
      'sixHours': sixHours,
      'twelveHours': twelveHours,
      'day': day,
      'month': month,
    };
  }
}
