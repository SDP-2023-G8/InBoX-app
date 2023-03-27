import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:inbox_app/components/delivery.dart';
import 'package:inbox_app/constants/constants.dart';
import 'package:http/http.dart' as http;
// TODO: view/change delivery pop-up widget

// TODO: help pop-ups with different instructions, such as:
// 1. for registration
// 2. for usage of the unit

class PopupHelpDialog extends StatelessWidget {
  final String titleText;
  final String helpText;
  const PopupHelpDialog(this.titleText, this.helpText, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(titleText),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(helpText),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: PRIMARY_GREEN),
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.white),
            )),
      ],
    );
  }
}

class AddCompartmentPopup extends StatefulWidget {
  final String unitName;
  const AddCompartmentPopup(this.unitName, {super.key});

  @override
  State<AddCompartmentPopup> createState() => _AddCompartmentPopupState();
}

class _AddCompartmentPopupState extends State<AddCompartmentPopup> {
  String? apiKey = "";
  String compartmentName = "";
  final _formKey = GlobalKey<FormState>();

  Future<void> loadApiKey() async {
    const storage = FlutterSecureStorage();
    apiKey = await storage.read(key: "jwt");
  }

  @override
  void initState() {
    super.initState();
    loadApiKey();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title:
          const Text("Add Compartment", style: TextStyle(color: Colors.white)),
      backgroundColor: PRIMARY_BLACK,
      children: [
        Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                children: [
                  TextFormField(
                    onSaved: (String? value) {
                      compartmentName = value!;
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        labelText: "Compartment Name",
                        labelStyle: TextStyle(color: Colors.white38)),
                    validator: (compartment) {
                      if (compartment == null || compartment.isEmpty) {
                        return "Compartment name is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  ElevatedButton(
                      child: const Text("Submit"),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState?.save();
                          var url = Uri.http(REST_ENDPOINT,
                              '/api/v1/units/compartment/${widget.unitName}/$compartmentName');
                          http.get(url,
                              headers: {'Authorization': "Bearer: $apiKey"});

                          Navigator.of(context).pop();
                        }
                      })
                ],
              ),
            ))
      ],
    );
  }
}

class ConfirmCompartmentDeletionPopup extends StatefulWidget {
  final String compartmentName;
  final Uri url;
  const ConfirmCompartmentDeletionPopup(this.compartmentName, this.url,
      {super.key});

  @override
  State<ConfirmCompartmentDeletionPopup> createState() =>
      _ConfirmCompartmentDeletionPopupState();
}

class _ConfirmCompartmentDeletionPopupState
    extends State<ConfirmCompartmentDeletionPopup> {
  String? apiKey = "";

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
    return AlertDialog(
      title: const Text("Confirm Compartment Delete",
          style: TextStyle(color: Colors.white)),
      backgroundColor: PRIMARY_BLACK,
      contentPadding: const EdgeInsets.all(20.0),
      content: Text(
          "Are you sure you want to delete the '${widget.compartmentName}' compartment?",
          style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w100,
              color: Colors.white38)),
      actions: [
        TextButton.icon(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: PRIMARY_GREEN),
            label: const Text('No', style: TextStyle(color: Colors.white))),
        TextButton.icon(
          icon: const Icon(Icons.check),
          onPressed: () {
            http.delete(widget.url,
                headers: {"Authorization": "Bearer: $apiKey"});
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(backgroundColor: PRIMARY_BLACK),
          label: const Text('Yes', style: TextStyle(color: Colors.white)),
        )
      ],
    );
  }
}

class DeliveryProofPopup extends StatelessWidget {
  final String imageData;

  const DeliveryProofPopup(this.imageData, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          const Text("Delivery Proof", style: TextStyle(color: Colors.white)),
      backgroundColor: PRIMARY_BLACK,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Image.memory(Uint8List.fromList(base64.decode(imageData))),
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: PRIMARY_RED),
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.white),
            )),
      ],
    );
  }
}
