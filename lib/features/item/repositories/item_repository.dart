import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vagali/features/item/models/item.dart';
import 'package:vagali/features/item/models/vehicle.dart';
import 'package:vagali/repositories/firestore_repository.dart';

class ItemRepository extends FirestoreRepository<Item> {
  ItemRepository()
      : super(
          collectionName: 'items',
          fromDocument: (document) => Item.fromDocument(document),
        );

  Future<List<Vehicle>> getVehicles({String? userId}) async {
    Query query = firestore
        .collection(collectionName)
        .where('type', isEqualTo: ItemType.vehicle);

    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }

    final querySnapshot = await query.get();
    final dataList =
        querySnapshot.docs.map((doc) => Vehicle.fromDocument(doc)).toList();

    debugPrint(
        'Successful fetch ${dataList.length} documents for Item Vehicles in Firestore.');
    return dataList;
  }
}
