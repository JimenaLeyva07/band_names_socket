import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

enum ServerStatus { Online, Offline, Connecting }

class SocketService extends ChangeNotifier {
  SocketService() {
    _initConfig();
  }
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late io.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  io.Socket get socket => _socket;

  void _initConfig() {
    // Dart client
    _socket = io.io('http://192.168.0.12:3000', <String, dynamic>{
      'transports': <String>['websocket'],
      'autoConnect': true,
    });

    _socket.on('connect', (_) {
      //aqui tb puede ser socket.onConect :)
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    _socket.onDisconnect((_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    //   socket.on('new-message', (dynamic payload) {
    //     final String name = payload['name'].toString();
    //     final String message = payload['message'].toString();

    //     print('new message:');
    //     print('name: $name');
    //     print('message: $message');
    //   });
    // }
  }
}

final ChangeNotifierProvider<SocketService> socketServiceProvider =
    ChangeNotifierProvider<SocketService>(
  (ChangeNotifierProviderRef<Object?> ref) => SocketService(),
);
