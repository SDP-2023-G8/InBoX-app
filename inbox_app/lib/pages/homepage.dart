import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:inbox_app/components/pop_ups.dart';
import 'package:inbox_app/constants/constants.dart';
import 'package:inbox_app/pages/live_video.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import '../components/bars.dart';
import '../components/box_compartment.dart';

class UnitData {
  final String name;
  final String ownerEmail;
  final String boxID;
  final List<CompartmentData> compartments;

  UnitData(
      {required this.name,
      required this.ownerEmail,
      required this.boxID,
      required this.compartments});

  factory UnitData.fromJson(Map<String, dynamic> json) {
    return UnitData(
        name: json["name"],
        ownerEmail: json["ownerEmail"],
        boxID: json["boxID"],
        compartments: (json["compartments"] as List)
            .map((data) => CompartmentData.fromJson(data))
            .toList());
  }
}

class CompartmentData {
  final String compartmentName;
  final bool free;
  final String deliveryID;

  CompartmentData(
      {required this.compartmentName,
      required this.free,
      required this.deliveryID});

  factory CompartmentData.fromJson(Map<String, dynamic> json) {
    return CompartmentData(
        compartmentName: json["compartmentName"],
        free: json["free"],
        deliveryID: json["deliveryID"]);
  }
}

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

  var loadingUnits;
  String? apiKey = "";
  int _index = 0;
  List<UnitData> _units = [];

  final TextEditingController _titleController =
      TextEditingController(text: "Loading...");
  bool _titleEnabled = false;

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

              Future.delayed(const Duration(seconds: 30), () {
                _socket.emit("enable_alarm");
              });

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
              child: Text("Unlock Unit",
                  style: TextStyle(color: Colors.white, fontSize: 17.0)),
            ),
          ),
        ]);
  }

  @override
  void initState() {
    super.initState();

    _socket.connect();

    loadingUnits = loadUnits();
  }

  Future<bool> loadUnits() async {
    const storage = FlutterSecureStorage();
    apiKey = await storage.read(key: "jwt");

    var url = Uri.http(REST_ENDPOINT, '/api/v1/units/josue.fle.sanc@gmail.com');
    var response =
        await http.get(url, headers: {'Authorization': "Bearer: $apiKey"});
    Iterable l = json.decode(response.body);
    _units = (l as List).map((data) => UnitData.fromJson(data)).toList();

    _titleController.text = _units[0].name;

    return true;
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
              appBar: const BarWithHelp(
                  'Your InBoX',
                  'How to use InBoX app?',
                  'Each compartment has its status. It can be occupied if a delivery has been completed, '
                      'reserved for a future delivery or free. \n'
                      '1. Occupied: you can open the compartment by tapping the "Open" button.\n'
                      '2. Reserved: you can view and/or change the details of a future delivery by tapping the "View Delivery" button.\n'
                      '3. Free: you can assign the compartment to a delivery by tapping the "Add Delivery" button, then it will become reserved.\n'
                      'To move between compartments, swipe left or right.'),
              floatingActionButton: _getFAB(),
              bottomNavigationBar: const BottomBar(1),
              body: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: FutureBuilder(
                      future: loadingUnits,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return const CircularProgressIndicator();
                        }

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      width: 100,
                                      child: TextField(
                                          controller: _titleController,
                                          decoration: const InputDecoration(
                                              disabledBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              focusedBorder: InputBorder.none),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: _titleEnabled
                                                  ? PRIMARY_GREEN
                                                  : Colors.white,
                                              fontSize: 24),
                                          enabled: _titleEnabled)),
                                  IconButton(
                                      icon: const Icon(Icons.edit),
                                      iconSize: 20,
                                      color: Colors.white,
                                      onPressed: () {
                                        setState(() {
                                          _titleEnabled = true;
                                        });
                                      })
                                ]),
                            const SizedBox(height: 10.0),
                            Container(
                                padding: const EdgeInsets.all(5),
                                height: 350,
                                width: 350,
                                decoration:
                                    const BoxDecoration(color: PRIMARY_GREY),
                                child: Center(
                                  child: SizedBox(
                                    height: 300,
                                    width: 300,
                                    child: PageView.builder(
                                        itemCount:
                                            _units[0].compartments.length + 1,
                                        controller:
                                            PageController(viewportFraction: 1),
                                        onPageChanged: (int index) =>
                                            setState(() => _index = index),
                                        itemBuilder: (_, i) {
                                          if (i ==
                                              _units[0].compartments.length) {
                                            return Card(
                                              elevation: 3,
                                              color: PRIMARY_BLACK,
                                              child: Center(
                                                child: Material(
                                                  type:
                                                      MaterialType.transparency,
                                                  child: IconButton(
                                                    icon: const Icon(Icons.add),
                                                    iconSize: 40,
                                                    splashColor: PRIMARY_GREEN,
                                                    color: Colors.white,
                                                    onPressed: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                                  context) =>
                                                              AddCompartmentPopup(
                                                                  _units[0]
                                                                      .name)).then(
                                                          (value) {
                                                        Navigator.of(context)
                                                            .pop();
                                                        Future.delayed(
                                                            const Duration(
                                                                seconds: 1));
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const HomeScreen()));
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                            );
                                          }

                                          return BoxCompartment(
                                              _units[0].name,
                                              _units[0]
                                                  .compartments[i]
                                                  .compartmentName,
                                              _units[0]
                                                  .compartments[i]
                                                  .deliveryID,
                                              _units[0].compartments[i].free);
                                        }),
                                  ),
                                )),
                          ],
                        );
                      }),
                ),
              ))),
    );
  }
}
