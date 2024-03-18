import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Socket.IO Demo',
      home: SocketIOClientDemo(),
    );
  }
}

class SocketIOClientDemo extends StatefulWidget {
  @override
  _SocketIOClientDemoState createState() => _SocketIOClientDemoState();
}

class _SocketIOClientDemoState extends State<SocketIOClientDemo> {
  late IO.Socket socket;

  @override
  void initState() {
    super.initState();

    // Replace 'http://localhost:port' with your backend server URL
    socket = IO.io('http://10.12.34.239:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      "auth": {
        "token":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY1ZWMzYjQxZTA5MDkxOTUzNjczM2Q0OSIsImlhdCI6MTcxMDU5NzM4NywiZXhwIjoxNzEzMTg5Mzg3fQ.dWS0EugMbneY_I0n-ueJFQsbRvj-PD_lVUD4dSVxsnw",
        "Custom-Header": "CustomValue"
      }
    });

    socket.connect();

    socket.onConnect((_) {
      print('Connected');
    });

    socket.onDisconnect((_) {
      print('Disconnected');
    });

    socket.on('message', (data) {
      print('Received message: $data');
    });
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Socket.IO Demo'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Emit a message to the server
            socket.emit('message', 'Hello from Flutter!');
          },
          child: Text('Send Message'),
        ),
      ),
    );
  }
}
