import 'package:client/src/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnginePage extends ConsumerWidget {
  const EnginePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(engineViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Engine Monitor')),
      body: data == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildParam('RPM', '${data.rpm}'),
                  _buildParam('Oil Temp', '${data.oilTemp} °C'),
                  _buildParam('Coolant Temp', '${data.coolantTemp} °C'),
                  _buildParam('Pressure', '${data.pressure} bar'),
                  _buildParam('Time', data.timestamp.toLocal().toString()),
                ],
              ),
            ),
    );
  }

  Widget _buildParam(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text('$label: $value', style: const TextStyle(fontSize: 18)),
    );
  }
}
