import 'package:vagali/features/parking/models/price.dart';

class PriceService {
  static const _hourBasePrice = 5;
  static const _sixHoursBasePrice = 10;
  static const _twelveHoursBasePrice = 16;
  static const _twentyFourHoursBasePrice = 20;
  static const _monthBasePrice = 150;

  Price calculateSuggestedPrices(double pricePerHour) {
    return Price(
      hour: pricePerHour,
      sixHours: (pricePerHour * _sixHoursBasePrice) / _hourBasePrice,
      twelveHours: (pricePerHour * _twelveHoursBasePrice) / _hourBasePrice,
      day: (pricePerHour * _twentyFourHoursBasePrice) / _hourBasePrice,
      month: (pricePerHour * _monthBasePrice) / _hourBasePrice,
    );
  }

  static double calculatePrice(DateTime startDateTime, DateTime endDateTime) {
    final double pricePerHour = _hourBasePrice.toDouble();

    final int durationInHours = endDateTime.difference(startDateTime).inHours;

    if (durationInHours <= 0) {
      return 0.0; // Caso a duração seja negativa ou zero, o preço é zero.
    } else if (durationInHours < 6) {
      return pricePerHour * durationInHours;
    } else if (durationInHours < 12) {
      final overtime = durationInHours - 6;

      return _sixHoursBasePrice.toDouble() + (overtime * pricePerHour);
    } else if (durationInHours < 24) {
      final overtime = durationInHours - 12;

      return _twelveHoursBasePrice.toDouble() + (overtime * pricePerHour);
    } else if (durationInHours < 24 * 30) {
      // Calcula o número de dias e arredonda para cima
      final int days = (durationInHours / 24).ceil();
      return _twentyFourHoursBasePrice.toDouble() * days;
    } else {
      return _monthBasePrice.toDouble();
    }
  }
}
