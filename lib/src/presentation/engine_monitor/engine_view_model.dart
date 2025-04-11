import 'package:client/src/data/engine_service.dart';
import 'package:client/src/domain/engine_data.dart';
import 'package:client/src/domain/engine_parameter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

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
        "Updating parameters with data: rpm=${data.rpm}, oilTemp=${data.oilTemp}, coolantTemp=${data.coolantTemp}, pressure=${data.pressure}, load=${data.load}");

    try {
      _parameters = [
        // Основные параметры двигателя
        EngineParameter.fromData(
            _parameterTags['RPM']!, 'RPM', data.rpm, 'rpm', 'H', 1200.0, 1),
        EngineParameter.fromData(_parameterTags['ENGINE_LOAD']!, 'ENGINE LOAD',
            data.load, '%', 'H', 90.0, 1),

        // Параметры масла
        EngineParameter.fromData(_parameterTags['OIL_TEMPERATURE']!,
            'OIL TEMPERATURE', data.oilTemp, 'C', 'H', 85.0, 1),
        EngineParameter.fromData(_parameterTags['OIL_PRESSURE']!,
            'OIL PRESSURE', data.pressure, 'bar', 'L', 3.0, 1),

        // Параметры охлаждающей жидкости
        EngineParameter.fromData(_parameterTags['COOLANT_TEMPERATURE']!,
            'COOLANT TEMPERATURE', data.coolantTemp, 'C', 'H', 95.0, 1),
        EngineParameter.fromData(_parameterTags['COOLANT_PRESSURE']!,
            'COOLANT PRESSURE', data.pressure / 2, 'bar', 'L', 1.0, 1),

        // Параметры топлива
        EngineParameter.fromData(_parameterTags['FUEL_PRESSURE']!,
            'FUEL PRESSURE', data.pressure, 'bar', 'L', 3.0, 1),
        EngineParameter.fromData(_parameterTags['FUEL_CONSUMPTION']!,
            'FUEL CONSUMPTION', data.load / 10, 'l/h', 'H', 10.0, 1),

        // Температурные параметры
        EngineParameter.fromData(_parameterTags['EXHAUST_TEMP_1']!,
            'EXHAUST TEMP 1', data.oilTemp * 4 + 100, 'C', 'H', 450.0, 1),
        EngineParameter.fromData(_parameterTags['EXHAUST_TEMP_2']!,
            'EXHAUST TEMP 2', data.oilTemp * 4 + 120, 'C', 'H', 450.0, 1),
        EngineParameter.fromData(_parameterTags['EXHAUST_TEMP_3']!,
            'EXHAUST TEMP 3', data.oilTemp * 4 + 90, 'C', 'H', 450.0, 1),
        EngineParameter.fromData(_parameterTags['EXHAUST_TEMP_4']!,
            'EXHAUST TEMP 4', data.oilTemp * 4 + 110, 'C', 'H', 450.0, 1),
        EngineParameter.fromData(_parameterTags['EXHAUST_TEMP_5']!,
            'EXHAUST TEMP 5', data.oilTemp * 4 + 105, 'C', 'H', 450.0, 1),

        // Другие параметры
        EngineParameter.fromData(_parameterTags['TURBO_PRESSURE']!,
            'TURBO PRESSURE', data.pressure * 1.5, 'bar', 'H', 5.0, 1),
        EngineParameter.fromData(_parameterTags['AIR_INTAKE_TEMP']!,
            'AIR INTAKE TEMP', data.coolantTemp / 2, 'C', 'H', 60.0, 1),
        EngineParameter.fromData(_parameterTags['BATTERY_VOLTAGE']!,
            'BATTERY VOLTAGE', 12 + data.load / 100, 'V', 'L', 11.5, 1),
        EngineParameter.fromData(_parameterTags['OIL_LEVEL']!, 'OIL LEVEL',
            80 + data.rpm / 100, '%', 'L', 70.0, 1),
        EngineParameter.fromData(_parameterTags['COOLANT_LEVEL']!,
            'COOLANT LEVEL', 85 + data.coolantTemp / 100, '%', 'L', 75.0, 1),
        EngineParameter.fromData(_parameterTags['FUEL_LEVEL']!, 'FUEL LEVEL',
            70 - data.load / 10, '%', 'L', 20.0, 1),
        EngineParameter.fromData(_parameterTags['ENGINE_HOURS']!,
            'ENGINE HOURS', 1250 + data.rpm / 1000, 'h', '', 0.0, 1),
      ];

      print("Generated ${_parameters.length} parameters");
    } catch (e) {
      print("Error generating parameters: $e");
    }
  }

  List<EngineParameter> get parameters => _parameters;
}
