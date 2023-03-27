import 'dart:async';
import 'dart:typed_data';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:inbox_app/components/bars.dart';
import 'package:inbox_app/constants/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:mic_stream/mic_stream.dart';

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

  Stream? _audioStream;
  late StreamSubscription _listener;
  bool _isRecording = false;

  Future<bool> _startListening() async {
    developer.log("START LISTENING", name: "inbox_app.recorder");

    MicStream.shouldRequestPermission(true);

    _audioStream = await MicStream.microphone(
        audioSource: AudioSource.DEFAULT,
        sampleRate: 48000, // 16000
        channelConfig: ChannelConfig.CHANNEL_IN_MONO,
        audioFormat: AudioFormat.ENCODING_PCM_16BIT);

    _socket.emit("startAudio");

    developer.log(
        "Started listening to the microphone, sample rate is ${await MicStream.sampleRate}, bit depth is ${await MicStream.bitDepth}, bufferSize: ${await MicStream.bufferSize}",
        name: "inbox_app.recorder");

    int bytesPerSample = (await MicStream.bitDepth)! ~/ 8;
    int samplesPerSecond = (await MicStream.sampleRate)!.toInt();

    developer.log("Bytes per sample: $bytesPerSample",
        name: "inbox_app.recorder");
    developer.log("Samples per second: $samplesPerSecond",
        name: "inbox_app.recorder");

    setState(() => _isRecording = true);
    _listener = _audioStream!.listen((data) {
      _socket.emit("audioBuffer", Uint8List.fromList(data));
    });

    return true;
  }

  bool _stopListening() {
    developer.log("Stop listening to the microphone",
        name: "inbox_app.recorder");

    _socket.emit("stopAudio");
    _listener.cancel();

    setState(() {
      _isRecording = false;
    });

    return true;
  }

  @override
  void initState() {
    super.initState();
    _socket.connect(); // Connect socket
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const BarWithBackArrow("Live Feed"),
        backgroundColor: PRIMARY_BLACK,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            _isRecording = !_isRecording;

            if (_isRecording) {
              _startListening();
            } else {
              _stopListening();
            }
          },
          backgroundColor: _isRecording ? PRIMARY_GREY : PRIMARY_GREEN,
          child: _isRecording ? const Icon(Icons.stop) : const Icon(Icons.mic),
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
