
import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:spotem/core/network/api_service/token_meneger.dart';

import '../local/token_manager.dart';


class SocketConnectParam {
  final String _token;
  final String _joinId;
  final String url;

  SocketConnectParam({
    required String token,
    required String joinId,
    required this.url
  }) : 
       _token = token,
       _joinId = joinId;
}


class SocketService {
  final Map<String, StreamController<dynamic>> _events = {};
  io.Socket? _socket;
  final String socketUrl = 'https://backend-jay.onrender.com';

  SocketService();
  /// Socket connect param
  /// Pass this param to the `init()` method to initialize the socket

  bool get isConnected => _socket?.connected ?? false;

  Future<void> init() async{
    final token = await TokenManager.getToken();
    // Dispose previous socket, if exists
    _disposeSocket();
    if (_socket != null) {
      return;
    }
    if(token == null) {
      return;
    }
      _socket = io.io(
        socketUrl,
        io.OptionBuilder()
            .setTransports(['websocket'])
            .setExtraHeaders({'Authorization': 'Bearer $token'})
            .build(),
      );
      _socket?.connect();
      _socket?.onConnect((data) {
        debugPrint("Socket connected");
      });
  }


  void emit(String eventName, dynamic data) {
    init().then((_) {
      _socket?.emit(eventName, data);
    });
  }

  Stream<dynamic> listen(String eventName,) {
    if (_events.containsKey(eventName)) {
      return _events[eventName]!.stream;
    }
    
    final controller = StreamController<dynamic>.broadcast();
    _events[eventName] = controller;

    init().then((_) {
      _socket?.on(eventName, (data) {
        controller.add(data);
      });
    });

    return controller.stream;
  }

  void stopListeningForEvent(String eventName) {
    _socket?.off(eventName);
    _events[eventName]?.close();
    _events.remove(eventName);
  }

  void _disposeSocket() {
    for (var controller in _events.values) {
      controller.close();
    }
    _events.clear();
    _socket?.disconnect();
    _socket?.destroy();
    _socket = null;
  }
}

