import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../system_schema/system_schema_page.dart';

class SystemGroup {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final int parameterCount;
  final bool hasWarnings;

  SystemGroup({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.parameterCount,
    required this.hasWarnings,
  });
}

final systemGroupsProvider = Provider<List<SystemGroup>>((ref) {
  return [
    SystemGroup(
      id: 'SG001',
      name: 'Fuel System',
      description: 'Main engine fuel management system',
      icon: Icons.local_gas_station,
      parameterCount: 18,
      hasWarnings: false,
    ),
    SystemGroup(
      id: 'SG002',
      name: 'Lubrication System',
      description: 'Main engine oil lubrication system',
      icon: Icons.oil_barrel,
      parameterCount: 24,
      hasWarnings: true,
    ),
    SystemGroup(
      id: 'SG003',
      name: 'Cooling System',
      description: 'Main engine cooling and temperature control system',
      icon: Icons.ac_unit,
      parameterCount: 15,
      hasWarnings: false,
    ),
    SystemGroup(
      id: 'SG004',
      name: 'Air Start System',
      description: 'Main engine pneumatic starting system',
      icon: Icons.air,
      parameterCount: 8,
      hasWarnings: false,
    ),
    SystemGroup(
      id: 'SG005',
      name: 'Exhaust System',
      description: 'Main engine exhaust gas management system',
      icon: Icons.wind_power,
      parameterCount: 12,
      hasWarnings: true,
    ),
    SystemGroup(
      id: 'SG006',
      name: 'Control System',
      description: 'Main engine electronic control and monitoring system',
      icon: Icons.settings,
      parameterCount: 32,
      hasWarnings: false,
    ),
    SystemGroup(
      id: 'SG007',
      name: 'Power Transmission',
      description: 'Main engine power transmission and gearbox system',
      icon: Icons.settings_input_component,
      parameterCount: 14,
      hasWarnings: false,
    ),
  ];
});

class SystemGroupsPage extends ConsumerWidget {
  const SystemGroupsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final systemGroups = ref.watch(systemGroupsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Engine Systems'),
        backgroundColor: const Color(0xFF444444),
      ),
      body: Container(
        color: const Color(0xFF333333),
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: systemGroups.length,
          itemBuilder: (context, index) {
            final group = systemGroups[index];
            return SystemGroupCard(group: group);
          },
        ),
      ),
    );
  }
}

class SystemGroupCard extends StatelessWidget {
  final SystemGroup group;

  const SystemGroupCard({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: const Color(0xFF3A3A3A),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF444444),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
              border: group.hasWarnings
                  ? Border.all(color: Colors.orange.withOpacity(0.7), width: 1)
                  : null,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  group.icon,
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'ID: ${group.id} • ${group.parameterCount} parameters',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (group.hasWarnings)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.warning,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Warning',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      icon: const Icon(
                        Icons.list,
                        size: 18,
                      ),
                      label: const Text('View Parameters'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue,
                      ),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      icon: const Icon(
                        Icons.show_chart,
                        size: 18,
                      ),
                      label: const Text('View Trend'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        _openSystemSchema(context, group.id);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Открывает страницу схемы системы при нажатии на кнопку View Trend
  void _openSystemSchema(BuildContext context, String groupId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SystemSchemaPage(
          systemGroupId: groupId,
        ),
      ),
    );
  }
}
