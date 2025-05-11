import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpos/core/web_socket/model/client.model.dart';
import 'package:mpos/model/todo.model.dart';

part 'web_socket_state.dart';

class WebSocketCubit extends Cubit<WebSocketState> {
  WebSocketCubit()
    : super(WebSocketState(status: Status.initial, clientinfo: [], todos: [])) {
    startServer();
  }

  bool get isRunning => state.status == Status.running;
  HttpServer? _server;

  String userType = "admin"; // admin,staff,other
  // if usertype is admin act as sever and client alongside else client
  Future startServer() async {
    if (isRunning) return;

    emit(state.copyWith(status: Status.starting));

    try {
      _server = await HttpServer.bind(InternetAddress.anyIPv4, 3000);
      final interfaces = await NetworkInterface.list(
        includeLinkLocal: false,
        type: InternetAddressType.IPv4,
      );
      final localIp = interfaces
          .expand((i) => i.addresses)
          .firstWhere(
            (addr) => addr.address.startsWith('192.'),
            orElse: () => _server!.address,
          );

      final localAddress = "ws://${localIp.address}:3000";

      emit(state.copyWith(status: Status.running, serverAddress: localAddress));

      /// 💡 Start acting as a client too
      _connectAsClient(localAddress);

      // Accept connections from others
      _server!.listen((HttpRequest request) async {
        if (WebSocketTransformer.isUpgradeRequest(request)) {
          final socket = await WebSocketTransformer.upgrade(request);
          final ip = request.connectionInfo?.remoteAddress.address ?? 'unknown';
          final client = ClientInfo(socket: socket, address: ip);

          final updatedClients = [...state.clientinfo, client];
          emit(state.copyWith(clientinfo: updatedClients));

          log('🟢 Client connected: $ip');

          socket.listen(
            (data) {
              final decoded = jsonDecode(data);
              final type = decoded['type'];
              final todoData = decoded['todo'] ?? {};
              final id = todoData['id'];

              List<Todo> updatedTodos = List.from(state.todos);

              switch (type) {
                case 'add':
                  updatedTodos.add(
                    Todo(
                      uuid: id,
                      title: todoData['title'],
                      completed: todoData['isDone'] ?? false,
                    ),
                  );
                  break;
                case 'update':
                  final index = updatedTodos.indexWhere((t) => t.uuid == id);
                  if (index != -1) {
                    updatedTodos[index] = Todo(
                      uuid: id,
                      title: todoData['title'],
                      completed: todoData['isDone'] ?? false,
                    );
                  }
                  break;
                case 'delete':
                  updatedTodos.removeWhere((t) => t.uuid == decoded['id']);
                  break;
              }

              emit(state.copyWith(todos: updatedTodos));

              // Broadcast to other clients
              for (final client in state.clientinfo) {
                try {
                  client.socket.add(data);
                } catch (e) {
                  log('⚠️ Failed to send to ${client.address}: $e');
                }
              }
            },
            onDone: () {
              log('🔴 Client disconnected: $ip');
              final remainingClients = List<ClientInfo>.from(state.clientinfo)
                ..removeWhere((c) => c.socket == socket);
              emit(state.copyWith(clientinfo: remainingClients));
            },
            onError: (error) {
              log('❌ WebSocket error from $ip: $error');
              final remainingClients = List<ClientInfo>.from(state.clientinfo)
                ..removeWhere((c) => c.socket == socket);
              emit(state.copyWith(clientinfo: remainingClients));
            },
            cancelOnError: true,
          );
        }
      });
    } catch (e) {
      emit(state.copyWith(status: Status.error));
      log("❌ WebSocket Server Error: $e");
    }
  }

  Future<void> _connectAsClient(String address) async {
    try {
      final ws = await WebSocket.connect(address);
      log("🟡 Server connected to its own WebSocket as client");
      ws.listen((data) {
        final json = jsonDecode(data);
        final type = json['type'];
        final todoData = json['todo'];

        final todo = Todo.fromJson(todoData);
        var updatedTodos = [...state.todos];

        switch (type) {
          case 'add':
            if (!updatedTodos.any((t) => t.uuid == todo.uuid)) {
              updatedTodos.add(todo);
            }
            break;
          case 'update':
            final index = updatedTodos.indexWhere((t) => t.uuid == todo.uuid);
            if (index != -1) updatedTodos[index] = todo;
            break;
          case 'delete':
            updatedTodos.removeWhere((t) => t.uuid == todo.uuid);
            break;
        }

        emit(state.copyWith(todos: updatedTodos));
      });

      // Optional: Send something as client
      // ws.add("Hello from server's client mode!");

      // You may store `ws` in a field if you want to send messages later
    } catch (e) {
      log("❌ Failed to connect to own server as client: $e");
    }
  }
}
