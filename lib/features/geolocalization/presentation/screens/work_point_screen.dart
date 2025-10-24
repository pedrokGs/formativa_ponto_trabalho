import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../../di/auth_providers.dart';
import '../states/work_point_state.dart';

class WorkPointScreen extends ConsumerWidget {
  const WorkPointScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(workPointNotifierProvider);
    final notifier = ref.read(workPointNotifierProvider.notifier);

    // Get userId from auth
    final user = ref.watch(currentUserProvider);
    final userId = user?.uid ?? 'user123';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => notifier.refresh(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: state.currentPosition != null && !state.isLoading
            ? () => notifier.setWorkPointAtCurrentLocation()
            : null,
        tooltip: 'Colocar ponto de trabalho',
        child: const Icon(Icons.add_location),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.errorMessage != null
              ? Center(child: Text('Erro: ${state.errorMessage}'))
              : Column(
                  children: [
                    Expanded(
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: state.currentPosition != null
                              ? LatLng(state.currentPosition!.latitude, state.currentPosition!.longitude)
                              : LatLng(0, 0),
                          initialZoom: 15.0,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.formativa_ponto_trabalho', 
                          ),
                          if (state.currentPosition != null)
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: LatLng(state.currentPosition!.latitude, state.currentPosition!.longitude),
                                  child: const Icon(
                                    Icons.my_location,
                                    color: Colors.blue,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          if (state.workPoint != null)
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: LatLng(state.workPoint!.latitude, state.workPoint!.longitude),
                                  child: const Icon(
                                    Icons.work,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          if (state.distance != null)
                            Text('Distância do trabalho: ${state.distance!.toStringAsFixed(2)} metros'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: state.canClockIn && !state.isLoading
                                ? () => notifier.clockIn(userId)
                                : null,
                            child: state.isLoading
                                ? const CircularProgressIndicator()
                                : const Text('Bater ponto'),
                          ),
                          if (state.clockInSuccess)
                            const Text('Sucesso!', style: TextStyle(color: Colors.green)),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}