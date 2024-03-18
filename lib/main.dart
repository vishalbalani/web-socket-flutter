import 'dart:async';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Socket.IO Flutter',
      home: SocketIOClientDemo(),
    );
  }
}

class SocketIOClientDemo extends StatefulWidget {
  const SocketIOClientDemo({super.key});

  @override
  _SocketIOClientDemoState createState() => _SocketIOClientDemoState();
}

class _SocketIOClientDemoState extends State<SocketIOClientDemo> {
  late IO.Socket socket;
  final TextEditingController _controller = TextEditingController();
  late StreamController<String> _messageStreamController;

  @override
  void initState() {
    super.initState();

    // Initialize the Socket.IO client
    socket = IO.io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'auth': {'token': '', 'Custom-Header': 'CustomValue'}
    });

    // Connect to the server
    socket.connect();

    // Initialize the stream controller
    _messageStreamController = StreamController<String>();

    // Listen for 'message' events from the server
    socket.on('message', (data) {
      // Add the received message to the stream
      _messageStreamController.add(data.toString());
    });
  }

  @override
  void dispose() {
    // Dispose of the socket and stream controller
    socket.dispose();
    _messageStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SocketIO Flutter')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: "Send any message to the server",
                ),
                controller: _controller,
              ),
            ),
            StreamBuilder<String>(
              stream: _messageStreamController.stream,
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(snapshot.hasData ? snapshot.data! : ''),
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.send),
        onPressed: () {
          // Emit a 'message' event with the content of the text input field
          socket.emit('message', _controller.text);
          _controller.clear();
        },
      ),
    );
  }
}
