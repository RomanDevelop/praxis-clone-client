import 'package:client/src/data/engine_service.dart';
import 'package:client/src/domain/engine_data.dart';
import 'package:client/src/domain/engine_parameter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EngineViewModel extends StateNotifier<EngineData?> {
  final EngineService _service;
  List<EngineParameter> _parameters = [];

  // Fixed static tags for all parameters
  static const Map<String, String> _parameterTags = {
    'RPM': '15619',
    'ENGINE_LOAD': '35829',
    'OIL_TEMPERATURE': '88351',
    'OIL_PRESSURE': '93173',
    'COOLANT_TEMPERATURE': '95480',
    'COOLANT_PRESSURE': '73629',
    'FUEL_PRESSURE': '51035',
    'FUEL_CONSUMPTION': '44219',
    'EXHAUST_TEMP_1': '97021',
    'EXHAUST_TEMP_2': '18003',
    'EXHAUST_TEMP_3': '98128',
    'EXHAUST_TEMP_4': '50654',
    'EXHAUST_TEMP_5': '89370',
    'TURBO_PRESSURE': '43781',
    'AIR_INTAKE_TEMP': '33621',
    'BATTERY_VOLTAGE': '64096',
    'OIL_LEVEL': '26781',
    'COOLANT_LEVEL': '77923',
    'FUEL_LEVEL': '59872',
    'ENGINE_HOURS': '10456',
  };

  EngineViewModel(this._service) : super(null) {
    _listen();
  }

  void _listen() {
    _service.getEngineStream().listen((event) {
      state = event;
      _updateParameters(event);
    });
  }

  void _updateParameters(EngineData data) {
    print(
        "Updating parameters with data: rpm=${data.rpm}, oilTemp=${data.oilTemperature}, coolantTemp=${data.coolantTemperature}, pressure=${data.fuelPressure}, load=${data.engineLoad}");

    try {
      _parameters = [
        // Основные параметры двигателя
        EngineParameter.fromData(
            _parameterTags['RPM']!, 'RPM', data.rpm, 'rpm', 'H', 1260.0, 1),
        EngineParameter.fromData(_parameterTags['ENGINE_LOAD']!, 'ENGINE LOAD',
            data.engineLoad, '%', 'H', 94.5, 1),

        // Параметры масла
        EngineParameter.fromData(_parameterTags['OIL_TEMPERATURE']!,
            'OIL TEMPERATURE', data.oilTemperature, 'C', 'H', 89.25, 1),
        EngineParameter.fromData(_parameterTags['OIL_PRESSURE']!,
            'OIL PRESSURE', data.oilPressure, 'bar', 'L', 2.85, 1),

        // Параметры охлаждающей жидкости
        EngineParameter.fromData(_parameterTags['COOLANT_TEMPERATURE']!,
            'COOLANT TEMPERATURE', data.coolantTemperature, 'C', 'H', 99.75, 1),
        EngineParameter.fromData(_parameterTags['COOLANT_PRESSURE']!,
            'COOLANT PRESSURE', data.coolantPressure, 'bar', 'L', 0.95, 1),

        // Параметры топлива
        EngineParameter.fromData(_parameterTags['FUEL_PRESSURE']!,
            'FUEL PRESSURE', data.fuelPressure, 'bar', 'L', 2.85, 1),
        EngineParameter.fromData(_parameterTags['FUEL_CONSUMPTION']!,
            'FUEL CONSUMPTION', data.fuelConsumption, 'l/h', 'H', 10.5, 1),

        // Температурные параметры
        EngineParameter.fromData(_parameterTags['EXHAUST_TEMP_1']!,
            'EXHAUST TEMP 1', data.exhaustTemp1, 'C', 'H', 472.5, 1),
        EngineParameter.fromData(_parameterTags['EXHAUST_TEMP_2']!,
            'EXHAUST TEMP 2', data.exhaustTemp2, 'C', 'H', 472.5, 1),
        EngineParameter.fromData(_parameterTags['EXHAUST_TEMP_3']!,
            'EXHAUST TEMP 3', data.exhaustTemp3, 'C', 'H', 472.5, 1),
        EngineParameter.fromData(_parameterTags['EXHAUST_TEMP_4']!,
            'EXHAUST TEMP 4', data.exhaustTemp4, 'C', 'H', 472.5, 1),
        EngineParameter.fromData(_parameterTags['EXHAUST_TEMP_5']!,
            'EXHAUST TEMP 5', data.exhaustTemp5, 'C', 'H', 472.5, 1),

        // Другие параметры
        EngineParameter.fromData(_parameterTags['TURBO_PRESSURE']!,
            'TURBO PRESSURE', data.turboPressure, 'bar', 'H', 5.25, 1),
        EngineParameter.fromData(_parameterTags['AIR_INTAKE_TEMP']!,
            'AIR INTAKE TEMP', data.airIntakeTemp, 'C', 'H', 63.0, 1),
        EngineParameter.fromData(_parameterTags['BATTERY_VOLTAGE']!,
            'BATTERY VOLTAGE', data.batteryVoltage, 'V', 'L', 10.925, 1),
        EngineParameter.fromData(_parameterTags['OIL_LEVEL']!, 'OIL LEVEL',
            data.oilLevel, '%', 'L', 66.5, 1),
        EngineParameter.fromData(_parameterTags['COOLANT_LEVEL']!,
            'COOLANT LEVEL', data.coolantLevel, '%', 'L', 71.25, 1),
        EngineParameter.fromData(_parameterTags['FUEL_LEVEL']!, 'FUEL LEVEL',
            data.fuelLevel, '%', 'L', 19.0, 1),
        EngineParameter.fromData(_parameterTags['ENGINE_HOURS']!,
            'ENGINE HOURS', data.engineHours, 'h', '', 0.0, 1),
      ];

      print("Generated ${_parameters.length} parameters");
    } catch (e) {
      print("Error generating parameters: $e");
    }
  }

  List<EngineParameter> get parameters => _parameters;
}
