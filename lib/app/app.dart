import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpos/app/multibloc.wrapper.dart';
import 'package:mpos/core/web_socket/web_socket_cubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlockWrapper(child: MaterialApp(home: WebSocketPage()));
  }
}

class WebSocketPage extends StatefulWidget {
  const WebSocketPage({super.key});

  @override
  State<WebSocketPage> createState() => _WebSocketPageState();
}

class _WebSocketPageState extends State<WebSocketPage> {
  final _controller = TextEditingController();

  void _send(String type, Map<String, dynamic> data) {
    final ws = context.read<WebSocketCubit>();
    final message = jsonEncode({'type': type, ...data});

    // send to server (as client)
    for (final client in ws.state.clientinfo) {
      client.socket.add(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<WebSocketCubit>().state;
    return Scaffold(
      appBar: AppBar(
        title: Text('WebSocket Server ${c.todos.length}'),
        actions: [
          ElevatedButton(
            onPressed: () async {
              if (c.status == Status.running) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Server already running!")),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Starting Server Please wait")),
                );
                context.read<WebSocketCubit>().startServer();
              }
            },
            child: const Text('Start'),
          ),
        ],
      ),
      body: Row(
        children: [
          /// ✅ Left panel – Todos
          Expanded(
            child: Column(
              children: [
                if (c.status == Status.running)
                  Text('Server IP: ${c.serverAddress}'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "New Todo",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          final id =
                              DateTime.now().millisecondsSinceEpoch.toString();
                          final todo = {
                            'todo': {
                              'id': id,
                              'title': _controller.text,
                              'isDone': false,
                            },
                          };
                          _send('add', todo);
                          _controller.clear();
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children:
                        c.todos.map((e) {
                          return ListTile(
                            title: Text(e.uuid),
                            leading: Checkbox(
                              value: e.completed,
                              onChanged: (_) {
                                _send('update', {
                                  'todo': {
                                    'id': e.id,
                                    'title': e.title,
                                    'isDone': !e.completed,
                                  },
                                });
                              },
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _send('delete', {'id': e.id});
                              },
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
          ),

          /// ✅ Right panel – Client connections
          Expanded(
            child: ListView(
              children: [
                if (c.status == Status.running)
                  Text('Server IP: ${c.serverAddress}'),
                ...c.clientinfo.map((e) {
                  return Text(e.socket.toString());
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
