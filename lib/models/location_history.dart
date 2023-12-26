import 'package:cloud_firestore/cloud_firestore.dart';

class LocationHistory {
  final double latitude;
  final double longitude;
  final double heading;
  final DateTime timestamp;

  LocationHistory({
    required this.latitude,
    required this.longitude,
    required this.heading,
    required this.timestamp,
  });

  factory LocationHistory.fromDocument(dynamic documentData) {
    if (documentData is Map<String, dynamic>) {
      final latitude = documentData['latitude'] as double? ?? -23.5488823;
      final longitude = documentData['longitude'] as double? ?? -46.6461734;
      final heading = documentData['heading'] as double? ?? 0;
      final timestamp = documentData['timestamp'] as Timestamp?;

      if (timestamp != null) {
        return LocationHistory(
          latitude: latitude,
          longitude: longitude,
          heading: heading,
          timestamp: timestamp.toDate(),
        );
      }
    }

    return LocationHistory(
      latitude: 0.0,
      longitude: 0.0,
      heading: 0.0,
      timestamp: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'heading': heading,
      'timestamp': timestamp,
    };
  }
}
