import 'package:equatable/equatable.dart';
import 'package:formativa_ponto_trabalho/features/geolocalization/domain/entities/location_point_entity.dart';

class LocationPointModel extends Equatable{
  final String? uid;
  final String name;
  final double longitude;
  final double latitude;

  const LocationPointModel({this.uid, required this.name, required this.longitude, required this.latitude});

  factory LocationPointModel.fromJson(Map<String, dynamic> json){
    return LocationPointModel(
      uid: json["uid"] ?? "",
      name: json["name"] ?? "", 
      longitude: double.parse(json["longitude"] ?? "0.0"),
      latitude: double.parse(json["latitude"] ?? "0.0"),
      );
  }

  LocationPointEntity toEntity(){
    return LocationPointEntity(uid: uid ?? "", name: name, longitude: longitude, latitude: latitude);
  }

  Map<String, dynamic> toMap(){
    return {
      "uid": uid,
      "name": name,
      "longitude": longitude,
      "latitude": latitude,
    };
  }

  @override
  List<Object?> get props => [uid, name, longitude, latitude];
}