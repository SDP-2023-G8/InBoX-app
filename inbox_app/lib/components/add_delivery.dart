import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:inbox_app/constants/constants.dart';
import 'package:http/http.dart' as http;

class AddDelivery extends StatefulWidget {
  const AddDelivery({super.key});

  @override
  createState() => _AddDeliveryFromState();
}

class _AddDeliveryFromState extends State<AddDelivery> {
  String deliveryName = "";
  String deliveryUnit = "";
  String? apiKey = "";
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    loadApiKey();
  }

  Future<void> loadApiKey() async {
    const storage = FlutterSecureStorage();
    apiKey = await storage.read(key: "jwt");
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    DateTime lastDate =
        DateTime(currentDate.year + 1, currentDate.month, currentDate.day);
    return SimpleDialog(
      title: const Text('Add Delivery', style: TextStyle(color: Colors.white)),
      backgroundColor: PRIMARY_BLACK,
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
                TextFormField(
                    onSaved: (String? value) {
                      deliveryUnit = value!;
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        labelText: 'InBoX Unit',
                        labelStyle: TextStyle(color: Colors.white38)),
                    validator: (unit) {
                      if (unit == null || unit.isEmpty) {
                        return "Unit Box name is required";
                      }
                      return null;
                    }),
                const SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState?.save();
                      var url =
                          Uri.http(REST_ENDPOINT, '/api/v1/deliveries/create');
                      Map data = {
                        "email":
                            "josue.fle.sanc@gmail.com", //TODO: change this to dynamic email
                        "deliveryName": deliveryName,
                        "unit": deliveryUnit,
                        "hashCode":
                            sha256.convert(utf8.encode(deliveryName)).toString()
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
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
