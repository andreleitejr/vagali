class Gate {
  final double height;
  final double width;
  final bool isAutomatic;

  Gate({
    required this.height,
    required this.width,
    required this.isAutomatic,
  });

  Map<String, dynamic> toMap() {
    return {
      'height': height,
      'width': width,
      'isAutomatic': isAutomatic,
    };
  }

  static Gate fromMap(Map<String, dynamic> map) {
    return Gate(
      height: map['height'],
      width: map['width'],
      isAutomatic: map['isAutomatic'],
    );
  }
}