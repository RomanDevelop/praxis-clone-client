import 'package:client/src/data/engine_service.dart';
import 'package:client/src/domain/engine_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EngineViewModel extends StateNotifier<EngineData?> {
  final EngineService _service;

  EngineViewModel(this._service) : super(null) {
    _listen();
  }

  void _listen() {
    _service.getEngineStream().listen((event) {
      state = event;
    });
  }
}
