import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:formativa_ponto_trabalho/features/geolocalization/domain/repositories/geolocation_repository.dart';
import 'package:geolocator/geolocator.dart';

import '../../domain/entities/location_point_entity.dart';
import '../../domain/entities/work_point_record_entity.dart';

class GeolocationRepositoryImpl implements GeolocationRepository {
  final FirebaseFirestore firestore;

  GeolocationRepositoryImpl(this.firestore);

  @override
  Future<LocationPointEntity> getWorkLocationPoint() async {
    final doc = await firestore.collection('workPoints').doc('main').get();
    final data = doc.data();
    if(data == null){
      return LocationPointEntity(uid: '', name: '', longitude: 0.0, latitude: 0.0);
    }
    return LocationPointEntity(
      uid: doc.id,
      name: data['name'],
      latitude: data['latitude'],
      longitude: data['longitude'],
    );
  }

  @override
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Serviço de localização desativado");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Permissão de localização negada");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Permissão de localização permanentemente negada");
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  @override
  Future<void> recordWorkPoint(WorkPointRecordEntity record) async {
    await firestore.collection('workRecords').doc(record.uid).set({
      'userId': record.userId,
      'timestamp': record.timestamp.toIso8601String(),
      'latitude': record.latitude,
      'longitude': record.longitude,
      'locationPointId': record.locationPointId,
    });
  }
}
