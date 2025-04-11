import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/engine_socket.dart';
import '../data/engine_service.dart';
import '../presentation/engine_monitor/engine_view_model.dart';
import '../domain/engine_data.dart';

const socketUrl =
    'ws://127.0.0.1:8000/ws/engine'; // заменить на IP сервера при необходимости

final engineSocketProvider = Provider((ref) => EngineSocketClient(socketUrl));

final engineServiceProvider =
    Provider((ref) => EngineService(ref.watch(engineSocketProvider)));

final engineViewModelProvider =
    StateNotifierProvider<EngineViewModel, EngineData?>(
  (ref) => EngineViewModel(ref.watch(engineServiceProvider)),
);
