import 'dart:io';

class SocketServer {
  final List<WebSocket> _clients = [];

  Future<void> start({int port = 3000}) async {
    final server = await HttpServer.bind(InternetAddress.anyIPv4, port);
    print('✅ WebSocket Server running at ws://${server.address.address}:$port');

    server.transform(WebSocketTransformer()).listen((WebSocket client) {
      _clients.add(client);
      print('📡 New client connected: ${client.hashCode}');

      client.listen(
        (data) {
          print('🔁 Received: $data');
          for (var other in _clients) {
            if (other != client && other.readyState == WebSocket.open) {
              other.add(data); // Broadcast to all other clients
            }
          }
        },
        onDone: () {
          _clients.remove(client);
          print('❌ Client disconnected: ${client.hashCode}');
        },
      );
    });
  }
}
