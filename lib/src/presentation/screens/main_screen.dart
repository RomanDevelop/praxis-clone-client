import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/ship_wheel.dart';
import '../viewmodels/navigation_viewmodel.dart';
import '../../domain/app_theme.dart';
import '../../domain/navigation_state.dart';
import '../main_navigation.dart';
import 'ship_position_screen.dart';

/// Главный экран приложения с боковым меню и навигацией
class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // Получаем текущее состояние навигации из ViewModel
    final navigationState = ref.watch(navigationProvider);

    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(navigationState),
      drawer: _buildDrawer(context),
      body: const MainNavigation(),
    );
  }

  /// Метод для построения AppBar
  AppBar _buildAppBar(NavigationState navigationState) {
    return AppBar(
      backgroundColor: AppTheme.secondaryBackground,
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          ref.read(navigationProvider.notifier).openDrawer(_scaffoldKey);
        },
      ),
      title: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShipWheel(size: 40),
            const SizedBox(width: 8),
            const Text(
              "M/V UNISTAR",
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
    );
  }

  /// Метод для построения Drawer
  Widget _buildDrawer(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: AppTheme.secondaryBackground,
        width: MediaQuery.of(context).size.width * 0.8, // 80% от ширины экрана
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Секция логотипа
            Container(
              height: MediaQuery.of(context).size.height *
                  0.3, // 30% высоты экрана для лого
              color: AppTheme.secondaryBackground,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Анимированный логотип
                    AnimatedShipWheel(
                      size: 100,
                      color: AppTheme.accentColor,
                    ),
                    const SizedBox(height: 16),
                    // Название приложения
                    Text(
                      "SCAIH",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        shadows: [
                          Shadow(
                            color: AppTheme.accentColor.withOpacity(0.5),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Пункты меню
            _buildDrawerItem(
              context,
              Icons.location_on,
              'Ship position',
              NavigationScreen.shipPosition,
            ),
            _buildDrawerItem(
              context,
              Icons.anchor,
              'Last PSC',
              NavigationScreen.lastPsc,
            ),
            _buildDrawerItem(
              context,
              Icons.shopping_bag,
              'Master Slopchest',
              NavigationScreen.masterSlopchest,
            ),
            _buildDrawerItem(
              context,
              Icons.support_agent,
              'Tech Support',
              NavigationScreen.techSupport,
            ),
            _buildDrawerItem(
              context,
              Icons.shopping_cart,
              'Purchasing Dept',
              NavigationScreen.purchasingDept,
            ),
          ],
        ),
      ),
    );
  }

  /// Метод для построения элемента бокового меню
  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    NavigationScreen screen,
  ) {
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
        // Используем ViewModel для навигации
        ref.read(navigationProvider.notifier).navigateTo(context, screen);
      },
    );
  }
}
