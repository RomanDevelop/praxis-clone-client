import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/src/domain/system_schema.dart';
import 'package:client/src/shared/providers.dart';

// Provider для схем систем
final systemSchemaViewModelProvider =
    StateNotifierProvider<SystemSchemaViewModel, Map<String, SystemSchema>>(
        (ref) {
  return SystemSchemaViewModel(ref);
});

// Provider для текущей выбранной схемы
final selectedSchemaProvider = StateProvider<String>((ref) {
  return ref.read(systemSchemaViewModelProvider).keys.first;
});

class SystemSchemaViewModel extends StateNotifier<Map<String, SystemSchema>> {
  final Ref _ref;

  SystemSchemaViewModel(this._ref) : super({}) {
    _loadSchemas();
  }

  void _loadSchemas() {
    // Создаем схемы систем
    state = {
      'SYS_FUEL': _createFuelSystemSchema(),
      'SYS_LUBRICATION': _createLubricationSystemSchema(),
      'SYS_COOLING': _createCoolingSystemSchema(),
      'SYS_EXHAUST': _createExhaustSystemSchema(),
    };
  }

  // Получает схему по ID группы
  SystemSchema? getSchemaByGroupId(String groupId) {
    return state[groupId];
  }

  void updateParameters() {
    // To avoid modifying state during initialization, use a safer approach
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Get current engine data
      final engineData = _ref.read(engineViewModelProvider);
      if (engineData == null) return;

      // Create a copy of the current state to work with
      final currentState = Map<String, SystemSchema>.from(state);
      final updatedSchemas = <String, SystemSchema>{};

      // Update each schema separately
      currentState.forEach((key, schema) {
        final updatedParameters = schema.parameters.map((param) {
          double newValue = param.value;

          // Update values based on engine data
          switch (param.id) {
            case 'FUEL_PRESS':
              newValue = engineData.fuelPressure;
              break;
            case 'OIL_TEMP':
              newValue = engineData.oilTemperature;
              break;
            case 'COOLANT_TEMP':
              newValue = engineData.coolantTemperature;
              break;
            case 'ENGINE_LOAD':
              newValue = engineData.engineLoad;
              break;
            case 'RPM':
              newValue = engineData.rpm;
              break;
            case 'FUEL_TEMP':
              newValue = engineData.coolantTemperature - 10;
              break;
            case 'EXHAUST_TEMP':
              newValue = engineData.exhaustTemp1;
              break;
            default:
              // Keep current value
              break;
          }

          // Create updated parameter
          return SystemParameter(
            id: param.id,
            name: param.name,
            tag: param.tag,
            value: newValue,
            unit: param.unit,
            minValue: param.minValue,
            maxValue: param.maxValue,
            warningThreshold: param.warningThreshold,
            isWarning: newValue > param.warningThreshold,
            position: param.position,
          );
        }).toList();

        // Create updated schema
        updatedSchemas[key] = SystemSchema(
          id: schema.id,
          name: schema.name,
          description: schema.description,
          schemaAsset: schema.schemaAsset,
          parameters: updatedParameters,
        );
      });

      // Set state only if we have updates
      if (updatedSchemas.isNotEmpty) {
        state = updatedSchemas;
      }
    });
  }

  // Создаем схемы систем с начальными параметрами
  SystemSchema _createFuelSystemSchema() {
    return SystemSchema(
      id: 'SYS_FUEL',
      name: 'Fuel System',
      description: 'Main engine fuel management system diagram',
      schemaAsset: 'assets/images/fuel_system_schema.png',
      parameters: [
        SystemParameter.fromData(
          'FUEL_PRESS',
          'Fuel Pressure',
          '101',
          5.0,
          'bar',
          0.0,
          10.5,
          7.35,
          const Offset(0.3, 0.4),
        ),
        SystemParameter.fromData(
          'FUEL_TEMP',
          'Fuel Temperature',
          '102',
          65.0,
          '°C',
          20.0,
          126.0,
          94.5,
          const Offset(0.7, 0.3),
        ),
        SystemParameter.fromData(
          'FUEL_FLOW',
          'Fuel Flow Rate',
          '103',
          120.0,
          'l/h',
          0.0,
          210.0,
          189.0,
          const Offset(0.5, 0.7),
        ),
      ],
    );
  }

  SystemSchema _createLubricationSystemSchema() {
    return SystemSchema(
      id: 'SYS_LUBRICATION',
      name: 'Lubrication System',
      description: 'Main engine oil lubrication system diagram',
      schemaAsset: 'assets/images/lubrication_system_schema.png',
      parameters: [
        SystemParameter.fromData(
          'OIL_PRESS',
          'Oil Pressure',
          '201',
          4.2,
          'bar',
          1.0,
          6.3,
          5.775,
          const Offset(0.4, 0.5),
        ),
        SystemParameter.fromData(
          'OIL_TEMP',
          'Oil Temperature',
          '202',
          82.0,
          '°C',
          50.0,
          115.5,
          94.5,
          const Offset(0.6, 0.3),
        ),
        SystemParameter.fromData(
          'OIL_LEVEL',
          'Oil Level',
          '203',
          85.0,
          '%',
          50.0,
          105.0,
          63.0,
          const Offset(0.2, 0.7),
        ),
      ],
    );
  }

  SystemSchema _createCoolingSystemSchema() {
    return SystemSchema(
      id: 'SYS_COOLING',
      name: 'Cooling System',
      description: 'Main engine cooling and temperature control system diagram',
      schemaAsset: 'assets/images/cooling_system_schema.png',
      parameters: [
        SystemParameter.fromData(
          'COOLANT_TEMP',
          'Coolant Temperature',
          '301',
          75.0,
          '°C',
          40.0,
          115.5,
          99.75,
          const Offset(0.5, 0.4),
        ),
        SystemParameter.fromData(
          'COOLANT_PRESS',
          'Coolant Pressure',
          '302',
          2.8,
          'bar',
          1.0,
          4.2,
          3.675,
          const Offset(0.7, 0.6),
        ),
        SystemParameter.fromData(
          'COOLANT_LEVEL',
          'Coolant Level',
          '303',
          90.0,
          '%',
          60.0,
          105.0,
          73.5,
          const Offset(0.3, 0.7),
        ),
      ],
    );
  }

  SystemSchema _createExhaustSystemSchema() {
    return SystemSchema(
      id: 'SYS_EXHAUST',
      name: 'Exhaust System',
      description: 'Main engine exhaust gas management system diagram',
      schemaAsset: 'assets/images/exhaust_system_schema.png',
      parameters: [
        SystemParameter.fromData(
          'EXHAUST_TEMP',
          'Exhaust Temperature',
          '401',
          450.0,
          '°C',
          300.0,
          630.0,
          577.5,
          const Offset(0.6, 0.3),
        ),
        SystemParameter.fromData(
          'EXHAUST_BACK_PRESS',
          'Exhaust Back Pressure',
          '402',
          3.2,
          'kPa',
          0.0,
          10.5,
          8.4,
          const Offset(0.4, 0.5),
        ),
        SystemParameter.fromData(
          'ENGINE_LOAD',
          'Engine Load',
          '403',
          65.0,
          '%',
          0.0,
          105.0,
          94.5,
          const Offset(0.7, 0.7),
        ),
        SystemParameter.fromData(
          'RPM',
          'Engine Speed',
          '404',
          850.0,
          'rpm',
          0.0,
          1575.0,
          1260.0,
          const Offset(0.2, 0.4),
        ),
      ],
    );
  }
}
