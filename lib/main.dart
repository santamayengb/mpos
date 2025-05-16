import 'package:flutter/material.dart';
import 'package:mpos/app/app.dart';
import 'package:mpos/core/config/objectbox_helper.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initObjectBox(); // Important!
  // deleteObjectBoxDb();
  runApp(MyApp());
}

// void deleteObjectBoxDb() {
//   final dir = Directory('objectbox');
//   if (dir.existsSync()) {
//     dir.deleteSync(recursive: true);
//     print('ObjectBox DB deleted');
//   }
// }
