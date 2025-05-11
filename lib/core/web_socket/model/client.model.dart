import 'dart:io';

class ClientInfo {
  final WebSocket socket;
  final String address;
  final int id;

  ClientInfo({required this.socket, required this.address})
    : id = socket.hashCode;
}
