import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService extends StateNotifier<List<String>> {
  late IO.Socket socket;

  SocketService() : super([]);

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
      state = [...state, data['message']];
      print('list: $state');

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

  void disposeSocket() {
    socket.dispose();
  }
}

final socketServiceProvider =
    StateNotifierProvider<SocketService, List<String>>((ref) {
  final socketService = SocketService();
  socketService.initSocketConnection();
  return socketService;
});
