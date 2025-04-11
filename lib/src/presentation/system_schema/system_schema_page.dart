import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/src/shared/providers.dart';
import 'package:client/src/domain/system_schema.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

class SystemSchemaPage extends ConsumerWidget {
  final String systemGroupId;

  const SystemSchemaPage({
    super.key,
    required this.systemGroupId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final systemSchema = ref.watch(systemSchemaProvider(systemGroupId));

    return Scaffold(
      backgroundColor: const Color(0xFF333333),
      appBar: AppBar(
        backgroundColor: const Color(0xFF222222),
        title: Text(
          systemSchema?.name ?? 'System Diagram',
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Схема системы, нарисованная вместо изображения
          Positioned.fill(
            child: RepaintBoundary(
              child: CustomPaint(
                painter: SystemSchemaPainter(
                  schemaId: systemSchema?.id ?? '',
                ),
                size: Size.infinite,
              ),
            ),
          ),

          // Индикаторы параметров на схеме
          ...systemSchema?.parameters
                  .map((param) => _buildParameterIndicator(context, param)) ??
              [],

          // Список параметров внизу экрана
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: RepaintBoundary(
              child: Container(
                height: 160,
                padding: const EdgeInsets.all(8),
                color: const Color(0xFF222222),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PARAMETERS',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 2.5,
                        children: systemSchema?.parameters
                                .map((param) => _buildParameterCard(param))
                                .toList() ??
                            [],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Создает индикатор параметра на схеме
  Widget _buildParameterIndicator(BuildContext context, SystemParameter param) {
    // Получаем размеры экрана
    final screenSize = MediaQuery.of(context).size;

    // Вычисляем позицию на экране на основе относительных координат
    final position = Offset(
      param.position.dx * screenSize.width,
      param.position.dy *
          screenSize.height *
          0.6, // Уменьшаем высоту, так как у нас есть панели сверху и снизу
    );

    return Positioned(
      left: position.dx - 25, // Смещаем, чтобы центрировать
      top: position.dy - 25, // Смещаем, чтобы центрировать
      child: RepaintBoundary(
        child: GestureDetector(
          onTap: () => _showParameterDetails(context, param),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: param.isWarning
                  ? Colors.red.withOpacity(0.9)
                  : Colors.blue.withOpacity(0.9),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: param.isWarning
                      ? Colors.red.withOpacity(0.5)
                      : Colors.blue.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    param.tag,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    param.value.toStringAsFixed(1),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Создает карточку с информацией о параметре
  Widget _buildParameterCard(SystemParameter param) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF444444),
        borderRadius: BorderRadius.circular(4),
        border: param.isWarning
            ? Border.all(color: Colors.red.withOpacity(0.7), width: 1.5)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              if (param.isWarning)
                const Icon(
                  Icons.warning,
                  color: Colors.red,
                  size: 14,
                ),
              if (param.isWarning) const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${param.tag} - ${param.name}',
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${param.value.toStringAsFixed(1)} ${param.unit}',
            style: TextStyle(
              color: param.isWarning ? Colors.red : Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Показывает диалоговое окно с подробной информацией о параметре
  void _showParameterDetails(BuildContext context, SystemParameter param) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF3A3A3A),
        title: Text(
          '${param.tag} - ${param.name}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Current Value',
                '${param.value.toStringAsFixed(1)} ${param.unit}'),
            _buildDetailRow('Min Value', '${param.minValue} ${param.unit}'),
            _buildDetailRow('Max Value', '${param.maxValue} ${param.unit}'),
            _buildDetailRow(
                'Warning Threshold', '${param.warningThreshold} ${param.unit}'),
            _buildDetailRow('Status', param.isWarning ? 'Warning' : 'Normal',
                color: param.isWarning ? Colors.red : Colors.green),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('CLOSE'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  // Создает строку с данными для диалогового окна
  Widget _buildDetailRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color ?? Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

// Кастомный painter для отрисовки схемы системы
class SystemSchemaPainter extends CustomPainter {
  final String schemaId;

  SystemSchemaPainter({required this.schemaId});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final backgroundPaint = Paint()
      ..color = const Color(0xFF383838)
      ..style = PaintingStyle.fill;

    // Заполняем фон
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.35;

    // В зависимости от ID схемы рисуем разные элементы
    switch (schemaId) {
      case 'SYS_FUEL':
        _drawFuelSystem(canvas, size, paint);
        break;
      case 'SYS_LUBRICATION':
        _drawLubricationSystem(canvas, size, paint);
        break;
      case 'SYS_COOLING':
        _drawCoolingSystem(canvas, size, paint);
        break;
      case 'SYS_EXHAUST':
        _drawExhaustSystem(canvas, size, paint);
        break;
      default:
        // Рисуем простую схему по умолчанию
        _drawDefaultSystem(canvas, size, center, radius, paint);
        break;
    }
  }

  void _drawFuelSystem(Canvas canvas, Size size, Paint paint) {
    final width = size.width;
    final height = size.height;

    // Основные линии и элементы топливной системы
    Paint fuelPaint = Paint()
      ..color = Colors.amber.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    Paint tankPaint = Paint()
      ..color = Colors.amber.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // Топливный бак
    final tankRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(width * 0.1, height * 0.2, width * 0.2, height * 0.3),
      const Radius.circular(10),
    );
    canvas.drawRRect(tankRect, tankPaint);
    canvas.drawRRect(tankRect, fuelPaint);

    // Топливный насос (круг)
    canvas.drawCircle(
      Offset(width * 0.5, height * 0.3),
      20,
      Paint()..color = Colors.grey.withOpacity(0.3),
    );
    canvas.drawCircle(
      Offset(width * 0.5, height * 0.3),
      20,
      Paint()
        ..color = Colors.blue.withOpacity(0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );

    // Инжектор (прямоугольник)
    canvas.drawRect(
      Rect.fromLTWH(width * 0.7, height * 0.35, width * 0.2, height * 0.1),
      Paint()..color = Colors.grey.withOpacity(0.5),
    );
    canvas.drawRect(
      Rect.fromLTWH(width * 0.7, height * 0.35, width * 0.2, height * 0.1),
      fuelPaint,
    );

    // Соединительные линии
    final path = Path()
      ..moveTo(width * 0.3, height * 0.35)
      ..lineTo(width * 0.5 - 20, height * 0.35)
      ..moveTo(width * 0.5 + 20, height * 0.3)
      ..lineTo(width * 0.7, height * 0.4);

    canvas.drawPath(path, fuelPaint);
  }

  void _drawLubricationSystem(Canvas canvas, Size size, Paint paint) {
    final width = size.width;
    final height = size.height;

    // Основные линии и элементы системы смазки
    Paint oilPaint = Paint()
      ..color = Colors.orange.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    Paint reservoirPaint = Paint()
      ..color = Colors.orange.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // Масляный резервуар
    final reservoirRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(width * 0.1, height * 0.5, width * 0.2, height * 0.2),
      const Radius.circular(5),
    );
    canvas.drawRRect(reservoirRect, reservoirPaint);
    canvas.drawRRect(reservoirRect, oilPaint);

    // Масляный насос
    canvas.drawCircle(
      Offset(width * 0.4, height * 0.4),
      25,
      Paint()..color = Colors.grey.withOpacity(0.3),
    );
    canvas.drawCircle(
      Offset(width * 0.4, height * 0.4),
      25,
      oilPaint,
    );

    // Масляный фильтр
    canvas.drawCircle(
      Offset(width * 0.6, height * 0.5),
      20,
      Paint()..color = Colors.grey.withOpacity(0.5),
    );
    canvas.drawCircle(
      Offset(width * 0.6, height * 0.5),
      20,
      oilPaint,
    );

    // Блок двигателя
    canvas.drawRect(
      Rect.fromLTWH(width * 0.7, height * 0.3, width * 0.2, height * 0.3),
      Paint()..color = Colors.grey.withOpacity(0.4),
    );
    canvas.drawRect(
      Rect.fromLTWH(width * 0.7, height * 0.3, width * 0.2, height * 0.3),
      Paint()
        ..color = Colors.blueGrey.withOpacity(0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );

    // Соединительные линии
    final path = Path()
      ..moveTo(width * 0.3, height * 0.6)
      ..lineTo(width * 0.4, height * 0.6)
      ..lineTo(width * 0.4, height * 0.4 + 25)
      ..moveTo(width * 0.4 + 25, height * 0.4)
      ..lineTo(width * 0.6 - 20, height * 0.5)
      ..moveTo(width * 0.6 + 20, height * 0.5)
      ..lineTo(width * 0.7, height * 0.5);

    canvas.drawPath(path, oilPaint);
  }

  void _drawCoolingSystem(Canvas canvas, Size size, Paint paint) {
    final width = size.width;
    final height = size.height;

    // Основные линии и элементы системы охлаждения
    Paint coolantPaint = Paint()
      ..color = Colors.cyan.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    Paint radiatorPaint = Paint()
      ..color = Colors.cyan.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // Радиатор
    canvas.drawRect(
      Rect.fromLTWH(width * 0.1, height * 0.2, width * 0.15, height * 0.4),
      radiatorPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(width * 0.1, height * 0.2, width * 0.15, height * 0.4),
      coolantPaint,
    );

    // Водяной насос
    canvas.drawCircle(
      Offset(width * 0.4, height * 0.5),
      22,
      Paint()..color = Colors.grey.withOpacity(0.3),
    );
    canvas.drawCircle(
      Offset(width * 0.4, height * 0.5),
      22,
      coolantPaint,
    );

    // Термостат
    canvas.drawCircle(
      Offset(width * 0.55, height * 0.3),
      15,
      Paint()..color = Colors.grey.withOpacity(0.4),
    );
    canvas.drawCircle(
      Offset(width * 0.55, height * 0.3),
      15,
      coolantPaint,
    );

    // Блок двигателя
    final engineRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(width * 0.7, height * 0.25, width * 0.2, height * 0.35),
      const Radius.circular(5),
    );
    canvas.drawRRect(
      engineRect,
      Paint()..color = Colors.grey.withOpacity(0.4),
    );
    canvas.drawRRect(
      engineRect,
      Paint()
        ..color = Colors.blueGrey.withOpacity(0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );

    // Соединительные линии
    final path = Path()
      ..moveTo(width * 0.25, height * 0.3)
      ..lineTo(width * 0.55, height * 0.3)
      ..moveTo(width * 0.55 + 15, height * 0.3)
      ..lineTo(width * 0.7, height * 0.3)
      ..moveTo(width * 0.7, height * 0.55)
      ..lineTo(width * 0.4 + 22, height * 0.55)
      ..moveTo(width * 0.4 - 22, height * 0.5)
      ..lineTo(width * 0.25, height * 0.5);

    canvas.drawPath(path, coolantPaint);
  }

  void _drawExhaustSystem(Canvas canvas, Size size, Paint paint) {
    final width = size.width;
    final height = size.height;

    // Основные линии и элементы выхлопной системы
    Paint exhaustPaint = Paint()
      ..color = Colors.red.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    Paint manifoldPaint = Paint()
      ..color = Colors.red.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    // Двигатель
    final engineRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(width * 0.1, height * 0.3, width * 0.25, height * 0.3),
      const Radius.circular(5),
    );
    canvas.drawRRect(
      engineRect,
      Paint()..color = Colors.grey.withOpacity(0.4),
    );
    canvas.drawRRect(
      engineRect,
      Paint()
        ..color = Colors.blueGrey.withOpacity(0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );

    // Выпускной коллектор
    final manifoldPath = Path()
      ..moveTo(width * 0.35, height * 0.35)
      ..lineTo(width * 0.45, height * 0.35)
      ..lineTo(width * 0.45, height * 0.55)
      ..lineTo(width * 0.35, height * 0.55)
      ..close();

    canvas.drawPath(manifoldPath, manifoldPaint);
    canvas.drawPath(manifoldPath, exhaustPaint);

    // Турбина
    canvas.drawCircle(
      Offset(width * 0.55, height * 0.45),
      25,
      Paint()..color = Colors.grey.withOpacity(0.3),
    );
    canvas.drawCircle(
      Offset(width * 0.55, height * 0.45),
      25,
      exhaustPaint,
    );

    // Выхлопная труба
    final pipePath = Path()
      ..moveTo(width * 0.55 + 25, height * 0.45)
      ..lineTo(width * 0.85, height * 0.45)
      ..lineTo(width * 0.85, height * 0.6);

    canvas.drawPath(pipePath, exhaustPaint);

    // Глушитель
    final mufflerRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(width * 0.75, height * 0.6, width * 0.2, height * 0.1),
      const Radius.circular(10),
    );
    canvas.drawRRect(
      mufflerRect,
      Paint()..color = Colors.grey.withOpacity(0.4),
    );
    canvas.drawRRect(mufflerRect, exhaustPaint);
  }

  void _drawDefaultSystem(
      Canvas canvas, Size size, Offset center, double radius, Paint paint) {
    // Default schema - just draw a simple diagram
    canvas.drawCircle(center, radius, paint);

    // Draw some cross lines
    canvas.drawLine(
      Offset(center.dx - radius, center.dy),
      Offset(center.dx + radius, center.dy),
      paint,
    );

    canvas.drawLine(
      Offset(center.dx, center.dy - radius),
      Offset(center.dx, center.dy + radius),
      paint,
    );

    // Draw a rectangle around
    canvas.drawRect(
      Rect.fromLTRB(
        center.dx - radius * 1.2,
        center.dy - radius * 1.2,
        center.dx + radius * 1.2,
        center.dy + radius * 1.2,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
