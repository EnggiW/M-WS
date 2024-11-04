import 'package:flutter/material.dart';
import 'halaman/home.dart';
import 'halaman/create.dart';
import 'halaman/edit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi CRUD dengan JSONPlaceholder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
      routes: {
        '/create': (context) => CreatePage(),
        '/edit': (context) => EditPage(post: ModalRoute.of(context)!.settings.arguments as Map),
      },
    );
  }
}
