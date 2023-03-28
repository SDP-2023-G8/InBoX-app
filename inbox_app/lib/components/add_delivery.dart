import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:inbox_app/constants/constants.dart';
import 'package:inbox_app/pages/homepage.dart';
import 'package:http/http.dart' as http;

class AddDelivery extends StatefulWidget {
  const AddDelivery({super.key});

  @override
  createState() => _AddDeliveryFromState();
}

class _AddDeliveryFromState extends State<AddDelivery> {
  String deliveryName = "";
  int deliveryIndex = 0;
  String compartmentUnit = "";
  int compartmentIndex = 0;
  String deliveryUnit = "";
  String? apiKey = "";
  String? userEmail = "";
  bool deliverToCompartment = false;
  List<UnitData> _units = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    loadVariables();
  }

  Future<void> loadVariables() async {
    const storage = FlutterSecureStorage();
    apiKey = await storage.read(key: "jwt");
    userEmail = await storage.read(key: "email");

    var url = Uri.http(REST_ENDPOINT, '/api/v1/units/$userEmail');
    var response =
        await http.get(url, headers: {'Authorization': "Bearer: $apiKey"});
    Iterable l = json.decode(response.body);
    _units = (l as List).map((data) => UnitData.fromJson(data)).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Add Delivery', style: TextStyle(color: Colors.white)),
      backgroundColor: PRIMARY_BLACK,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      children: [
        Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              children: <Widget>[
                //DeliveryName
                TextFormField(
                  onSaved: (String? value) {
                    deliveryName = value!;
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                      labelText: 'Delivery Name',
                      labelStyle: TextStyle(color: Colors.white38)),
                  validator: (name) {
                    if (name == null || name.isEmpty) {
                      return 'Delivery name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),
                SizedBox(
                  width: 240,
                  child: DropdownButton(
                      isExpanded: true,
                      value: 0,
                      items: _units.asMap().entries.map((u) {
                        return DropdownMenuItem(
                            value: u.key, child: Text(u.value.name));
                      }).toList(),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      hint: const Text("InBoX Unit",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      style: const TextStyle(color: Colors.white),
                      underline: Container(
                        height: 1,
                        color: Colors.black.withAlpha(120),
                      ),
                      dropdownColor: PRIMARY_GREEN,
                      onChanged: (value) {
                        setState(() {
                          deliveryUnit = _units[value!].name;
                          deliveryIndex = value;
                        });
                      }),
                ),
                const SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      "Deliver to Compartment?",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    Switch(
                      value: deliverToCompartment,
                      activeColor: PRIMARY_GREEN,
                      onChanged: (value) {
                        setState(() {
                          deliverToCompartment = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 15.0),
                if (deliverToCompartment)
                  SizedBox(
                    width: 240,
                    child: DropdownButton(
                        isExpanded: true,
                        value: compartmentIndex,
                        items: _units[deliveryIndex]
                            .compartments
                            .asMap()
                            .entries
                            .map((c) {
                          return DropdownMenuItem(
                              value: c.key,
                              child: Text(c.value.compartmentName));
                        }).toList(),
                        icon: const Icon(Icons.keyboard_arrow_down),
                        hint: const Text("InBoX Unit",
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        style: const TextStyle(color: Colors.white),
                        underline: Container(
                          height: 1,
                          color: Colors.black.withAlpha(120),
                        ),
                        dropdownColor: PRIMARY_GREEN,
                        onChanged: (value) {
                          setState(() {
                            compartmentUnit = _units[deliveryIndex]
                                .compartments[value!]
                                .compartmentName;

                            compartmentIndex = value;
                          });
                        }),
                  ),
                deliverToCompartment
                    ? const SizedBox(height: 15.0)
                    : const SizedBox(height: 0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState?.save();
                      var url =
                          Uri.http(REST_ENDPOINT, '/api/v1/deliveries/create');
                      Map data = {
                        "email": userEmail,
                        "deliveryName": deliveryName,
                        "unit": deliveryUnit,
                        "compartment": compartmentUnit,
                        "hashCode": sha256
                            .convert(utf8.encode(deliveryName))
                            .toString()
                            .substring(0, 15)
                      };
                      http
                          .post(url,
                              headers: {
                                'Content-Type': "application/json",
                                'Authorization': "Bearer: $apiKey"
                              },
                              body: json.encode(data))
                          .then((value) {
                        Navigator.of(context).pop();
                      });

                      // If delivery assigned to compartment, send POST request
                      if (compartmentUnit != "") {
                        var url = Uri.http(
                            REST_ENDPOINT, "api/v1/units/compartment/delivery");
                        Map payload = {
                          "unit": deliveryUnit,
                          "compartment": compartmentUnit,
                          "deliveryName": deliveryName
                        };
                        http.post(url,
                            headers: {'Content-Type': "application/json"},
                            body: json.encode(payload));
                      }
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
