import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/features/support/models/support.dart';
import 'package:vagali/theme/theme_colors.dart';

extension TimeOfDayExtension on TimeOfDay {
  DateTime toDateTimeToday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }
}

extension DateTimeExtensions on DateTime {
  String toFormattedString() {
    final day = this.day.toString().padLeft(2, '0');
    final month = this.month.toString().padLeft(2, '0');
    final year = this.year.toString();
    final hour = this.hour.toString().padLeft(2, '0');
    final minute = this.minute.toString().padLeft(2, '0');

    return '$day/$month/$year $hour:$minute';
  }

  String toMonthlyAndYearFormattedString() {
    final day = this.day.toString();
    final month = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro'
    ][this.month - 1];
    final year = this.year.toString();

    return '$day de $month de $year';
  }

  String toMonthlyFormattedString() {
    final day = this.day.toString();
    final month = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro'
    ][this.month - 1];

    return '$day de $month';
  }

  String toFriendlyDateTimeString({bool showTime = true}) {
    final day = this.day.toString();
    final month = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro'
    ][this.month - 1];
    final year = this.year.toString();
    final hour = this.hour.toString().padLeft(2, '0');
    final minute = this.minute.toString().padLeft(2, '0');

    return '$day de $month de $year${showTime ? ' às $hour:$minute' : ''}';
  }

  String toTimeString() {
    final timeDifference = DateTime.now().difference(this).inSeconds;
    if (timeDifference < 60) {
      return '${timeDifference.toStringAsFixed(0)}s';
    } else if (timeDifference < 3600) {
      final minutes = timeDifference / 60.toInt();
      return '${minutes.toStringAsFixed(0)}m';
    } else if (timeDifference < 86400) {
      final hours = timeDifference / 3600.toInt();
      return '${hours.toStringAsFixed(0)}h';
    } else {
      final days = timeDifference / 86400.toInt();
      return '${days.toStringAsFixed(0)}d';
    }
  }
}

extension StringExtensions on String {
  String get lastSegmentAfterSlash {
    final segments = split('/');
    if (segments.isNotEmpty) {
      return segments.last;
    }
    return '';
  }

  String get toReadableGender {
    if (this == 'male') {
      return 'Masculino';
    } else if (this == 'female') {
      return 'Feminino';
    } else if (this == 'transgender') {
      return 'Transgênero';
    } else {
      return 'Outros';
    }
  }
  String get toReadableReservationType {
    if (this == 'month') {
      return 'Mensal';
    }  else {
      return 'Flexível';
    }
  }

  String get clean => removeDiacritics(toLowerCase()).removeDots.removeHyphen;

  String get removeDots => replaceAll('.', '');

  String get removeHyphen => replaceAll('-', '');
}

extension DoubleExtension on double {
  String get formatDistance {
    if (this <= 999) {
      return '${toStringAsFixed(0)} m';
    } else {
      final distanceInKm = this / 1000;
      return '${distanceInKm.toStringAsFixed(1)} km';
    }
  }
}

extension ReservationStatusExtension on ReservationStatus {
  String toStringSimplified() => toString().split('.').last;

  static ReservationStatus fromString(String value) {
    switch (value) {
      case 'pendingPayment':
        return ReservationStatus.pendingPayment;
      case 'paymentApproved':
        return ReservationStatus.paymentApproved;
      case 'paymentDenied':
        return ReservationStatus.paymentDenied;
      case 'paymentTimeOut':
        return ReservationStatus.paymentTimeOut;
      case 'canceled':
        return ReservationStatus.canceled;
      case 'confirmed':
        return ReservationStatus.confirmed;
      case 'userOnTheWay':
        return ReservationStatus.userOnTheWay;
      case 'parked':
        return ReservationStatus.parked;
      case 'concluded':
        return ReservationStatus.concluded;
      default:
        return ReservationStatus.error;
    }
  }

  String get message {
    switch (this) {
      case ReservationStatus.pendingPayment:
        return "Aguardando pagamento...";
      case ReservationStatus.paymentApproved:
        return "Pagamento aprovado. Aguardando confirmação.";
      case ReservationStatus.paymentDenied:
        return "Pagamento Negado. Tente novamente.";
      case ReservationStatus.paymentTimeOut:
        return "Tempo de pagamento. Faça uma nova reserva.";
      case ReservationStatus.canceled:
        return "A reserva foi cancelada.";
      case ReservationStatus.confirmed:
        return "Confirmado pelo locatário.";
      case ReservationStatus.userOnTheWay:
        return "Estou à caminho.";
      case ReservationStatus.parked:
        return "Veículo estacionado.";
      case ReservationStatus.concluded:
        return "Reserva concluída. Obrigado por utilizar o Vagali.";
      case ReservationStatus.error:
        return "Ocorreu um erro inesperado. Tente novamente.";
    }
  }

  String get title {
    if (this == ReservationStatus.paymentDenied) {
      return "Pagamento negado";
    } else if (this == ReservationStatus.canceled) {
      return "Cancelada";
    } else if (this == ReservationStatus.paymentTimeOut) {
      return "Tempo excedido";
    } else if (this == ReservationStatus.concluded) {
      return "Concluída";
    } else if (this == ReservationStatus.pendingPayment) {
      return "Pendente de Pagamento";
    } else if (this == ReservationStatus.paymentApproved) {
      return "Aguardando Confirmacao";
    } else if (this == ReservationStatus.confirmed) {
      return "Confirmado";
    } else if (this == ReservationStatus.userOnTheWay) {
      return "Veiculo a caminho";
    } else if (this == ReservationStatus.parked) {
      return "Veiculo estacionado";
    } else {
      return "Erro desconhecido";
    }
  }

  Color get color {
    if (this == ReservationStatus.paymentDenied ||
        this == ReservationStatus.canceled ||
        this == ReservationStatus.paymentTimeOut) {
      return Colors.red;
    } else {
      return ThemeColors.primary;
    }
  }
}

extension SupportStatusExtension on SupportStatus {
  String toStringSimplified() => toString().split('.').last;

  static SupportStatus fromString(String value) {
    switch (value) {
      case 'open':
        return SupportStatus.open;
      case 'analysis':
        return SupportStatus.analysis;
      default:
        return SupportStatus.done;
    }
  }

  String get message {
    switch (this) {
      case SupportStatus.open:
        return "O pedido de suporte aberto.";
      case SupportStatus.analysis:
        return "O pedido de suporte está sendo analisado.";
      default:
        return "O pedido de suporte foi finalizado. Esperamos ter ajudado.";
    }
  }

  String get title {
    if (this == SupportStatus.open) {
      return "Suporte aberto";
    } else if (this == SupportStatus.analysis) {
      return "Suporte em análise";
    } else {
      return "Suporte finalizado";
    }
  }
}
