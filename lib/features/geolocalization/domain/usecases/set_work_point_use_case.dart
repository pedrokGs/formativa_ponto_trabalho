import 'package:formativa_ponto_trabalho/features/geolocalization/domain/repositories/geolocation_repository.dart';

import '../entities/location_point_entity.dart';

class SetWorkPointUseCase {
  final GeolocationRepository repository;

  SetWorkPointUseCase(this.repository);

  Future<void> execute(LocationPointEntity workPoint) async {
    await repository.setWorkLocationPoint(workPoint);
  }
}
