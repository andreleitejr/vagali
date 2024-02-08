
import 'package:vagali/models/selectable_item.dart';
import 'package:vagali/theme/images.dart';

class PaymentMethodItem extends SelectableItem {
  final String? name;
  final String? description;
  final String method;
  late final String image;

  PaymentMethodItem({
    required this.method,
    this.name,
    this.description,
    this.image = Images.creditCard,
  });

  Map<String, dynamic> toMap() {
    return {
      'method': method,
    };
  }

  static PaymentMethodItem fromMap(Map<String, dynamic> map) {
    return PaymentMethodItem(
      method: map['method'],
    );
  }

  @override
  String get title => method;

  static const creditCard = 'creditCard';
  static const pix = 'pix';
  static const other = 'other';
}

final paymentMethods = <PaymentMethodItem>[
  PaymentMethodItem(
    method: PaymentMethodItem.creditCard,
    name: 'Cartão de Crédito',
    description: 'Selecione um cartão de crédito',
    image: Images.creditCard,
  ),
  PaymentMethodItem(
    method: PaymentMethodItem.pix,
    name: 'Pix',
    description: 'Aprovação em até 15 minutos',
    image: Images.money,
  ),
];