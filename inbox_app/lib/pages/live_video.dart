import 'dart:async';
import 'package:flutter/material.dart';
import 'package:inbox_app/constants/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:flutter_mjpeg/flutter_mjpeg.dart';

class StreamSocket {
  final _socketResponse = StreamController<String>();

  void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<String> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}

class LiveVideoScreen extends StatefulWidget {
  const LiveVideoScreen({Key? key}) : super(key: key);

  @override
  _LiveVideoScreenState createState() => _LiveVideoScreenState();
}

class _LiveVideoScreenState extends State<LiveVideoScreen> {
  final IO.Socket _socket = IO.io('http://$REST_ENDPOINT', <String, dynamic>{
    'autoConnect': false,
    'transports': ['websocket'],
  });

  @override
  void initState() {
    super.initState();
    _socket.connect(); // Connect socket
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Live Feed"),
          centerTitle: true,
          backgroundColor: PRIMARY_BLACK,
        ),
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: FutureBuilder(
                  future: Future.delayed(const Duration(seconds: 2)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Mjpeg(
                          isLive: true,
                          error: (context, error, stack) {
                            return Text(error.toString(),
                                style: const TextStyle(color: Colors.red));
                          },
                          stream: 'http://192.168.43.199:8090/?action=stream');
                    }

                    return const CircularProgressIndicator();
                  }),
            )));
  }

  @override
  void dispose() {
    _socket.emit("stopVideo");
    _socket.disconnect(); // Disconnect socket

    super.dispose();
  }
}
