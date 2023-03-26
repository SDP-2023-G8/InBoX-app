import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import 'package:inbox_app/components/add_delivery.dart';
import 'package:inbox_app/constants/constants.dart';
import '../components/bars.dart';
import '../components/delivery.dart';
import 'homepage.dart';

class DeliveriesScreen extends StatefulWidget {
  const DeliveriesScreen({Key? key}) : super(key: key);

  @override
  _DeliveriesScreenState createState() => _DeliveriesScreenState();
}

class _DeliveriesScreenState extends State<DeliveriesScreen> {
  final IO.Socket _socket = IO.io('http://$REST_ENDPOINT', <String, dynamic>{
    'autoConnect': false,
    'transports': ['websocket'],
  });
  List<Delivery> _deliveries = <Delivery>[];

  @override
  void initState() {
    super.initState();
    _socket.connect();
  }

  Future<bool> loadDeliveries() async {
    _deliveries = [];

    //TODO: Change my email to a dynamically loaded user email
    var url =
        Uri.http(REST_ENDPOINT, '/api/v1/deliveries/josue.fle.sanc@gmail.com');
    var response = await http.get(url);
    Iterable l = json.decode(response.body);
    List<DeliveryData> deliveryDataObjects =
        (l as List).map((data) => DeliveryData.fromJson(data)).toList();

    // Create Delivery Objects from DeliveryData
    for (var dataObj in deliveryDataObjects) {
      _deliveries.add(Delivery(data: dataObj));
    }

    return true;
  }

  void addDelivery(Delivery delivery) {
    setState(() {
      _deliveries.add(delivery);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
        return true;
      },
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
          appBar: const SimpleBar('Deliveries'),
          bottomNavigationBar: const BottomBar(0),
          body: FutureBuilder(
              future: loadDeliveries(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CustomScrollView(
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: _deliveries),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                      context: context,
                      builder: (BuildContext context) => const AddDelivery())
                  .then((value) {
                setState(() {});
              });
            },
            backgroundColor: PRIMARY_GREEN,
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
