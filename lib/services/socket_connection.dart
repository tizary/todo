import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/foundation.dart';

class SocketService extends ChangeNotifier {
  late IO.Socket socket;
  final List<String> _messages = [];

  List<String> get messages => List.unmodifiable(_messages);

  void initSocketConnection() {
    socket = IO.io(
      'http://127.0.0.1:3000',
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      },
    );

    socket.onConnect((_) {
      print('Socket connected: ${socket.id}');
      socket.emit("message", "Привет с Flutter!");
    });

    socket.onDisconnect((_) {
      print('Socket disconnected');
    });

    socket.on('message', handleMessage);
    socket.on('typing', handleTyping);
    socket.on('location', handleLocation);

    socket.connect();
  }

  void sendMessage(String message) {
    socket.emit('message', {
      'id': socket.id,
      'message': message,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  void sendTyping(bool typing) {
    socket.emit('typing', {
      'id': socket.id,
      'typing': typing,
    });
  }

  void sendLocation(Map<String, dynamic> locationData) {
    socket.emit('location', locationData);
  }

  void handleMessage(dynamic data) {
    print('Received message: $data');
    try {
      _messages.add(data['message']);
      print('list: $_messages');
      notifyListeners();
    } catch (e, stack) {
      print('Error in handleMessage: $e');
      print(stack);
    }
  }

  void handleTyping(dynamic data) {
    print('Received typing status: $data');
  }

  void handleLocation(dynamic data) {
    print('Received location: $data');
  }

  void dispose() {
    socket.dispose();
  }
}
