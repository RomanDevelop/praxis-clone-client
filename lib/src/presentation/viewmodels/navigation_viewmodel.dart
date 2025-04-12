import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/navigation_state.dart';
import '../screens/ship_position_screen.dart';

/// Провайдер для NavigationViewModel
final navigationProvider =
    StateNotifierProvider<NavigationViewModel, NavigationState>((ref) {
  return NavigationViewModel();
});

/// ViewModel для управления состоянием навигации (MVVM pattern)
class NavigationViewModel extends StateNotifier<NavigationState> {
  NavigationViewModel() : super(const NavigationState());

  /// Метод для изменения текущего экрана
  void setCurrentIndex(int index) {
    state = state.copyWith(selectedIndex: index);
  }

  /// Метод для открытия бокового меню
  void openDrawer(GlobalKey<ScaffoldState> scaffoldKey) {
    scaffoldKey.currentState?.openDrawer();
    state = state.copyWith(drawerOpen: true);
  }

  /// Метод для закрытия бокового меню
  void closeDrawer() {
    state = state.copyWith(drawerOpen: false);
  }

  /// Метод для навигации к определенному экрану
  void navigateTo(BuildContext context, NavigationScreen screen) {
    // Сначала закрываем drawer если открыт
    if (state.drawerOpen) {
      Navigator.pop(context);
      state = state.copyWith(drawerOpen: false);
    }

    // Обновление состояния в зависимости от экрана
    switch (screen) {
      case NavigationScreen.parameters:
        state = state.copyWith(selectedIndex: 0);
        break;
      case NavigationScreen.alarms:
        state = state.copyWith(selectedIndex: 1);
        break;
      case NavigationScreen.systems:
        state = state.copyWith(selectedIndex: 2);
        break;
      case NavigationScreen.visualDisplay:
        state = state.copyWith(selectedIndex: 3);
        break;
      case NavigationScreen.shipPosition:
      case NavigationScreen.lastPsc:
      case NavigationScreen.masterSlopchest:
      case NavigationScreen.techSupport:
      case NavigationScreen.purchasingDept:
        // Для экранов из бокового меню используем Navigator.push
        _navigateToScreen(context, screen);
        break;
    }
  }

  /// Вспомогательный метод для навигации к экрану через Navigator
  void _navigateToScreen(BuildContext context, NavigationScreen screen) {
    switch (screen) {
      case NavigationScreen.shipPosition:
        _pushScreen(context, '/ship-position');
        break;
      case NavigationScreen.lastPsc:
        _pushScreen(context, '/last-psc');
        break;
      case NavigationScreen.masterSlopchest:
        _pushScreen(context, '/master-slopchest');
        break;
      case NavigationScreen.techSupport:
        _pushScreen(context, '/tech-support');
        break;
      case NavigationScreen.purchasingDept:
        _pushScreen(context, '/purchasing-dept');
        break;
      default:
        break;
    }
  }

  /// Метод для навигации к экрану по именованному маршруту
  void _pushScreen(BuildContext context, String routeName) {
    // В будущем можно использовать именованные маршруты
    // Navigator.pushNamed(context, routeName);

    // Временная реализация, которая просто показывает заглушку для неразработанных экранов
    if (routeName == '/ship-position') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ShipPositionScreen(),
        ),
      );
    } else {
      _showPlaceholderScreen(context, routeName);
    }
  }

  /// Временный метод для показа заглушки экрана
  void _showPlaceholderScreen(BuildContext context, String routeName) {
    final screenName = routeName.replaceAll('/', '').replaceAll('-', ' ');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text(screenName)),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.construction, size: 80, color: Colors.amber),
                const SizedBox(height: 20),
                Text(
                  'Screen "$screenName" is under construction',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
