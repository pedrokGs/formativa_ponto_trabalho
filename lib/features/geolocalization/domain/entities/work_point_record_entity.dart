class WorkPointRecordEntity {
  final String uid;
  final String userId;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final String locationPointId;

  const WorkPointRecordEntity({
    required this.uid,
    required this.userId,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.locationPointId,
  });
}
