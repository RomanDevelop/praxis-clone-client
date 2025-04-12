// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'dart:math' as Math;
import 'src/presentation/main_navigation.dart';
import 'src/presentation/screens/ship_position_screen.dart';
import 'src/domain/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: ShipMonitorApp()));
}

/// Главный компонент приложения
class ShipMonitorApp extends StatelessWidget {
  const ShipMonitorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ship Engine Monitor',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    // Pulsing animation for the wheel
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Rotation animation for the wheel
    _rotateAnimation = Tween<double>(begin: 0.0, end: 0.25).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 0.9, curve: Curves.easeInOut),
      ),
    );

    _animationController.forward();

    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavigationWithDrawer()),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A2639),
      body: RepaintBoundary(
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Ship wheel logo with pulse and rotate animations
                      RepaintBoundary(
                        child: Transform.scale(
                          scale: _pulseAnimation.value,
                          child: Transform.rotate(
                            angle: _rotateAnimation.value * 2 * Math.pi,
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                color: const Color(0xFF3E4C5E),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                  // Glowing effect that pulses with animation
                                  BoxShadow(
                                    color: Colors.cyan.withOpacity(
                                        0.3 + _pulseAnimation.value * 0.1),
                                    blurRadius: 20 + _pulseAnimation.value * 15,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: CustomPaint(
                                painter: ShipWheelPainter(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Title text with animated shadow
                      RepaintBoundary(
                        child: Text(
                          'SEAMENS CLUB',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.blue.withOpacity(
                                    0.3 + _fadeAnimation.value * 0.3),
                                blurRadius: 5 + _fadeAnimation.value * 10,
                                offset: Offset(0, 3 + _fadeAnimation.value * 3),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Subtitle text
                      RepaintBoundary(
                        child: Text(
                          'AI HUB',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 8.0,
                            color: Colors.cyan.shade300,
                            shadows: [
                              Shadow(
                                color: Colors.cyan.withOpacity(
                                    0.3 + _scaleAnimation.value * 0.4),
                                blurRadius: 5 + _scaleAnimation.value * 10,
                                offset:
                                    Offset(0, 2 + _scaleAnimation.value * 4),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),
                      // Loading indicator with sliding animation
                      RepaintBoundary(
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(-0.2, 0),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: _animationController,
                              curve: const Interval(0.4, 0.8,
                                  curve: Curves.easeOut),
                            ),
                          ),
                          child: SizedBox(
                            width: 180,
                            child: LinearProgressIndicator(
                              value: _animationController.value,
                              backgroundColor: const Color(0xFF3E4C5E),
                              color: Colors.cyan,
                              minHeight: 6,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// Custom painter for ship wheel logo
class ShipWheelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;

    // Paint for the ship wheel
    final wheelPaint = Paint()
      ..color = Colors.cyan.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    // Paint for the spokes
    final spokePaint = Paint()
      ..color = Colors.cyan.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    // Paint for the center
    final centerPaint = Paint()
      ..color = Colors.cyan.shade300
      ..style = PaintingStyle.fill;

    // Draw outer rim
    canvas.drawCircle(center, radius, wheelPaint);

    // Draw inner rim
    canvas.drawCircle(center, radius * 0.7, wheelPaint);

    // Draw center
    canvas.drawCircle(center, radius * 0.2, centerPaint);

    // Draw 8 spokes
    for (int i = 0; i < 8; i++) {
      final angle = i * 3.14159 / 4;
      final innerX = center.dx + radius * 0.7 * cos(angle);
      final innerY = center.dy + radius * 0.7 * sin(angle);
      final outerX = center.dx + radius * cos(angle);
      final outerY = center.dy + radius * sin(angle);

      canvas.drawLine(
        Offset(innerX, innerY),
        Offset(outerX, outerY),
        spokePaint,
      );

      // Draw handle
      final handleLength = radius * 0.2;
      final handleWidth = radius * 0.1;

      final handlePaint = Paint()
        ..color = Colors.cyan.shade300
        ..style = PaintingStyle.fill;

      final handleRect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(outerX, outerY),
          width: handleWidth,
          height: handleLength,
        ),
        const Radius.circular(5),
      );

      // Rotate the canvas to align the handle along the spoke
      canvas.save();
      canvas.translate(outerX, outerY);
      canvas.rotate(angle + 3.14159 / 2);
      canvas.translate(-outerX, -outerY);

      canvas.drawRRect(handleRect, handlePaint);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ShipWheelPainter oldDelegate) => false;
}

double cos(double angle) => Math.cos(angle);
double sin(double angle) => Math.sin(angle);

// Wrap MainNavigation with a drawer
class MainNavigationWithDrawer extends StatefulWidget {
  const MainNavigationWithDrawer({super.key});

  @override
  State<MainNavigationWithDrawer> createState() =>
      _MainNavigationWithDrawerState();
}

class _MainNavigationWithDrawerState extends State<MainNavigationWithDrawer>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _animationController;
  late Animation<double> _rotateAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Инициализация контроллера анимации для логотипа в drawer
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10), // Медленное вращение
    );

    // Анимация вращения (полный круг)
    _rotateAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );

    // Пульсирующая анимация
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Запускаем повторяющуюся анимацию
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF3E4C5E),
                  shape: BoxShape.circle,
                ),
                child: CustomPaint(
                  painter: ShipWheelPainter(),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                "SCAIH",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.headset_mic, color: Colors.teal),
            onPressed: () {},
          ),
        ],
      ),
      drawer: SafeArea(
        child: Drawer(
          backgroundColor: const Color(0xFF1A1A1A),
          width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                height: MediaQuery.of(context).size.height *
                    0.3, // 30% высоты экрана для лого
                color: const Color(0xFF121212),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Анимированный логотип
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _pulseAnimation.value,
                            child: Transform.rotate(
                              angle: _rotateAnimation.value * 2 * Math.pi,
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3E4C5E),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                    // Glowing effect
                                    BoxShadow(
                                      color: Colors.cyan.withOpacity(
                                          0.3 + _pulseAnimation.value * 0.1),
                                      blurRadius: 15,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: CustomPaint(
                                  painter: ShipWheelPainter(),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      // App name
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Text(
                            "SCAIH",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              shadows: [
                                Shadow(
                                  color: Colors.cyan.withOpacity(
                                      0.3 + _pulseAnimation.value * 0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              _buildDrawerItem(Icons.location_on, 'Ship position'),
              _buildDrawerItem(Icons.anchor, 'Last PSC'),
              _buildDrawerItem(Icons.shopping_bag, 'Master Slopchest'),
              _buildDrawerItem(Icons.support_agent, 'Tech Support'),
              _buildDrawerItem(Icons.shopping_cart, 'Purchasing Dept'),
            ],
          ),
        ),
      ),
      body: const MainNavigation(),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
        size: 24,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      onTap: () {
        // Close drawer
        Navigator.pop(context);

        // Navigate to the appropriate screen based on the title
        if (title == 'Ship position') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ShipPositionScreen()),
          );
        }
      },
    );
  }
}
