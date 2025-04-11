class EngineParameter {
  final String tag;
  final String description;
  final double value;
  final String units;
  final String limitType; // 'H' for high, 'L' for low
  final double limit;
  final int dt;
  final String status;

  EngineParameter({
    required this.tag,
    required this.description,
    required this.value,
    required this.units,
    required this.limitType,
    required this.limit,
    required this.dt,
    required this.status,
  });

  factory EngineParameter.fromData(String tag, String description, double value,
      String units, String limitType, double limit, int dt) {
    // Ensure value is not NaN or infinite
    if (value.isNaN || value.isInfinite) {
      value = 0.0;
    }

    // Round value to handle floating point precision issues
    final roundedValue = double.parse(value.toStringAsFixed(1));

    // Calculate status based on value and limit
    String status = 'Normal';
    if (limitType == 'H' && roundedValue > limit) {
      status = 'Alarm';
    } else if (limitType == 'L' && roundedValue < limit) {
      status = 'Alarm';
    } else if (roundedValue == 0) {
      status = 'Off';
    }

    return EngineParameter(
      tag: tag,
      description: description,
      value: roundedValue,
      units: units,
      limitType: limitType,
      limit: limit,
      dt: dt,
      status: status,
    );
  }
}
