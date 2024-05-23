class Price {
  final num? hour;
  final num? sixHours;
  final num? twelveHours;
  final num? day;
  final num month;

  Price({
    this.hour,
    this.sixHours,
    this.twelveHours,
    this.day,
    required this.month,
  });

  static Price fromMap(Map<String, dynamic> map) {
    return Price(
      day: map['day'],
      hour: map['hour'],
      month: map['month'],
      sixHours: map['sixHours'],
      twelveHours: map['twelveHours'],
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
