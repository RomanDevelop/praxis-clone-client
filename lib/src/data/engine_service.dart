import '../domain/engine_data.dart';
import 'engine_socket.dart';

class EngineService {
  final EngineSocketClient _client;

  EngineService(this._client);

  Stream<EngineData> getEngineStream() {
    return _client.stream.map((json) => EngineData.fromJson(json));
  }
}
