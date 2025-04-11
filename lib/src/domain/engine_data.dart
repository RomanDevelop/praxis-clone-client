class EngineData {
  final double rpm;
  final double oilTemp;
  final double coolantTemp;
  final double pressure;
  final DateTime timestamp;

  EngineData({
    required this.rpm,
    required this.oilTemp,
    required this.coolantTemp,
    required this.pressure,
    required this.timestamp,
  });

  factory EngineData.fromJson(Map<String, dynamic> json) {
    print("Received JSON: $json");
    return EngineData(
      rpm: (json['rpm'] ?? 0).toDouble(),
      oilTemp: (json['oil_temp'] ?? 0).toDouble(), // 🐍
      coolantTemp: (json['coolant_temp'] ?? 0).toDouble(), // 🐍
      pressure: (json['fuel_pressure'] ?? 0)
          .toDouble(), // 🐍 возможно, у тебя это оно
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
    );
  }
}
