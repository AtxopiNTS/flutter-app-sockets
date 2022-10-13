import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting
}
class SocketService with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;

  IO.Socket get socket => _socket;
  Function get emit => _socket.emit;

  SocketService() {
    this._initConfig();
  }

  void _initConfig() {
    // Dart client
    _socket = IO.io('http://192.168.1.134:3000/', {
      'transports': ['websocket'],
      'autoConnect': true
    });

    _socket.onConnect((_) {
      // print('connect');
      // socket.emit('msg', 'test');
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    // socket.on('event', (data) => print(data));
    _socket.onDisconnect((_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    // socket.on('nuevo-mensaje', ( payload){
    //   print('Nuevo-mensaje:');
    //   print('nombre:' + payload['nombre'] );
    //   print('nombre:' + payload['nombre'] + ' + ' + payload['mensaje'] );
    //   print( payload.containsKey('mensaje') ?  payload['mensaje'] : 'no hay' );

      // var list = jsonEncode(payload);
      // // print(payload.toString());
      // print( list );
      // print( jsonDecode(list) );
      // // print( list['nombre']);
      // jsonDecode(list).map((entry) {
      //     int idx = entry.key;
      //     String val = entry.value;

      //     print( '$idx : $val'  );
      //     // return something;
      // });

      // jsonDecode(list).map((i) => {
      //   print(i)
      // });
      // print('nombre: '+ payload['nombre'] );
      // print('mensaje: '+ payload['mensaje'] );
    // });
  }
}