import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/engine_socket.dart';
import '../data/engine_service.dart';
import '../presentation/engine_monitor/engine_view_model.dart';
import '../domain/engine_data.dart';
import '../domain/engine_parameter.dart';
import '../domain/system_schema.dart';

const socketUrl =
    'ws://127.0.0.1:8000/ws/engine'; // заменить на IP сервера при необходимости

// Временно отключаем WebSocket для тестирования
// final engineSocketProvider = Provider((ref) => EngineSocketClient(socketUrl));
final engineSocketProvider = Provider((ref) => null);

final engineServiceProvider =
    Provider((ref) => EngineService(ref.watch(engineSocketProvider)));

final engineViewModelProvider =
    StateNotifierProvider<EngineViewModel, EngineData?>(
  (ref) => EngineViewModel(ref.watch(engineServiceProvider)),
);

final engineParametersProvider = Provider<List<EngineParameter>>((ref) {
  // Принудительно пересоздаем провайдер при изменении engineViewModelProvider
  ref.watch(engineViewModelProvider);
  return ref.watch(engineViewModelProvider.notifier).parameters;
});

// Forward reference declaration to avoid circular dependency
final systemSchemaViewModelProvider =
    StateNotifierProvider<SystemSchemaViewModel, Map<String, SystemSchema>>(
        (ref) {
  // We'll import the SystemSchemaViewModel directly in files that need it
  return SystemSchemaViewModel(ref);
});

// Провайдер для получения конкретной схемы по ID группы
final systemSchemaProvider =
    Provider.family<SystemSchema?, String>((ref, groupId) {
  final schemas = ref.watch(systemSchemaViewModelProvider);
  return schemas[groupId];
});

// We need this class declaration here to prevent circular dependencies
// The actual implementation is in system_schema_view_model.dart
class SystemSchemaViewModel extends StateNotifier<Map<String, SystemSchema>> {
  SystemSchemaViewModel(Ref ref) : super({});
}
