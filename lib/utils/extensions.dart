import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vagali/features/reservation/models/reservation.dart';
import 'package:vagali/features/support/models/support.dart';
import 'package:vagali/models/flavor_config.dart';
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

  String get monthAbbreviation {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Fev';
      case 3:
        return 'Mar';
      case 4:
        return 'Abr';
      case 5:
        return 'Mai';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Ago';
      case 9:
        return 'Set';
      case 10:
        return 'Out';
      case 11:
        return 'Nov';
      case 12:
        return 'Dez';
      default:
        return '';
    }
  }

  String get monthName {
    switch (month) {
      case 1:
        return 'Janeiro de $year';
      case 2:
        return 'Fevereiro de $year';
      case 3:
        return 'Março de $year';
      case 4:
        return 'Abril de $year';
      case 5:
        return 'Maio de $year';
      case 6:
        return 'Junho de $year';
      case 7:
        return 'Julho de $year';
      case 8:
        return 'Agosto de $year';
      case 9:
        return 'Setembro de $year';
      case 10:
        return 'Outubro de $year';
      case 11:
        return 'Novembro de $year';
      case 12:
        return 'Dezembro de $year';
      default:
        return '';
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

  String get toReadableReservationType {
    if (this == 'month') {
      return 'Mensal';
    } else {
      return 'Flexível';
    }
  }

  String toMonetaryString() => 'R\$${this}';

  String get clean => removeDiacritics(toLowerCase()).removeDots.removeHyphen;

  String get removeDots => replaceAll('.', '');

  String get removeHyphen => replaceAll('-', '');

  String get removeParenthesis => replaceAll(')', '').replaceAll('(', '');
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

  String toMonetaryString() => 'R\$${this}';

  String toFormattedTime() {
    int hours = (this / 3600).floor();
    int minutes = ((this % 3600) / 60).floor();

    String formattedTime = '';
    if (hours > 0) {
      formattedTime += '$hours h ';
    }
    if (minutes > 0 || hours == 0) {
      formattedTime += '$minutes min';
    }

    return formattedTime;
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
      case 'confirmationTimeOut':
        return ReservationStatus.confirmationTimeOut;
      case 'canceled':
        return ReservationStatus.canceled;
      case 'confirmed':
        return ReservationStatus.confirmed;
      case 'userOnTheWay':
        return ReservationStatus.userOnTheWay;
      case 'inProgress':
        return ReservationStatus.inProgress;
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
      case ReservationStatus.confirmationTimeOut:
        return "Tempo de confirmação excedido. Seu dinheiro será extornado em breve.";
      case ReservationStatus.canceled:
        return "A reserva foi cancelada.";
      case ReservationStatus.confirmed:
        return "Confirmado pelo locatário.";
      case ReservationStatus.inProgress:
        return "A reserva está em andamento";
      case ReservationStatus.userOnTheWay:
        return "O locatário à caminho. Fique atento para abrir o portão.";
      case ReservationStatus.arrived:
        return Get.find<FlavorConfig>().flavor == Flavor.tenant
            ? "O locatário chegou. Abra o portão para recebe-lo."
            : "Você chegou à vaga. Aguarde o locatário abrir o portão.";
      case ReservationStatus.parked:
        return "O veículo está estacionado na vaga.";
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
    } else if (this == ReservationStatus.canceled) {
      return "Cancelada";
    } else if (this == ReservationStatus.paymentTimeOut) {
      return "Tempo de pagamento excedido";
    } else if (this == ReservationStatus.confirmationTimeOut) {
      return "Tempo de confirmação excedido";
    } else if (this == ReservationStatus.concluded) {
      return "Concluída";
    } else if (this == ReservationStatus.pendingPayment) {
      return "Pendente de pagamento";
    } else if (this == ReservationStatus.paymentApproved) {
      return "Aguardando confirmacao";
    } else if (this == ReservationStatus.confirmed) {
      return "Confirmado";
    } else if (this == ReservationStatus.inProgress) {
      return "Em andamento";
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
        this == ReservationStatus.paymentTimeOut ||
        this == ReservationStatus.confirmationTimeOut) {
      return Colors.red;
    } else if (this == ReservationStatus.pendingPayment) {
      return Colors.amber;
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
