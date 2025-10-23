import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formativa_ponto_trabalho/features/geolocalization/data/repositories/geolocation_repository_impl.dart';
import 'package:formativa_ponto_trabalho/features/geolocalization/domain/repositories/geolocation_repository.dart';

import '../features/geolocalization/domain/usecases/record_work_point_use_case.dart';
import '../features/geolocalization/presentation/state/map_state.dart';

final firestoreProvider = Provider((ref) => FirebaseFirestore.instance,);

final workPointRepositoryProvider = Provider<GeolocationRepository>((ref) {
  return GeolocationRepositoryImpl(ref.watch(firestoreProvider));
});

final recordWorkPointUseCaseProvider = Provider<RecordWorkPointUseCase>((ref) {
  final repository = ref.watch(workPointRepositoryProvider);
  return RecordWorkPointUseCase(repository);
});

final mapStateProvider = NotifierProvider<MapStateNotifier, MapState>(
  () => MapStateNotifier(),
);
