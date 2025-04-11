import 'package:flutter/material.dart';

class SystemParameter {
  final String id;
  final String name;
  final String tag; // 3-digit tag code
  final double value;
  final String unit;
  final double minValue;
  final double maxValue;
  final double warningThreshold;
  final bool isWarning;
  final Offset position; // Позиция на схеме (x, y в процентах от 0.0 до 1.0)

  SystemParameter({
    required this.id,
    required this.name,
    required this.tag,
    required this.value,
    required this.unit,
    required this.minValue,
    required this.maxValue,
    required this.warningThreshold,
    required this.isWarning,
    required this.position,
  });

  factory SystemParameter.fromData(
    String id,
    String name,
    String tag,
    double value,
    String unit,
    double minValue,
    double maxValue,
    double warningThreshold,
    Offset position,
  ) {
    bool isWarning = false;

    if (value > warningThreshold) {
      isWarning = true;
    }

    return SystemParameter(
      id: id,
      name: name,
      tag: tag,
      value: value,
      unit: unit,
      minValue: minValue,
      maxValue: maxValue,
      warningThreshold: warningThreshold,
      isWarning: isWarning,
      position: position,
    );
  }
}

class SystemSchema {
  final String id;
  final String name;
  final String description;
  final String schemaAsset; // Путь к изображению схемы
  final List<SystemParameter> parameters;

  SystemSchema({
    required this.id,
    required this.name,
    required this.description,
    required this.schemaAsset,
    required this.parameters,
  });
}
