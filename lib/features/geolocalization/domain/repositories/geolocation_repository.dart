import 'package:formativa_ponto_trabalho/features/geolocalization/domain/entities/location_point_entity.dart';

abstract class GeolocationRepository {
  Future<LocationPointEntity> getAllLocationPoints();
  Future<LocationPointEntity> getLocationPointById({required String uid});
  Future<LocationPointEntity> addLocationPointEntity({required LocationPointEntity locationPointEntity});
  Future<LocationPointEntity> updateLocationPointEntity({required LocationPointEntity locationPointEntity});
  Future<void> deleteLocationPointEntity({required String uid});
}