import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/src/shared/providers.dart';

class AlarmItem {
  final String tag;
  final String description;
  final DateTime timestamp;
  final String severity;
  final bool isActive;

  AlarmItem({
    required this.tag,
    required this.description,
    required this.timestamp,
    required this.severity,
    required this.isActive,
  });
}

final alarmsProvider = Provider<List<AlarmItem>>((ref) {
  // Наблюдаем за данными двигателя
  final engineData = ref.watch(engineViewModelProvider);

  if (engineData == null) {
    return [];
  }

  // Генерируем тревоги на основе данных двигателя
  final alarms = <AlarmItem>[];

  // RPM тревога
  if (engineData.rpm > 1000) {
    alarms.add(
      AlarmItem(
        tag: '10001',
        description: 'HIGH RPM WARNING',
        timestamp: engineData.timestamp,
        severity: 'Warning',
        isActive: true,
      ),
    );
  }

  // Температура масла
  if (engineData.oilTemperature > 90) {
    alarms.add(
      AlarmItem(
        tag: '10932',
        description: 'OIL TEMPERATURE HIGH',
        timestamp: engineData.timestamp,
        severity: 'Critical',
        isActive: true,
      ),
    );
  }

  // Температура охлаждающей жидкости
  if (engineData.coolantTemperature > 85) {
    alarms.add(
      AlarmItem(
        tag: '10906',
        description: 'COOLANT TEMPERATURE HIGH',
        timestamp: engineData.timestamp,
        severity: 'Warning',
        isActive: true,
      ),
    );
  }

  // Низкое давление топлива
  if (engineData.fuelPressure < 2.5) {
    alarms.add(
      AlarmItem(
        tag: '11017',
        description: 'FUEL PRESSURE LOW',
        timestamp: engineData.timestamp,
        severity: 'Warning',
        isActive: true,
      ),
    );
  }

  // Высокая нагрузка
  if (engineData.engineLoad > 85) {
    alarms.add(
      AlarmItem(
        tag: '10801',
        description: 'ENGINE LOAD HIGH',
        timestamp: engineData.timestamp,
        severity: 'Warning',
        isActive: true,
      ),
    );
  }

  // Добавляем несколько исторических тревог
  alarms.addAll([
    AlarmItem(
      tag: '10906',
      description: 'COOLANT TEMPERATURE HIGH',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      severity: 'Warning',
      isActive: false,
    ),
    AlarmItem(
      tag: '10932',
      description: 'OIL TEMPERATURE HIGH',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      severity: 'Critical',
      isActive: false,
    ),
    AlarmItem(
      tag: '11017',
      description: 'FUEL PRESSURE LOW',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      severity: 'Warning',
      isActive: false,
    ),
    AlarmItem(
      tag: '10801',
      description: 'ENGINE LOAD HIGH',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      severity: 'Warning',
      isActive: false,
    ),
  ]);

  return alarms;
});

class AlarmsPage extends ConsumerWidget {
  const AlarmsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarms = ref.watch(alarmsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alarm History'),
        backgroundColor: const Color(0xFF444444),
      ),
      body: Container(
        color: const Color(0xFF333333),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: alarms.length,
                itemBuilder: (context, index) {
                  final alarm = alarms[index];
                  return AlarmListItem(alarm: alarm);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AlarmListItem extends StatelessWidget {
  final AlarmItem alarm;

  const AlarmListItem({super.key, required this.alarm});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF3A3A3A),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: _getSeverityColor(alarm.severity).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _getSeverityColor(alarm.severity),
          ),
          child: alarm.isActive
              ? const Center(
                  child: Icon(
                    Icons.warning,
                    color: Colors.white,
                    size: 16,
                  ),
                )
              : Center(
                  child: Icon(
                    Icons.check,
                    color: Colors.white.withOpacity(0.7),
                    size: 16,
                  ),
                ),
        ),
        title: Text(
          alarm.description,
          style: TextStyle(
            color: Colors.white,
            fontWeight: alarm.isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Row(
          children: [
            Text(
              'Tag: ${alarm.tag}',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Time: ${_formatTime(alarm.timestamp)}',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: Text(
          alarm.severity,
          style: TextStyle(
            color: _getSeverityColor(alarm.severity),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return Colors.red;
      case 'warning':
        return Colors.orange;
      case 'info':
        return Colors.blue;
      default:
        return Colors.green;
    }
  }

  String _formatTime(DateTime time) {
    return '${time.day.toString().padLeft(2, '0')}.${time.month.toString().padLeft(2, '0')}.${time.year} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
