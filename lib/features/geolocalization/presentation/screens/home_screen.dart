import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../../di/work_point_providers.dart';

class WorkPointMapPage extends ConsumerWidget {
  const WorkPointMapPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mapStateProvider);
    final notifier = ref.read(mapStateProvider.notifier);

    // Show error snackbar if there's an error
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.errorMessage!),
            action: SnackBarAction(
              label: 'OK',
              onPressed: () => notifier.clearError(),
            ),
          ),
        );
      }
    });

    if (state.isLoading || state.workPoint == null || state.userPosition == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrar Ponto"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => notifier.loadPositions(),
          ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(state.workPoint!.latitude, state.workPoint!.longitude),
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
                point: LatLng(state.workPoint!.latitude, state.workPoint!.longitude),
                child: const Icon(
                    Icons.location_on, color: Colors.red, size: 40),
              ),
              Marker(
                width: 80,
                height: 80,
                point: state.userPosition!,
                child: const Icon(
                    Icons.person_pin_circle, color: Colors.blue, size: 40),
              ),
            ],
          ),
          CircleLayer(
            circles: [
              CircleMarker(
                point: LatLng(state.workPoint!.latitude, state.workPoint!.longitude),
                color: state.isWithinRange ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                borderColor: state.isWithinRange ? Colors.green : Colors.red,
                borderStrokeWidth: 2,
                radius: 100,
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: state.isRegistering ? null : () => notifier.registerPoint(),
        backgroundColor: state.isWithinRange ? null : Colors.grey,
        child: state.isRegistering
            ? const CircularProgressIndicator(color: Colors.white)
            : const Icon(Icons.check),
      ),
    );
  }
}
