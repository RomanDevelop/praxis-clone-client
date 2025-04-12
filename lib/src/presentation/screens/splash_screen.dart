import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/ship_wheel.dart';
import '../viewmodels/splash_viewmodel.dart';
import '../../domain/app_theme.dart';
import 'main_screen.dart';
import 'dart:math' as Math;

/// Компонент SplashScreen с использованием MVVM
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // Инициализация ViewModel (через Riverpod)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(splashProvider.notifier).initialize(
            _animationController,
            context,
            const MainScreen(),
          );

      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Получаем текущее состояние из ViewModel
    final splashState = ref.watch(splashProvider);

    return Scaffold(
      backgroundColor: AppTheme.primaryBackground,
      body: RepaintBoundary(
        child: Center(
          child: Opacity(
            opacity: splashState.fadeValue,
            child: Transform.scale(
              scale: splashState.scaleValue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Ship wheel logo с вращением и пульсацией
                  RepaintBoundary(
                    child: Transform.scale(
                      scale: splashState.pulseValue,
                      child: Transform.rotate(
                        angle: splashState.rotateValue * 2 * Math.pi,
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryAccent,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                              // Glowing эффект, пульсирующий с анимацией
                              BoxShadow(
                                color: AppTheme.accentColor.withOpacity(
                                    0.3 + splashState.pulseValue * 0.1),
                                blurRadius: 20 + splashState.pulseValue * 15,
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
                  // Текст заголовка с анимированной тенью
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
                            color: Colors.blue
                                .withOpacity(0.3 + splashState.fadeValue * 0.3),
                            blurRadius: 5 + splashState.fadeValue * 10,
                            offset: Offset(0, 3 + splashState.fadeValue * 3),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Подзаголовок с анимированной тенью
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
                            color: AppTheme.accentColor.withOpacity(
                                0.3 + splashState.scaleValue * 0.4),
                            blurRadius: 5 + splashState.scaleValue * 10,
                            offset: Offset(0, 2 + splashState.scaleValue * 4),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                  // Индикатор загрузки со скользящей анимацией
                  RepaintBoundary(
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(-0.2, 0),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve:
                              const Interval(0.4, 0.8, curve: Curves.easeOut),
                        ),
                      ),
                      child: SizedBox(
                        width: 180,
                        child: LinearProgressIndicator(
                          value: _animationController.value,
                          backgroundColor: AppTheme.primaryAccent,
                          color: AppTheme.accentColor,
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
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
}
