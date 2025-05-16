part of 'web_socket_cubit.dart';

enum Status { initial, starting, running, error }

class WebSocketState extends Equatable {
  const WebSocketState({
    this.serverAddress,
    required this.status,
    required this.clientinfo,
  });
  final Status status;
  final List<ClientInfo> clientinfo;
  final String? serverAddress;

  WebSocketState copyWith({
    Status? status,
    List<ClientInfo>? clientinfo,
    String? serverAddress,
  }) {
    return WebSocketState(
      status: status ?? this.status,
      clientinfo: clientinfo ?? this.clientinfo,
      serverAddress: serverAddress ?? this.serverAddress,
    );
  }

  @override
  List<Object?> get props => [status, clientinfo];
}
