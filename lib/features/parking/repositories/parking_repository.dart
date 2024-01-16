import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:vagali/features/landlord/models/landlord.dart';
import 'package:vagali/features/landlord/repositories/landlord_repository.dart';
import 'package:vagali/features/parking/models/parking.dart';
import 'package:vagali/repositories/firestore_repository.dart';
import 'package:vagali/services/image_service.dart';
import 'package:vagali/services/location_service.dart';
import 'package:vagali/utils/extensions.dart';

class ParkingRepository extends FirestoreRepository<Parking> {
  ParkingRepository()
      : super(
          collectionName: 'parkings',
          fromDocument: (document) => Parking.fromDocument(document),
        );

  Future<Parking> getParkingWithEntities(String ownerId) async {
    try {
      final document = await firestore
          .collectionGroup(collectionName.lastSegmentAfterSlash)
          .where('ownerId', isEqualTo: ownerId)
          .get();
      final parking = fromDocument(document.docs.first);
      final landlord = await LandlordRepository().get(parking.userId);

      parking.owner = landlord as Landlord;

      return parking;
    } catch (error) {
      debugPrint('Error fetching reservation with entities: $error');
      rethrow;
    }
  }

  Future<List<Parking>> getParkingsWithEntities() async {
    try {
      final query =
          firestore.collectionGroup(collectionName.lastSegmentAfterSlash);

      final querySnapshot = await query.get();
      final parkings =
          querySnapshot.docs.map((doc) => fromDocument(doc)).toList();

      final landlords = await LandlordRepository().getAll();

      for (final parking in parkings) {
        parking.owner = landlords
            .firstWhereOrNull((landlord) => parking.userId == landlord.id!);
      }
      return parkings;
    } catch (error) {
      debugPrint('Error fetching parkings with entities: $error');
      rethrow;
    }
  }

  Future<List<Parking>> getParkingsNearUser() async {
    const maxDistance = 10.0;

    final locationService = LocationService();

    final currentLocation = locationService.userLocation;

    if (currentLocation == null) {
      return [];
    }

    final userLatitude = currentLocation.latitude;
    final userLongitude = currentLocation.longitude;

    try {
      const degreesToRadians = 0.017453292519943295;
      const earthRadiusKm = 6371.0;

      final parkingsCollection = firestore.collection('parkings');

      final double maxLat =
          userLatitude + (maxDistance / earthRadiusKm) / degreesToRadians;
      final double minLat =
          userLatitude - (maxDistance / earthRadiusKm) / degreesToRadians;

      final double maxLon = userLongitude +
          (maxDistance / earthRadiusKm) / (degreesToRadians * 1.5);
      final double minLon = userLongitude -
          (maxDistance / earthRadiusKm) / (degreesToRadians * 1.5);

      final QuerySnapshot querySnapshot = await parkingsCollection
          .where('location.latitude', isGreaterThanOrEqualTo: minLat)
          .where('location.latitude', isLessThanOrEqualTo: maxLat)
          .where('location.longitude', isGreaterThanOrEqualTo: minLon)
          .where('location.longitude', isLessThanOrEqualTo: maxLon)
          .get();

      final List<Parking> nearbyParkings =
          querySnapshot.docs.map((QueryDocumentSnapshot doc) {
        return Parking.fromDocument(doc);
      }).toList();

      return nearbyParkings;
    } catch (error) {
      debugPrint('Erro ao buscar parkings próximos: $error');
      return [];
    }
  }

  final ImageService _imageService = ImageService();

  Future<void> saveParkingWithImages(
      Parking parking, List<File> imageFiles) async {
    try {
      final docReference =
          await firestore.collection(collectionName).add(parking.toMap());

      final imageUrls =
          await _imageService.uploadImages(imageFiles, 'parking_images');

      await docReference.update({'imageUrls': imageUrls});
    } catch (error) {
      debugPrint('Erro ao salvar estacionamento com imagens: $error');
    }
  }
}
