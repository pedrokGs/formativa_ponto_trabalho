import 'package:formativa_ponto_trabalho/features/geolocalization/domain/entities/location_point_entity.dart';
import 'package:geolocator/geolocator.dart';

import '../entities/work_point_record_entity.dart';

abstract class GeolocationRepository {
  Future<LocationPointEntity> getWorkLocationPoint();
  Future<Position> getCurrentPosition();
  Future<void> recordWorkPoint(WorkPointRecordEntity record);
}