import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vagali/apps/landlord/features/parking/models/parking.dart';
import 'package:vagali/apps/landlord/features/parking/models/parking_tag.dart';
import 'package:vagali/apps/landlord/features/parking/models/price.dart';
import 'package:vagali/features/address/models/address.dart';
import 'package:vagali/models/image_blurhash.dart';
import 'package:vagali/repositories/firestore_repository.dart';

class ParkingRepository extends FirestoreRepository<Parking> {
  ParkingRepository()
      : super(
          collectionName: 'parkings',
          fromDocument: (document) => Parking.fromDocument(document),
        );

  final List<String> userIds = [
    'ZH1CTUqTVfhq1p32Y6oe2fwcOLu1',
    'kfUpQSoSXRg2PTSqlHJ7Aed40ie2',
    'vHdropyI8OSsCLNpkR5pFoiQe3x1',
  ];
  final List<ImageBlurHash> randomImages = [
    ImageBlurHash(
        image:
            'https://firebasestorage.googleapis.com/v0/b/vagali-8385f.appspot.com/o/landlords%2F1706705165750.jpg?alt=media&token=8837c82e-9536-451f-8f48-fa0aa416ad57',
        blurHash: 'LgG8l,IVRjay~qM{WBay_3Rjaejt'),
    ImageBlurHash(
        image:
            'https://firebasestorage.googleapis.com/v0/b/vagali-8385f.appspot.com/o/users%2Fscaled_5a04a336-290e-42e3-9d65-1ce2928915b86149404600217638860.jpg?alt=media&token=faa0bc37-487c-4292-bb34-c35844cdaa74',
        blurHash: 'LIH3{k3;.mqGF_GGO?XmB--prDR5'),
    ImageBlurHash(
        image:
            'https://firebasestorage.googleapis.com/v0/b/vagali-8385f.appspot.com/o/users%2Fc41a3f13-09e8-4bab-944f-340e404964135765926682922194486.jpg?alt=media&token=22ecb828-e472-4220-80ef-5704547439ad',
        blurHash: 'LQEx^W~p-;%M-p%LtQt7IUIURPM{'),
    ImageBlurHash(
        image:
            'https://firebasestorage.googleapis.com/v0/b/vagali-8385f.appspot.com/o/parkings%2F1706561889541.jpg?alt=media&token=828ca3e5-e304-46a2-9fd8-2b9880f2822c',
        blurHash: 'L-F\$w@_4%gozjFaeWBf6WBWBWCfk'),
    ImageBlurHash(
        image:
            'https://firebasestorage.googleapis.com/v0/b/vagali-8385f.appspot.com/o/parkings%2F1706561895417.jpg?alt=media&token=f1186685-07f1-4709-9bf5-cbeac9cfedec',
        blurHash: 'LWFr#79F~qRiWBWBt7ayofjbRjWC'),
    ImageBlurHash(
        image:
            'https://firebasestorage.googleapis.com/v0/b/vagali-8385f.appspot.com/o/parkings%2F1706561900614.jpg?alt=media&token=5f3938a2-6048-4d2d-8d61-42f7fe37fe67',
        blurHash: 'LpG+aZ~q?v.8ofWWayWCtRt7ofWB'),
    ImageBlurHash(
        image:
            'https://firebasestorage.googleapis.com/v0/b/vagali-8385f.appspot.com/o/parkings%2F1706561905962.jpg?alt=media&token=300b52cc-e908-4121-a243-da3e35672812',
        blurHash: 'LqF\$U}~q?bxua}j[j[ayR%WBj[s:'),
    ImageBlurHash(
        image:
            'https://firebasestorage.googleapis.com/v0/b/vagali-8385f.appspot.com/o/parkings%2F1706561911191.jpg?alt=media&token=0cf71d80-fd2a-46e7-91c1-ea3a493eb367',
        blurHash: 'LKEfTj~qS#tRt8.8%NkWtRt8tRoz'),
    ImageBlurHash(
        image:
            'https://firebasestorage.googleapis.com/v0/b/vagali-8385f.appspot.com/o/parkings%2F1706561915882.jpg?alt=media&token=fd62d479-e781-4e42-a196-e6201123f5db',
        blurHash: 'LaEV?2~q%go#V?RjfPozx]tRkDj['),
  ];

  Future<void> generateRandomParkings() async {
    final random = Random();
    final parkingsToGenerate = 50;

    // Limites geográficos aproximados de São Paulo
    final minLatitude = -23.950088; // Latitude sul
    final maxLatitude = -23.357619; // Latitude norte
    final minLongitude = -46.825965; // Longitude oeste
    final maxLongitude = -46.365997; // Longitude leste

    for (int i = 1; i <= parkingsToGenerate; i++) {
      final randomIndex = random.nextInt(parkingTags.length);
      final randomImageIndex = random.nextInt(randomImages.length);
      final randomUserIdIndex = random.nextInt(userIds.length);

      final latitude =
          minLatitude + random.nextDouble() * (maxLatitude - minLatitude);
      final longitude =
          minLongitude + random.nextDouble() * (maxLongitude - minLongitude);

      final parking = Parking(
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        name: 'Vaga $i',
        price: Price(
          hour: 6.0,
          sixHours: 12.0,
          twelveHours: 18.0,
          day: 50.0,
          month: 200.0,
        ),
        // Preencha conforme necessário
        isAvailable: true,
        tags: [parkingTags[randomIndex]],
        description: 'Descrição aleatória',
        images: [randomImages[randomImageIndex]],
        userId: userIds[randomUserIdIndex],
        type: 'Tipo aleatório',
        location: GeoPoint(latitude, longitude),
        address: generateRandomAddress(),
        gateHeight: random.nextDouble(),
        gateWidth: random.nextDouble(),
        garageDepth: random.nextDouble(),
        isAutomatic: true,
        isOpen: true,
        reservationType: 'Tipo de reserva aleatório',
      );

      await save(parking);
    }
  }

  Address generateRandomAddress() {
    final random = Random();
    final saoPauloCeps = [
      '01000-000',
      '02000-000',
      '03000-000',
      '04000-000',
      '05000-000',
      // Adicione mais CEPs de São Paulo
    ];

    final randomCep = saoPauloCeps[random.nextInt(saoPauloCeps.length)];

    return Address(
      postalCode: randomCep,
      street: 'Rua Aleatória',
      number: random.nextInt(100).toString(),
      county: 'Bairro Aleatório',
      city: 'São Paulo',
      state: 'SP',
      country: 'Brasil',
    );
  }
}
