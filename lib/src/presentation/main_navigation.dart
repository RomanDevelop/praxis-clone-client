import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'engine_monitor/engine_page.dart';
import 'alarms/alarms_page.dart';
import 'system_groups/system_groups_page.dart';
import 'visual_display/gauges_page.dart';

final navigationIndexProvider = StateProvider<int>((ref) => 0);

class MainNavigation extends ConsumerWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: const [
          EnginePage(),
          GaugesPage(),
          SystemGroupsPage(),
          AlarmsPage(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF222222),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 5,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) =>
              ref.read(navigationIndexProvider.notifier).state = index,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF222222),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.table_rows),
              label: 'Parameters',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.speed),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Systems',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.warning),
              label: 'Alarms',
            ),
          ],
        ),
      ),
    );
  }
}
