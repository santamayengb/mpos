import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpos/core/config/cubit/tab_cubit.dart';
import 'package:mpos/core/config/web_socket/web_socket_cubit.dart';

class MultiBlockWrapper extends StatelessWidget {
  const MultiBlockWrapper({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => WebSocketCubit()),
        BlocProvider(create: (context) => TabCubit()),
      ],
      child: child,
    );
  }
}
