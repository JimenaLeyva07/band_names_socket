import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/socket_service.dart';

class ServerStatusPage extends ConsumerWidget {
  const ServerStatusPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Server Status: ${ref.watch(socketServiceProvider)}',
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(socketServiceProvider.notifier).socket.emit(
            'emiting-message',
            <String, String>{'name': 'Jimena', 'message': 'Hey ;) '},
          );
        },
        elevation: 1,
        child: const Icon(Icons.message),
      ),
    );
  }
}
