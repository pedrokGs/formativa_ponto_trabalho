import 'package:formativa_ponto_trabalho/features/geolocalization/domain/usecases/record_work_point_use_case.dart';
import 'package:formativa_ponto_trabalho/features/geolocalization/domain/usecases/set_work_point_use_case.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod/riverpod.dart';

import '../../domain/entities/location_point_entity.dart';
import '../../../../di/work_point_providers.dart';

class WorkPointState {
  final Position? currentPosition;
  final LocationPointEntity? workPoint;
  final double? distance;
  final bool isLoading;
  final String? errorMessage;
  final bool clockInSuccess;

  WorkPointState({
    this.currentPosition,
    this.workPoint,
    this.distance,
    this.isLoading = false,
    this.errorMessage,
    this.clockInSuccess = false,
  });

  bool get canClockIn => distance != null && distance! <= 100;
}

class WorkPointStateNotifier extends Notifier<WorkPointState> {
  late final RecordWorkPointUseCase recordWorkPointUseCase;
  late final SetWorkPointUseCase setWorkPointUseCase;

  @override
  WorkPointState build() {
    recordWorkPointUseCase = ref.watch(recordWorkPointUseCaseProvider);
    setWorkPointUseCase = ref.watch(setWorkPointUseCaseProvider);
    _loadData();
    return WorkPointState(isLoading: true);
  }

  Future<void> _loadData() async {
    state = WorkPointState(isLoading: true);
    try {
      final position = await Geolocator.getCurrentPosition();
      final workPoint = await recordWorkPointUseCase.repository.getWorkLocationPoint();
      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        workPoint.latitude,
        workPoint.longitude,
      );
      state = WorkPointState(
        currentPosition: position,
        workPoint: workPoint,
        distance: distance,
        isLoading: false,
      );
    } catch (e) {
      state = WorkPointState(
        isLoading: false,
        errorMessage: 'Failed to load location data: $e',
      );
    }
  }

  Future<void> clockIn(String userId) async {
    if (!state.canClockIn) return;
    state = WorkPointState(
      currentPosition: state.currentPosition,
      workPoint: state.workPoint,
      distance: state.distance,
      isLoading: true,
    );
    try {
      final success = await recordWorkPointUseCase.execute(userId);
      state = WorkPointState(
        currentPosition: state.currentPosition,
        workPoint: state.workPoint,
        distance: state.distance,
        isLoading: false,
        clockInSuccess: success,
        errorMessage: success ? null : 'Clock in failed: Not within range',
      );
    } catch (e) {
      state = WorkPointState(
        currentPosition: state.currentPosition,
        workPoint: state.workPoint,
        distance: state.distance,
        isLoading: false,
        errorMessage: 'Clock in error: $e',
      );
    }
  }

  Future<void> setWorkPointAtCurrentLocation() async {
    if (state.currentPosition == null) return;
    state = WorkPointState(
      currentPosition: state.currentPosition,
      workPoint: state.workPoint,
      distance: state.distance,
      isLoading: true,
    );
    try {
      final workPoint = LocationPointEntity(
        uid: 'main',
        name: 'Work Point',
        latitude: state.currentPosition!.latitude,
        longitude: state.currentPosition!.longitude,
      );
      await setWorkPointUseCase.execute(workPoint);
      await _loadData();
    } catch (e) {
      state = WorkPointState(
        currentPosition: state.currentPosition,
        workPoint: state.workPoint,
        distance: state.distance,
        isLoading: false,
        errorMessage: 'Failed to set work point: $e',
      );
    }
  }

  void refresh() {
    _loadData();
  }
}

final workPointNotifierProvider = NotifierProvider<WorkPointStateNotifier, WorkPointState>(
  () => WorkPointStateNotifier(),
);
