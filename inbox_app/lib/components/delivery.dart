import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:inbox_app/components/pop_ups.dart';
import 'package:inbox_app/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:inbox_app/pages/deliveries.dart';

enum Status { notInitialised, initialised, assigned, delivered }

class DeliveryData {
  final String deliveryID;
  final String deliveryName;
  final String userEmail;
  final String hash;
  final String deliveryDate;
  final String imageProof;
  final bool scanned;
  final bool delivered;
  final String unit;
  final String compartment;
  final String url;

  DeliveryData(
      {required this.deliveryID,
      required this.deliveryName,
      required this.userEmail,
      required this.hash,
      required this.deliveryDate,
      required this.imageProof,
      required this.scanned,
      required this.delivered,
      required this.unit,
      required this.compartment,
      required this.url});

  factory DeliveryData.fromJson(Map<String, dynamic> json) {
    return DeliveryData(
        deliveryID: json["_id"]["\$oid"],
        deliveryName: json["deliveryName"],
        userEmail: json["email"],
        hash: json["hashCode"],
        deliveryDate: json["deliveryDate"],
        imageProof: json["imageProof"],
        scanned: json["scanned"],
        delivered: json["delivered"],
        unit: json["unit"],
        compartment: json["compartment"],
        url: json["url"]);
  }
}

class Delivery extends StatefulWidget {
  const Delivery({
    super.key,
    required this.data,
  });

  final DeliveryData data;

  @override
  _DeliveryState createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  String _deliveryId = "";
  String _deliveryName = "";
  String _unitId = "";
  String _unitName = "";
  String _url = "";
  String _imageProof = "";
  bool _delivered = false;
  String _compartmentId = "";
  String? apiKey = "";
  String? userEmail = "";
  String _unit = "";
  DateTime _deliveryDate = DateTime(2023, 3, 22);
  int _status = 0;
  //0 = un-initialised, 1 = initialised, 2 = assigned compartment, 3 = delivered
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    loadApiKey();

    _deliveryId = widget.data.deliveryID;
    _deliveryName = widget.data.deliveryName;
    _status = widget.data.delivered ? 3 : 2;
    _url = widget.data.url;
    _delivered = widget.data.delivered;
    _unit = widget.data.unit;
    _imageProof = widget.data.imageProof;
  }

  Future<void> loadApiKey() async {
    const storage = FlutterSecureStorage();
    apiKey = await storage.read(key: "jwt");
    userEmail = await storage.read(key: "email");
  }

  // Function assigns a compartment to the delivery
  void assignCompartment(String unitId, String compartmentId, String unitName) {
    setState(() {
      _unitId = unitId;
      _unitName = unitName;
      _compartmentId = compartmentId;
      _status = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      color: PRIMARY_GREY,
      child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Stack(children: [
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(_deliveryName.toUpperCase(),
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          fontWeight: FontWeight.w100,
                          color: Colors.white,
                          fontSize: 30)),
                ),
                const Divider(
                  thickness: 2,
                  color: PRIMARY_BLACK,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Column(children: [
                    Row(
                      children: [
                        const Text('Status: ',
                            style: TextStyle(color: Colors.white)),
                        const SizedBox(width: 5.0),
                        Text(_delivered ? 'Delivered' : 'Waiting',
                            style: TextStyle(
                                color:
                                    _delivered ? PRIMARY_GREEN : PRIMARY_YELLOW,
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                    const SizedBox(height: 5.0),
                    Row(
                      children: [
                        const Text('Unit: ',
                            style: TextStyle(color: Colors.white)),
                        const SizedBox(width: 5.0),
                        Text(
                            widget.data.compartment != ""
                                ? "$_unit (${widget.data.compartment})"
                                : _unit,
                            style: TextStyle(
                                color:
                                    _delivered ? PRIMARY_GREEN : PRIMARY_YELLOW,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              flex: 8,
                              child: TextButton.icon(
                                  icon: const Icon(Icons.copy),
                                  label: const Text("URL",
                                      style: TextStyle(color: Colors.white)),
                                  style: TextButton.styleFrom(
                                      backgroundColor: PRIMARY_BLACK,
                                      iconColor: Colors.white,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.all(Radius.zero))),
                                  onPressed: () {
                                    Clipboard.setData(
                                        ClipboardData(text: _url));
                                    final snackBar = SnackBar(
                                      content:
                                          const Text("Copied to Clipboard!"),
                                      backgroundColor: PRIMARY_GREEN,
                                      behavior: SnackBarBehavior.fixed,
                                      action: SnackBarAction(
                                        label: 'Undo',
                                        textColor: PRIMARY_BLACK,
                                        onPressed: () {},
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  })),
                          const SizedBox(width: 5),
                          if (_delivered) ...[
                            Material(
                              child: InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        DeliveryProofPopup(_imageProof),
                                  );
                                },
                                child: Ink(
                                    color: PRIMARY_BLACK,
                                    height: 40.0,
                                    width: 40.0,
                                    child: const Icon(Icons.image,
                                        color: Colors.white)),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Material(
                              child: InkWell(
                                onTap: () {
                                  var url = Uri.http(REST_ENDPOINT,
                                      '/api/v1/deliveries/delete/$_deliveryId');
                                  Map data = {
                                    "email": userEmail,
                                  };
                                  http.delete(url, body: data, headers: {
                                    'Authorization': "Bearer: $apiKey"
                                  });
                                  Navigator.pop(context); // pop current page
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const DeliveriesScreen())); // push it back in
                                },
                                child: Ink(
                                    color: PRIMARY_RED,
                                    height: 40.0,
                                    width: 40.0,
                                    child: const Icon(
                                      Icons.delete_forever_rounded,
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                          ]
                        ])
                  ]),
                )
              ],
            ),
            Positioned(
                top: 10,
                right: 10,
                child: Container(
                    width: 15.0,
                    height: 15.0,
                    decoration: BoxDecoration(
                      color: _delivered ? PRIMARY_GREEN : PRIMARY_YELLOW,
                      shape: BoxShape.circle,
                    )))
          ])),
    );
  }
}
