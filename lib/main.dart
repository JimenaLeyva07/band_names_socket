import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pages/home.dart';
import 'pages/server_status.dart';

void main() => runApp(const ProviderScope(child: MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'home',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
      ),
      routes: <String, Widget Function(BuildContext)>{
        'home': (_) => const HomePage(),
        'status': (_) => const ServerStatusPage()
      },
    );
  }
}
