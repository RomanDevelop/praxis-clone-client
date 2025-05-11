import '../domain/engine_data.dart';
import 'engine_socket.dart';
import 'dart:async';

class EngineService {
  final EngineSocketClient? _client;
  Timer? _mockTimer;

  EngineService(this._client) {
    if (_client == null) {
      _startMockData();
    }
  }

  void _startMockData() {
    _mockTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      // Mock data will be handled by the stream
    });
  }

  Stream<EngineData> getEngineStream() {
    if (_client != null) {
      return _client!.stream.map((json) => EngineData.fromJson(json));
    } else {
      // Return mock data stream
      return Stream.periodic(const Duration(milliseconds: 500), (i) {
        return EngineData(
          rpm: 750.0 + (i % 100),
          engineLoad: 85.0 + (i % 15),
          oilTemperature: 85.0 + (i % 10),
          oilPressure: 3.0 + (i % 2),
          coolantTemperature: 90.0 + (i % 8),
          coolantPressure: 1.0 + (i % 1),
          fuelPressure: 3.0 + (i % 2),
          fuelConsumption: 8.5 + (i % 2),
          exhaustTemp1: 450.0 + (i % 20),
          exhaustTemp2: 445.0 + (i % 20),
          exhaustTemp3: 448.0 + (i % 20),
          exhaustTemp4: 452.0 + (i % 20),
          exhaustTemp5: 447.0 + (i % 20),
          turboPressure: 5.0 + (i % 1),
          airIntakeTemp: 35.0 + (i % 5),
          batteryVoltage: 24.0 + (i % 0.5),
          oilLevel: 85.0 + (i % 5),
          coolantLevel: 90.0 + (i % 5),
          fuelLevel: 75.0 + (i % 5),
          engineHours: 1250.5 + (i % 0.1),
          timestamp: DateTime.now(),
        );
      });
    }
  }

  void dispose() {
    _mockTimer?.cancel();
  }
}
