import 'package:vagali/models/selectable_item.dart';

class ReservationType extends SelectableItem {
  final String name;
  final String type;

  ReservationType({
    required this.name,
    required this.type,
  });

  static const month = 'month';
  static const flex = 'flex';

  @override
  String get title => name;
}

final List<ReservationType> reservationTypes = [
  ReservationType(
    name: 'Mensal',
    type: ReservationType.month,
  ),
  ReservationType(
    name: 'Flexível',
    type: ReservationType.flex,
  ),
];
