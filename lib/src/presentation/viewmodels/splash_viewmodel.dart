import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

/// Модель для хранения состояния SplashScreen
class SplashState {
  final double fadeValue;
  final double scaleValue;
  final double pulseValue;
  final double rotateValue;
  final bool isFinished;

  const SplashState({
    this.fadeValue = 0.0,
    this.scaleValue = 0.85,
    this.pulseValue = 0.95,
    this.rotateValue = 0.0,
    this.isFinished = false,
  });

  SplashState copyWith({
    double? fadeValue,
    double? scaleValue,
    double? pulseValue,
    double? rotateValue,
    bool? isFinished,
  }) {
    return SplashState(
      fadeValue: fadeValue ?? this.fadeValue,
      scaleValue: scaleValue ?? this.scaleValue,
      pulseValue: pulseValue ?? this.pulseValue,
      rotateValue: rotateValue ?? this.rotateValue,
      isFinished: isFinished ?? this.isFinished,
    );
  }
}

/// Провайдер для SplashViewModel
final splashProvider =
    StateNotifierProvider<SplashViewModel, SplashState>((ref) {
  return SplashViewModel();
});

/// ViewModel для управления состоянием SplashScreen (MVVM pattern)
class SplashViewModel extends StateNotifier<SplashState> {
  late AnimationController _animationController;
  Timer? _navigationTimer;

  SplashViewModel() : super(const SplashState());

  void initialize(AnimationController controller, BuildContext context,
      Widget destination) {
    _animationController = controller;

    // Настройка анимаций
    _animationController.addListener(_updateAnimationValues);

    // Настройка таймера для навигации
    _navigationTimer = Timer(const Duration(seconds: 3), () {
      state = state.copyWith(isFinished: true);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => destination),
      );
    });
  }

  /// Метод для обновления значений анимации при изменении контроллера
  void _updateAnimationValues() {
    // Fade анимация (0.0-0.5)
    final fadeValue = _animationController.value <= 0.5
        ? _animationController.value * 2 // Преобразуем 0-0.5 в 0-1
        : 1.0;

    // Scale анимация (0.5-1.0)
    final scaleValue = _animationController.value >= 0.5
        ? 0.85 +
            (_animationController.value - 0.5) *
                0.3 // Преобразуем 0.5-1.0 в 0.85-1.0
        : 0.85;

    // Pulse анимация (0.6-1.0)
    final pulseProgress = _animationController.value >= 0.6
        ? (_animationController.value - 0.6) / 0.4 // Преобразуем 0.6-1.0 в 0-1
        : 0.0;
    final pulseValue = 0.95 + pulseProgress * 0.1; // 0.95-1.05

    // Rotate анимация (0.3-0.9)
    final rotateProgress = _animationController.value >= 0.3 &&
            _animationController.value <= 0.9
        ? (_animationController.value - 0.3) / 0.6 // Преобразуем 0.3-0.9 в 0-1
        : (_animationController.value < 0.3 ? 0.0 : 1.0);
    final rotateValue = rotateProgress * 0.25; // 0-0.25 (90 градусов)

    state = state.copyWith(
      fadeValue: fadeValue,
      scaleValue: scaleValue,
      pulseValue: pulseValue,
      rotateValue: rotateValue,
    );
  }

  @override
  void dispose() {
    _animationController.removeListener(_updateAnimationValues);
    _navigationTimer?.cancel();
    super.dispose();
  }
}
