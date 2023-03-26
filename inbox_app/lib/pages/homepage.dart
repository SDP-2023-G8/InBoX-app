import 'package:flutter/material.dart';
import 'package:inbox_app/constants/constants.dart';
import 'package:inbox_app/pages/live_video.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:inbox_app/components/compartment.dart';
import '../components/bars.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final IO.Socket _socket = IO.io('http://$REST_ENDPOINT', <String, dynamic>{
    'autoConnect': false,
    'transports': ['websockets'],
  });

  final List<Compartment> _compartments = [];

  @override
  void initState() {
    super.initState();

    _socket.connect();

    // TODO: get states of the compartments from server
    for (int i = 1; i <= 4; i++) {
      _compartments.add(Compartment(i));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: PRIMARY_BLACK,
              appBar: const BarWithHelp('Your InBoX', 'How to use InBoX app?',
                  'Description'), // TODO: add description
              bottomNavigationBar: const BottomBar(1),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  _socket.emit("startVideo");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LiveVideoScreen()));
                },
                child: const Icon(Icons.camera),
              ),
              body: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: PRIMARY_GREY,
                          border: const Border(
                              top: BorderSide(),
                              bottom: BorderSide(),
                              left: BorderSide(),
                              right: BorderSide()),
                          borderRadius: BorderRadius.circular(0)),
                      child: GridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                          children: _compartments),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Compartment Status:',
                            style: TextStyle(fontSize: 20)),
                        Row(
                          children: const [
                            Icon(
                              Icons.circle,
                              color: Colors.red,
                            ),
                            Text(' Occupied', style: TextStyle(fontSize: 20)),
                          ],
                        ),
                        Row(
                          children: const [
                            Icon(Icons.circle, color: Colors.yellow),
                            Text('Reserved', style: TextStyle(fontSize: 20)),
                          ],
                        ),
                        Row(
                          children: const [
                            Icon(Icons.circle, color: Colors.green),
                            Text('Free', style: TextStyle(fontSize: 20)),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ))),
    );
  }
}
