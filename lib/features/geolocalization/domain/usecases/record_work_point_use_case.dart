import 'package:flutter/cupertino.dart';
import 'package:formativa_ponto_trabalho/features/geolocalization/domain/repositories/geolocation_repository.dart';
import 'package:geolocator/geolocator.dart';

import '../entities/work_point_record_entity.dart';

class RecordWorkPointUseCase {
  final GeolocationRepository repository;

  RecordWorkPointUseCase(this.repository);

  Future<bool> execute(String userId) async {
    final position = await repository.getCurrentPosition();
    final workPoint = await repository.getWorkLocationPoint();

    final distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      workPoint.latitude,
      workPoint.longitude,
    );

    if (distance <= 100) {
      final record = WorkPointRecordEntity(
        uid: UniqueKey().toString(),
        userId: userId,
        timestamp: DateTime.now(),
        latitude: position.latitude,
        longitude: position.longitude,
        locationPointId: workPoint.uid,
      );
      await repository.recordWorkPoint(record);
      return true;
    } else {
      return false;
    }
  }
}