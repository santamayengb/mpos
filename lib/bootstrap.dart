import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import 'firebase_options.dart';
class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

/// all the initial setup required before running the the app add here
Future initSetup() async {
  // init firebase
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  // FcmNotification.fcmInitial();
}



typedef BuilderType =
    FutureOr<Widget> Function(
      // AppRouter,
      // SharedPreferences,
    );
Future<void> bootstrap(BuilderType builder) async {
  Bloc.observer;
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };
  await initSetup();

  await runZonedGuarded(
    () async => runApp(
      await builder(
        // auth,
        // appRouter,
        // sp,
      ),
    ),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
