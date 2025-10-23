import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formativa_ponto_trabalho/di/auth_providers.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../di/work_point_providers.dart';
import '../../domain/entities/location_point_entity.dart';
import '../../domain/usecases/record_work_point_use_case.dart';

class WorkPointMapPage extends ConsumerStatefulWidget {
  const WorkPointMapPage({super.key});

  @override
  ConsumerState<WorkPointMapPage> createState() => _WorkPointMapPageState();
}

class _WorkPointMapPageState extends ConsumerState<WorkPointMapPage> {
  LocationPointEntity? workPoint;
  LatLng? userPosition;
  bool isWithinRange = false;

  @override
  void initState() {
    super.initState();
    _loadPositions();
  }

  Future<void> _loadPositions() async {
    final useCase = ref.read(recordWorkPointUseCaseProvider);

    workPoint = await useCase.repository.getWorkLocationPoint();

    Position position = await useCase.repository.getCurrentPosition();
    userPosition = LatLng(position.latitude, position.longitude);

    final distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      workPoint!.latitude,
      workPoint!.longitude,
    );

    setState(() {
      isWithinRange = distance <= 100;
    });
  }

  Future<void> _registerPoint() async {
    final useCase = ref.read(recordWorkPointUseCaseProvider);
    final userId = ref.read(currentUserProvider)!.uid;

    if (!isWithinRange) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Você está fora do alcance do ponto.")),
      );
      return;
    }

    final success = await useCase.execute(userId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(
          success ? "Ponto registrado!" : "Erro ao registrar ponto.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (workPoint == null || userPosition == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Registrar Ponto")),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(workPoint!.latitude, workPoint!.longitude),
          initialZoom: 17.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 80,
                height: 80,
                point: LatLng(workPoint!.latitude, workPoint!.longitude),
                child: const Icon(
                    Icons.location_on, color: Colors.red, size: 40),
              ),
              Marker(
                width: 80,
                height: 80,
                point: userPosition!,
                child: const Icon(
                    Icons.person_pin_circle, color: Colors.blue, size: 40),
              ),
            ],
          ),
          CircleLayer(
            circles: [
              CircleMarker(
                point: LatLng(workPoint!.latitude, workPoint!.longitude),
                color: Colors.green.withOpacity(0.2),
                borderColor: Colors.green,
                borderStrokeWidth: 2,
                radius: 100,
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _registerPoint,
        child: const Icon(Icons.check),
      ),
    );
  }
}