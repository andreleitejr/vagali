class PriceService {
  static const _hourBasePrice = 10;
  static const _sixHoursBasePrice = 15;
  static const _twelveHoursBasePrice = 20;
  static const _twentyFourHoursBasePrice = 25;
  static const _monthBasePrice = 200;

  static Map<String, double> calculateSuggestedPrices(double pricePerHour) {
    final Map<String, double> suggestedPrices = {};

    suggestedPrices['hourly'] = pricePerHour;
    suggestedPrices['6_hours'] =
        (pricePerHour * _sixHoursBasePrice) / _hourBasePrice;
    suggestedPrices['12_hours'] =
        (pricePerHour * _twelveHoursBasePrice) / _hourBasePrice;
    suggestedPrices['24_hours'] =
        (pricePerHour * _twentyFourHoursBasePrice) / _hourBasePrice;
    suggestedPrices['monthly'] =
        (pricePerHour * _monthBasePrice) / _hourBasePrice;

    return suggestedPrices;
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
