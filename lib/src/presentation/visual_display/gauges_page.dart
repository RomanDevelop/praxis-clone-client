import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/src/shared/providers.dart';

class GaugesPage extends ConsumerWidget {
  const GaugesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final engineData = ref.watch(engineViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Engine Dashboard'),
        backgroundColor: const Color(0xFF444444),
      ),
      body: engineData == null
          ? const Center(child: CircularProgressIndicator())
          : Container(
              color: const Color(0xFF333333),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'REAL-TIME ENGINE PARAMETERS',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // Первый ряд датчиков
                            SizedBox(
                              height: 200,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: RepaintBoundary(
                                      child: DialGauge(
                                        value: engineData.rpm,
                                        minValue: 0,
                                        maxValue: 1500,
                                        title: 'RPM',
                                        unit: 'rpm',
                                        primaryColor: Colors.blue,
                                        dangerZoneStart: 1200,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: RepaintBoundary(
                                      child: DialGauge(
                                        value: engineData.engineLoad,
                                        minValue: 0,
                                        maxValue: 100,
                                        title: 'LOAD',
                                        unit: '%',
                                        primaryColor: Colors.green,
                                        dangerZoneStart: 85,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Второй ряд датчиков
                            SizedBox(
                              height: 180,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: RepaintBoundary(
                                      child: DialGauge(
                                        value: engineData.oilTemperature,
                                        minValue: 50,
                                        maxValue: 120,
                                        title: 'OIL TEMP',
                                        unit: '°C',
                                        primaryColor: Colors.orange,
                                        dangerZoneStart: 90,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: RepaintBoundary(
                                      child: DialGauge(
                                        value: engineData.coolantTemperature,
                                        minValue: 40,
                                        maxValue: 110,
                                        title: 'COOLANT TEMP',
                                        unit: '°C',
                                        primaryColor: Colors.cyan,
                                        dangerZoneStart: 95,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Третий ряд датчиков
                            SizedBox(
                              height: 180,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: RepaintBoundary(
                                      child: DialGauge(
                                        value: engineData.fuelPressure,
                                        minValue: 0,
                                        maxValue: 10,
                                        title: 'FUEL PRESSURE',
                                        unit: 'bar',
                                        primaryColor: Colors.amber,
                                        dangerZoneStart: 7,
                                        dangerZoneEnd: 2,
                                        isDangerLow: true,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: RepaintBoundary(
                                      child: DialGauge(
                                        value: engineData.exhaustTemp1,
                                        minValue: 300,
                                        maxValue: 600,
                                        title: 'EXHAUST TEMP',
                                        unit: '°C',
                                        primaryColor: Colors.red,
                                        dangerZoneStart: 550,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Replace the GridView with a Column of indicators
                            const SizedBox(height: 16),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildSimpleDigitalIndicator(
                                        'CHARGE AIR TEMP',
                                        engineData.airIntakeTemp
                                            .toStringAsFixed(1),
                                        '°C',
                                        Icons.thermostat,
                                        Colors.teal,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: _buildSimpleDigitalIndicator(
                                        'TURBO PRESSURE',
                                        engineData.turboPressure
                                            .toStringAsFixed(1),
                                        'bar',
                                        Icons.speed,
                                        Colors.indigo,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildSimpleDigitalIndicator(
                                        'OIL PRESSURE',
                                        engineData.oilPressure
                                            .toStringAsFixed(1),
                                        'bar',
                                        Icons.oil_barrel,
                                        Colors.deepOrange,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: _buildSimpleDigitalIndicator(
                                        'BATTERY VOLTAGE',
                                        engineData.batteryVoltage
                                            .toStringAsFixed(1),
                                        'V',
                                        Icons.battery_charging_full,
                                        Colors.purple,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // New simpler digital indicator widget
  Widget _buildSimpleDigitalIndicator(
      String title, String value, String unit, IconData icon, Color color) {
    final numericValue = double.tryParse(value) ?? 0.0;

    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF444444),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and icon row
            Row(
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Value and unit row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(
                      begin: numericValue * 0.8, end: numericValue),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutCubic,
                  builder: (context, animatedValue, child) {
                    return Text(
                      '${animatedValue.toStringAsFixed(1)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DialGauge extends StatefulWidget {
  final double value;
  final double minValue;
  final double maxValue;
  final String title;
  final String unit;
  final Color primaryColor;
  final double dangerZoneStart;
  final double dangerZoneEnd;
  final bool isDangerLow;

  const DialGauge({
    super.key,
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.title,
    required this.unit,
    required this.primaryColor,
    required this.dangerZoneStart,
    this.dangerZoneEnd = 0,
    this.isDangerLow = false,
  });

  @override
  State<DialGauge> createState() => _DialGaugeState();
}

class _DialGaugeState extends State<DialGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _valueAnimation;
  late double _previousValue;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.value;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _valueAnimation = Tween<double>(
      begin: _previousValue,
      end: widget.value,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void didUpdateWidget(DialGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = _valueAnimation.value;
      _valueAnimation = Tween<double>(
        begin: _previousValue,
        end: widget.value,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ));
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.title,
          style: TextStyle(
            color: Colors.grey[300],
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          width: 120,
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: _valueAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: GaugePainter(
                    value: _valueAnimation.value,
                    minValue: widget.minValue,
                    maxValue: widget.maxValue,
                    primaryColor: widget.primaryColor,
                    dangerZoneStart: widget.dangerZoneStart,
                    dangerZoneEnd: widget.dangerZoneEnd,
                    isDangerLow: widget.isDangerLow,
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        AnimatedBuilder(
          animation: _valueAnimation,
          builder: (context, child) {
            return Text(
              '${_valueAnimation.value.toStringAsFixed(1)} ${widget.unit}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ],
    );
  }
}

class GaugePainter extends CustomPainter {
  final double value;
  final double minValue;
  final double maxValue;
  final Color primaryColor;
  final double dangerZoneStart;
  final double dangerZoneEnd;
  final bool isDangerLow;

  GaugePainter({
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.primaryColor,
    required this.dangerZoneStart,
    required this.dangerZoneEnd,
    required this.isDangerLow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.45;
    final arcWidth = size.width * 0.08;

    // Draw background arc
    final bgPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = arcWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 0.8,
      math.pi * 1.4,
      false,
      bgPaint,
    );

    // Calculate value in percentage and convert to angle
    double safeValue = value.clamp(minValue, maxValue);
    double valuePercentage = (safeValue - minValue) / (maxValue - minValue);
    double valueAngle = valuePercentage * math.pi * 1.4;

    // Draw value arc
    final valuePaint = Paint()
      ..color = _getValueColor(safeValue)
      ..style = PaintingStyle.stroke
      ..strokeWidth = arcWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 0.8,
      valueAngle,
      false,
      valuePaint,
    );

    // Draw ticks
    for (int i = 0; i <= 10; i++) {
      final tickAngle = math.pi * 0.8 + (i / 10) * math.pi * 1.4;
      final outerTickRadius = radius + arcWidth / 2;
      final innerTickRadius = radius - arcWidth / 2;
      final dx = math.cos(tickAngle);
      final dy = math.sin(tickAngle);

      final tickPaint = Paint()
        ..color = Colors.grey.withOpacity(0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;

      final p1 = center + Offset(dx * innerTickRadius, dy * innerTickRadius);
      final p2 = center + Offset(dx * outerTickRadius, dy * outerTickRadius);
      canvas.drawLine(p1, p2, tickPaint);
    }

    // Draw needle
    final needlePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final needleAngle = math.pi * 0.8 + valueAngle;
    final needleLength = radius * 0.85;
    final needleX = center.dx + math.cos(needleAngle) * needleLength;
    final needleY = center.dy + math.sin(needleAngle) * needleLength;

    canvas.drawLine(center, Offset(needleX, needleY), needlePaint);

    // Draw center circle
    final centerPaint = Paint()
      ..color = Colors.grey[800]!
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, arcWidth / 2, centerPaint);
    canvas.drawCircle(
        center, arcWidth / 4, Paint()..color = primaryColor.withOpacity(0.8));
  }

  Color _getValueColor(double value) {
    if (isDangerLow) {
      if (value < dangerZoneEnd) {
        return Colors.red;
      }
    } else {
      if (value > dangerZoneStart) {
        return Colors.red;
      }
    }
    return primaryColor;
  }

  @override
  bool shouldRepaint(covariant GaugePainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.minValue != minValue ||
        oldDelegate.maxValue != maxValue ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.dangerZoneStart != dangerZoneStart ||
        oldDelegate.dangerZoneEnd != dangerZoneEnd ||
        oldDelegate.isDangerLow != isDangerLow;
  }
}
