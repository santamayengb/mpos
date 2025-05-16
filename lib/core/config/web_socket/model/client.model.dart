import 'dart:io';

class ClientInfo {
  final WebSocket socket;
  final String address;
  final int id;
  final String empId;

  ClientInfo({required this.empId, required this.socket, required this.address})
    : id = socket.hashCode;
}
