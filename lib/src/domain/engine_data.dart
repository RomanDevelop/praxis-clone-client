class EngineData {
  // Основные параметры двигателя
  final double rpm;
  final double engineLoad;

  // Параметры масла
  final double oilTemperature;
  final double oilPressure;

  // Параметры охлаждающей жидкости
  final double coolantTemperature;
  final double coolantPressure;

  // Параметры топлива
  final double fuelPressure;
  final double fuelConsumption;

  // Температурные параметры выхлопа
  final double exhaustTemp1;
  final double exhaustTemp2;
  final double exhaustTemp3;
  final double exhaustTemp4;
  final double exhaustTemp5;

  // Другие параметры
  final double turboPressure;
  final double airIntakeTemp;
  final double batteryVoltage;
  final double oilLevel;
  final double coolantLevel;
  final double fuelLevel;
  final double engineHours;

  final DateTime timestamp;

  EngineData({
    required this.rpm,
    required this.engineLoad,
    required this.oilTemperature,
    required this.oilPressure,
    required this.coolantTemperature,
    required this.coolantPressure,
    required this.fuelPressure,
    required this.fuelConsumption,
    required this.exhaustTemp1,
    required this.exhaustTemp2,
    required this.exhaustTemp3,
    required this.exhaustTemp4,
    required this.exhaustTemp5,
    required this.turboPressure,
    required this.airIntakeTemp,
    required this.batteryVoltage,
    required this.oilLevel,
    required this.coolantLevel,
    required this.fuelLevel,
    required this.engineHours,
    required this.timestamp,
  });

  factory EngineData.fromJson(Map<String, dynamic> json) {
    print("Received JSON: $json");
    return EngineData(
      // Основные параметры двигателя
      rpm: (json['rpm'] ?? 0).toDouble(),
      engineLoad: (json['engine_load'] ?? 0).toDouble(),

      // Параметры масла
      oilTemperature: (json['oil_temperature'] ?? 0).toDouble(),
      oilPressure: (json['oil_pressure'] ?? 0).toDouble(),

      // Параметры охлаждающей жидкости
      coolantTemperature: (json['coolant_temperature'] ?? 0).toDouble(),
      coolantPressure: (json['coolant_pressure'] ?? 0).toDouble(),

      // Параметры топлива
      fuelPressure: (json['fuel_pressure'] ?? 0).toDouble(),
      fuelConsumption: (json['fuel_consumption'] ?? 0).toDouble(),

      // Температурные параметры выхлопа
      exhaustTemp1: (json['exhaust_temp_1'] ?? 0).toDouble(),
      exhaustTemp2: (json['exhaust_temp_2'] ?? 0).toDouble(),
      exhaustTemp3: (json['exhaust_temp_3'] ?? 0).toDouble(),
      exhaustTemp4: (json['exhaust_temp_4'] ?? 0).toDouble(),
      exhaustTemp5: (json['exhaust_temp_5'] ?? 0).toDouble(),

      // Другие параметры
      turboPressure: (json['turbo_pressure'] ?? 0).toDouble(),
      airIntakeTemp: (json['air_intake_temp'] ?? 0).toDouble(),
      batteryVoltage: (json['battery_voltage'] ?? 0).toDouble(),
      oilLevel: (json['oil_level'] ?? 0).toDouble(),
      coolantLevel: (json['coolant_level'] ?? 0).toDouble(),
      fuelLevel: (json['fuel_level'] ?? 0).toDouble(),
      engineHours: (json['engine_hours'] ?? 0).toDouble(),

      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
    );
  }
}
