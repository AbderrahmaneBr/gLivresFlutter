import 'package:flutter/material.dart';
import 'package:gestion_livres/pages/home.page.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future main() async {
  // Initialize FFI
  sqfliteFfiInit();

  databaseFactory = databaseFactoryFfi;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Manager',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SearchPage(),
    );
  }
}
