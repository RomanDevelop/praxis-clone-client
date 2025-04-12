import 'package:flutter/material.dart';
import 'dart:math' as Math;

/// Виджет ShipWheel, отвечающий за отрисовку штурвала (Single Responsibility Principle)
class ShipWheel extends StatelessWidget {
  final double size;
  final Color color;

  const ShipWheel({
    super.key,
    required this.size,
    this.color = Colors.cyan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF3E4C5E),
        shape: BoxShape.circle,
      ),
      child: CustomPaint(
        painter: ShipWheelPainter(color: color),
      ),
    );
  }
}

/// Анимированный ShipWheel с вращением и пульсацией
class AnimatedShipWheel extends StatefulWidget {
  final double size;
  final Color color;
  final Duration duration;
  final bool autoStart;

  const AnimatedShipWheel({
    super.key,
    required this.size,
    this.color = Colors.cyan,
    this.duration = const Duration(seconds: 10),
    this.autoStart = true,
  });

  @override
  State<AnimatedShipWheel> createState() => _AnimatedShipWheelState();
}

class _AnimatedShipWheelState extends State<AnimatedShipWheel>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotateAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.autoStart) {
      _animationController.repeat();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Запуск анимации
  void startAnimation() {
    _animationController.repeat();
  }

  /// Остановка анимации
  void stopAnimation() {
    _animationController.stop();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Transform.rotate(
            angle: _rotateAnimation.value * 2 * Math.pi,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: const Color(0xFF3E4C5E),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                  BoxShadow(
                    color: widget.color
                        .withOpacity(0.3 + _pulseAnimation.value * 0.1),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: CustomPaint(
                painter: ShipWheelPainter(color: widget.color),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Кастомный painter для отрисовки штурвала
class ShipWheelPainter extends CustomPainter {
  final Color color;

  ShipWheelPainter({this.color = Colors.cyan});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;

    // Paint для штурвала
    final wheelPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    // Paint для спиц
    final spokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    // Paint для центра
    final centerPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Отрисовка внешнего обода
    canvas.drawCircle(center, radius, wheelPaint);

    // Отрисовка внутреннего обода
    canvas.drawCircle(center, radius * 0.7, wheelPaint);

    // Отрисовка центра
    canvas.drawCircle(center, radius * 0.2, centerPaint);

    // Отрисовка 8 спиц
    for (int i = 0; i < 8; i++) {
      final angle = i * Math.pi / 4;
      final innerX = center.dx + radius * 0.7 * Math.cos(angle);
      final innerY = center.dy + radius * 0.7 * Math.sin(angle);
      final outerX = center.dx + radius * Math.cos(angle);
      final outerY = center.dy + radius * Math.sin(angle);

      canvas.drawLine(
        Offset(innerX, innerY),
        Offset(outerX, outerY),
        spokePaint,
      );

      // Отрисовка ручек
      final handleLength = radius * 0.2;
      final handleWidth = radius * 0.1;

      final handlePaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      final handleRect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(outerX, outerY),
          width: handleWidth,
          height: handleLength,
        ),
        const Radius.circular(5),
      );

      // Поворот canvas для выравнивания ручки вдоль спицы
      canvas.save();
      canvas.translate(outerX, outerY);
      canvas.rotate(angle + Math.pi / 2);
      canvas.translate(-outerX, -outerY);

      canvas.drawRRect(handleRect, handlePaint);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ShipWheelPainter oldDelegate) =>
      oldDelegate.color != color;
}
