import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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

  Widget _getFAB() {
    return SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: const IconThemeData(size: 22),
        backgroundColor: PRIMARY_GREEN,
        overlayColor: PRIMARY_GREY,
        overlayOpacity: 0.9,
        spacing: 20,
        visible: true,
        curve: Curves.bounceIn,
        children: [
          // Live Feed FAB
          SpeedDialChild(
            child: const Icon(Icons.camera),
            backgroundColor: PRIMARY_GREEN,
            onTap: () {
              _socket.emit("startVideo");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LiveVideoScreen()));
            },
            labelWidget: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("Live Feed",
                  style: TextStyle(color: Colors.white, fontSize: 17.0)),
            ),
          ),

          // Disable Alarm FAB
          SpeedDialChild(
            child: const Icon(Icons.volume_off),
            backgroundColor: PRIMARY_GREEN,
            onTap: () {
              _socket.emit("disable_alarm");
              var snackBar = SnackBar(
                content: Row(children: const <Widget>[
                  Icon(Icons.info_outline, color: Colors.white),
                  SizedBox(width: 10.0),
                  Text("Alarm Disabled! You can now move your unit",
                      style: TextStyle(color: Colors.white))
                ]),
                backgroundColor: PRIMARY_GREEN,
                duration: const Duration(milliseconds: 1500),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            labelWidget: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("Disable Alarm",
                  style: TextStyle(color: Colors.white, fontSize: 17.0)),
            ),
          ),

          // Unlock Unit FAB
          SpeedDialChild(
            child: const Icon(Icons.lock_open),
            backgroundColor: PRIMARY_GREEN,
            onTap: () {
              _socket.emit("unlock");
              var snackBar = SnackBar(
                content: Row(children: const <Widget>[
                  Icon(Icons.info_outline, color: Colors.white),
                  SizedBox(width: 10.0),
                  Text("Unit Unlocked!", style: TextStyle(color: Colors.white))
                ]),
                backgroundColor: PRIMARY_GREEN,
                duration: const Duration(milliseconds: 1500),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            labelWidget: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("Live Feed",
                  style: TextStyle(color: Colors.white, fontSize: 17.0)),
            ),
          ),
        ]);
  }

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
              floatingActionButton: _getFAB(),
              bottomNavigationBar: const BottomBar(1),
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
