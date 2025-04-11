import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class EngineSocketClient {
  final WebSocketChannel _channel;

  EngineSocketClient(String url)
      : _channel = WebSocketChannel.connect(Uri.parse(url));

  Stream<Map<String, dynamic>> get stream =>
      _channel.stream.map((event) => jsonDecode(event));
}
