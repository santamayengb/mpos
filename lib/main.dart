import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mpos/app/app.dart';
import 'package:mpos/core/config/objectbox.helper.dart';

import 'package:mpos/services/user.service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initObjectBox(); // Important!
  // deleteObjectBoxDb();
  simulateLoginUser();
  final current = UserService.currentUser;
  log("Simulate as Logged with user => ${current?.id} |  ${current?.name}");

  runApp(MyApp());
}

simulateLoginUser() {
  final loggedInUser = UserService.getUserById(1);
  if (loggedInUser != null) {
    UserService.setCurrentUser(loggedInUser);
  }
}

// void deleteObjectBoxDb() {
//   final dir = Directory('objectbox');
//   if (dir.existsSync()) {
//     dir.deleteSync(recursive: true);
//     print('ObjectBox DB deleted');
//   }
// }
