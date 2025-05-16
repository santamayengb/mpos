import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mpos/app/multibloc.wrapper.dart';
import 'package:mpos/core/animations/user.animate.dart';
import 'package:mpos/core/config/web_socket/web_socket_cubit.dart';
import 'package:mpos/routers/routers.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlockWrapper(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: routerConfig,
        builder: EasyLoading.init(),
      ),
    );
  }
}

class WebSocketPage extends StatefulWidget {
  const WebSocketPage({super.key});

  @override
  State<WebSocketPage> createState() => _WebSocketPageState();
}

class _WebSocketPageState extends State<WebSocketPage> {
  @override
  void initState() {
    super.initState();
  }

  // conntectionInit() async {
  //   var state = context.read<WebSocketCubit>().state;
  //   if (state.serverAddress != null) {
  //     var ws = await WebSocket.connect(state.serverAddress!);
  //     ws.listen((data) {
  //       final json = jsonDecode(data);
  //       final type = json['type'];
  //       final todoData = json['todo'];

  //       final todo = Todo.fromJson(todoData);
  //       var updatedTodos = [...state.todos];

  //       switch (type) {
  //         case 'add':
  //           if (!updatedTodos.any((t) => t.uuid == todo.uuid)) {
  //             updatedTodos.add(todo);
  //           }
  //           break;
  //         case 'update':
  //           final index = updatedTodos.indexWhere((t) => t.uuid == todo.uuid);
  //           if (index != -1) updatedTodos[index] = todo;
  //           break;
  //         case 'delete':
  //           updatedTodos.removeWhere((t) => t.uuid == todo.uuid);
  //           break;
  //       }
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<WebSocketCubit>().state;
    return Scaffold(body: Row(children: [AvatarStackDemo()]));
  }
}
