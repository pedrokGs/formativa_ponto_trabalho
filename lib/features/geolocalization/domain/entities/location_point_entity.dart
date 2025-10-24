class LocationPointEntity{
  final String uid;
  final String name;
  final double longitude;
  final double latitude;

  const LocationPointEntity({required this.uid, required this.name, required this.longitude, required this.latitude});

  static const LocationPointEntity empty = LocationPointEntity(uid: '', name: '', longitude: 0.00, latitude: 0.00);

  bool get isEmpty => this == LocationPointEntity.empty;
}