import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:inbox_app/components/delivery.dart';
import 'package:inbox_app/constants/constants.dart';
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
