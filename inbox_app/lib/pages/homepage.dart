import 'package:flutter/material.dart';
import 'package:inbox_app/constants/constants.dart';
import 'package:inbox_app/notification_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../components/bars.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
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
              backgroundColor: Colors.white,
              appBar: const SimpleBar('Your InBoX'),
              bottomNavigationBar: const BottomBar(1),
              body: CustomScrollView(slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                        child: Column(
                      children: [
                        Text('HOME PAGE'),
                        ElevatedButton(
                          onPressed: () {
                            NotificationService().showLocalNotification(
                                id: 0,
                                title: "test",
                                body: "test body",
                                payload: "payload");
                          },
                          child: const Text("Send Notification"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            IO.Socket socket = IO
                                .io('http://$REST_ENDPOINT', <String, dynamic>{
                              'autoConnect': false,
                              'transports': ['websocket'],
                            });

                            socket.connect();
                            socket.emit("isthisworking", "something");
                          },
                          child: const Text("Send Socket Message"),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              IO.Socket socket = IO.io(
                                  'http://$REST_ENDPOINT', <String, dynamic>{
                                'autoConnect': false,
                                'transports': ['websocket'],
                              });

                              socket.connect();
                              socket.emit("unlock");
                            },
                            child: const Text("Unlock InBoX"))
                      ],
                    )),
                  ),
                )
              ]))),
    );
  }
}
