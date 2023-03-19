import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter/material.dart';
import 'package:inbox_app/constants/constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

const int tSampleRate = 44000;

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
  final StreamSocket _streamSocket = StreamSocket();
  // final FlutterSoundRecorder _mRecorder = FlutterSoundRecorder();
  // StreamSubscription? _mRecordingDataSubscription;
  bool _isConnected = false;
  bool _recordingAudio = false;
  bool _mRecorderInited = false;

  // Future<void> _openRecorder() async {
  //   var status = await Permission.microphone.request();
  //   if (status != PermissionStatus.granted) {
  //     throw RecordingPermissionException("Microphone permission not granted");
  //   }

  //   await _mRecorder.openRecorder();

  //   setState(() {
  //     _mRecorderInited = true;
  //   });
  // }

  // Future<void> record() async {
  //   assert(_mRecorderInited);
  //   var recordingDataController = StreamController<Food>();
  //   _mRecordingDataSubscription =
  //       recordingDataController.stream.listen((buffer) {
  //     if (buffer is FoodData) {
  //       // Send to socket
  //       _socket.emit("audioBuffer", buffer);
  //     }
  //   });

  //   await _mRecorder.startRecorder(
  //     toStream: recordingDataController.sink,
  //     codec: Codec.pcm16,
  //     numChannels: 1,
  //     sampleRate: tSampleRate,
  //   );
  //   setState(() {});
  // }

  @override
  void initState() {
    super.initState();
    _socket.connect(); // Connect socket

    _socket.emit("startVideo");

    // When event received from server, data added to the stream
    _socket.on('videoFrame', (data) => _streamSocket.addResponse(data));

    setState(() {
      _isConnected = true;
    });

    // _openRecorder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Feed"),
        centerTitle: true,
        backgroundColor: PRIMARY_GREEN,
      ),
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: StreamBuilder(
                stream: _streamSocket.getResponse,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  return Image.memory(
                    Uint8List.fromList(
                      base64Decode(snapshot.data.toString()),
                    ),
                    gaplessPlayback: true,
                    excludeFromSemantics: true,
                  );
                }),
          )),
      floatingActionButton: FloatingActionButton(
          backgroundColor: PRIMARY_GREEN,
          onPressed: () {
            // setState(() {
            //   _recordingAudio = !_recordingAudio;
            // });

            // if (_recordingAudio) {
            //   record();
            // }
          },
          child: const Icon(Icons.mic)),
    );
  }

  @override
  void dispose() {
    setState(() {
      _isConnected = false;
    });

    super.dispose();
    _socket.emit("stopVideo");
    _socket.disconnect(); // Disconnect socket

    // _mRecorder.closeRecorder();
  }
}
