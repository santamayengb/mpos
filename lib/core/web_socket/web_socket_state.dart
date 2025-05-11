part of 'web_socket_cubit.dart';

enum Status { initial, starting, running, error }

class WebSocketState extends Equatable {
  const WebSocketState({
    required this.todos,
    this.serverAddress,
    required this.status,
    required this.clientinfo,
  });
  final Status status;
  final List<ClientInfo> clientinfo;
  final String? serverAddress;
  final List<Todo> todos;
  WebSocketState copyWith({
    Status? status,
    List<ClientInfo>? clientinfo,
    String? serverAddress,
    List<Todo>? todos,
  }) {
    return WebSocketState(
      todos: todos ?? this.todos,
      status: status ?? this.status,
      clientinfo: clientinfo ?? this.clientinfo,
      serverAddress: serverAddress ?? this.serverAddress,
    );
  }

  @override
  List<Object?> get props => [status, clientinfo, todos];
}
