/// Модель для хранения состояния навигации согласно MVVM
class NavigationState {
  final int selectedIndex;
  final bool drawerOpen;

  const NavigationState({
    this.selectedIndex = 0,
    this.drawerOpen = false,
  });

  NavigationState copyWith({
    int? selectedIndex,
    bool? drawerOpen,
  }) {
    return NavigationState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      drawerOpen: drawerOpen ?? this.drawerOpen,
    );
  }
}

/// Определение доступных экранов для навигации (Open-Closed Principle)
enum NavigationScreen {
  parameters,
  alarms,
  systems,
  visualDisplay,
  shipPosition,
  lastPsc,
  masterSlopchest,
  techSupport,
  purchasingDept,
}

/// Расширение для получения названия экрана
extension NavigationScreenExtension on NavigationScreen {
  String get title {
    switch (this) {
      case NavigationScreen.parameters:
        return 'Parameters';
      case NavigationScreen.alarms:
        return 'Alarms';
      case NavigationScreen.systems:
        return 'Systems';
      case NavigationScreen.visualDisplay:
        return 'Visual Display';
      case NavigationScreen.shipPosition:
        return 'Ship Position';
      case NavigationScreen.lastPsc:
        return 'Last PSC';
      case NavigationScreen.masterSlopchest:
        return 'Master Slopchest';
      case NavigationScreen.techSupport:
        return 'Tech Support';
      case NavigationScreen.purchasingDept:
        return 'Purchasing Dept';
    }
  }
}
